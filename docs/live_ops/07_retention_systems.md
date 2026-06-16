# Retention Engineering & Daily Systems

## Hook Model Implementation

### Trigger → Action → Reward → Investment Loop

#### 1. Triggers (External → Internal)
**External Triggers**:
- Push notifications (timed to player habits)
- Email campaigns (churn prediction based)
- Social pressure (guild pings)

**Internal Triggers** (After 21 days):
- Boredom → Automatic app open
- Morning coffee → Login routine
- Commute start → Daily quests

#### 2. Actions (Friction Reduction)
- One-tap login (social auth saved)
- Auto-pathing to objectives
- Skip tickets for repeat content
- Clear UI hierarchy (no decision paralysis)

#### 3. Variable Rewards
- Gacha pulls (random outcomes)
- Mob drops (loot box psychology)
- Crit chance (combat variance)
- Daily reward rotation (unpredictable bonuses)

#### 4. Investment (Sunk Cost Creation)
- Time invested (daily streaks)
- Money spent (subscription active)
- Social capital (guild position)
- Collection progress (completionist drive)

## Daily Retention Checklist

### Mandatory Daily Touchpoints

#### Login Bonus (Day 1-30 Cycle)
```
Day 1-6: Small rewards (gold, potions)
Day 7: Major reward (SSR shard, mount)
Day 8-13: Reset with bonus multiplier
Day 30: Grand prize (Limited title/character)
```

**Psychology**: Loss aversion - missing day resets progress

#### Stamina Refills (Time-Gated)
- 12:00 PM: Free refill (60 energy)
- 6:00 PM: Free refill (60 energy)
- 9:00 PM: Optional ad watch (+30 energy)

**Purpose**: Forces specific login times, builds habit anchors

#### Daily Quest Matrix
| Quest Type | Count | Reward | Psychology |
|------------|-------|--------|------------|
| Kill Mobs | 10x | Activity +10 | Completion urge |
| Enhance Gear | 1x | Activity +15 | Progression push |
| Arena Fights | 3x | Activity +20 | Competitive hook |
| Guild Donate | 1x | Activity +10 | Social obligation |
| Dungeon Clear | 2x | Activity +25 | Content consumption |

**Activity Points System**:
- 50 points: Bronze chest
- 100 points: Silver chest  
- 150 points: Gold chest
- 200 points: Diamond chest (rare items)

**Key Insight**: Players hate leaving bar at 190/200 - will complete meaningless tasks to reach 200.

### Timed Events Schedule

#### 13:00 - Treasure Goblin (AFK Farming)
- 15-minute window
- High gold/EXP drops
- Auto-battle compatible
- **Goal**: Lunch break engagement

#### 18:00 - World Boss Spawn
- Server-wide participation
- Damage = Guild points
- Ranking rewards top 100
- **Goal**: Pre-dinner peak concurrency

#### 20:00 - Guild War (Prime Time)
- Mandatory attendance expectation
- Territory control stakes
- Voice chat coordination
- **Goal**: Social lock-in, peak spending before battle

#### 22:00 - Night Market
- Limited-time discounts
- Random inventory per player
- Refresh costs diamonds
- **Goal**: Bedtime spending impulse

## Push Notification Strategy

### Behavioral Timing Algorithm

**Player hasn't logged in 24hrs**:
```
12:00 PM: "Stamina full! Losing EXP!" (Loss Aversion)
06:00 PM: "[GuildMate] missed you at Boss!" (Social Guilt)  
09:00 PM: "200% Pack expires in 1hr!" (Urgency)
```

**Player failed upgrade recently**:
```
Immediate: "Don't quit! 50% OFF Protection Stone!" (Frustration monetization)
```

**Player killed in PvP**:
```
When killer online: "[Killer] is online. REVENGE NOW!" (Anger motivation)
```

**Churn Prediction (ML-based)**:
If login_frequency drops 40% and session_length drops 30%:
```
Send: "We miss you! Here's 10 free pulls!" (Re-engagement offer)
```

## Habit Formation Science

### The 21-Day Rule
- Days 1-7: Conscious effort required
- Days 8-14: Routine forming
- Days 15-21: Automatic behavior
- Day 22+: Identity integration ("I am a player")

### Streak Mechanics
```
DailyLoginStreak:
  if streak >= 7: BonusMultiplier = 1.5x
  if streak >= 30: ExclusiveTitle = "Dedicated"
  if streak broken: Reset to 0, send consolation offer
```

**Break Pain**: Missing login feels physically uncomfortable (withdrawal symptom)

### Social Obligation Layers

#### Guild Dependency
- Guild boss requires 10+ members
- Guild war needs active participation
- Guild tech buffs lost if leave
- **Result**: Quitting = letting down 50 friends

#### Marriage/Mentor Systems
- Partner bonuses scale with online time together
- Mentor rewards when disciple spends money
- Divorce/breakup penalties (social shame)

#### Leaderboard Proximity
- Show players ranked just above/below you
- "You're #101 - Top 100 gets rewards!"
- Create artificial rivalry clusters

## Retention Metrics & Alerts

### Key Performance Indicators

#### DAU/MAU Ratio (Stickiness)
- Target: > 20%
- Warning: < 15%
- Critical: < 10%

#### D1/D7/D30 Retention
```
D1: > 40% (Tutorial success indicator)
D7: > 20% (Core loop validation)
D30: > 10% (Long-term viability)
```

#### Session Metrics
- Avg Session Length: 25-45 min optimal
- Sessions per Day: 3-5 ideal
- Time between sessions: 2-4 hrs

### Churn Prediction Model

**Risk Factors** (Weighted Score):
- Login frequency drop (-30%)
- Session length decline (-25%)
- Spending decrease (-50%)
- Guild activity reduction (-40%)
- PvP participation drop (-60%)

**Intervention Triggers**:
- Score > 0.6: Send retention email
- Score > 0.8: Offer limited-time discount pack
- Score > 0.9: CS personal outreach (for whales)

## Anti-Burnout Mechanisms

### Forced Breaks
- Stamina cap prevents over-grinding
- Daily dungeon limits (3 runs max)
- AFK kick after 4 hours continuous

### Content Rotation
- Weekly featured dungeons (bonus drops)
- Rotating event types (PvP week, PvE week)
- Seasonal themes prevent monotony

### Catch-Up Mechanics
- Returning player boost (2x EXP for 7 days)
- Level sync for underleveled friends
- Gear loan systems for guild help

**Balance**: Must not punish loyal players while welcoming returners.
