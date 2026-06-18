package models

import (
	"time"
)

// Player progression tiers based on docs
type PlayerTier int

const (
	TierMortal PlayerTier = iota
	TierSpiritMaster
	TierSpiritElder
	TierTitledDouluo
	TierLimitDouluo
	TierGod
)

// Core stats architecture from combat system docs
type Stats struct {
	ATK           int64 `json:"atk"`            // Base attack
	DEF           int64 `json:"def"`            // Base defense
	HP            int64 `json:"hp"`             // Health points
	CritRate      float64 `json:"crit_rate"`    // Crit chance %
	CritDMG       float64 `json:"crit_dmg"`     // Crit damage multiplier %
	Penetration   float64 `json:"penetration"`  // Defense ignore %
	Accuracy      float64 `json:"accuracy"`     // Hit chance %
	Dodge         float64 `json:"dodge"`        // Dodge chance %
	CCResistance  float64 `json:"cc_resistance"`// Crowd control resistance %
	ElementalMastery int64 `json:"elem_mastery"`// Elemental advantage
}

// Battle Power calculation
func (s *Stats) CalculateBP() int64 {
	// BP = Σ(Stat_i × Weight_i)
	weights := map[string]float64{
		"atk": 1.0,
		"def": 0.8,
		"hp":  0.6,
	}
	
	bp := float64(s.ATK)*weights["atk"] + 
		  float64(s.DEF)*weights["def"] + 
		  float64(s.HP)*weights["hp"] +
		  s.CritRate*10 + 
		  s.CritDMG*5 +
		  s.Penetration*8
	
	return int64(bp)
}

// Martial Soul types from docs
type SoulType string

const (
	SoulControl  SoulType = "control"   // CC, debuffs
	SoulAttack   SoulType = "attack"    // Burst DPS
	SoulTank     SoulType = "tank"      // Damage absorption
	SoulSupport  SoulType = "support"   // Buffs
	SoulSpeedDPS SoulType = "speed_dps" // High crit/dodge
)

// Rarity tiers for gacha system
type Rarity string

const (
	RarityCommon  Rarity = "common"   // R - 90% rate
	RarityRare    Rarity = "rare"     // SR - 8% rate
	RarityEpic    Rarity = "epic"     // SSR - 2% rate
	RarityLegendary Rarity = "legendary"
	RarityDivine  Rarity = "divine"
)

// Soul Ring age tiers
type RingTier string

const (
	TierWhite  RingTier = "white"   // 10-100 years
	TierYellow RingTier = "yellow"  // 100-999 years
	TierPurple RingTier = "purple"  // 1k-9,999 years
	TierBlack  RingTier = "black"   // 10k-99,999 years
	TierRed    RingTier = "red"     // 100,000+ years
	TierGold   RingTier = "gold"    // 1M+ years
)

// Equipment slots
type EquipSlot string

const (
	SlotWeapon  EquipSlot = "weapon"
	SlotArmor   EquipSlot = "armor"
	SlotHelm    EquipSlot = "helm"
	SlotPants   EquipSlot = "pants"
	SlotBoots   EquipSlot = "boots"
	SlotGloves  EquipSlot = "gloves"
	SlotNecklace EquipSlot = "necklace"
	SlotRing1   EquipSlot = "ring1"
	SlotRing2   EquipSlot = "ring2"
	SlotArtifact EquipSlot = "artifact"
)

// Upgrade levels
type UpgradeLevel int

const (
	MaxEnhancement UpgradeLevel = 15  // +1 to +15
	MaxRefinement  UpgradeLevel = 10  // Star 1-10
	MaxAwakening   UpgradeLevel = 5   // Tier 1-5
)
