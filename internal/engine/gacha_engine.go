package engine

import (
	"fmt"
	"math"
	"math/rand"
	"time"
)

// GachaEngine xử lý hệ thống gacha với pity mechanics theo design docs
type GachaEngine struct {
	config *GachaConfig
}

type GachaConfig struct {
	SSRBaseRate    float64 // 0.02 = 2%
	SRBaseRate     float64 // 0.15 = 15%
	RBaseRate      float64 // 0.83 = 83%
	SoftPityStart  int     // Bắt đầu tăng rate từ pull thứ 70
	HardPity       int     // Guaranteed SSR ở pull thứ 90
	SoftPityFactor float64 // Rate tăng thêm mỗi pull sau soft pity
}

func NewGachaEngine() *GachaEngine {
	return &GachaEngine{
		config: &GachaConfig{
			SSRBaseRate:    0.02,
			SRBaseRate:     0.15,
			RBaseRate:      0.83,
			SoftPityStart:  70,
			HardPity:       90,
			SoftPityFactor: 0.03, // +3% mỗi pull sau soft pity
		},
	}
}

// GachaResult kết quả của một lần quay
type GachaResult struct {
	ItemID     string
	ItemName   string
	Rarity     string // "SSR", "SR", "R"
	ItemType   string // "martial_soul", "soul_ring", "equipment", "skill"
	IsNew      bool   // Lần đầu获得
	PityCount  int    // Số pity hiện tại
	Timestamp  time.Time
}

// PullResult kết quả của một lần kéo (1 hoặc 10 pulls)
type PullResult struct {
	Items       []*GachaResult
	TotalSSR    int
	TotalSR     int
	TotalR      int
	NewPityCount int
	Cost        int64
}

// SinglePull thực hiện 1 lần quay
func (e *GachaEngine) SinglePull(pityCount int, banner *GachaBanner) *GachaResult {
	pityCount++
	
	// Calculate effective SSR rate với pity system
	ssrRate := e.calculateSSRRate(pityCount)
	
	randValue := rand.Float64()
	
	var rarity string
	if randValue < ssrRate {
		rarity = "SSR"
		pityCount = 0 // Reset pity khi có SSR
	} else if randValue < ssrRate+e.config.SRBaseRate {
		rarity = "SR"
	} else {
		rarity = "R"
	}
	
	// Select item based on rarity and banner rates
	item := e.selectItem(rarity, banner)
	
	return &GachaResult{
		ItemID:    item.ID,
		ItemName:  item.Name,
		Rarity:    rarity,
		ItemType:  item.Type,
		PityCount: pityCount,
		Timestamp: time.Now(),
	}
}

// MultiPull thực hiện 10 lần quay
func (e *GachaEngine) MultiPull(pityCount int, banner *GachaBanner) *PullResult {
	result := &PullResult{
		Items: make([]*GachaResult, 0, 10),
		Cost:  banner.Cost * 10,
	}
	
	currentPity := pityCount
	
	for i := 0; i < 10; i++ {
		pullResult := e.SinglePull(currentPity, banner)
		result.Items = append(result.Items, pullResult)
		
		currentPity = pullResult.PityCount
		
		switch pullResult.Rarity {
		case "SSR":
			result.TotalSSR++
		case "SR":
			result.TotalSR++
		case "R":
			result.TotalR++
		}
	}
	
	result.NewPityCount = currentPity
	
	return result
}

// calculateSSRRate tính toán tỷ lệ SSR với pity system
func (e *GachaEngine) calculateSSRRate(pityCount int) float64 {
	if pityCount < e.config.SoftPityStart {
		return e.config.SSRBaseRate
	}
	
	// Soft pity: tăng rate dần
	pullsAfterSoftPity := pityCount - e.config.SoftPityStart
	additionalRate := float64(pullsAfterSoftPity) * e.config.SoftPityFactor
	
	effectiveRate := e.config.SSRBaseRate + additionalRate
	
	// Hard pity: guaranteed
	if pityCount >= e.config.HardPity {
		return 1.0
	}
	
	return math.Min(effectiveRate, 1.0)
}

// selectItem chọn item dựa trên rarity và banner weights
func (e *GachaEngine) selectItem(rarity string, banner *GachaBanner) *GachaItem {
	var items []*GachaItem
	
	// Filter items by rarity
	for _, item := range banner.Items {
		if item.Rarity == rarity {
			items = append(items, item)
		}
	}
	
	if len(items) == 0 {
		// Fallback to default items
		return e.getDefaultItem(rarity)
	}
	
	// Weighted random selection
	totalWeight := 0.0
	for _, item := range items {
		totalWeight += item.DropRate
	}
	
	randValue := rand.Float64() * totalWeight
	currentWeight := 0.0
	
	for _, item := range items {
		currentWeight += item.DropRate
		if randValue <= currentWeight {
			return item
		}
	}
	
	return items[len(items)-1]
}

func (e *GachaEngine) getDefaultItem(rarity string) *GachaItem {
	// Default fallback items
	return &GachaItem{
		ID:       "default_" + rarity,
		Name:     rarity + " Item",
		Rarity:   rarity,
		Type:     "material",
		DropRate: 1.0,
	}
}

// GachaBanner định nghĩa banner gacha
type GachaBanner struct {
	ID          string
	Name        string
	Description string
	StartTime   time.Time
	EndTime     time.Time
	Items       []*GachaItem
	Cost        int64 // Cost per pull (diamonds)
	Featured    []string // Featured item IDs (increased rate)
	BannerType  string // "standard", "limited", "beginner", "weapon"
}

// GachaItem định nghĩa item trong gacha
type GachaItem struct {
	ID         string
	Name       string
	Rarity     string
	Type       string // "martial_soul", "soul_ring", "equipment", "skill", "fragment"
	DropRate   float64
	FragmentCount int // Số mảnh nếu là fragment
	MaxDropRate   float64 // Max rate cho featured items
}

// PityCounter theo dõi pity progress
type PityCounter struct {
	PlayerID      string
	BannerID      string
	SSRPity       int
	SRPity        int
	LastSSRTime   time.Time
	GuaranteedSSR bool // True nếu lần SSR tiếp theo là guaranteed (50/50 lost)
}

// UpdatePity cập nhật pity counter sau khi pull
func (e *GachaEngine) UpdatePity(counter *PityCounter, result *GachaResult) {
	if result.Rarity == "SSR" {
		counter.SSRPity = 0
		counter.LastSSRTime = time.Now()
		
		// Nếu không phải guaranteed, set flag cho lần sau
		if !counter.GuaranteedSSR {
			counter.GuaranteedSSR = true // Lost 50/50
		} else {
			counter.GuaranteedSSR = false // Got guaranteed
		}
	} else {
		counter.SSRPity++
	}
	
	if result.Rarity == "SR" {
		counter.SRPity = 0
	} else {
		counter.SRPity++
	}
}

// GetExpectedValue tính toán expected value cho player
func (e *GachaEngine) GetExpectedValue(banner *GachaBanner) map[string]interface{} {
	avgPullsToSSR := 1.0 / e.config.SSRBaseRate
	expectedCost := int64(avgPullsToSSR) * banner.Cost
	
	return map[string]interface{}{
		"avg_pulls_to_ssr": avgPullsToSSR,
		"expected_cost":    expectedCost,
		"ssr_rate":         e.config.SSRBaseRate,
		"sr_rate":          e.config.SRBaseRate,
		"soft_pity_start":  e.config.SoftPityStart,
		"hard_pity":        e.config.HardPity,
	}
}

// ValidateBanner kiểm tra banner config hợp lệ
func (e *GachaEngine) ValidateBanner(banner *GachaBanner) error {
	totalRate := 0.0
	for _, item := range banner.Items {
		totalRate += item.DropRate
	}
	
	if totalRate > 1.0 {
		return fmt.Errorf("total drop rate exceeds 100%%: %.2f", totalRate)
	}
	
	if banner.Cost <= 0 {
		return fmt.Errorf("banner cost must be positive")
	}
	
	return nil
}
