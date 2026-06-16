# Event Design & FOMO Architecture

## Event Cadence Strategy

### Weekly Events (Routine Engagement)
**Monday-Friday**: Daily themed bonuses
- Monday: EXP Boost Day (+50% mob EXP)
- Tuesday: Gold Rush (Double gold drops)
- Wednesday: Gacha Lucky Day (Free extra pull)
- Thursday: Gear Upgrade Fest (Reduced fail rates)
- Friday: PvP Tournament Night

**Weekend**: Major social events
- Saturday: Guild Boss Mega Spawn
- Sunday: Cross-Server Skirmish

### Bi-Weekly Events (Spending Spikes)
**Limited Banner Cycle** (14 days):
- Days 1-3: Launch urgency ("First 72hrs bonus!")
- Days 4-10: Steady state (whale grinding)
- Days 11-14: Closing panic ("Last chance!")

**Psychology**: Players who wait for "perfect timing" end up rushing at deadline.

### Monthly Events (Major Revenue)
1. **Server Siege** (Week 1): Territory control, guild rankings
2. **Accumulative Spend** (Week 2): Tiered rewards for total spending
3. **Ranking Contest** (Week 3): Arena/Gear score competitions  
4. **Treasure Hunt** (Week 4): Server-wide collection event

### Quarterly Events (Massive Returns)
- **Anniversary Celebration**: Best rewards, returner bonuses
- **Seasonal Festivals**: Lunar New Year, Christmas, Summer
- **Expansion Launch**: New cap, new zone, new systems
- **Server Merge**: Consolidate populations, refresh economy

## FOMO (Fear Of Missing Out) Engineering

### Scarcity Tactics

#### Time-Limited Exclusives
```
Event_Item:
  availability: "2024-01-15 to 2024-01-29"
  label: "NEVER RETURNING"
  reality: May return in 12 months with different skin
```

**Key**: Never confirm if/when items return - ambiguity drives urgency.

#### Quantity Limits
- "Only 100 available on server!"
- "First come, first served!"
- Real-time counter showing depletion

#### Progressive Unlock Anxiety
```
Event_Progress:
  total_players: 10000
  your_rank: 101
  reward_cutoff: Top_100
  time_remaining: 2_hours
```

Player at #101 will spend irrationally to reach #100.

### Urgency Amplifiers

#### Countdown Timers (Visual Pressure)
- Red color scheme (danger/alert association)
- Flashing at < 1 hour remaining
- Seconds displayed at < 10 minutes
- Persistent UI element (always visible)

#### Loss Framing
Instead of: "Get this reward!"
Use: "DON'T MISS OUT on this reward!"

**Psychology**: Loss aversion is 2x stronger than gain desire.

#### Social Proof Broadcasting
```
System_Message: 
  "[WhaleName] just obtained [Legendary_Item]!"
  "[GuildMate] completed [Event_Set]!"
  "Server collectively contributed 85% to goal!"
```

Creates bandwagon effect + competitive anxiety.

## Event Types Deep Dive

### Type 1: Accumulative Spend Events

**Structure**:
| Tier | Total Spend | Reward | Psychology |
|------|-------------|--------|------------|
| 1 | $10 | Basic mats | Entry commitment |
| 2 | $50 | Rare item | Sunk cost trap |
| 3 | $100 | Epic gear | Mid-whale target |
| 4 | $500 | Limited title | Prestige unlock |
| 5 | $1000+ | Exclusive mount | Whale flex |

**Mechanism**: Each tier makes next tier feel "closer" - don't waste previous spending.

### Type 2: Ranking Contests

**Categories**:
- Arena Points (PvP focus)
- Gear Score (Grind/spend focus)
- Damage Dealt (Guild boss focus)
- Collection Index (Completionist focus)

**Reward Distribution**:
```
Rank_1: Unique title + Mount + 10000 Diamonds
Rank_2-3: Title + 5000 Diamonds
Rank_4-10: 2000 Diamonds
Rank_11-100: 500 Diamonds
Participation: 50 Diamonds
```

**Critical Design**: Visible gap between #100 and #101 drives mass spending.

### Type 3: Server-Wide Goals

**Mechanic**: Entire server contributes to collective meter
```
Goal: Defeat 1,000,000 Event Bosses
Progress: 847,293 / 1,000,000
Time: 4 days remaining
Reward_Unlock: All players get [Event_Pet]
```

**Psychology**:
- Peer pressure ("Don't let server down!")
- Free-rider problem (some contribute more)
- Last-minute surge (whales carry at end)

### Type 4: Gacha Rate-Up Events

**Banner Variations**:
- **Standard Rate-Up**: SSR rate 1% → 2%
- **Super Rate-Up**: SSR rate 1% → 4% (limited days)
- **Guaranteed SSR**: First 10-pull = SSR (one-time)
- **No-Pity Banner**: Higher rates but no pity counter (gambling appeal)

**Manipulation**: Show "recent pulls" feed with many SSRs (cherry-picked data).

## Event Economy Impact

### Pre-Event Preparation (Week Before)
- Players hoard resources
- Spending decreases (saving for event)
- **Counter**: Offer "preparation packs" to capture savings

### During Event (Active Phase)
- Resource velocity increases 300-500%
- Whale spending spikes 10x normal
- F2P engagement peaks (free event currency)

### Post-Event Hangover (Week After)
- Spending crashes 60-70%
- Player fatigue high
- **Solution**: Low-key maintenance events, no major spends

### Inflation Management
```
if event_inflation > threshold:
    introduce_event-exclusive_sinks()
    bind_event_currency(no_trade)
    limit_conversion_rates()
```

## Event Success Metrics

### Participation Rates
- Target: > 60% of DAU for major events
- Warning: < 40% indicates poor communication/rewards

### Conversion Lift
- Event期间 paying_user_conversion should increase 2-3x
- ARPPU should increase 5x for whales

### Retention Impact
- D7 retention for event participants vs non-participants
- Should show +15-20% lift for participants

### Revenue Attribution
```
Event_Revenue = Direct_Spend + Uplift_Spend - Cannibalization
```
- Direct: Event pack sales, event gacha
- Uplift: Normal packs bought due to event momentum
- Cannibalization: Normal spending deferred to event

## Dark Patterns in Events

### Fake Deadlines
- "Ends in 24 hours!" (Resets daily until event actually ends)
- Timer reaches 0 → "Extended by popular demand!"

### Bait-and-Switch
- Advertise Reward A prominently
- Reveal fine print: "Requires completing X, Y, Z first"
- X, Y, Z require spending

### Artificial Difficulty Spikes
- Event starts easy (hook players)
- Mid-event: Difficulty jumps 300%
- Only solvable with spending/power-ups

### Predatory Targeting
Using player data to customize offers:
- Whales see $1000 packs first
- Dolphins see $50 "best value" highlighted
- F2P see "$0.99 starter" exclusively

## Event Calendar Template

```
Q1 (Jan-Mar):
  Jan: New Year Festival + Anniversary
  Feb: Valentine's Romance Event (marriage system push)
  Mar: Spring Expansion Launch

Q2 (Apr-Jun):
  Apr: April Fools Mini-Event (low spend)
  May: Labor Day Holiday Push
  Jun: Summer Kickoff + School's Out Campaign

Q3 (Jul-Sep):
  Jul: Mid-Year Mega Event (biggest of year)
  Aug: Summer Vacation Extended
  Sep: Back-to-School (re-engagement for lapsed)

Q4 (Oct-Dec):
  Oct: Halloween Horror Theme
  Nov: Black Friday/Cyber Monday (spend focus)
  Dec: Christmas + Year-End Celebration
```

**Rule**: Never more than 2 weeks without a major event. Constant engagement rhythm prevents habit decay.
