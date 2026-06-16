# Technical Architecture for Zero-Lag Performance

## Technology Stack Selection

### Backend: Go (Golang)
**Why Go?**
- Native concurrency with goroutines (10,000+ concurrent connections per server)
- Sub-millisecond garbage collection pauses
- Compiled binary = no interpreter overhead
- Built-in profiling and optimization tools
- Excellent for real-time multiplayer games

**Performance Targets**:
- API Response Time: < 50ms (p95)
- Database Query: < 10ms (with caching)
- WebSocket Latency: < 30ms intra-server
- Throughput: 10,000 requests/second per instance

### Frontend: Unity (C#) + WebGL Optimization
**Why Unity?**
- Cross-platform (iOS, Android, PC, Web)
- Advanced rendering pipeline for particle effects
- Asset bundling for lazy loading
- Mature networking libraries (Mirror, Photon)

**Web Optimization Strategy**:
- Asset compression (Brotli, ASTC texture compression)
- Code splitting (load only needed scenes)
- Service workers for offline caching
- WebGL 2.0 with WASM for near-native performance

### Database: PostgreSQL + Redis Hybrid
**PostgreSQL** (Persistent Data):
- ACID compliance for transactions (gacha, purchases)
- JSONB fields for flexible inventory systems
- Row-level locking for concurrent updates
- Read replicas for query scaling

**Redis** (Hot Data & Caching):
- Player session data (online status, temp buffs)
- Leaderboards (sorted sets O(log N))
- Rate limiting counters
- Pub/sub for real-time notifications
- TTL-based expiration for temporary events

### Message Queue: Apache Kafka
- Event sourcing for audit trails
- Asynchronous processing (email sending, analytics)
- Backpressure handling during traffic spikes
- Exactly-once delivery for purchase events

## Server Architecture Patterns

### Microservices Decomposition

```
┌─────────────────────────────────────────────────┐
│              API Gateway (Kong/Nginx)           │
│         Rate Limiting | Auth | Routing          │
└───────────────────┬─────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
┌───────▼────┐ ┌───▼────────┐ ┌▼──────────────┐
│   User     │ │   Game     │ │  Payment      │
│   Service  │ │   Service  │ │  Service      │
│            │ │            │ │               │
│ - Login    │ │ - Combat   │ │ - IAP         │
│ - Profile  │ │ - Quests   │ │ - Wallet      │
│ - Friends  │ │ - Guilds   │ │ - Receipts    │
└────────────┘ └────────────┘ └───────────────┘
        │           │           │
        └───────────┼───────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
┌───────▼────┐ ┌───▼────────┐ ┌▼──────────────┐
│  Leader    │ │   Gacha    │ │   Chat        │
│  Board     │ │   Service  │ │   Service     │
│  Service   │ │            │ │               │
│            │ │ - Pulls    │ │ - Global      │
│ - Rankings │ │ - Pity     │ │ - Guild       │
│ - Seasons  │ │ - Rates    │ │ - PM          │
└────────────┘ └────────────┘ └───────────────┘
```

### Stateful vs Stateless Services

**Stateless** (Horizontally Scalable):
- API handlers
- Combat calculation
- Gacha logic
- Can auto-scale based on CPU/memory

**Stateful** (Requires Sticky Sessions):
- WebSocket connections
- Real-time PvP matchmaking
- Guild war instances
- Use Redis for shared state

## Database Optimization Strategies

### Connection Pooling
```go
// Optimal pool configuration for high concurrency
dbConfig := pgxpool.Config{
    MaxConns:        100,  // Per service instance
    MinConns:        10,
    MaxConnLifetime: time.Hour,
    MaxConnIdleTime: time.Minute * 30,
    HealthCheckPeriod: time.Minute,
}
```

**Rule**: Pool size = (CPU cores × 2) + effective_spindle_count

### Indexing Strategy
```sql
-- Critical indexes for game queries
CREATE INDEX idx_player_level_exp ON players(level DESC, exp DESC);
CREATE INDEX idx_guild_power ON guilds(total_power DESC);
CREATE INDEX idx_arena_rank ON arena_seasons(season_id, rating DESC);
CREATE INDEX idx_inventory_player_item ON inventory(player_id, item_type);

-- Composite index for common WHERE clauses
CREATE INDEX idx_active_players_region 
ON players(region, last_login DESC, level) 
WHERE is_banned = false;
```

### Query Optimization
**Bad** (N+1 Problem):
```go
// DON'T DO THIS
players := getPlayers()
for _, p := range players {
    guild := getGuild(p.GuildID) // Query per player!
}
```

**Good** (Batch Loading):
```go
players := getPlayers()
guildIDs := extractGuildIDs(players)
guilds := getGuildsBatch(guildIDs) // Single query
guildMap := toMap(guilds)
```

### Read/Write Splitting
```
Writes (Master): Player updates, purchases, gacha pulls
Reads  (Replicas): Leaderboards, profiles, inventories

Replication Lag Tolerance:
- Inventory: 0ms (must be consistent)
- Leaderboard: 1000ms (eventual consistency OK)
- Profile: 500ms (acceptable staleness)
```

## Caching Architecture

### Multi-Layer Cache Strategy

#### L1: In-Memory (Go maps with RWMutex)
```go
type LocalCache struct {
    mu sync.RWMutex
    data map[string]CachedItem
}
// TTL: 30 seconds
// Use: Session data, config values
```

#### L2: Redis Distributed Cache
```go
// Key patterns
player:{id}:profile     -> Hash (TTL: 1 hour)
player:{id}:inventory   -> Hash (TTL: 5 min)
leaderboard:arena:{season} -> Sorted Set (persistent)
event:{id}:progress     -> String (TTL: event duration)
```

#### L3: Database (Persistent)
- Only source of truth
- Write-through cache pattern
- Cache invalidation on write

### Cache Invalidation Patterns

**Write-Through** (Consistency Critical):
```go
func UpdatePlayerGold(playerID string, gold int64) error {
    // 1. Write to DB
    err := db.Exec("UPDATE players SET gold=$1 WHERE id=$2", gold, playerID)
    if err != nil { return err }
    
    // 2. Invalidate cache
    redis.Del("player:" + playerID + ":profile")
    
    return nil
}
```

**Cache-Aside** (Read-Heavy Data):
```go
func GetPlayerProfile(playerID string) (*Player, error) {
    // 1. Try cache first
    cached := redis.Get("player:" + playerID + ":profile")
    if cached != nil { return cached, nil }
    
    // 2. Cache miss - read from DB
    player := db.Query("SELECT * FROM players WHERE id=$1", playerID)
    
    // 3. Populate cache
    redis.Set("player:" + playerID + ":profile", player, 1*time.Hour)
    
    return player, nil
}
```

## Real-Time Communication

### WebSocket Architecture
```go
type GameServer struct {
    clients    map[uint64]*Client
    broadcast  chan []byte
    register   chan *Client
    unregister chan *Client
}

func (gs *GameServer) HandleMessage(client *Client, msg Message) {
    switch msg.Type {
    case "MOVE":
        gs.handleMovement(client, msg.Data)
    case "SKILL_CAST":
        gs.validateAndBroadcastSkill(client, msg.Data)
    case "CHAT":
        gs.routeChatMessage(client, msg.Data)
    }
}
```

**Optimization Techniques**:
- Binary protocol (Protocol Buffers) instead of JSON
- Message batching (collect updates every 50ms)
- Delta compression (send only changed fields)
- Interest management (only send nearby entities)

### Zone-Based Sharding
```
Server Cluster A (Levels 1-50)
  ├── Zone 1: Starting City
  ├── Zone 2: Beginner Forest
  └── Zone 3: Coastal Region

Server Cluster B (Levels 51-100)
  ├── Zone 4: Capital City
  ├── Zone 5: Mountain Pass
  └── Zone 6: Desert Wasteland

Cross-Zone Communication:
  - Kafka message bus
  - State synchronization every 100ms
  - Lazy loading for border transitions
```

## Load Balancing & Auto-Scaling

### Kubernetes HPA Configuration
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: game-service-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: game-service
  minReplicas: 3
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Percent
        value: 100
        periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
```

### Traffic Distribution Strategy
```
Global Load Balancer (Cloudflare/AWS Global Accelerator)
  ↓
Regional Load Balancers (US-East, EU-West, AP-Southeast)
  ↓
Service Mesh (Istio/Linkerd)
  ↓
Individual Pods (Game Services)
```

## Performance Monitoring

### Key Metrics Dashboard
```prometheus
# Request latency histogram
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Active WebSocket connections
sum(game_websocket_connections{state="active"})

# Database connection pool usage
pgxpool_acquired_conns / pgxpool_max_conns

# Gacha pull rate (business metric)
rate(gacha_pulls_total[1m])

# Error rate by service
sum(rate(http_requests_total{status=~"5.."}[5m])) by (service)
```

### Alerting Rules
```yaml
groups:
- name: game-alerts
  rules:
  - alert: HighLatency
    expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
    for: 5m
    annotations:
      summary: "API latency above 500ms"
      
  - alert: DatabasePoolExhausted
    expr: pgxpool_acquired_conns / pgxpool_max_conns > 0.9
    for: 2m
    annotations:
      summary: "DB connection pool > 90% utilized"
      
  - alert: GachaFailureSpike
    expr: rate(gacha_errors_total[5m]) > 10
    for: 1m
    annotations:
      summary: "Gacha system error rate critical"
```

## Anti-Cheat & Security

### Server-Side Validation
```go
func ValidateSkillCast(player *Player, skillID int, target Position) error {
    // Check cooldown
    if !player.CooldownReady(skillID) {
        return ErrCooldownNotReady
    }
    
    // Check range (server calculates distance, not client)
    distance := CalculateDistance(player.Pos, target)
    if distance > skill.MaxRange {
        return ErrOutOfRange
    }
    
    // Check line of sight
    if !HasLineOfSight(player.Pos, target) {
        return ErrNoLineOfSight
    }
    
    // Check mana/energy
    if player.Mana < skill.Cost {
        return ErrInsufficientMana
    }
    
    return nil
}
```

### Rate Limiting
```go
// Per-player action limits
rateLimiter := rate.NewLimiter(
    rate.Every(time.Second), // Window
    10,  // Max actions per window
)

// Purchase protection
if !purchaseLimiter.Allow(playerID) {
    log.Warn("Potential fraud: rapid purchases", "player", playerID)
    triggerFraudReview(playerID)
}
```

### Data Encryption
- TLS 1.3 for all API communication
- AES-256 for sensitive data at rest (payment info)
- HMAC signatures for critical game actions
- Regular key rotation (every 90 days)

## Deployment Pipeline

### CI/CD Flow
```
Git Push → GitHub Actions → Build → Test → Deploy
    │
    ├→ Unit Tests (Go test -race)
    ├→ Integration Tests (Docker Compose)
    ├→ Load Tests (k6, 10k concurrent users)
    └→ Security Scan (gosec, dependency check)
```

### Blue-Green Deployment
```
Production Environment:
  [Blue: v1.2.3] ← Live traffic
  [Green: v1.2.4] ← New deployment
  
1. Deploy Green with 0% traffic
2. Run smoke tests on Green
3. Shift 10% traffic to Green
4. Monitor metrics (5 minutes)
5. If OK → 100% Green
6. If Fail → Rollback to Blue (instant)
```

### Database Migrations
```bash
# Zero-downtime migration strategy
# Step 1: Add new column (nullable)
ALTER TABLE players ADD COLUMN new_stat INT DEFAULT NULL;

# Step 2: Deploy code that writes to both columns
# (dual-write period: 24 hours)

# Step 3: Backfill existing data
UPDATE players SET new_stat = old_stat WHERE new_stat IS NULL;

# Step 4: Make column NOT NULL
ALTER TABLE players ALTER COLUMN new_stat SET NOT NULL;

# Step 5: Remove old column (next release)
ALTER TABLE players DROP COLUMN old_stat;
```

This architecture ensures sub-100ms response times even under 100k concurrent users, with automatic scaling and zero-downtime deployments.
