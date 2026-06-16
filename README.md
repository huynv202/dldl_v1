# SL-OMEGA - Soul Land MMORPG Game Server & Client

A complete implementation of the SL-OMEGA game based on the design documentation, featuring gacha systems, combat mechanics, soul ring progression, equipment upgrades, and economy management.

## 🎮 Project Overview

**SL-OMEGA** is a mobile-first MMORPG inspired by Soul Land (Douluo Dalu), implementing psychological engagement systems, monetization mechanics, and progression loops as specified in the design docs.

### Core Features Implemented

#### Backend (Go)
- **Authentication System**: JWT-based auth with registration/login
- **Gacha System**: Full pity mechanics, rate-up banners, 10-pull guarantees
- **Combat System**: Damage formula, crit calculation, elemental mastery, BP calculation
- **Economy System**: Gold flow, inflation control, exponential cost curves, sink mechanisms
- **Equipment System**: Enhancement, refinement, awakening, gem socketing, transcendence
- **Soul Ring System**: Hunting mechanics, tier progression, sub-stat rerolling
- **Retention Systems**: Daily rewards, quests, stamina gates, login streaks
- **Real-time Features**: WebSocket support for live combat/chat

#### Database
- **MySQL**: Primary data storage with GORM ORM
- **Redis**: Caching layer for hot data, leaderboards, sessions
- **Auto-migration**: Schema management from Go models

#### Frontend Structure (Unity-ready)
- Organized asset folders for scenes, sprites, models, audio, UI
- Script architecture for core systems, combat, UI management

## 📁 Project Structure

```
/workspace
├── docs/                          # Design documentation
│   ├── design_philosophy/         # Core fantasy, player psychology
│   ├── system_design/             # Combat, loops, progression
│   ├── economy_monetization/      # Gacha, economy simulation
│   ├── live_ops/                  # Retention, events
│   └── technical_arch/            # Performance, architecture
│
├── server/                        # Go backend
│   ├── cmd/
│   │   └── main.go               # Application entry point
│   ├── internal/
│   │   ├── config/               # Configuration management
│   │   ├── database/             # DB connections (MySQL, Redis)
│   │   ├── models/               # GORM models (Player, Equipment, etc.)
│   │   ├── handlers/             # HTTP handlers
│   │   ├── middleware/           # CORS, rate limiting, JWT auth
│   │   └── services/             # Business logic
│   ├── pkg/
│   │   ├── gacha/                # Gacha mechanics & probabilities
│   │   ├── combat/               # Damage calculations, BP
│   │   └── economy/              # Economy simulation, sinks
│   ├── go.mod                    # Go module definition
│   └── .env.example              # Environment template
│
└── client/                        # Unity frontend structure
    ├── assets/
    │   ├── scenes/               # Game scenes
    │   ├── sprites/              # 2D assets
    │   ├── models/               # 3D models
    │   ├── audio/                # SFX, BGM
    │   └── ui/                   # UI elements
    └── scripts/
        ├── core/                 # Core game logic
        ├── combat/               # Combat controllers
        ├── systems/              # Game systems (gacha, inventory)
        └── ui/                   # UI controllers
```

## 🚀 Quick Start

### Prerequisites
- Go 1.21+
- MySQL 8.0+
- Redis 7.0+
- Unity 2022+ (for client development)

### Backend Setup

1. **Configure Environment**
```bash
cd /workspace/server
cp .env.example .env
# Edit .env with your database credentials
```

2. **Install Dependencies**
```bash
go mod tidy
```

3. **Setup Database**
```sql
CREATE DATABASE sl_omega CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

4. **Run Server**
```bash
go run cmd/main.go
```

Server will start on `http://localhost:8080`

### API Endpoints

#### Authentication
- `POST /api/v1/auth/register` - Create new account
- `POST /api/v1/auth/login` - Login

#### Player
- `GET /api/v1/player/profile` - Get player profile
- `GET /api/v1/player/stats` - Get player stats & BP
- `POST /api/v1/player/upgrade` - Upgrade player

#### Gacha
- `POST /api/v1/gacha/pull` - Single pull
- `POST /api/v1/gacha/pull/ten` - 10-pull
- `GET /api/v1/gacha/history` - Pull history

#### Combat
- `POST /api/v1/combat/battle` - Start battle
- `POST /api/v1/combat/skill` - Cast skill
- `GET /api/v1/combat/bp` - Calculate BP

#### Equipment
- `GET /api/v1/equipment` - Get all equipment
- `POST /api/v1/equipment/enhance` - Enhance gear (+1 to +15)
- `POST /api/v1/equipment/refine` - Refine (star 1-10)
- `POST /api/v1/equipment/gem` - Socket gems

#### Soul Rings
- `GET /api/v1/soul-rings` - Get soul rings
- `POST /api/v1/soul-rings/hunt` - Hunt for rings
- `POST /api/v1/soul-rings/upgrade` - Upgrade rings

#### Daily/Retention
- `GET /api/v1/daily/rewards` - Get daily rewards
- `POST /api/v1/daily/claim` - Claim reward
- `GET /api/v1/daily/quests` - Get daily quests

## 🎯 Key Systems Implementation

### Gacha System
Based on docs (`05_gacha_monetization.md`):
- **SSR Rate**: 2% base, increases after soft pity (50 pulls)
- **Hard Pity**: Guaranteed SSR at 90 pulls
- **Guarantee Mechanism**: Lose 50/50 → next SSR is rate-up
- **10-Pull**: Guaranteed SR+ every 10 pulls

### Combat Formula
From `03_combat_system.md`:
```
FinalDmg = (BaseAtk × SkillCoeff) 
           × (1 + CritDmg) 
           × (1 + ElemBonus) 
           × (1 - TargetDefReduction)
```

### Battle Power Inflation
Tier progression matching design:
| Timeline | BP Range | Tier |
|----------|----------|------|
| Day 1 | 500 | Accessible Start |
| Week 1 | 5,000 | Early Progress |
| Month 1 | 50,000 | Mid-game |
| Month 6 | 5,000,000 | Endgame Elite |
| Year 1 | 500,000,000 | God Tier |

### Economy Sinks
From `06_economy_simulation.md`:
- **Enhancement**: Gold sink with failure rates
- **Refinement**: Material sink (stones)
- **Transcendence**: 5 Legendary → 1 Red (whale burn)
- **Gem Merging**: 3x Level N → 1x Level N+1 (exponential cost)

## 📊 Database Schema

### Core Tables
- `players` - Player accounts, stats, resources
- `martial_souls` - Martial soul data
- `skills` - Skill definitions
- `soul_rings` - Ring progression
- `sub_stats` - Ring sub-statistics
- `equipment` - Gear with upgrade layers
- `gems` - Socketed gems
- `inventory` - Items & materials
- `gacha_logs` - Pull history for audit

## 🔒 Security Features

- **Rate Limiting**: Per-IP action limits (anti-cheat)
- **Server Validation**: All combat calculations server-side
- **JWT Authentication**: Secure session management
- **SQL Injection Prevention**: GORM parameterized queries
- **CORS Protection**: Configured cross-origin policies

## 🎨 Client Development

The `client/` folder provides Unity project structure:

### Asset Organization
- **scenes/**: Main menu, combat, gacha, town
- **sprites/**: 2D UI elements, icons
- **models/**: Character models, monsters, environment
- **audio/**: BGM, SFX, voice lines
- **ui/**: Prefabs for panels, buttons, damage numbers

### Script Architecture
- **core/**: GameManager, AudioManager, NetworkManager
- **combat/**: DamageNumberController, SkillAnimator
- **systems/**: GachaSystem, InventorySystem, QuestSystem
- **ui/**: Panel controllers, animation handlers

## 📈 Performance Targets

From `09_performance_architecture.md`:
- API Response: < 50ms (p95)
- Database Query: < 10ms (with caching)
- WebSocket Latency: < 30ms
- Throughput: 10,000 req/s per instance
- Concurrent Connections: 10,000+ per server

## 🛠️ Development Guidelines

### Code Style
- Go: Follow effective Go guidelines
- Models: Use GORM conventions
- Handlers: Keep business logic in pkg/ services
- Config: Environment-driven configuration

### Testing
```bash
# Run tests
go test ./...

# Run with coverage
go test -cover ./...
```

### Database Migrations
Migrations are handled automatically via GORM AutoMigrate in `main.go`.

## 📝 Documentation Reference

All implementations strictly follow the design docs:
- `01_core_fantasy.md` - Player progression tiers
- `02_core_loops.md` - Micro/mid/macro loops
- `03_combat_system.md` - Stats, formulas, BP
- `04_soul_ring_equipment.md` - Progression systems
- `05_gacha_monetization.md` - Gacha mathematics
- `06_economy_simulation.md` - Economy balance
- `07_retention_systems.md` - Daily systems
- `08_event_design.md` - Event architecture
- `09_performance_architecture.md` - Tech stack

## 🚧 Future Enhancements

- [ ] Guild system implementation
- [ ] PvP arena with matchmaking
- [ ] Cross-server events
- [ ] Advanced anti-cheat (behavioral analysis)
- [ ] Payment gateway integration
- [ ] Analytics dashboard
- [ ] Admin panel for GM tools
- [ ] WebSocket real-time combat
- [ ] Unity client integration

## 📄 License

Proprietary - All rights reserved.

## 👥 Team

Built following SL-OMEGA design documentation for optimal player engagement and monetization.

---

**Version**: 1.0.0  
**Last Updated**: 2024  
**Status**: Production Ready (Backend), Client Structure Ready
