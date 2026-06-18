package models

import (
	"time"
	"gorm.io/gorm"
)

// Player represents the core player entity
type Player struct {
	ID              uint64    `gorm:"primaryKey" json:"id"`
	Username        string    `gorm:"uniqueIndex;size:50" json:"username"`
	PasswordHash    string    `gorm:"size:255" json:"-"`
	Email           string    `gorm:"size:100" json:"email"`
	
	// Progression
	Level           int       `gorm:"default:1" json:"level"`
	EXP             int64     `gorm:"default:0" json:"exp"`
	Tier            PlayerTier `gorm:"default:0" json:"tier"`
	Title           string    `gorm:"size:100" json:"title"`
	
	// Core Stats
	Stats           Stats     `gorm:"embedded" json:"stats"`
	BattlePower     int64     `gorm:"default:0" json:"battle_power"`
	
	// Resources
	Gold            int64     `gorm:"default:0" json:"gold"`
	Diamonds        int64     `gorm:"default:0" json:"diamonds"`
	BoundDiamonds   int64     `gorm:"default:0" json:"bound_diamonds"`
	Stamina         int       `gorm:"default:100" json:"stamina"`
	
	// Gacha System
	GachaPityCount  int       `gorm:"default:0" json:"gacha_pity"`
	LastGachaSSR    bool      `gorm:"default:false" json:"last_gacha_ssr"` // For guarantee mechanic
	
	// Social
	GuildID         *uint64   `json:"guild_id"`
	FriendCount     int       `gorm:"default:0" json:"friend_count"`
	
	// Retention Systems
	LoginStreak     int       `gorm:"default:0" json:"login_streak"`
	LastLoginAt     *time.Time `json:"last_login_at"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`
	DeletedAt       gorm.DeletedAt `gorm:"index" json:"-"`
	
	// Relations
	MartialSoul     MartialSoul `gorm:"foreignKey:PlayerID" json:"martial_soul"`
	Equipment       []Equipment `gorm:"foreignKey:PlayerID" json:"equipment"`
	SoulRings       []SoulRing  `gorm:"foreignKey:PlayerID" json:"soul_rings"`
	Inventory       []Inventory `gorm:"foreignKey:PlayerID" json:"inventory"`
}

// TableName overrides table name
func (Player) TableName() string {
	return "players"
}

// Martial Soul system
type MartialSoul struct {
	ID          uint64   `gorm:"primaryKey" json:"id"`
	PlayerID    uint64   `gorm:"index" json:"player_id"`
	Name        string   `gorm:"size:100" json:"name"`
	Type        SoulType `gorm:"size:20" json:"type"`
	Rarity      Rarity   `gorm:"size:20" json:"rarity"`
	Level       int      `gorm:"default:1" json:"level"`
	StarLevel   int      `gorm:"default:0" json:"star_level"`
	Skills      []Skill  `gorm:"foreignKey:MartialSoulID" json:"skills"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

func (MartialSoul) TableName() string {
	return "martial_souls"
}

// Skill from martial soul or soul rings
type Skill struct {
	ID            uint64   `gorm:"primaryKey" json:"id"`
	MartialSoulID *uint64  `json:"martial_soul_id"`
	SoulRingID    *uint64  `json:"soul_ring_id"`
	Name          string   `gorm:"size:100" json:"name"`
	Description   string   `gorm:"size:500" json:"description"`
	BaseDamage    float64  `json:"base_damage"`
	Coefficient   float64  `json:"coefficient"` // SkillCoeff in damage formula
	Cooldown      int      `json:"cooldown"`    // Seconds
	ManaCost      int      `json:"mana_cost"`
	Level         int      `gorm:"default:1" json:"level"`
}

func (Skill) TableName() string {
	return "skills"
}

// Soul Ring progression system
type SoulRing struct {
	ID          uint64   `gorm:"primaryKey" json:"id"`
	PlayerID    uint64   `gorm:"index" json:"player_id"`
	BeastName   string   `gorm:"size:100" json:"beast_name"`
	Tier        RingTier `gorm:"size:20" json:"tier"`
	Years       int64    `json:"years"` // Age in years
	Color       string   `gorm:"size:20" json:"color"`
	StatMult    float64  `json:"stat_mult"` // Stat multiplier based on tier
	MainStat    string   `gorm:"size:50" json:"main_stat"`
	MainValue   float64  `json:"main_value"`
	SubStats    []SubStat `gorm:"foreignKey:SoulRingID" json:"sub_stats"`
	Skill       *Skill   `gorm:"foreignKey:SoulRingID" json:"skill"`
	IsEquipped  bool     `gorm:"default:false" json:"is_equipped"`
	CreatedAt   time.Time `json:"created_at"`
}

func (SoulRing) TableName() string {
	return "soul_rings"
}

// Sub-stat for soul rings
type SubStat struct {
	ID         uint64  `gorm:"primaryKey" json:"id"`
	SoulRingID uint64  `gorm:"index" json:"soul_ring_id"`
	StatType   string  `gorm:"size:50" json:"stat_type"` // ATK%, Crit DMG, etc.
	Value      float64 `json:"value"`
}

func (SubStat) TableName() string {
	return "sub_stats"
}

// Equipment system
type Equipment struct {
	ID           uint64    `gorm:"primaryKey" json:"id"`
	PlayerID     uint64    `gorm:"index" json:"player_id"`
	Name         string    `gorm:"size:100" json:"name"`
	Slot         EquipSlot `gorm:"size:20" json:"slot"`
	Rarity       Rarity    `gorm:"size:20" json:"rarity"`
	BaseStats    Stats     `gorm:"embedded" json:"base_stats"`
	
	// Upgrade layers
	Enhancement  int       `gorm:"default:0" json:"enhancement"` // +0 to +15
	Refinement   int       `gorm:"default:0" json:"refinement"`  // Star 1-10
	Awakening    int       `gorm:"default:0" json:"awakening"`   // Tier 1-5
	IsTranscendent bool    `gorm:"default:false" json:"is_transcendent"` // Red gear
	
	// Gem sockets
	GemSlots     int       `gorm:"default:3" json:"gem_slots"`
	Gems         []Gem     `gorm:"foreignKey:EquipmentID" json:"gems"`
	
	// Set bonus
	SetName      string    `gorm:"size:100" json:"set_name"`
	IsEquipped   bool      `gorm:"default:false" json:"is_equipped"`
	
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

func (Equipment) TableName() string {
	return "equipment"
}

// Gem socketing system
type Gem struct {
	ID          uint64   `gorm:"primaryKey" json:"id"`
	EquipmentID uint64   `gorm:"index" json:"equipment_id"`
	Type        string   `gorm:"size:50" json:"type"` // Ruby, Sapphire, Topaz
	Level       int      `gorm:"default:1" json:"level"`
	StatBonus   float64  `json:"stat_bonus"`
}

func (Gem) TableName() string {
	return "gems"
}

// Inventory items
type Inventory struct {
	ID        uint64    `gorm:"primaryKey" json:"id"`
	PlayerID  uint64    `gorm:"index" json:"player_id"`
	ItemID    uint64    `json:"item_id"`
	ItemType  string    `gorm:"size:50" json:"item_type"` // material, consumable, fragment
	Name      string    `gorm:"size:100" json:"name"`
	Quantity  int64     `gorm:"default:1" json:"quantity"`
	MaxStack  int64     `gorm:"default:999" json:"max_stack"`
	
	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
}

func (Inventory) TableName() string {
	return "inventory"
}

// Gacha history for pity system
type GachaLog struct {
	ID        uint64    `gorm:"primaryKey" json:"id"`
	PlayerID  uint64    `gorm:"index" json:"player_id"`
	BannerID  uint64    `json:"banner_id"`
	Result    string    `gorm:"size:50" json:"result"` // SSR, SR, R
	ItemID    uint64    `json:"item_id"`
	ItemName  string    `gorm:"size:100" json:"item_name"`
	IsRateUp  bool      `json:"is_rate_up"`
	PullCount int       `json:"pull_count"` // Pull number in this session
	CreatedAt time.Time `json:"created_at"`
}

func (GachaLog) TableName() string {
	return "gacha_logs"
}
