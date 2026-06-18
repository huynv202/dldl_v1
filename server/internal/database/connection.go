package database

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/redis/go-redis/v9"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"sl-omega-server/internal/config"
)

var (
	DB    *gorm.DB
	Redis *redis.Client
)

func InitDB(cfg *config.Config) error {
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		cfg.DBUser,
		cfg.DBPassword,
		cfg.DBHost,
		cfg.DBPort,
		cfg.DBName,
	)

	var err error
	DB, err = gorm.Open(mysql.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		return fmt.Errorf("failed to connect to database: %w", err)
	}

	sqlDB, err := DB.DB()
	if err != nil {
		return fmt.Errorf("failed to get underlying DB: %w", err)
	}

	sqlDB.SetMaxOpenConns(cfg.DBMaxOpen)
	sqlDB.SetMaxIdleConns(cfg.DBMaxIdle)
	sqlDB.SetConnMaxLifetime(time.Hour)

	log.Println("Database connection established")
	return nil
}

func InitRedis(cfg *config.Config) error {
	Redis = redis.NewClient(&redis.Options{
		Addr:     cfg.RedisHost + ":" + cfg.RedisPort,
		Password: cfg.RedisPass,
		DB:       cfg.RedisDB,
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	_, err := Redis.Ping(ctx).Result()
	if err != nil {
		return fmt.Errorf("failed to connect to Redis: %w", err)
	}

	log.Println("Redis connection established")
	return nil
}

func Close() {
	if DB != nil {
		sqlDB, _ := DB.DB()
		sqlDB.Close()
	}
	if Redis != nil {
		Redis.Close()
	}
}
