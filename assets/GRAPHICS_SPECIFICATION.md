# SL-OMEGA Graphics & Asset Specification

## Overview
**Game Style**: 2.5D Mobile MMORPG với optimized 3D models và 2D UI
**Target Performance**: 60 FPS trên mid-range devices (Snapdragon 660+)
**Art Direction**: Fantasy Asian cultivation style, vibrant colors, exaggerated effects

---

## Character Specifications

### Base Characters (4 Classes)

#### Warrior (Nam/Nữ)
- **Height**: 1.85m (nam), 1.75m (nữ)
- **Polygon Count**: 8,000 - 12,000 tris
- **Texture Resolution**: 2048x2048 (Body), 1024x1024 (Weapons)
- **Rigging**: Humanoid rig với 45 bones
- **LOD Levels**: 
  - LOD0: 12k tris (0-15m)
  - LOD1: 6k tris (15-30m)
  - LOD2: 3k tris (30m+)

**Animations Required**:
- Idle (2 variants)
- Run/Walk/Sprint
- Basic Attack (3-hit combo)
- Skill Cast (4 skills)
- Ultimate (cinematic)
- Hit/Death/Stun
- Emotes (10+)

#### Mage (Nam/Nữ)
- **Height**: 1.80m (nam), 1.70m (nữ)
- **Special Effects**: Robe physics, magical auras
- **Weapon**: Staff (floating animations)

#### Archer (Nam/Nữ)
- **Height**: 1.82m (nam), 1.72m (nữ)
- **Special**: Bow string physics, quiver system
- **Hair**: Long hair with wind physics

#### Assassin (Nam/Nữ)
- **Height**: 1.78m (nam), 1.68m (nữ)
- **Special**: Dual daggers, shadow effects
- **Clothing**: Tight armor with cloth simulation

### Martial Soul Forms

#### Common Souls (Low Poly)
- **Iron Sword**: Floating sword spirit
- **Wooden Staff**: Nature orb + vines
- **Stone Hammer**: Earth particles

#### Epic Souls (High Detail)
- **White Tiger**: Full beast model (15k tris)
  - Fur shader with dynamic wind
  - Claw swipe VFX
  - Roar animation with screen shake
  
- **Hell Civet**: Shadow beast
  - Semi-transparent body
  - Lightning trail effects
  - Teleportation blinks

#### Legendary Souls (Cinematic Quality)
- **Clear Sky Hammer**: Giant hammer (2m tall)
  - Cracked earth on slam
  - Shockwave rings
  - Dark energy particles

- **Blue Silver Emperor**: Plant entity
  - Growing vine animations
  - Poison spore clouds
  - Root emergence from ground

- **Phoenix**: Bird form (flight capable)
  - Fire feather particles
  - Rebirth explosion VFX
  - Heat distortion shader

#### Divine Souls (God-tier)
- **Seraphim**: 6-winged angel
  - Wing feather physics (6 wings, 200 feathers each)
  - Holy light rays (volumetric)
  - Golden particle halo
  - Flight trails

- **Dragon God**: Massive dragon (5m length)
  - Scale shader with iridescence
  - Breath attack (element-based)
  - Thunder cloud aura
  - Eye glow effects

---

## Monster/Boss Design

### Normal Mobs (Low Priority)
- **Poly Count**: 3,000 - 5,000 tris
- **Textures**: 1024x1024
- **Examples**: Wild Boar, Forest Wolf, Flame Spirit
- **AI Visuals**: Simple aggro indicators

### Elite Mobs (Medium Detail)
- **Poly Count**: 8,000 - 10,000 tris
- **Special**: Unique color schemes, elite auras
- **Examples**: Rock Golem, Ice Witch
- **VFX**: Elemental shields, special attacks

### Bosses (High Detail)
- **Poly Count**: 15,000 - 25,000 tris
- **Textures**: 4096x4096 (PBR materials)
- **Special Mechanics**:
  - Multiple phases (visual transformation)
  - Enrage mode (red aura, size increase)
  - Summon minions
  - Arena-wide AoE indicators

#### Thunder Dragon (Level 50 Boss)
- **Length**: 8 meters
- **Wingspan**: 12 meters
- **Features**:
  - Animated scales (lightning pattern)
  - Charged lightning orbs
  - Thundercloud summoning
  - Tail swipe telegraph
  - Bite/jaw animation rig

#### Demon Lord (World Boss)
- **Height**: 4 meters
- **Weapons**: Dual cursed blades
- **Phases**:
  1. Normal (black armor)
  2. Enraged (red glow, spikes emerge)
  3. True Form (wings unfold, 6m height)
- **VFX Budget**: 50+ simultaneous particles

---

## Map/Environment Design

### City Zones (Social Hubs)
**Novice Village**:
- **Size**: 200m x 200m
- **Style**: Chinese ancient village
- **Buildings**: 15 structures (optimized LODs)
- **NPCs**: 20+ with idle animations
- **Lighting**: Warm sunset tones
- **Performance**: Target 60 FPS with 50 players

**Main Capital** (Endgame):
- **Size**: 500m x 500m
- **Districts**: 
  - Palace district (VIP area)
  - Market square (auction house)
  - Arena entrance
  - Guild headquarters row
  - Residential zones
- **VFX**: Banners, fountains, teleportation gates
- **Crowd**: Up to 100 players visible

### Wilderness Zones (Grinding Areas)
**Spirit Forest**:
- **Vegetation**: Dense trees (billboard LODs)
- **Ground**: Grass with wind animation
- **Ambient**: Floating spirit particles
- **Wildlife**: Passive animals (deer, birds)

**Frozen Wasteland**:
- **Shader**: Ice/snow with footprints
- **Weather**: Snowfall particle system
- **Hazards**: Ice patches (slip effect)
- **Mood**: Cold blue lighting, fog

### Dungeon Instances
**Iron Mine**:
- **Lighting**: Torch-lit corridors
- **Geometry**: Cave system with wooden supports
- **Hazards**: Falling rocks, mine carts
- **Boss Room**: Large cavern (50m diameter)

**Flame Volcano**:
- **Dynamic Lighting**: Lava glow (orange/red)
- **Heat Haze**: Distortion shader near lava
- **Particles**: Ash, embers, smoke
- **Platforming**: Lava flows (timed crossings)

### Arena Maps (PvP)
**Arena of Champions**:
- **Size**: 40m x 40m (symmetrical)
- **Obstacles**: 4 pillars (cover system)
- **Floor**: Marble with faction logos
- **Crowd**: Spectator stands (ambient NPCs)
- **Lighting**: Bright, even (competitive visibility)

---

## Equipment Visualization

### Weapon Types (with Tier Progression)

#### Swords (Warrior)
- **Common**: Iron sword (rusty texture)
- **Rare**: Steel blade (polished, blue tint)
- **Epic**: Enchanted sword (runes glowing)
- **Legendary**: Dragon Fang (bone hilt, fire aura)
- **Red**: God Slayer Blade (cracked reality effect)

#### Staves (Mage)
- **Common**: Wooden stick
- **Rare**: Crystal-topped staff
- **Epic**: Multi-orb floating staff
- **Legendary**: Phoenix Wing Staff (feather details)
- **Red**: Void Scepter (dark matter core)

#### Bows (Archer)
- **Common**: Hunter's bow
- **Rare**: Composite bow (metal reinforcements)
- **Epic**: Wind Spirit Bow (invisible string)
- **Legendary**: Eagle Wing Bow (feather fletching)
- **Red**: Starfall Bow (constellation pattern)

### Armor Sets (with Set Bonuses Visual)

#### Tier Progression:
- **White**: Cloth/leather (no effects)
- **Green**: Light metal (subtle shine)
- **Blue**: Enchanted metal (blue glow trim)
- **Purple**: Magical alloy (purple particle trail)
- **Orange**: Legendary (golden aura, animated details)
- **Red**: Divine (reality distortion, multiple layers)

#### Set Bonus Activation:
- **2-piece**: Subtle glow on armor pieces
- **4-piece**: Character aura appears
- **6-piece**: Full-body transformation + ground effects

---

## Soul Ring Visual System

### Tier Appearance

| Tier | Color | Model | Effect |
|------|-------|-------|--------|
| White | #FFFFFF | Simple band | None |
| Yellow | #FFFF00 | Gold trim | Soft yellow glow |
| Purple | #9932CC | Gem inlays | Purple particle orbit |
| Black | #000000 | Dark metal | Black smoke wisps |
| Red | #FF0000 | Crystalline | Red lightning arcs |
| Gold | #FFD700 | Divine material | Golden halo + time distortion |

### Ring Acquisition Animation
1. Beast defeated → Soul extracts (ghostly form)
2. Soul condenses → Ring shape forms
3. Color reveals → Tier determined
4. Stats roll → Numbers flash
5. Final ring → Floats to player's hand

---

## VFX (Visual Effects) Library

### Combat Effects

#### Damage Numbers
- **Normal**: White, bold font, fade up
- **Crit**: Green/Yellow, larger, bounce animation
- **Massive Crit**: Orange/Red, screen shake, slow-mo frame
- **True Damage**: Purple, void-like distortion

#### Skill Impacts
- **Physical**: Dust clouds, debris, screen flash
- **Fire**: Explosion, burn DoT particles, heat haze
- **Ice**: Freeze crystals, frost spread, breath fog
- **Lightning**: Chain lightning, scorch marks, hair raise effect
- **Holy**: Golden light rays, healing sparkles, cleanse waves
- **Dark**: Shadow tendrils, life drain beams, fear aura

#### Buff/Debuff Icons
- **Buff**: Blue border, upward arrow animation
- **Debuff**: Red border, downward drip effect
- **CC**: Yellow border, spinning stun stars

### Environmental VFX
- **Weather**: Rain, snow, sandstorm (performance-scaled)
- **Time of Day**: Dynamic shadows, color grading shifts
- **Portals**: Swirling vortex, suction effect
- **Treasure Chests**: Golden light beams when spawned

### UI Effects
- **Gacha Pull**: Screen darkens, gold beams for SSR
- **Level Up**: Radial burst, confetti, stat numbers fly in
- **Achievement**: Banner slide-in, sparkle trail
- **Purchase Success**: Diamond shower, satisfying "cha-ching" sound visual

---

## UI/UX Design

### Art Style
- **Theme**: Cultivation fantasy (Chinese/xianxia)
- **Colors**: Gold/purple (prestige), blue/green (F2P friendly)
- **Icons**: Clear silhouettes, color-coded by rarity
- **Fonts**: Bold, readable at small sizes (mobile-first)

### Key Screens

#### Main HUD
- **Top-left**: Player portrait, HP/MP bars, level
- **Top-right**: Mini-map, quest tracker
- **Bottom-left**: Virtual joystick, skill buttons (4 + ultimate)
- **Bottom-right**: Auto-battle toggle, menu buttons
- **Center-top**: Damage number spawn zone

#### Character Screen
- **3D Model Viewer**: Rotatable, zoomable character
- **Stats Panel**: Expandable detailed stats
- **Equipment Grid**: 10 slots with item icons
- **Fashion Tab**: Costume preview with dyes

#### Gacha Screen
- **Banner Display**: Featured character artwork (full-screen)
- **Pull Buttons**: Single (left), 10-pull (right, highlighted)
- **Pity Counter**: Visible progress bar
- **Recent Pulls**: Scrollable history feed

#### Shop UI
- **Tabs**: Diamonds, Gold, Limited, VIP
- **Items**: Card layout with clear value proposition
- **Countdown Timers**: Red, prominent on limited offers
- **IAP Packages**: Screenshot-worthy presentation

### Rarity Color Coding
- **Common**: White (#FFFFFF)
- **Rare**: Green (#00FF00)
- **Epic**: Blue (#0080FF)
- **Legendary**: Purple (#A020F0)
- **Divine**: Gold (#FFD700)
- **Red Gear**: Crimson (#DC143C)

---

## Audio Specifications

### Music Tracks
- **Login Screen**: Epic orchestral (30 sec loop)
- **City Zones**: Peaceful traditional instruments
- **Wilderness**: Ambient nature sounds
- **Combat**: Intense percussion + strings
- **Boss Battles**: Choir + heavy drums
- **Victory**: Triumphant fanfare (5 sec sting)

### Sound Effects (SFX)

#### Combat
- **Weapon Hits**: Metal clang / flesh thud / crit shatter
- **Skills**: Element-specific (fire whoosh, ice crack, lightning zap)
- **Ultimates**: Cinematic bass drops, voice lines
- **Damage Taken**: Grunts, armor impacts

#### UI
- **Button Clicks**: Satisfying tactile feedback
- **Gacha Pull**: Portal open, rarity reveal stings
- **Currency Gain**: Coin chime, diamond sparkle
- **Notifications**: Soft ping (non-intrusive)

#### Voice Acting
- **Player Characters**: Battle grunts, skill calls (optional)
- **NPCs**: Quest dialogue (text-to-speech acceptable for F2P)
- **Monsters**: Roars, growls, death cries
- **Announcer**: Arena matches, event start/end

---

## Technical Requirements

### Platform Targets
- **iOS**: iPhone 8+ (A11 chip), iOS 13+
- **Android**: Snapdragon 660+, Android 8.0+
- **PC**: WebGL build for browser play

### Performance Budgets

#### Mobile (Mid-range)
- **Draw Calls**: < 200 per frame
- **Triangles**: < 100k visible
- **Textures**: Max 512 MB VRAM
- **Physics**: < 50 rigidbodies active
- **Particles**: < 500 simultaneous

#### PC/WebGL
- **Draw Calls**: < 500
- **Triangles**: < 500k
- **Textures**: Max 2 GB VRAM
- **Resolution**: Up to 4K support

### Asset Optimization

#### Models
- **Retopology**: Clean edge flow for animation
- **UV Unwrapping**: Efficient packing (85%+ utilization)
- **Normals**: Baked high-poly details
- **Colliders**: Simplified primitive shapes

#### Textures
- **Format**: ASTC (mobile), BC7 (PC)
- **Compression**: 4x4 block compression
- **Mipmaps**: Generated for all textures
- **Atlasing**: Combine small textures into sheets

#### Animations
- **Compression**: Keyframe reduction
- **Root Motion**: Used for movement skills
- **Blend Trees**: Smooth locomotion transitions
- **LOD**: Animation quality scales with distance

---

## Production Pipeline

### Tools Required
- **3D Modeling**: Blender (free) or Maya (industry standard)
- **Texturing**: Substance Painter, Photoshop
- **Animation**: Blender, Maya, or Mixamo (base animations)
- **VFX**: Unity Particle System, Shader Graph
- **UI**: Figma (design), Unity UGUI (implementation)

### Workflow Steps
1. **Concept Art**: 2D designs approved by art director
2. **Blockout**: Low-poly greybox for scale/proportion
3. **High-Poly Sculpt**: ZBrush for details
4. **Retopology**: Game-ready low-poly mesh
5. **UV Mapping**: Prepare for texturing
6. **Texturing**: PBR materials (Albedo, Normal, Metallic, Roughness)
7. **Rigging**: Skeleton + skin weights
8. **Animation**: Keyframe or motion capture
9. **VFX Integration**: Particle systems, shaders
10. **LOD Generation**: Automatic or manual
11. **Optimization**: Profiling, budget checks
12. **QA**: In-engine testing on target devices

### Naming Conventions
```
Characters:
  CHR_Warrior_Male_LOD0.fbx
  CHR_Warrior_Male_LOD1.fbx
  CHR_Warrior_Female_Skeleton.fbx

Weapons:
  WPN_Sword_Legendary_01.fbx
  WPN_Staff_Epic_03.fbx

Monsters:
  MON_ThunderDragon_Boss.fbx
  MON_ForestWolf_Normal.fbx

Maps:
  MAP_City_NoviceVille.unity
  MAP_Dungeon_IronMine.unity

Effects:
  FX_Skill_Fireball_Impact.prefab
  FX_Buff_HolyShield.prefab

UI:
  UI_Icon_Sword_Common.png
  UI_Button_Gacha_Pull.psd
```

---

## Asset Checklist (Minimum Viable Product)

### Characters
- [ ] 4 base classes (male + female) = 8 models
- [ ] 10 martial soul forms (visual only)
- [ ] 20 equipment models (weapons + armor sets)
- [ ] 50 animation clips per character

### Monsters
- [ ] 10 normal mob types
- [ ] 5 elite mob types
- [ ] 3 boss models (Thunder Dragon, Demon Lord, etc.)

### Maps
- [ ] 1 starter city (Novice Village)
- [ ] 2 wilderness zones (Forest, Wasteland)
- [ ] 2 dungeons (Mine, Volcano)
- [ ] 1 arena map

### VFX
- [ ] 20 skill effects (basic attacks + ultimates)
- [ ] 10 buff/debuff visuals
- [ ] 5 environmental effects (weather, portals)
- [ ] 15 UI effects (gacha, level up, rewards)

### UI
- [ ] Complete HUD set
- [ ] All menu screens (character, inventory, shop, gacha)
- [ ] 100+ item icons
- [ ] 50+ skill/buff icons
- [ ] Rarity frames and borders

### Audio
- [ ] 5 background music tracks
- [ ] 30 combat SFX
- [ ] 20 UI SFX
- [ ] 10 monster vocalizations
- [ ] Optional: Character voice lines (10 per class)

---

## Outsourcing Guidelines

### When to Outsource
- **Outsource**: Generic monsters, environment props, icon art
- **In-house**: Main characters, bosses, key VFX, UI/UX design

### Vendor Requirements
- Portfolio showing mobile game experience
- Ability to match provided style guides
- Meet polygon/texture budgets consistently
- Deliver in required formats (FBX, PNG, Unity packages)

### Quality Control
- Weekly review checkpoints
- Test assets in-engine before approval
- Performance profiling on target devices
- Revision rounds included in contract (min 2 rounds)

---

**Document Version**: 1.0.0
**Last Updated**: 2024-06-16
**Owner**: Art Director
**Status**: Ready for Production
