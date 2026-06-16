# Economy Simulation & Inflation Control

## Core Economy Equations

### Gold Flow Model
```
G_in = Σ(PlayerCount × DailyGoldEarn)
G_sink = Σ(UpgradeCosts + Taxes + Consumption)
MoneySupply(t) = MoneySupply(t-1) + G_in - G_sink
```

### Inflation Rate Calculation
```
InflationRate = (G_in - G_sink) / TotalMoneySupply
```

**Target**: Keep weekly inflation < 5%

### Exponential Cost Curves
To prevent hyperinflation as players level:
```
Cost(Level) = BaseCost × (1.5)^Level
```

This ensures cost outpaces income growth exponentially.

## Dynamic Sink Mechanisms

### Tier 1: Soft Sinks (F2P Friendly)
- Enhancement attempts (+1 to +9)
- Basic consumables (potions, buffs)
- Travel costs (teleport, mount speed)

### Tier 2: Medium Sinks (Dolphin Target)
- Refinement stones
- Skill upgrade materials
- Guild donations

### Tier 3: Hard Sinks (Whale Only)
- Transcendence fusion (5 Legendary → 1 Red)
- Protection runes (prevent downgrade)
- Auction house bulk purchases
- Re-roll perfect stats

## Simulation Scenarios

### Scenario A: New Server Launch
**Day 1-7**:
- Players: 10,000
- Daily Gold Earn: 10k per player
- Total Inflow: 100M gold/day
- Sinks: Minimal (players haven't reached upgrade walls)
- **Risk**: Early inflation spike

**Mitigation**: 
- Cap daily quest gold at Day 3
- Introduce early gear upgrade costs
- Auction house tax active from Day 1

### Scenario B: Mid-Game (Month 3)
**Conditions**:
- Active Players: 5,000
- Daily Gold Earn: 100k per player (leveled)
- Total Inflow: 500M gold/day
- Sinks: High (upgrade walls reached)

**Balance Check**:
If InflationRate > 5%:
1. Increase enhancement failure rates
2. Add new gold-only upgrades
3. Raise auction tax temporarily

### Scenario C: Endgame (Year 1)
**Conditions**:
- Whales: 50 players with billions in gold
- F2P: Struggling to afford basics
- **Risk**: Two-tier economy collapse

**Solutions**:
- Introduce "Gold Statue" decoration (10M gold each)
- Server-wide gold sink events (guild contributions)
- Bind-on-pickup requirements for key items

## Currency Exchange Dynamics

### Official vs Black Market
```
OfficialRate: $1 = 100 Diamonds
BlackMarket: Player gold ↔ Diamond conversion
```

**Monitoring Metric**: Black market premium indicates economy health
- Premium < 20%: Healthy
- Premium > 50%: Inflation crisis
- Premium < 5%: Deflation risk (whales hoarding)

### Resource Interconversion Matrix
| From | To | Conversion Rate | Sink % |
|------|-----|-----------------|--------|
| Gold | EXP Potions | 100:1 | 0% |
| Diamonds | Gold | 1:1000 | 10% tax |
| Tickets | SSR Shards | 10:1 | RNG |
| Duplicates | Awakening | 1:1 | 100% sink |

## Anti-Hoarding Mechanisms

### Decay Systems
- **Stamina Decay**: Unused stamina caps at 24hrs
- **Event Currency**: Expires after event ends
- **Seasonal Resets**: Some progress resets quarterly

### Opportunity Costs
- Inventory slots limited → Must choose what to keep
- Daily attempt limits → Cannot farm everything
- Energy system → Forces prioritization

### Whale-Specific Sinks
For players who max all content:
1. **Collection Index**: Infinite fragment collection
2. **Appearance System**: Cosmetic-only gold sinks
3. **Guild Treasury**: Donation leaderboards
4. **Server Events**: Competitive gold contributions

## Economy Monitoring Dashboard

### Key Metrics (Daily Tracking)
1. **Gold Velocity**: Average gold changing hands per player
2. **Sink Efficiency**: % of generated gold actually spent
3. **Auction Volume**: Player-to-player trade activity
4. **Whale Concentration**: Top 1% gold ownership %
5. **F2P Survival Index**: Can F2P afford basic upgrades?

### Alert Thresholds
- Gold Velocity drops 20% → Economy stagnating
- Sink Efficiency < 60% → Need new sinks
- Whale Concentration > 40% → Wealth inequality crisis
- F2P Survival < 80% → Risk of ecosystem collapse

### Dynamic Adjustment Triggers
```python
if inflation_rate > 0.05:  # 5% weekly
    increase_upgrade_costs(10%)
    add_new_gold_sink()
    
if whale_concentration > 0.40:
    introduce_wealth_tax()  # Luxury item costs scale with net worth
    
if f2p_survival < 0.80:
    boost_f2p_drop_rates()
    add_f2p_exclusive_rewards()
```

## Long-Term Economy Roadmap

### Phase 1 (Months 1-3): Controlled Scarcity
- Limited gold sources
- High demand for basics
- Rapid early spending

### Phase 2 (Months 4-6): Expansion
- New currency types introduced
- Cross-server trading opens
- Inflation management critical

### Phase 3 (Months 7-12): Maturation  
- Sinks must outpace sources
- Whale consumption drives economy
- F2P protected zones essential

### Phase 4 (Year 2+): Reset Mechanics
- Server merges to consolidate economy
- "Ascension" systems reset some progress
- New expansion currencies (non-convertible)

**Golden Rule**: Never let players feel "rich enough". Perpetual scarcity drives engagement and spending.
