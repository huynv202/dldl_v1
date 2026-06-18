package economy

import (
	"math"
	"sl-omega-server/internal/config"
)

// EconomyService manages gold flow, inflation, and sinks
type EconomyService struct {
	config *config.Config
}

// NewEconomyService creates new economy service
func NewEconomyService(cfg *config.Config) *EconomyService {
	return &EconomyService{config: cfg}
}

// GoldFlow tracks economy metrics
type GoldFlow struct {
	TotalInflow    int64 `json:"total_inflow"`     // G_in
	TotalSink      int64 `json:"total_sink"`       // G_sink
	MoneySupply    int64 `json:"money_supply"`     // Current money supply
	InflationRate  float64 `json:"inflation_rate"` // Weekly inflation %
}

// CalculateInflation implements: InflationRate = (G_in - G_sink) / TotalMoneySupply
func (s *EconomyService) CalculateInflation(inflow, sink, supply int64) float64 {
	if supply == 0 {
		return 0
	}
	return float64(inflow-sink) / float64(supply) * 100
}

// CalculateUpgradeCost implements exponential cost curve:
// Cost(Level) = BaseCost × (1.5)^Level
func (s *EconomyService) CalculateUpgradeCost(baseCost int64, level int) int64 {
	multiplier := math.Pow(1.5, float64(level))
	return int64(float64(baseCost) * multiplier)
}

// EnhancementCost calculates gold cost for gear enhancement (+1 to +15)
func (s *EconomyService) EnhancementCost(currentLevel int) int64 {
	baseCost := int64(100)
	
	// 100% success to +9, then drops
	if currentLevel >= 9 {
		// Higher levels cost more due to lower success rate
		cost := s.CalculateUpgradeCost(baseCost, currentLevel)
		return cost * 2 // Double cost for high levels
	}
	
	return s.CalculateUpgradeCost(baseCost, currentLevel)
}

// RefinementCost calculates cost for star refinement
func (s *EconomyService) RefinementCost(currentStar int) int64 {
	// Uses refinement stones instead of gold
	// Stone cost scales exponentially
	baseStones := int64(5)
	return baseStones * int64(math.Pow(1.8, float64(currentStar)))
}

// TranscendenceCost calculates cost for Red gear fusion
// Requires 5 Legendary → 1 Red, plus protection runes
func (s *EconomyService) TranscendenceCost() (goldCost int64, runeCost int64) {
	goldCost = 1000000 // 1M gold base
	runeCost = 10      // 10 protection runes
	
	// Protection runes prevent downgrade on failure
	// This is the "Whale burn zone" from docs
	return
}

// GemMergeCost calculates cost to merge gems: 3x Level N → 1x Level N+1
// Exponential cost: Level 10 = 10,000x Level 1 cost
func (s *EconomyService) GemMergeCost(gemLevel int) int64 {
	baseCost := int64(100)
	// Each level requires 3x materials, so cost grows by 3x
	return baseCost * int64(math.Pow(3, float64(gemLevel-1)))
}

// DailyGoldEarn calculates expected daily gold earnings
func (s *EconomyService) DailyGoldEarn(playerLevel int, isActivePlayer bool) int64 {
	baseEarn := int64(1000)
	
	// Scales with level
	levelMultiplier := float64(playerLevel) / 10.0
	
	// Active players earn more (daily quests, events)
	if isActivePlayer {
		levelMultiplier *= 1.5
	}
	
	return int64(float64(baseEarn) * levelMultiplier * s.config.GoldRate)
}

// ShouldTriggerInflationAlert checks if inflation exceeds threshold
// Target: Keep weekly inflation < 5%
func (s *EconomyService) ShouldTriggerInflationAlert(rate float64) bool {
	return rate > 5.0
}

// GetSinkRecommendations returns recommended sinks based on inflation
func (s *EconomyService) GetSinkRecommendations(inflationRate float64) []string {
	var recommendations []string
	
	if inflationRate > 10 {
		recommendations = append(recommendations, 
			"Increase enhancement failure rates",
			"Add new gold-only upgrades",
			"Raise auction tax temporarily")
	} else if inflationRate > 5 {
		recommendations = append(recommendations,
			"Introduce limited-time gold sinks",
			"Increase material costs")
	}
	
	return recommendations
}

// AuctionTax calculates 5% tax on player-to-player trades
func (s *EconomyService) AuctionTax(amount int64) int64 {
	return amount * 5 / 100
}

// StaminaGate implements time-gated resource scarcity
// Unused stamina caps at 24hrs (anti-hoarding)
func (s *EconomyService) CalculateStaminaRegen(hoursSinceLastLogin int, currentStamina int, maxStamina int) int {
	regenRate := 5 // 5 stamina per hour
	maxRegen := regenRate * hoursSinceLastLogin
	
	newStamina := currentStamina + maxRegen
	
	// Cap at max stamina (forces regular logins)
	if newStamina > maxStamina {
		newStamina = maxStamina
	}
	
	return newStamina
}

// Economy monitoring metrics from docs
type EconomyMetrics struct {
	GoldVelocity        float64 `json:"gold_velocity"`         // Avg gold changing hands per player
	SinkEfficiency      float64 `json:"sink_efficiency"`       // % of generated gold spent
	AuctionVolume       int64   `json:"auction_volume"`        // P2P trade activity
	WhaleConcentration  float64 `json:"whale_concentration"`   // Top 1% gold ownership %
	F2PSurvivalIndex    float64 `json:"f2p_survival_index"`    // Can F2P afford basics?
}

// CheckEconomyHealth evaluates economy against alert thresholds
func (s *EconomyService) CheckEconomyHealth(metrics *EconomyMetrics) []string {
	var alerts []string
	
	if metrics.GoldVelocity < -0.2 {
		alerts = append(alerts, "WARNING: Economy stagnating - gold velocity dropped 20%")
	}
	
	if metrics.SinkEfficiency < 0.6 {
		alerts = append(alerts, "CRITICAL: Sink efficiency below 60% - need new sinks")
	}
	
	if metrics.WhaleConcentration > 0.4 {
		alerts = append(alerts, "CRITICAL: Wealth inequality crisis - top 1% owns >40%")
	}
	
	if metrics.F2PSurvivalIndex < 0.8 {
		alerts = append(alerts, "WARNING: F2P ecosystem at risk - survival index <80%")
	}
	
	return alerts
}
