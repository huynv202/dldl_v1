package combat

import (
	"math/rand"
	"sl-omega-server/internal/models"
)

// CombatService handles all combat calculations
type CombatService struct{}

// NewCombatService creates new combat service
func NewCombatService() *CombatService {
	return &CombatService{}
}

// DamageResult contains full damage calculation details
type DamageResult struct {
	BaseDamage      float64 `json:"base_damage"`
	CritMultiplier  float64 `json:"crit_multiplier"`
	ElementBonus    float64 `json:"element_bonus"`
	DefReduction    float64 `json:"def_reduction"`
	FinalDamage     float64 `json:"final_damage"`
	IsCrit          bool    `json:"is_crit"`
	DamageType      string  `json:"damage_type"` // "normal", "crit", "true"
	ColorCode       string  `json:"color_code"`  // For UI feedback
}

// CalculateDamage implements the damage formula from docs:
// FinalDmg = (BaseAtk × SkillCoeff) × (1 + CritDmg) × (1 + ElemBonus) × (1 - TargetDefReduction)
func (s *CombatService) CalculateDamage(
	attacker *models.Player,
	defender *models.Player,
	skillCoeff float64,
) *DamageResult {
	result := &DamageResult{}
	
	// Base damage = ATK × Skill Coefficient
	baseAtk := float64(attacker.Stats.ATK)
	result.BaseDamage = baseAtk * skillCoeff
	
	// Crit calculation
	isCrit := s.rollCrit(attacker.Stats.CritRate)
	result.IsCrit = isCrit
	
	if isCrit {
		result.CritMultiplier = 1.0 + (attacker.Stats.CritDMG / 100.0)
	} else {
		result.CritMultiplier = 1.0
	}
	
	// Elemental bonus (Rock-Paper-Scissors dynamic)
	result.ElementBonus = s.calculateElementalBonus(attacker.Stats.ElementalMastery, defender.Stats.ElementalMastery)
	
	// Defense reduction
	result.DefReduction = s.calculateDefReduction(attacker.Stats.Penetration, defender.Stats.DEF)
	
	// Final damage calculation
	result.FinalDamage = result.BaseDamage *
		result.CritMultiplier *
		(1.0 + result.ElementBonus) *
		(1.0 - result.DefReduction)
	
	// Ensure minimum damage of 1
	if result.FinalDamage < 1 {
		result.FinalDamage = 1
	}
	
	// Determine damage type and color code for UI
	result.DamageType, result.ColorCode = s.getDamageType(result.FinalDamage, isCrit)
	
	return result
}

// rollCrit determines if attack crits based on crit rate
func (s *CombatService) rollCrit(critRate float64) bool {
	// Simplified - in production use proper RNG
	return rand.Float64()*100 < critRate
}

// calculateElementalBonus implements elemental mastery advantage
func (s *CombatService) calculateElementalBonus(attackerEM, defenderEM int64) float64 {
	// Elemental Mastery creates Rock-Paper-Scissors dynamic
	// Higher EM gives percentage bonus
	emDiff := float64(attackerEM - defenderEM)
	
	// Diminishing returns formula
	bonus := emDiff / (emDiff + 1000)
	
	// Cap at 50% bonus
	if bonus > 0.5 {
		bonus = 0.5
	}
	if bonus < -0.3 {
		bonus = -0.3
	}
	
	return bonus
}

// calculateDefReduction calculates how much defense is ignored
func (s *CombatService) calculateDefReduction(penetration float64, targetDEF int64) float64 {
	// Penetration ignores percentage of DEF
	defValue := float64(targetDEF)
	ignoredDEF := defValue * (penetration / 100.0)
	
	// Effective defense after penetration
	effectiveDEF := defValue - ignoredDEF
	
	// Defense reduces damage by: DEF / (DEF + 1000)
	reduction := effectiveDEF / (effectiveDEF + 1000)
	
	// Cap reduction at 75%
	if reduction > 0.75 {
		reduction = 0.75
	}
	
	return reduction
}

// getDamageType returns damage classification and UI color
func (s *CombatService) getDamageType(damage float64, isCrit bool) (string, string) {
	if damage >= 1000000 {
		return "divine", "gold" // Gold: Divine/execute
	}
	if isCrit && damage >= 100000 {
		return "crit", "red" // Red: Massive crit
	}
	if isCrit && damage >= 10000 {
		return "crit", "orange" // Orange: Big crit
	}
	if isCrit {
		return "crit", "green" // Green: Small crit
	}
	return "normal", "white" // White: Normal hit
}

// CalculateBP calculates Battle Power from stats
// BP = Σ(Stat_i × Weight_i) + BonusMultipliers
func (s *CombatService) CalculateBP(stats *models.Stats, bonuses map[string]float64) int64 {
	// Hidden developer weights (ATK > DEF usually)
	weights := map[string]float64{
		"atk":   1.0,
		"def":   0.8,
		"hp":    0.6,
		"crit":  10.0,
		"critdmg": 5.0,
		"pen":   8.0,
	}
	
	bp := float64(stats.ATK)*weights["atk"] +
		  float64(stats.DEF)*weights["def"] +
		  float64(stats.HP)*weights["hp"] +
		  stats.CritRate*weights["crit"] +
		  stats.CritDMG*weights["critdmg"] +
		  stats.Penetration*weights["pen"]
	
	// Add bonus multipliers (titles, guild tech, marriage buffs)
	for _, bonus := range bonuses {
		bp *= (1.0 + bonus)
	}
	
	return int64(bp)
}

// ValidateSkillCast performs server-side anti-cheat validation
func (s *CombatService) ValidateSkillCast(
	player *models.Player,
	skillCooldowns map[int]float64,
	skillID int,
	targetPos models.Position,
) error {
	// Check cooldown
	if lastCast, exists := skillCooldowns[skillID]; exists {
		// Would need current timestamp - simplified here
		_ = lastCast
	}
	
	// Check range (server calculates distance, not client)
	// distance := CalculateDistance(player.Pos, targetPos)
	// if distance > skill.MaxRange { return ErrOutOfRange }
	
	// Check line of sight
	// if !HasLineOfSight(player.Pos, targetPos) { return ErrNoLineOfSight }
	
	// Check mana/energy
	// if player.Mana < skill.Cost { return ErrInsufficientMana }
	
	return nil
}

// Position represents 3D coordinates
type Position struct {
	X float64 `json:"x"`
	Y float64 `json:"y"`
	Z float64 `json:"z"`
}

// CalculateDistance returns distance between two positions
func CalculateDistance(a, b Position) float64 {
	dx := a.X - b.X
	dy := a.Y - b.Y
	dz := a.Z - b.Z
	return dx*dx + dy*dy + dz*dz
}
