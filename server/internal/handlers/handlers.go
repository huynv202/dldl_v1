package handlers

import (
"net/http"

"github.com/gin-gonic/gin"
"gorm.io/gorm"
"sl-omega-server/internal/database"
"sl-omega-server/internal/models"
"sl-omega-server/pkg/gacha"
"sl-omega-server/pkg/combat"
"sl-omega-server/internal/config"
)

var (
gachaService  *gacha.GachaService
combatService *combat.CombatService
)

func init() {
cfg := config.Load()
gachaService = gacha.NewGachaService(cfg)
combatService = combat.NewCombatService()
}

type RegisterRequest struct {
Username string `json:"username" binding:"required"`
Password string `json:"password" binding:"required"`
Email    string `json:"email"`
}

func Register(c *gin.Context) {
var req RegisterRequest
if err := c.ShouldBindJSON(&req); err != nil {
c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
return
}

player := models.Player{
Username: req.Username,
Email:    req.Email,
Level:    1,
Stamina:  100,
Gold:     1000,
Diamonds: 100,
}

player.PasswordHash = req.Password

if err := database.DB.Create(&player).Error; err != nil {
c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create player"})
return
}

c.JSON(http.StatusCreated, gin.H{
"id":       player.ID,
"username": player.Username,
"message":  "Registration successful",
})
}

type LoginRequest struct {
Username string `json:"username" binding:"required"`
Password string `json:"password" binding:"required"`
}

func Login(c *gin.Context) {
var req LoginRequest
if err := c.ShouldBindJSON(&req); err != nil {
c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
return
}

var player models.Player
if err := database.DB.Where("username = ?", req.Username).First(&player).Error; err != nil {
if err == gorm.ErrRecordNotFound {
c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
return
}
c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
return
}

if player.PasswordHash != req.Password {
c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
return
}

token := "sample-jwt-token"

c.JSON(http.StatusOK, gin.H{
"token": token,
"player": gin.H{
"id":       player.ID,
"username": player.Username,
"level":    player.Level,
"bp":       player.BattlePower,
},
})
}

func GetPlayerProfile(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Profile endpoint"})
}

func GetPlayerStats(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Stats endpoint"})
}

func UpgradePlayer(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Upgrade successful"})
}

func GachaPull(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Gacha pull"})
}

func GachaTenPull(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Ten pull"})
}

func GetGachaHistory(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"history": []interface{}{}})
}

func StartBattle(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Battle started"})
}

type SkillCastRequest struct {
SkillID   int     `json:"skill_id"`
TargetX   float64 `json:"target_x"`
TargetY   float64 `json:"target_y"`
TargetZ   float64 `json:"target_z"`
}

func CastSkill(c *gin.Context) {
var req SkillCastRequest
if err := c.ShouldBindJSON(&req); err != nil {
c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
return
}
c.JSON(http.StatusOK, gin.H{"message": "Skill cast successful"})
}

func GetBattlePower(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"battle_power": 500})
}

func GetEquipment(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"equipment": []interface{}{}})
}

func EnhanceEquipment(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Enhancement successful"})
}

func RefineEquipment(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Refinement successful"})
}

func SocketGem(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Gem socketed"})
}

func GetSoulRings(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"soul_rings": []interface{}{}})
}

func HuntSoulRing(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Hunt completed"})
}

func UpgradeSoulRing(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Ring upgraded"})
}

func GetInventory(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"inventory": []interface{}{}})
}

func UseItem(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Item used"})
}

func GetDailyRewards(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{
"rewards": []gin.H{
{"day": 1, "reward": "100 Gold", "claimed": false},
{"day": 7, "reward": "SSR Shard", "claimed": false},
},
})
}

func ClaimDailyReward(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "Reward claimed"})
}

func GetDailyQuests(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{
"quests": []gin.H{
{"id": 1, "name": "Kill 10 Mobs", "progress": 0, "reward": "10 Activity"},
{"id": 2, "name": "Enhance Gear", "progress": 0, "reward": "15 Activity"},
{"id": 3, "name": "Arena Fights", "progress": 0, "reward": "20 Activity"},
},
"activity_points": 0,
})
}

func HandleWebSocket(c *gin.Context) {
c.JSON(http.StatusOK, gin.H{"message": "WebSocket upgrade"})
}
