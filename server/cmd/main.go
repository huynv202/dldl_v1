package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"sl-omega-server/internal/config"
	"sl-omega-server/internal/database"
	"sl-omega-server/internal/handlers"
	"sl-omega-server/internal/middleware"
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using system environment")
	}

	// Load configuration
	cfg := config.Load()

	// Initialize database connections
	if err := database.InitDB(cfg); err != nil {
		log.Fatalf("Failed to initialize database: %v", err)
	}
	defer database.Close()

	if err := database.InitRedis(cfg); err != nil {
		log.Fatalf("Failed to initialize Redis: %v", err)
	}

	// Auto-migrate database tables
	if err := migrateDatabase(); err != nil {
		log.Fatalf("Failed to migrate database: %v", err)
	}

	// Setup Gin router
	gin.SetMode(cfg.GinMode)
	router := gin.Default()

	// Global middleware
	router.Use(middleware.CORS())
	router.Use(middleware.RateLimiter(cfg.RateLimit))

	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok", "server": cfg.ServerName})
	})

	// API routes
	api := router.Group("/api/v1")
	{
		// Public routes
		auth := api.Group("/auth")
		{
			auth.POST("/register", handlers.Register)
			auth.POST("/login", handlers.Login)
		}

		// Protected routes
		protected := api.Group("")
		protected.Use(middleware.JWTAuth())
		{
			// Player endpoints
			player := protected.Group("/player")
			{
				player.GET("/profile", handlers.GetPlayerProfile)
				player.GET("/stats", handlers.GetPlayerStats)
				player.POST("/upgrade", handlers.UpgradePlayer)
			}

			// Gacha endpoints
			gacha := protected.Group("/gacha")
			{
				gacha.POST("/pull", handlers.GachaPull)
				gacha.POST("/pull/ten", handlers.GachaTenPull)
				gacha.GET("/history", handlers.GetGachaHistory)
			}

			// Combat endpoints
			combat := protected.Group("/combat")
			{
				combat.POST("/battle", handlers.StartBattle)
				combat.POST("/skill", handlers.CastSkill)
				combat.GET("/bp", handlers.GetBattlePower)
			}

			// Equipment endpoints
			equipment := protected.Group("/equipment")
			{
				equipment.GET("", handlers.GetEquipment)
				equipment.POST("/enhance", handlers.EnhanceEquipment)
				equipment.POST("/refine", handlers.RefineEquipment)
				equipment.POST("/gem", handlers.SocketGem)
			}

			// Soul Ring endpoints
			soulrings := protected.Group("/soul-rings")
			{
				soulrings.GET("", handlers.GetSoulRings)
				soulrings.POST("/hunt", handlers.HuntSoulRing)
				soulrings.POST("/upgrade", handlers.UpgradeSoulRing)
			}

			// Inventory endpoints
			inventory := protected.Group("/inventory")
			{
				inventory.GET("", handlers.GetInventory)
				inventory.POST("/use", handlers.UseItem)
			}

			// Daily rewards / retention
			daily := protected.Group("/daily")
			{
				daily.GET("/rewards", handlers.GetDailyRewards)
				daily.POST("/claim", handlers.ClaimDailyReward)
				daily.GET("/quests", handlers.GetDailyQuests)
			}
		}
	}

	// WebSocket endpoint for real-time features
	router.GET("/ws", handlers.HandleWebSocket)

	// Start server
	go func() {
		addr := ":" + cfg.Port
		log.Printf("Starting SL-OMEGA server on %s", addr)
		if err := router.Run(addr); err != nil {
			log.Fatalf("Failed to start server: %v", err)
		}
	}()

	// Graceful shutdown
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	log.Println("Shutting down server...")
}

// migrateDatabase auto-migrates all models
func migrateDatabase() error {
	return database.DB.AutoMigrate(
		// Add models here
	)
}
