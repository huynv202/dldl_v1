package engine

import (
	"fmt"
	"math"
	"math/rand"
	"time"
)

// CombatEngine xử lý toàn bộ logic chiến đấu theo design docs
type CombatEngine struct {
	config *CombatConfig
}

type CombatConfig struct {
	BaseDamageFactor    float64
	CritBaseRate        float64
	CritDamageBase      float64
	AccuracyBase        float64
	DodgeBase           float64
	BlockBase           float64
	PenetrationFactor   float64
	DefenseDiminishing  float64
}

func NewCombatEngine() *CombatEngine {
	return &CombatEngine{
		config: &CombatConfig{
			BaseDamageFactor:    1.5,
			CritBaseRate:        0.05,
			CritDamageBase:      1.5,
			AccuracyBase:        100.0,
			DodgeBase:           0.0,
			BlockBase:           0.0,
			PenetrationFactor:   0.001,
			DefenseDiminishing:  0.95,
		},
	}
}

// AttackResult kết quả của một đòn đánh
type AttackResult struct {
	IsCrit       bool
	IsDodge      bool
	IsBlock      bool
	Damage       int64
	FinalDamage  int64
	BPGenerated  int
	EffectType   string // "physical", "fire", "ice", etc.
}

// CalculateDamage tính toán damage theo formula trong docs
// Damage = (ATK × SkillMultiplier - DEF × DefenseFactor) × CritModifier × ElementModifier
func (e *CombatEngine) CalculateDamage(attacker *CombatStats, defender *CombatStats, skillMultiplier float64, elementAdvantage float64) *AttackResult {
	result := &AttackResult{}

	// 1. Check Dodge
	dodgeChance := e.calculateDodgeChance(attacker, defender)
	if rand.Float64() < dodgeChance {
		result.IsDodge = true
		result.Damage = 0
		result.FinalDamage = 0
		return result
	}

	// 2. Check Block (nếu có shield)
	if defender.BlockRate > 0 && rand.Float64() < defender.BlockRate {
		result.IsBlock = true
	}

	// 3. Base Damage Calculation
	baseDamage := attacker.Attack * skillMultiplier
	
	// Defense mitigation với diminishing returns
	defenseMitigation := defender.Defense / (defender.Defense + e.config.DefenseDiminishing*attacker.Attack)
	defenseReduction := baseDamage * defenseMitigation * 0.5
	
	netDamage := baseDamage - defenseReduction
	
	// Apply penetration
	if attacker.Penetration > 0 {
		penetrationBonus := math.Min(float64(attacker.Penetration)*e.config.PenetrationFactor, 0.5)
		netDamage *= (1 + penetrationBonus)
	}

	// 4. Critical Hit Calculation
	critChance := e.calculateCritChance(attacker, defender)
	critDamage := e.config.CritDamageBase + attacker.CritDamageBonus
	
	if rand.Float64() < critChance {
		result.IsCrit = true
		netDamage *= critDamage
	}

	// 5. Element Advantage
	netDamage *= elementAdvantage

	// 6. Random Variance (±5%)
	variance := 0.95 + rand.Float64()*0.1
	netDamage *= variance

	result.Damage = int64(math.Max(1, netDamage))
	result.FinalDamage = result.Damage
	
	if result.IsBlock {
		result.FinalDamage = result.Damage / 2
	}

	// 7. Calculate BP Generation
	result.BPGenerated = e.calculateBPGeneration(result.Damage, attacker, skillMultiplier)

	return result
}

func (e *CombatEngine) calculateCritChance(attacker, defender *CombatStats) float64 {
	baseCrit := e.config.CritBaseRate + attacker.CritRate
	
	// Anti-crit từ defender
	antiCrit := defender.AntiCrit * 0.001 // 1000 anti-crit = -10%
	
	finalCrit := baseCrit - antiCrit
	return math.Max(0.01, math.Min(0.8, finalCrit)) // Clamp 1%-80%
}

func (e *CombatEngine) calculateDodgeChance(attacker, defender *CombatStats) float64 {
	accuracy := e.config.AccuracyBase + attacker.Accuracy
	dodge := defender.Dodge
	
	// Formula: Dodge% = Dodge / (Dodge + Accuracy * K)
	k := 100.0
	dodgeChance := float64(dodge) / (float64(dodge) + accuracy*k/100)
	
	return math.Max(0, math.Min(0.75, dodgeChance)) // Clamp 0%-75%
}

func (e *CombatEngine) calculateBPGeneration(damage int64, attacker *CombatStats, skillMultiplier float64) int {
	// BP = (Damage / EnemyMaxHP * 100) * SkillFactor + BaseBP
	baseBP := 5.0
	
	if skillMultiplier > 1.0 {
		baseBP *= 1.5 // Ultimate skills generate more BP
	}
	
	bpFromDamage := float64(damage) / float64(attacker.TargetMaxHP) * 100 * 0.3
	
	totalBP := baseBP + bpFromDamage
	totalBP *= (1 + attacker.BPBonus) // BP generation bonus
	
	return int(math.Max(1, totalBP))
}

// CombatStats thống số chiến đấu
type CombatStats struct {
	Attack            int64
	Defense           int64
	HP                int64
	MaxHP             int64
	CritRate          float64
	CritDamageBonus   float64
	AntiCrit          int64
	Accuracy          int64
	Dodge             int64
	BlockRate         float64
	Penetration       int64
	ElementPower      int64
	ElementResist     int64
	BPBonus           float64
	TargetMaxHP       int64 // Để tính BP generation
}

// BattleState trạng thái trận đấu
type BattleState struct {
	Turn              int
	Attacker          *BattleUnit
	Defender          *BattleUnit
	ActionQueue       []*BattleAction
	Logs              []string
	IsFinished        bool
	Winner            *BattleUnit
}

type BattleUnit struct {
	ID              string
	Name            string
	Level           int
	Stats           *CombatStats
	CurrentHP       int64
	BP              int
	Skills          []*Skill
	Buffs           []*Buff
	Debuffs         []*Debuff
	IsAlive         bool
	Speed           int64
}

type BattleAction struct {
	UnitID      string
	ActionType  string // "attack", "skill", "item", "passive"
	SkillID     string
	TargetIDs   []string
	Priority    int
}

type Skill struct {
	ID              string
	Name            string
	Multiplier      float64
	BPCost          int
	Cooldown        int
	ElementType     string
	TargetType      string // "single", "aoe", "self"
	Effects         []SkillEffect
}

type SkillEffect struct {
	Type        string // "damage", "heal", "buff", "debuff", "dot"
	Value       float64
	Duration    int
	Stackable   bool
}

type Buff struct {
	ID          string
	Name        string
	StatMod     map[string]float64
	Duration    int
	Remaining   int
	StackCount  int
}

type Debuff struct {
	ID          string
	Name        string
	StatMod     map[string]float64
	DoTValue    int64
	Duration    int
	Remaining   int
}

// StartBattle khởi tạo trận đấu
func (e *CombatEngine) StartBattle(attacker, defender *BattleUnit) *BattleState {
	state := &BattleState{
		Turn:       0,
		Attacker:   attacker,
		Defender:   defender,
		ActionQueue: make([]*BattleAction, 0),
		Logs:       make([]string, 0),
		IsFinished: false,
	}
	
	// Initialize units
	state.Attacker.CurrentHP = state.Attacker.Stats.HP
	state.Attacker.BP = 0
	state.Attacker.IsAlive = true
	
	state.Defender.CurrentHP = state.Defender.Stats.HP
	state.Defender.BP = 0
	state.Defender.IsAlive = true
	
	// Set target max HP for BP calculation
	state.Attacker.Stats.TargetMaxHP = state.Defender.Stats.MaxHP
	state.Defender.Stats.TargetMaxHP = state.Attacker.Stats.MaxHP
	
	// First action queue based on speed
	e.queueNextActions(state)
	
	return state
}

// ExecuteTurn thực hiện một lượt
func (e *CombatEngine) ExecuteTurn(state *BattleState) *BattleState {
	if state.IsFinished {
		return state
	}
	
	state.Turn++
	
	// Sort actions by priority (speed)
	e.sortActionQueue(state)
	
	// Execute first action
	if len(state.ActionQueue) > 0 {
		action := state.ActionQueue[0]
		state.ActionQueue = state.ActionQueue[1:]
		
		e.executeAction(state, action)
	}
	
	// Check death
	if state.Attacker.CurrentHP <= 0 {
		state.Attacker.IsAlive = false
		state.IsFinished = true
		state.Winner = state.Defender
		state.Logs = append(state.Logs, formatLog("%s đã thua!", state.Attacker.Name))
	} else if state.Defender.CurrentHP <= 0 {
		state.Defender.IsAlive = false
		state.IsFinished = true
		state.Winner = state.Attacker
		state.Logs = append(state.Logs, formatLog("%s đã thắng!", state.Attacker.Name))
	}
	
	// Queue next actions if battle continues
	if !state.IsFinished {
		e.queueNextActions(state)
	}
	
	// Process DoT and buff/debuff timers
	e.processTimedEffects(state)
	
	return state
}

func (e *CombatEngine) executeAction(state *BattleState, action *BattleAction) {
	unit := state.Attacker
	if action.UnitID == state.Defender.ID {
		unit = state.Defender
	}
	
	switch action.ActionType {
	case "attack":
		e.executeBasicAttack(state, unit)
	case "skill":
		e.executeSkill(state, unit, action.SkillID)
	case "passive":
		e.executePassive(state, unit)
	}
	
	state.Logs = append(state.Logs, formatLog("Turn %d: %s uses %s", state.Turn, unit.Name, action.ActionType))
}

func (e *CombatEngine) executeBasicAttack(state *BattleState, attacker *BattleUnit) {
	target := state.Defender
	if attacker.ID == state.Defender.ID {
		target = state.Attacker
	}
	
	result := e.CalculateDamage(attacker.Stats, target.Stats, 1.0, 1.0)
	target.CurrentHP -= result.FinalDamage
	attacker.BP += result.BPGenerated
	
	logMsg := formatLog("%s tấn công gây %d damage", attacker.Name, result.FinalDamage)
	if result.IsCrit {
		logMsg += " (CRIT!)"
	}
	if result.IsDodge {
		logMsg = formatLog("%s né tránh đòn tấn công!", target.Name)
	}
	state.Logs = append(state.Logs, logMsg)
}

func (e *CombatEngine) executeSkill(state *BattleState, attacker *BattleUnit, skillID string) {
	// Find skill
	var skill *Skill
	for _, s := range attacker.Skills {
		if s.ID == skillID {
			skill = s
			break
		}
	}
	
	if skill == nil || attacker.BP < skill.BPCost {
		return
	}
	
	attacker.BP -= skill.BPCost
	
	target := state.Defender
	if attacker.ID == state.Defender.ID {
		target = state.Attacker
	}
	
	// Calculate element advantage
	elementAdvantage := e.getElementAdvantage(skill.ElementType, target)
	
	result := e.CalculateDamage(attacker.Stats, target.Stats, skill.Multiplier, elementAdvantage)
	target.CurrentHP -= result.FinalDamage
	
	logMsg := formatLog("%s dùng kỹ năng %s gây %d damage", attacker.Name, skill.Name, result.FinalDamage)
	state.Logs = append(state.Logs, logMsg)
	
	// Apply skill effects
	for _, effect := range skill.Effects {
		e.applySkillEffect(state, target, effect)
	}
}

func (e *CombatEngine) getElementAdvantage(element string, target *BattleUnit) float64 {
	// Simple element system: Fire > Nature > Water > Fire
	// Holy <> Dark counter each other
	multiplier := 1.0
	
	// Implement based on your element system
	_ = element
	_ = target
	
	return multiplier
}

func (e *CombatEngine) applySkillEffect(state *BattleState, target *BattleUnit, effect SkillEffect) {
	switch effect.Type {
	case "buff":
		target.Buffs = append(target.Buffs, &Buff{
			ID:        "buff_" + time.Now().String(),
			StatMod:   effect.StatMod,
			Duration:  effect.Duration,
			Remaining: effect.Duration,
		})
	case "debuff":
		target.Debuffs = append(target.Debuffs, &Debuff{
			ID:        "debuff_" + time.Now().String(),
			StatMod:   effect.StatMod,
			Duration:  effect.Duration,
			Remaining: effect.Duration,
		})
	case "dot":
		target.Debuffs = append(target.Debuffs, &Debuff{
			ID:        "dot_" + time.Now().String(),
			DoTValue:  int64(effect.Value),
			Duration:  effect.Duration,
			Remaining: effect.Duration,
		})
	}
}

func (e *CombatEngine) processTimedEffects(state *BattleState) {
	// Process DoT damage
	for _, unit := range []*BattleUnit{state.Attacker, state.Defender} {
		for _, debuff := range unit.Debuffs {
			if debuff.DoTValue > 0 {
				unit.CurrentHP -= debuff.DoTValue
				state.Logs = append(state.Logs, formatLog("%s chịu %d damage từ DoT", unit.Name, debuff.DoTValue))
			}
		}
		
		// Decrease duration
		newBuffs := []*Buff{}
		for _, buff := range unit.Buffs {
			buff.Remaining--
			if buff.Remaining > 0 {
				newBuffs = append(newBuffs, buff)
			}
		}
		unit.Buffs = newBuffs
		
		newDebuffs := []*Debuff{}
		for _, debuff := range unit.Debuffs {
			debuff.Remaining--
			if debuff.Remaining > 0 {
				newDebuffs = append(newDebuffs, debuff)
			}
		}
		unit.Debuffs = newDebuffs
	}
}

func (e *CombatEngine) queueNextActions(state *BattleState) {
	// Add basic attack for both units
	if state.Attacker.IsAlive {
		state.ActionQueue = append(state.ActionQueue, &BattleAction{
			UnitID:     state.Attacker.ID,
			ActionType: "attack",
			Priority:   int(state.Attacker.Speed),
		})
	}
	
	if state.Defender.IsAlive {
		state.ActionQueue = append(state.ActionQueue, &BattleAction{
			UnitID:     state.Defender.ID,
			ActionType: "attack",
			Priority:   int(state.Defender.Speed),
		})
	}
}

func (e *CombatEngine) sortActionQueue(state *BattleState) {
	// Sort by priority (speed) descending
	for i := 0; i < len(state.ActionQueue)-1; i++ {
		for j := i + 1; j < len(state.ActionQueue); j++ {
			if state.ActionQueue[j].Priority > state.ActionQueue[i].Priority {
				state.ActionQueue[i], state.ActionQueue[j] = state.ActionQueue[j], state.ActionQueue[i]
			}
		}
	}
}

func formatLog(format string, args ...interface{}) string {
	return fmt.Sprintf(format, args...)
}
