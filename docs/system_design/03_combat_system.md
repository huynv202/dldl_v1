# Combat System & Battle Power

## Combat Mechanics

### Core Stats Architecture
**Primary Stats**:
- ATK: Base damage calculation
- DEF: Flat damage reduction  
- HP: Survivability pool

**Secondary Multipliers**:
- Crit Rate (%): Chance for 200%+ damage
- Crit DMG (%): Baseline multiplier increase
- Penetration (%): Ignores target DEF percentage
- Accuracy/Dodge: Binary hit/miss check
- CC Resistance: Stun/freeze duration reduction
- Elemental Mastery: Rock-Paper-Scissors dynamic

### Damage Formula
```
FinalDmg = (BaseAtk × SkillCoeff) 
           × (1 + CritDmg) 
           × (1 + ElemBonus) 
           × (1 - TargetDefReduction)
```

## Hit Feedback System (Game Feel)

### Visual Requirements
- **Freeze Frames**: 3-5 frames on crit/ultimate impact
- **Camera Shake**: Scale intensity with damage dealt
- **Screen Flash**: Subtle white flash on massive damage
- **Damage Numbers**: 
  - White: Normal hit
  - Green: Small crit
  - Orange: Big crit  
  - Red: Massive crit/true damage
  - Gold: Divine/execute

### Audio Design
- Distinct sounds: Armor Hit (Clang) vs Flesh Hit (Thud) vs Crit (Shatter)
- Dynamic mixing based on damage multiplier
- Ultimate skill voice lines with priority interrupt

## Battle Power Illusion

### BP Formula
```
BP = Σ(Stat_i × Weight_i) + BonusMultipliers
```

Where:
- Stat_i = ATK, DEF, HP, Crit, etc.
- Weight_i = Hidden developer weights (ATK > DEF usually)
- BonusMultipliers = Title bonuses, guild tech, marriage buffs

### Inflation Curve Design
| Timeline | BP Range | Psychological Effect |
|----------|----------|---------------------|
| Day 1 | 500 | Accessible start |
| Week 1 | 5,000 | Early progress |
| Month 1 | 50,000 | Mid-game power |
| Month 6 | 5,000,000 | Endgame elite |
| Year 1 | 500,000,000 | God tier |

### Psychological Functions
1. **Universal Metric**: Instant comparison without stat analysis
2. **Progression Validation**: Any BP increase feels like progress
3. **False Growth**: Fluff stats inflate number without real power
4. **Gatekeeping**: Dungeon requirements force specific grinding

## Martial Soul System

### Rarity Tiers
1. **Common**: Pig, Dog, Sickle (early game only)
2. **Rare**: Wolf, Eagle, Standard Swords
3. **Epic**: White Tiger, Hell Civet
4. **Legendary**: Clear Sky Hammer, Seven Treasure Pagoda
5. **Divine**: Blue Silver Emperor, Phoenix, Seraphim (Gacha/Event only)

### Class Archetypes
- **Control System**: CC, debuffs, poison (Blue Silver Grass)
- **Attack System**: Burst DPS, slow but huge hits (Clear Sky Hammer)
- **Tank System**: Damage absorption, taunts (Diamond Bristle Tiger)
- **Support System**: Buffs, no direct damage (Seven Treasure Pagoda)
- **Speed DPS**: High crit/dodge, multi-hit (Hell Civet)

**Balance Philosophy**: Intentional imbalance in PvP drives aspiration and spending.
