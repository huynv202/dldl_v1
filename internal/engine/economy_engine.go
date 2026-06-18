package engine

import (
"fmt"
"math"
"math/rand"
"time"
)

// EconomyEngine quản lý nền kinh tế game theo design docs
type EconomyEngine struct {
config *EconomyConfig
}

type EconomyConfig struct {
GoldQuestBaseReward    int64
GoldQuestScaling       float64
GoldMonsterBaseDrop    int64
GoldMonsterScaling     float64
DiamondDailyLogin      int64
DiamondAchievement     int64
DiamondEvent           int64
EnergyRefillCost       int64
SkillUpgradeGoldBase   int64
SkillUpgradeGoldScale  float64
EquipmentEnhanceGold   int64
MaxDailyGoldSource     int64
GoldTaxRate            float64
}

func NewEconomyEngine() *EconomyEngine {
return &EconomyEngine{
config: &EconomyConfig{
GoldQuestBaseReward:    100,
GoldQuestScaling:       1.05,
GoldMonsterBaseDrop:    50,
GoldMonsterScaling:     1.03,
DiamondDailyLogin:      50,
DiamondAchievement:     100,
DiamondEvent:           200,
EnergyRefillCost:       50,
SkillUpgradeGoldBase:   500,
SkillUpgradeGoldScale:  1.15,
EquipmentEnhanceGold:   100,
MaxDailyGoldSource:     50000,
GoldTaxRate:            0.05,
},
}
}

type EconomyState struct {
PlayerID        string
Gold            int64
Diamonds        int64
BoundDiamonds   int64
Silver          int64
GuildPoints     int64
ArenaPoints     int64
EventTokens     int64
DailyGoldEarned int64
LastResetTime   int64
}

func (e *EconomyEngine) CalculateQuestGoldReward(questLevel int, questTier string, completionStars int) int64 {
baseReward := e.config.GoldQuestBaseReward
levelMultiplier := math.Pow(e.config.GoldQuestScaling, float64(questLevel-1))

tierMultipliers := map[string]float64{"common": 1.0, "rare": 1.5, "epic": 2.0, "legendary": 3.0}
tierMult := tierMultipliers[questTier]
if tierMult == 0 {
tierMult = 1.0
}

starBonuses := map[int]float64{3: 1.0, 2: 0.7, 1: 0.4}
starBonus := starBonuses[completionStars]
if starBonus == 0 {
starBonus = 0.0
}

reward := float64(baseReward) * levelMultiplier * tierMult * starBonus
return int64(reward)
}

func (e *EconomyEngine) CalculateMonsterGoldDrop(monsterLevel int, isElite bool, isBoss bool) int64 {
baseDrop := e.config.GoldMonsterBaseDrop
levelMultiplier := math.Pow(e.config.GoldMonsterScaling, float64(monsterLevel-1))
drop := float64(baseDrop) * levelMultiplier

if isElite {
drop *= 2.0
}
if isBoss {
drop *= 5.0
}

variance := 0.9 + rand.Float64()*0.2
drop *= variance

return int64(drop)
}

func (e *EconomyEngine) CalculateSkillUpgradeCost(currentLevel int, skillRarity string) (gold int64, diamonds int64) {
baseCost := e.config.SkillUpgradeGoldBase
costMultiplier := math.Pow(e.config.SkillUpgradeGoldScale, float64(currentLevel))
gold = int64(float64(baseCost) * costMultiplier)

if currentLevel >= 10 {
diamonds = int64(10 * math.Pow(1.2, float64(currentLevel-10)))
}

rarityModifiers := map[string]float64{"common": 1.0, "rare": 1.5, "epic": 2.0, "legendary": 3.0, "divine": 5.0}
mod := rarityModifiers[skillRarity]
if mod == 0 {
mod = 1.0
}

gold = int64(float64(gold) * mod)
diamonds = int64(float64(diamonds) * mod)

return gold, diamonds
}

func (e *EconomyEngine) CalculateEquipmentEnhanceCost(currentLevel int, equipmentTier int) (gold int64, materialCount int) {
baseGold := e.config.EquipmentEnhanceGold
gold = int64(float64(baseGold) * math.Pow(1.1, float64(currentLevel)))
materialCount = 1 + (currentLevel / 5)
tierMultiplier := 1.0 + float64(equipmentTier)*0.2
gold = int64(float64(gold) * tierMultiplier)
materialCount = int(float64(materialCount) * tierMultiplier)
return gold, materialCount
}

func (e *EconomyEngine) ApplyTransactionTax(amount int64) (tax int64, netAmount int64) {
tax = int64(float64(amount) * e.config.GoldTaxRate)
netAmount = amount - tax
return tax, netAmount
}

func (e *EconomyEngine) CanAfford(state *EconomyState, gold int64, diamonds int64, useBoundDiamonds bool) bool {
canAffordGold := state.Gold >= gold
var availableDiamonds int64
if useBoundDiamonds {
availableDiamonds = state.Diamonds + state.BoundDiamonds
} else {
availableDiamonds = state.Diamonds
}
canAffordDiamonds := availableDiamonds >= diamonds
return canAffordGold && canAffordDiamonds
}

func (e *EconomyEngine) Purchase(state *EconomyState, goldCost int64, diamondCost int64, useBoundDiamonds bool) error {
if !e.CanAfford(state, goldCost, diamondCost, useBoundDiamonds) {
return fmt.Errorf("insufficient funds")
}
state.Gold -= goldCost
if useBoundDiamonds && state.Diamonds < diamondCost {
remaining := diamondCost - state.Diamonds
state.Diamonds = 0
state.BoundDiamonds -= remaining
} else {
state.Diamonds -= diamondCost
}
return nil
}

func (e *EconomyEngine) AddCurrency(state *EconomyState, gold int64, diamonds int64, isBound bool) {
state.Gold += gold
if isBound {
state.BoundDiamonds += diamonds
} else {
state.Diamonds += diamonds
}
}

func (e *EconomyEngine) CheckDailyLimit(state *EconomyState, additionalGold int64) bool {
return state.DailyGoldEarned+additionalGold <= e.config.MaxDailyGoldSource
}

func (e *EconomyEngine) ResetDaily(state *EconomyState) {
state.DailyGoldEarned = 0
state.LastResetTime = time.Now().Unix()
}

func (e *EconomyEngine) CalculateVIPDiscount(vipLevel int) float64 {
discount := math.Min(0.2, float64(vipLevel)*0.015)
return discount
}

func (e *EconomyEngine) GetShopPrice(basePrice int64, vipLevel int) int64 {
discount := e.CalculateVIPDiscount(vipLevel)
finalPrice := float64(basePrice) * (1 - discount)
return int64(finalPrice)
}

func (e *EconomyEngine) ExchangeCurrency(state *EconomyState, from string, to string, amount int64) (received int64, err error) {
exchangeRates := map[string]float64{
"gold_to_silver": 100.0,
"diamond_to_gold": 1000.0,
"gold_to_diamond": 0.001,
}

rateKey := from + "_to_" + to
rate, exists := exchangeRates[rateKey]
if !exists {
return 0, fmt.Errorf("unsupported exchange pair")
}

fee := 0.1
received = int64(float64(amount) * rate * (1 - fee))

switch from {
case "gold":
if state.Gold < amount {
return 0, fmt.Errorf("insufficient gold")
}
state.Gold -= amount
case "diamonds":
if state.Diamonds < amount {
return 0, fmt.Errorf("insufficient diamonds")
}
state.Diamonds -= amount
case "silver":
if state.Silver < amount {
return 0, fmt.Errorf("insufficient silver")
}
state.Silver -= amount
}

switch to {
case "gold":
state.Gold += received
case "diamonds":
state.Diamonds += received
case "silver":
state.Silver += received
}

return received, nil
}
