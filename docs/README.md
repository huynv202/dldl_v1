# SL-OMEGA Design Documentation Index

## Document Structure Overview

This documentation follows a modular structure organized by functional areas. Each document is self-contained but references related systems.

### Folder Organization

```
docs/
├── design_philosophy/      # Core vision, psychology, player journey
├── system_design/          # Gameplay systems, mechanics, formulas
├── economy_monetization/   # Gacha, economy, monetization strategies
├── live_ops/               # Retention, events, daily operations
└── technical_arch/         # Performance, infrastructure, security
```

## Document Catalog

### Design Philosophy (Foundation)

| File | Topic | Key Concepts |
|------|-------|--------------|
| `01_core_fantasy.md` | Player Psychology & Core Fantasy | God-complex engineering, progression tiers, whale food chain, player journey mapping |

**Reading Order**: Start here - establishes the psychological foundation for all other systems.

### System Design (Gameplay Mechanics)

| File | Topic | Key Concepts |
|------|-------|--------------|
| `02_core_loops.md` | Core Game Loop Architecture | Micro/mid/macro loops, auto-play philosophy, session design |
| `03_combat_system.md` | Combat & Battle Power | Stats architecture, damage formulas, BP inflation, martial souls |
| `04_soul_ring_equipment.md` | Progression Systems | Soul ring tiers, equipment upgrades, material sinks, RNG layers |

**Reading Order**: 02 → 03 → 04 (builds from core loop to specific systems)

### Economy & Monetization (Revenue Engine)

| File | Topic | Key Concepts |
|------|-------|--------------|
| `05_gacha_monetization.md` | Gacha Mathematics & Monetization | Pity systems, EV calculations, summon psychology, monetization pyramid |
| `06_economy_simulation.md` | Economy Simulation & Inflation | Gold flow models, dynamic sinks, currency dynamics, anti-hoarding |

**Reading Order**: 05 → 06 (gacha first as primary revenue, then broader economy)

### Live Operations (Retention & Engagement)

| File | Topic | Key Concepts |
|------|-------|--------------|
| `07_retention_systems.md` | Retention Engineering | Hook model, daily systems, push notifications, habit formation |
| `08_event_design.md` | Event Architecture | Event cadence, FOMO engineering, ranking contests, dark patterns |

**Reading Order**: 07 → 08 (daily retention before special events)

### Technical Architecture (Implementation)

| File | Topic | Key Concepts |
|------|-------|--------------|
| `09_performance_architecture.md` | Zero-Lag Performance | Go backend, caching strategies, database optimization, WebSocket architecture |

**Reading Order**: Read after understanding game systems to appreciate technical requirements.

## Quick Reference by Role

### For Game Designers
1. `01_core_fantasy.md` - Vision alignment
2. `02_core_loops.md` - Core engagement design
3. `03_combat_system.md` - Combat balance
4. `04_soul_ring_equipment.md` - Progression tuning

### For Monetization Managers
1. `05_gacha_monetization.md` - Gacha configuration
2. `06_economy_simulation.md` - Economy health monitoring
3. `08_event_design.md` - Event planning calendar

### For Live Ops Teams
1. `07_retention_systems.md` - Daily operation checklist
2. `08_event_design.md` - Event execution guide
3. `06_economy_simulation.md` - Inflation management

### For Engineers
1. `09_performance_architecture.md` - System architecture
2. `03_combat_system.md` - Combat calculation requirements
3. `05_gacha_monetization.md` - RNG implementation specs

### For Product Managers
1. `01_core_fantasy.md` - Product vision
2. `05_gacha_monetization.md` - Revenue model
3. `07_retention_systems.md` - KPI definitions

## Cross-Reference Matrix

| System | Related Documents |
|--------|-------------------|
| **Gacha** | 05 (design), 06 (economy impact), 09 (RNG implementation) |
| **PvP** | 03 (combat), 07 (retention), 08 (ranking events) |
| **Guilds** | 01 (social), 07 (retention), 08 (guild wars) |
| **Equipment** | 04 (systems), 06 (gold sinks), 09 (inventory DB) |
| **Daily Quests** | 02 (loops), 07 (checklist), 08 (event integration) |

## Version Control

All documents follow semantic versioning:
- **Major.Minor.Patch** (e.g., 1.2.3)
- Major: Fundamental system changes
- Minor: New features/mechanics
- Patch: Balance tweaks, clarifications

**Update Protocol**:
1. Update relevant .md file
2. Increment version number in document header
3. Add changelog entry at bottom of file
4. Commit with message: "docs: [system] v1.2.3 - description"

## Glossary of Terms

| Term | Definition |
|------|------------|
| **F2P** | Free-to-Play player (never spends money) |
| **Whale** | High-spending player ($100+/month) |
| **Dolphin** | Medium spender ($10-100/month) |
| **BP** | Battle Power (composite strength metric) |
| **SSR/SR/R** | Super Super Rare / Super Rare / Rare (gacha tiers) |
| **Pity** | Guaranteed rare drop after X failed attempts |
| **Sunk Cost** | Psychological trap of continuing due to past investment |
| **FOMO** | Fear Of Missing Out (urgency driver) |
| **DAU/MAU** | Daily/Monthly Active Users |
| **ARPPU** | Average Revenue Per Paying User |
| **LTV** | Lifetime Value (total revenue from player) |
| **Churn** | Player quitting the game |

## Maintenance Schedule

- **Weekly**: Review metrics against document assumptions
- **Monthly**: Update balance numbers based on live data
- **Quarterly**: Major system review and documentation audit
- **Annually**: Complete rewrite if paradigm shifts occur

## Contact & Ownership

Each document should have an owner responsible for updates:
- Design Philosophy: Lead Game Designer
- System Design: Senior System Designer
- Economy/Monetization: Monetization Director
- Live Ops: Live Ops Manager
- Technical Arch: CTO / Tech Director

---

**Last Updated**: 2024-06-16  
**Document Version**: 1.0.0  
**Status**: Initial Release
