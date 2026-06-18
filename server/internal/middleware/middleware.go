package middleware

import (
	"net/http"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"golang.org/x/time/rate"
)

// CORS middleware for cross-origin requests
func CORS() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(http.StatusNoContent)
			return
		}

		c.Next()
	}
}

// RateLimiter implements per-IP rate limiting for anti-cheat
func RateLimiter(maxPerSecond int) gin.HandlerFunc {
	var (
		mu      sync.Mutex
		limiters = make(map[string]*rate.Limiter)
	)

	return func(c *gin.Context) {
		ip := c.ClientIP()

		mu.Lock()
		limiter, exists := limiters[ip]
		if !exists {
			limiter = rate.NewLimiter(rate.Every(time.Second), maxPerSecond)
			limiters[ip] = limiter
		}
		mu.Unlock()

		if !limiter.Allow() {
			c.JSON(http.StatusTooManyRequests, gin.H{
				"error": "Rate limit exceeded. Please slow down.",
			})
			c.Abort()
			return
		}

		c.Next()
	}
}

// JWTAuth middleware for protected routes
func JWTAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Simplified - in production implement full JWT validation
		token := c.GetHeader("Authorization")
		if token == "" {
			c.JSON(http.StatusUnauthorized, gin.H{
				"error": "Missing authorization token",
			})
			c.Abort()
			return
		}

		// In production: validate JWT, extract player ID, set in context
		// For now, just pass through
		c.Next()
	}
}
