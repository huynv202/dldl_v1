# Core Game Loop Architecture

## Three-Tier Loop System

### Micro Loop (10s - 3min) - The Dopamine Hit
**Sequence**: Input → Action → Feedback → Reward → Repeat

**Key Elements**:
- Instant damage numbers with color coding
- Screen shake + hit stop on crits
- Particle effects scaling with damage
- Variable ratio reinforcement (Skinner Box)

**Technical Requirements**:
- World-space UI floating damage numbers
- 0.1s freeze frame on critical hits
- 60fps animation target minimum
- Sub-100ms input-to-feedback latency

### Mid Loop (30min - 4hr) - Session Goals
**Flow**: Login → Daily Rewards → Objectives → Grind → Upgrade → BP Check → Logout

**Design Intent**:
- Session length fits commute/lunch/evening blocks
- Stamina system forces breaks (scarcity creation)
- Resource pacing: exactly enough for ONE upgrade per session
- "Just one more thing" psychology for tomorrow retention

### Macro Loop (1 month - years) - Life Goals
**Objectives**:
- Max level achievement
- Full Red gear set collection
- 9x 100,000-year soul rings
- Server #1 arena ranking
- Guild cross-server war victory

**Retention Mechanisms**:
- Horizon Effect: Goalpost moves when cap reached
- Social Investment: Guild/spouse/reputation lock-in
- Asset Accumulation: Account has perceived real-world value

## Auto-Play Philosophy

### Why Auto-Play is Feature, Not Bug
1. **Mobile Context**: Play on bus/work/TV - can't stare 100%
2. **Grind Volume**: 10,000 mobs/day would cause RSI manually
3. **Retention**: App stays open during semi-distraction (ad impressions)

### Auto-System Components
- **Auto-Pathing**: Quest click → automatic navigation
- **Auto-Combat AI**: Smart skill priority trees
- **AFK Rewards**: Offline EXP accumulation (12hr cap)

**Critical Insight**: Depth is in strategic preparation (builds/resources), not combat execution. Combat is just animation showing spreadsheet working.
