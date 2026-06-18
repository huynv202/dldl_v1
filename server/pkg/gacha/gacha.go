package gacha

import (
	"math/rand"
	"time"
	"sl-omega-server/internal/config"
	"sl-omega-server/internal/models"
)

// Banner types from docs
type BannerType string

const (
	BannerStandard BannerType = "standard" // Trash dump - all non-limited
	BannerLimited  BannerType = "limited"  // Rate-up banner - money printer
)

// GachaService handles all gacha mechanics
type GachaService struct {
	config *config.Config
	rng    *rand.Rand
}

// PullResult represents a single pull result
type PullResult struct {
	Rarity   models.Rarity `json:"rarity"`
	ItemID   uint64        `json:"item_id"`
	ItemName string        `json:"item_name"`
	IsRateUp bool          `json:"is_rate_up"`
	IsNew    bool          `json:"is_new"`
}

// MultiPullResult for 10-pull
type MultiPullResult struct {
	Results    []PullResult `json:"results"`
	TotalCost  int64        `json:"total_cost"`
	PityCount  int          `json:"pity_count"`
	Guaranteed bool         `json:"guaranteed"`
}

// NewGachaService creates new gacha service
func NewGachaService(cfg *config.Config) *GachaService {
	return &GachaService{
		config: cfg,
		rng:    rand.New(rand.NewSource(time.Now().UnixNano())),
	}
}

// calculateRate returns the effective SSR rate based on pity count
func (s *GachaService) calculateRate(pityCount int) float64 {
	baseRate := s.config.GachaSSR
	
	// Soft pity: after threshold, rate increases gradually
	if pityCount > s.config.PitySoft {
		increase := float64(pityCount-s.config.PitySoft) * 0.005 // 0.5% per pull
		return baseRate + increase
	}
	
	return baseRate
}

// SinglePull performs one gacha pull with pity system
func (s *GachaService) SinglePull(pityCount int, guaranteed bool) (PullResult, int, bool) {
	roll := s.rng.Float64()
	effectiveRate := s.calculateRate(pityCount)
	
	var result PullResult
	newPity := pityCount + 1
	newGuaranteed := guaranteed
	
	// Hard pity check
	if pityCount >= s.config.PityHard {
		result = s.generateItem(models.RarityEpic, guaranteed)
		newPity = 0
		newGuaranteed = false
		return result, newPity, newGuaranteed
	}
	
	// Normal roll
	if roll < effectiveRate {
		// SSR pulled
		isRateUp := s.rng.Float64() < 0.5 // 50% chance for rate-up
		result = s.generateItem(models.RarityEpic, isRateUp)
		newPity = 0
		
		// If not rate-up, next SSR is guaranteed
		if !isRateUp {
			newGuaranteed = true
		} else {
			newGuaranteed = false
		}
	} else if roll < effectiveRate+s.config.GachaSR {
		// SR pulled
		result = s.generateItem(models.RarityRare, false)
	} else {
		// R pulled
		result = s.generateItem(models.RarityCommon, false)
	}
	
	return result, newPity, newGuaranteed
}

// TenPull performs 10-pull with guaranteed SR+ every 10 pulls
func (s *GachaService) TenPull(pityCount int, guaranteed bool) (*MultiPullResult, int, bool) {
	results := make([]PullResult, 10)
	currentPity := pityCount
	currentGuaranteed := guaranteed
	totalCost := int64(30) // 10 pulls × 3 cost per pull (simplified)
	
	hasGuaranteedSR := false
	
	for i := 0; i < 10; i++ {
		// Every 10th pull guaranteed SR+
		if i == 9 && !hasGuaranteedSR {
			roll := s.rng.Float64()
			if roll < s.config.GachaSSR {
				results[i] = s.generateItem(models.RarityEpic, currentGuaranteed)
				currentPity = 0
				currentGuaranteed = false
			} else {
				results[i] = s.generateItem(models.RarityRare, false)
			}
			hasGuaranteedSR = true
		} else {
			result, newPity, newGuaranteed := s.SinglePull(currentPity, currentGuaranteed)
			results[i] = result
			currentPity = newPity
			currentGuaranteed = newGuaranteed
			
			if result.Rarity != models.RarityCommon {
				hasGuaranteedSR = true
			}
		}
	}
	
	return &MultiPullResult{
		Results:    results,
		TotalCost:  totalCost,
		PityCount:  currentPity,
		Guaranteed: currentGuaranteed,
	}, currentPity, currentGuaranteed
}

// generateItem creates a random item of given rarity
func (s *GachaService) generateItem(rarity models.Rarity, isRateUp bool) PullResult {
	// Simplified item generation - in production would use item database
	itemPool := map[models.Rarity][]struct {
		ID   uint64
		Name string
	}{
		models.RarityCommon: {
			{ID: 1, Name: "Iron Sword"},
			{ID: 2, Name: "Leather Armor"},
			{ID: 3, Name: "Health Potion"},
		},
		models.RarityRare: {
			{ID: 10, Name: "Steel Blade"},
			{ID: 11, Name: "Chain Mail"},
			{ID: 12, Name: "Spirit Crystal"},
		},
		models.RarityEpic: {
			{ID: 100, Name: "Clear Sky Hammer"},
			{ID: 101, Name: "Blue Silver Emperor"},
			{ID: 102, Name: "Phoenix Feather"},
		},
	}
	
	pool := itemPool[rarity]
	if len(pool) == 0 {
		return PullResult{Rarity: rarity, ItemName: "Unknown"}
	}
	
	item := pool[s.rng.Intn(len(pool))]
	
	return PullResult{
		Rarity:   rarity,
		ItemID:   item.ID,
		ItemName: item.Name,
		IsRateUp: isRateUp,
		IsNew:    s.rng.Float64() < 0.3, // 30% chance it's new
	}
}

// ExpectedValue calculates expected cost for specific item
// Based on Coupon Collector's Problem from docs
func (s *GachaService) ExpectedValue(targetItems int, poolSize int) float64 {
	// E = n × (ln(n) + γ) × targetItems
	// γ (Euler-Mascheroni constant) ≈ 0.577
	gamma := 0.57721
	expectedPulls := float64(poolSize) * (float64(poolSize)/float64(targetItems)) * float64(targetItems)
	
	costPerPull := 3.0 // $3 per pull simplified
	return expectedPulls * costPerPull
}
