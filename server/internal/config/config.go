package config

import (
	"os"
	"strconv"
)

type Config struct {
	GinMode     string
	Port        string
	DBHost      string
	DBPort      string
	DBUser      string
	DBPassword  string
	DBName      string
	DBMaxOpen   int
	DBMaxIdle   int
	RedisHost   string
	RedisPort   string
	RedisPass   string
	RedisDB     int
	JWTSecret   string
	JWTExpire   int
	ServerID    int
	ServerName  string
	EXPRate     float64
	GoldRate    float64
	DropRate    float64
	GachaSSR    float64
	GachaSR     float64
	PitySoft    int
	PityHard    int
	RateLimit   int
}

var AppConfig *Config

func Load() *Config {
	config := &Config{
		GinMode:     getEnv("GIN_MODE", "release"),
		Port:        getEnv("PORT", "8080"),
		DBHost:      getEnv("DB_HOST", "localhost"),
		DBPort:      getEnv("DB_PORT", "3306"),
		DBUser:      getEnv("DB_USER", "root"),
		DBPassword:  getEnv("DB_PASSWORD", ""),
		DBName:      getEnv("DB_NAME", "sl_omega"),
		DBMaxOpen:   getEnvInt("DB_MAX_OPEN_CONNS", 100),
		DBMaxIdle:   getEnvInt("DB_MAX_IDLE_CONNS", 10),
		RedisHost:   getEnv("REDIS_HOST", "localhost"),
		RedisPort:   getEnv("REDIS_PORT", "6379"),
		RedisPass:   getEnv("REDIS_PASSWORD", ""),
		RedisDB:     getEnvInt("REDIS_DB", 0),
		JWTSecret:   getEnv("JWT_SECRET", "change-me"),
		JWTExpire:   getEnvInt("JWT_EXPIRE_HOURS", 72),
		ServerID:    getEnvInt("SERVER_ID", 1),
		ServerName:  getEnv("SERVER_NAME", "Dragon Soul"),
		EXPRate:     getEnvFloat("EXP_RATE", 1.0),
		GoldRate:    getEnvFloat("GOLD_RATE", 1.0),
		DropRate:    getEnvFloat("DROP_RATE", 1.0),
		GachaSSR:    getEnvFloat("GACHA_SSR_RATE", 0.02),
		GachaSR:     getEnvFloat("GACHA_SR_RATE", 0.08),
		PitySoft:    getEnvInt("PITY_SOFT_THRESHOLD", 50),
		PityHard:    getEnvInt("PITY_HARD_THRESHOLD", 90),
		RateLimit:   getEnvInt("RATE_LIMIT_PER_SECOND", 10),
	}
	AppConfig = config
	return config
}

func getEnv(key, defaultVal string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultVal
}

func getEnvInt(key string, defaultVal int) int {
	if value, exists := os.LookupEnv(key); exists {
		val, _ := strconv.Atoi(value)
		return val
	}
	return defaultVal
}

func getEnvFloat(key string, defaultVal float64) float64 {
	if value, exists := os.LookupEnv(key); exists {
		val, _ := strconv.ParseFloat(value, 64)
		return val
	}
	return defaultVal
}
