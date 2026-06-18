-- SL-OMEGA Database Seed Data
-- MySQL 8.0+
-- Based on Design Docs v1.0.0

SET NAMES utf8mb4;

-- ============================================
-- EQUIPMENT TYPES
-- ============================================
INSERT INTO `equipment_types` (`name`, `slot_index`, `description`) VALUES
('weapon', 0, 'Main weapon slot'),
('armor', 1, 'Chest armor'),
('helm', 2, 'Head protection'),
('pants', 3, 'Leg armor'),
('boots', 4, 'Foot gear'),
('gloves', 5, 'Hand protection'),
('necklace', 6, 'Neck accessory'),
('ring1', 7, 'First ring slot'),
('ring2', 8, 'Second ring slot'),
('artifact', 9, 'Special artifact slot');

-- ============================================
-- MARTIAL SOULS
-- ============================================
INSERT INTO `martial_souls` (`name`, `rarity`, `soul_type`, `base_atk`, `base_def`, `base_hp`, `crit_rate`, `crit_dmg`, `description`, `unlock_level`, `gacha_weight`, `skill_ids`, `is_obtainable`) VALUES
-- Common Souls
('Iron Sword', 'common', 'attack', 50, 10, 100, 0.00, 50.00, 'A basic sword spirit', 1, 100, '[1, 2]', 1),
('Wooden Staff', 'common', 'support', 30, 15, 120, 0.00, 40.00, 'Simple wooden staff with nature energy', 1, 100, '[3]', 1),
('Stone Hammer', 'common', 'tank', 40, 30, 200, 0.00, 45.00, 'Heavy hammer made from mountain stone', 1, 100, '[4]', 1),

-- Rare Souls
('Steel Blade', 'rare', 'attack', 100, 20, 200, 2.00, 60.00, 'Sharpened steel blade', 10, 80, '[5, 6]', 1),
('Wind Bow', 'rare', 'speed_dps', 90, 15, 180, 5.00, 70.00, 'Bow infused with wind spirit', 10, 80, '[7, 8]', 1),
('Crystal Shield', 'rare', 'tank', 60, 50, 400, 0.00, 50.00, 'Magical crystal barrier', 10, 80, '[9]', 1),

-- Epic Souls
('White Tiger', 'epic', 'attack', 200, 40, 400, 8.00, 100.00, 'Fierce tiger spirit with devastating claws', 20, 50, '[10, 11, 12]', 1),
('Hell Civet', 'epic', 'speed_dps', 180, 35, 350, 12.00, 120.00, 'Shadowy beast with lightning speed', 20, 50, '[13, 14]', 1),
('Seven Treasure Pagoda', 'epic', 'support', 150, 60, 500, 5.00, 80.00, 'Ancient pagoda providing powerful buffs', 20, 50, '[15, 16]', 1),

-- Legendary Souls
('Clear Sky Hammer', 'legendary', 'attack', 400, 80, 800, 15.00, 150.00, 'Legendary hammer of destruction', 40, 20, '[17, 18, 19]', 1),
('Blue Silver Emperor', 'legendary', 'control', 300, 100, 1000, 10.00, 120.00, 'Emperor of plant spirits', 40, 20, '[20, 21, 22]', 1),
('Phoenix', 'legendary', 'attack', 450, 90, 900, 20.00, 180.00, 'Immortal fire bird', 40, 20, '[23, 24, 25]', 1),

-- Divine Souls
('Seraphim', 'divine', 'attack', 800, 150, 1500, 25.00, 250.00, 'Six-winged angel of judgment', 60, 5, '[26, 27, 28, 29]', 1),
('Dragon God', 'divine', 'control', 700, 200, 2000, 20.00, 220.00, 'Supreme dragon deity', 60, 5, '[30, 31, 32, 33]', 1);

-- ============================================
-- SOUL RINGS
-- ============================================
INSERT INTO `soul_rings` (`name`, `tier`, `min_years`, `max_years`, `stat_multiplier`, `color_hex`, `effect_description`, `gacha_weight`) VALUES
-- White Tier (10-100 years)
('Lesser Strength', 'white', 10, 100, 1.00, '#FFFFFF', 'Basic strength enhancement', 100),
('Minor Vitality', 'white', 10, 100, 1.00, '#FFFFFF', 'Small HP boost', 100),
('Weak Precision', 'white', 10, 100, 1.00, '#FFFFFF', 'Slight accuracy increase', 100),

-- Yellow Tier (100-999 years)
('Strength Ring', 'yellow', 100, 999, 1.20, '#FFFF00', 'Moderate ATK boost', 80),
('Vitality Ring', 'yellow', 100, 999, 1.20, '#FFFF00', 'Decent HP increase', 80),
('Swift Ring', 'yellow', 100, 999, 1.20, '#FFFF00', 'Attack speed enhancement', 80),

-- Purple Tier (1,000-9,999 years)
('Warrior''s Ring', 'purple', 1000, 9999, 1.50, '#9932CC', 'Strong attack power', 60),
('Guardian''s Ring', 'purple', 1000, 9999, 1.50, '#9932CC', 'Solid defense boost', 60),
('Assassin''s Ring', 'purple', 1000, 9999, 1.50, '#9932CC', 'Critical rate increase', 60),

-- Black Tier (10,000-99,999 years)
('Demon Lord Ring', 'black', 10000, 99999, 2.50, '#000000', 'Massive all-stats boost', 40),
('Shadow Master Ring', 'black', 10000, 99999, 2.50, '#000000', 'High crit and penetration', 40),
('Battle King Ring', 'black', 10000, 99999, 2.50, '#000000', 'Balanced offensive stats', 40),

-- Red Tier (100,000+ years)
('God Slayer Ring', 'red', 100000, 999999, 5.00, '#FF0000', 'Divine-level power', 20),
('Eternal Flame Ring', 'red', 100000, 999999, 5.00, '#FF0000', 'Fire damage amplification', 20),
('Void Walker Ring', 'red', 100000, 999999, 5.00, '#FF0000', 'Dimensional穿透 ability', 20),

-- Gold Tier (1M+ years)
('Reality Bender Ring', 'gold', 1000000, 9999999, 10.00, '#FFD700', 'Breaks the laws of physics', 5),
('Omnipotent Ring', 'gold', 1000000, 9999999, 10.00, '#FFD700', 'Near-infinite power', 5);

-- ============================================
-- SOUL RING SUBSTATS
-- ============================================
INSERT INTO `soul_ring_substats` (`substat_type`, `min_value`, `max_value`, `weight`, `applicable_tiers`) VALUES
('atk_percent', 1.00, 5.00, 100, '["yellow", "purple", "black", "red", "gold"]'),
('def_percent', 1.00, 5.00, 100, '["yellow", "purple", "black", "red", "gold"]'),
('hp_percent', 1.00, 5.00, 100, '["yellow", "purple", "black", "red", "gold"]'),
('crit_rate', 0.50, 2.00, 80, '["purple", "black", "red", "gold"]'),
('crit_dmg', 5.00, 15.00, 80, '["purple", "black", "red", "gold"]'),
('penetration', 1.00, 4.00, 70, '["black", "red", "gold"]'),
('accuracy', 1.00, 3.00, 60, '["yellow", "purple", "black", "red"]'),
('dodge', 1.00, 3.00, 60, '["yellow", "purple", "black", "red"]'),
('cooldown_reduction', 1.00, 5.00, 50, '["purple", "black", "red", "gold"]'),
('attack_speed', 1.00, 5.00, 70, '["yellow", "purple", "black", "red", "gold"]');

-- ============================================
-- SKILLS
-- ============================================
INSERT INTO `skills` (`name`, `skill_type`, `element`, `base_damage`, `scaling_coefficient`, `cooldown_seconds`, `energy_cost`, `cast_range`, `aoe_radius`, `duration_seconds`, `effect_type`, `cc_type`, `description`, `max_level`) VALUES
-- Basic Skills
('Slash', 'basic', 'physical', 100.00, 1.00, 0.00, 0, 3.00, 0.00, 0.00, 'damage', NULL, 'Basic melee attack', 1),
('Shoot', 'basic', 'physical', 90.00, 0.95, 0.00, 0, 15.00, 0.00, 0.00, 'damage', NULL, 'Basic ranged attack', 1),
('Zap', 'basic', 'physical', 85.00, 0.90, 0.00, 0, 8.00, 0.00, 0.00, 'damage', NULL, 'Basic magic attack', 1),

-- Active Skills
('Whirlwind Slash', 'active', 'physical', 200.00, 1.50, 8.00, 30, 4.00, 3.00, 0.00, 'damage', NULL, 'Spinning AoE attack', 10),
('Power Shot', 'active', 'physical', 250.00, 1.60, 10.00, 35, 20.00, 0.00, 0.00, 'damage', NULL, 'Charged precision shot', 10),
('Fireball', 'active', 'fire', 300.00, 1.80, 6.00, 40, 15.00, 4.00, 0.00, 'damage', NULL, 'Explosive fire projectile', 10),

-- Ultimate Skills
('Dragon Strike', 'ultimate', 'physical', 800.00, 3.00, 30.00, 100, 5.00, 6.00, 0.00, 'damage', NULL, 'Devastating dragon-shaped attack', 10),
('Phoenix Rebirth', 'ultimate', 'fire', 600.00, 2.50, 60.00, 120, 0.00, 8.00, 10.00, 'heal', NULL, 'Resurrect with HP and deal damage', 10),
('Absolute Zero', 'ultimate', 'water', 500.00, 2.20, 45.00, 100, 12.00, 10.00, 5.00, 'damage', 'freeze', 'Freeze all enemies in area', 10),

-- CC Skills
('Root Bind', 'active', 'earth', 150.00, 1.20, 12.00, 50, 10.00, 0.00, 3.00, 'cc', 'root', 'Immobilize target with vines', 10),
('Silence Curse', 'active', 'dark', 0.00, 0.00, 20.00, 60, 15.00, 0.00, 4.00, 'cc', 'silence', 'Prevent skill usage', 10),
('Fear Aura', 'active', 'dark', 100.00, 1.00, 25.00, 70, 8.00, 6.00, 3.00, 'cc', 'fear', 'Cause enemies to flee', 10),

-- Buff Skills
('Battle Cry', 'active', 'physical', 0.00, 0.00, 30.00, 40, 0.00, 10.00, 15.00, 'buff', NULL, 'Increase party ATK by 30%', 10),
('Divine Shield', 'active', 'light', 0.00, 0.00, 40.00, 80, 0.00, 8.00, 10.00, 'shield', NULL, 'Damage absorption barrier', 10),
('Haste', 'active', 'wind', 0.00, 0.00, 20.00, 50, 0.00, 10.00, 15.00, 'buff', NULL, 'Increase movement and attack speed', 10);

-- ============================================
-- GEMS
-- ============================================
INSERT INTO `gems` (`name`, `type`, `level`, `stat_type`, `stat_value`, `combine_material_count`) VALUES
('Tiny Ruby', 'ruby', 1, 'atk', 10.00, 3),
('Small Ruby', 'ruby', 2, 'atk', 25.00, 3),
('Ruby', 'ruby', 3, 'atk', 60.00, 3),
('Large Ruby', 'ruby', 4, 'atk', 150.00, 3),
('Huge Ruby', 'ruby', 5, 'atk', 350.00, 3),
('Giant Ruby', 'ruby', 6, 'atk', 800.00, 3),
('Perfect Ruby', 'ruby', 7, 'atk', 1800.00, 3),
('Flawless Ruby', 'ruby', 8, 'atk', 4000.00, 3),
('Radiant Ruby', 'ruby', 9, 'atk', 9000.00, 3),
('Celestial Ruby', 'ruby', 10, 'atk', 20000.00, 3),

('Tiny Sapphire', 'sapphire', 1, 'def', 15.00, 3),
('Small Sapphire', 'sapphire', 2, 'def', 35.00, 3),
('Sapphire', 'sapphire', 3, 'def', 80.00, 3),
('Large Sapphire', 'sapphire', 4, 'def', 180.00, 3),
('Huge Sapphire', 'sapphire', 5, 'def', 400.00, 3),
('Giant Sapphire', 'sapphire', 6, 'def', 900.00, 3),
('Perfect Sapphire', 'sapphire', 7, 'def', 2000.00, 3),
('Flawless Sapphire', 'sapphire', 8, 'def', 4500.00, 3),
('Radiant Sapphire', 'sapphire', 9, 'def', 10000.00, 3),
('Celestial Sapphire', 'sapphire', 10, 'def', 22000.00, 3),

('Tiny Topaz', 'topaz', 1, 'hp', 50.00, 3),
('Small Topaz', 'topaz', 2, 'hp', 120.00, 3),
('Topaz', 'topaz', 3, 'hp', 280.00, 3),
('Large Topaz', 'topaz', 4, 'hp', 650.00, 3),
('Huge Topaz', 'topaz', 5, 'hp', 1500.00, 3),
('Giant Topaz', 'topaz', 6, 'hp', 3400.00, 3),
('Perfect Topaz', 'topaz', 7, 'hp', 7500.00, 3),
('Flawless Topaz', 'topaz', 8, 'hp', 16500.00, 3),
('Radiant Topaz', 'topaz', 9, 'hp', 36000.00, 3),
('Celestial Topaz', 'topaz', 10, 'hp', 78000.00, 3);

-- ============================================
-- GACHA BANNERS
-- ============================================
INSERT INTO `gacha_banners` (`name`, `banner_type`, `ssr_rate`, `sr_rate`, `r_rate`, `soft_pity_start`, `hard_pity`, `rate_up_probability`, `cost_per_pull`, `cost_per_10pull`, `currency_type`, `is_active`, `priority`, `description`) VALUES
('Standard Summon', 'standard', 0.0200, 0.1800, 0.8000, 50, 90, 0.5000, 160, 1600, 'diamond_free', 1, 1, 'Permanent banner with all standard items'),
('Beginner Banner', 'beginner', 0.0500, 0.2500, 0.7000, 30, 60, 0.7000, 80, 800, 'diamond_paid', 1, 3, 'New player special - limited 100 pulls'),
('Limited: Dragon God', 'limited_rate_up', 0.0200, 0.1800, 0.8000, 50, 90, 0.5000, 160, 1600, 'diamond_paid', 1, 2, 'Rate-up for Dragon God martial soul'),
('Weapon Special', 'weapon', 0.0150, 0.1850, 0.8000, 60, 100, 0.6000, 160, 1600, 'ticket', 1, 4, 'Weapon-focused summon banner'),
('Soul Ring Hunt', 'soul_ring', 0.0250, 0.1750, 0.8000, 45, 80, 0.5000, 200, 2000, 'diamond_paid', 0, 5, 'Exclusive soul ring banner');

-- ============================================
-- DAILY QUESTS
-- ============================================
INSERT INTO `daily_quests` (`name`, `quest_type`, `target_count`, `activity_points`, `gold_reward`, `diamond_reward`, `exp_reward`, `min_level`, `priority`) VALUES
('Mob Hunter I', 'kill_mobs', 10, 10, 5000, 0, 1000, 1, 1),
('Mob Hunter II', 'kill_mobs', 50, 20, 15000, 0, 3000, 10, 2),
('Mob Hunter III', 'kill_mobs', 100, 30, 30000, 0, 5000, 30, 3),
('Enhance Your Gear', 'enhance_gear', 1, 15, 2000, 0, 500, 5, 4),
('Arena Warrior', 'arena_fight', 3, 20, 5000, 10, 2000, 15, 5),
('Guild Support', 'guild_donate', 1, 10, 1000, 5, 500, 10, 6),
('Dungeon Explorer', 'dungeon_clear', 2, 25, 10000, 20, 4000, 20, 7),
('Daily Login', 'login', 1, 5, 1000, 10, 500, 1, 8),
('Big Spender', 'spend_currency', 1000, 15, 0, 50, 1000, 20, 9),
('Lucky Pull', 'gacha_pull', 1, 10, 0, 20, 500, 15, 10);

-- ============================================
-- LOGIN REWARDS (30-Day Cycle)
-- ============================================
INSERT INTO `login_rewards` (`day_number`, `reward_type`, `reward_quantity`, `is_special_day`, `special_multiplier`) VALUES
(1, 'diamonds', 100, 0, 1.00),
(2, 'gold', 5000, 0, 1.00),
(3, 'stamina', 50, 0, 1.00),
(4, 'diamonds', 100, 0, 1.00),
(5, 'gold', 10000, 0, 1.00),
(6, 'stamina', 50, 0, 1.00),
(7, 'item', 1, 1, 1.00), -- SSR Shard Box
(8, 'diamonds', 150, 0, 1.00),
(9, 'gold', 10000, 0, 1.00),
(10, 'stamina', 50, 0, 1.00),
(11, 'diamonds', 150, 0, 1.00),
(12, 'gold', 15000, 0, 1.00),
(13, 'stamina', 50, 0, 1.00),
(14, 'item', 1, 1, 1.50), -- Enhanced SSR Shard Box
(15, 'diamonds', 200, 0, 1.00),
(16, 'gold', 15000, 0, 1.00),
(17, 'stamina', 50, 0, 1.00),
(18, 'diamonds', 200, 0, 1.00),
(19, 'gold', 20000, 0, 1.00),
(20, 'stamina', 50, 0, 1.00),
(21, 'item', 1, 1, 2.00), -- Premium Reward Box
(22, 'diamonds', 250, 0, 1.00),
(23, 'gold', 20000, 0, 1.00),
(24, 'stamina', 50, 0, 1.00),
(25, 'diamonds', 250, 0, 1.00),
(26, 'gold', 25000, 0, 1.00),
(27, 'stamina', 50, 0, 1.00),
(28, 'diamonds', 300, 0, 1.00),
(29, 'gold', 30000, 0, 1.00),
(30, 'item', 1, 1, 3.00); -- Grand Prize: Limited Title

-- ============================================
-- ACTIVITY CHESTS
-- ============================================
INSERT INTO `activity_chests` (`activity_threshold`, `chest_type`, `rewards`, `claim_order`) VALUES
(50, 'bronze', '{"gold": 10000, "exp": 2000}', 1),
(100, 'silver', '{"gold": 25000, "diamonds": 50, "exp": 5000}', 2),
(150, 'gold', '{"gold": 50000, "diamonds": 100, "exp": 10000, "items": [{"id": 101, "qty": 5}]}', 3),
(200, 'diamond', '{"gold": 100000, "diamonds": 200, "exp": 20000, "items": [{"id": 102, "qty": 3}]}', 4);

-- ============================================
-- VIP LEVELS
-- ============================================
INSERT INTO `vip_levels` (`vip_level`, `required_exp`, `privileges`, `daily_diamond_bonus`, `stamina_buy_limit`, `gacha_discount_percent`, `exp_boost_percent`, `gold_boost_percent`, `skip_ticket_limit`, `auto_battle_unlock`) VALUES
(0, 0, '{}', 0, 3, 0.00, 0.00, 0.00, 5, 0),
(1, 100, '{"extra_quest_slots": 1}', 10, 5, 0.00, 5.00, 5.00, 10, 0),
(2, 500, '{"extra_quest_slots": 1, "fast_forward": true}', 20, 7, 2.00, 10.00, 10.00, 15, 1),
(3, 1000, '{"extra_quest_slots": 2, "fast_forward": true}', 30, 9, 3.00, 15.00, 15.00, 20, 1),
(4, 2500, '{"extra_quest_slots": 2, "fast_forward": true, "auto_combat": true}', 50, 11, 5.00, 20.00, 20.00, 25, 1),
(5, 5000, '{"extra_quest_slots": 3, "fast_forward": true, "auto_combat": true}', 80, 13, 7.00, 25.00, 25.00, 30, 1),
(6, 10000, '{"extra_quest_slots": 3, "fast_forward": true, "auto_combat": true, "boss_skip": true}', 120, 15, 10.00, 30.00, 30.00, 40, 1),
(7, 25000, '{"extra_quest_slots": 4, "fast_forward": true, "auto_combat": true, "boss_skip": true}', 180, 17, 12.00, 35.00, 35.00, 50, 1),
(8, 50000, '{"extra_quest_slots": 4, "fast_forward": true, "auto_combat": true, "boss_skip": true, "dungeon_sweep": true}', 260, 19, 15.00, 40.00, 40.00, 60, 1),
(9, 100000, '{"extra_quest_slots": 5, "fast_forward": true, "auto_combat": true, "boss_skip": true, "dungeon_sweep": true}', 380, 21, 18.00, 45.00, 45.00, 80, 1),
(10, 250000, '{"extra_quest_slots": 5, "fast_forward": true, "auto_combat": true, "boss_skip": true, "dungeon_sweep": true, "exclusive_shop": true}', 550, 25, 20.00, 50.00, 50.00, 100, 1),
(11, 500000, '{"extra_quest_slots": 6, "all_previous": true}', 800, 30, 22.00, 55.00, 55.00, 120, 1),
(12, 1000000, '{"extra_quest_slots": 6, "all_previous": true}', 1200, 35, 25.00, 60.00, 60.00, 150, 1),
(13, 2500000, '{"extra_quest_slots": 7, "all_previous": true}', 1800, 40, 28.00, 65.00, 65.00, 180, 1),
(14, 5000000, '{"extra_quest_slots": 7, "all_previous": true}', 2600, 45, 30.00, 70.00, 70.00, 200, 1),
(15, 10000000, '{"extra_quest_slots": 8, "all_previous": true, "god_mode": true}', 4000, 50, 35.00, 75.00, 75.00, 999, 1);

-- ============================================
-- PAYMENT PACKAGES
-- ============================================
INSERT INTO `payment_packages` (`package_id`, `name`, `price_usd`, `diamonds`, `bonus_items`, `first_purchase_only`, `is_active`, `priority`, `description`) VALUES
('starter_pack', 'Starter Pack', 0.99, 100, '{"items": [{"id": 50, "qty": 10}, {"id": 51, "qty": 5}]}', 1, 1, 10, 'Best value for new players'),
('monthly_card', 'Monthly Card', 4.99, 0, '{"daily_diamonds": 100, "duration_days": 30}', 0, 1, 9, '100 diamonds daily for 30 days'),
('diamond_pack_1', 'Diamond Pack S', 1.99, 200, '{}', 0, 1, 5, 'Small diamond top-up'),
('diamond_pack_2', 'Diamond Pack M', 4.99, 550, '{"bonus": 50}', 0, 1, 5, 'Medium diamond pack +10% bonus'),
('diamond_pack_3', 'Diamond Pack L', 9.99, 1200, '{"bonus": 200}', 0, 1, 5, 'Large diamond pack +20% bonus'),
('diamond_pack_4', 'Diamond Pack XL', 19.99, 2600, '{"bonus": 600}', 0, 1, 5, 'Extra large pack +30% bonus'),
('diamond_pack_5', 'Diamond Pack XXL', 49.99, 7000, '{"bonus": 2000}', 0, 1, 5, 'Mega pack +40% bonus'),
('diamond_pack_6', 'Diamond Pack Whale', 99.99, 15000, '{"bonus": 5000, "title": "Big Spender"}', 0, 1, 5, 'Ultimate whale pack'),
('growth_fund', 'Growth Fund', 9.99, 0, '{"total_return": 10000, "milestones": [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]}', 0, 1, 8, '10x return as you level up'),
('battle_pass', 'Battle Pass', 9.99, 0, '{"premium_rewards": true, "duration_days": 30}', 0, 1, 7, 'Unlock premium battle pass rewards'),
('weekly_subscription', 'Weekly Privilege', 2.99, 300, '{"auto_battle": true, "extra_loot": true, "duration_days": 7}', 0, 1, 6, 'Weekly convenience bundle');

-- ============================================
-- MAPS
-- ============================================
INSERT INTO `maps` (`name`, `map_type`, `min_level`, `max_level`, `difficulty`, `recommended_bp`, `stamina_cost`, `max_players`, `respawn_time_seconds`, `time_limit_seconds`, `description`, `is_active`) VALUES
('Novice Village', 'city', 1, 10, 'easy', 500, 0, 100, 0, 0, 'Starting area for new players', 1),
('Spirit Forest', 'wilderness', 5, 20, 'easy', 1000, 5, 50, 30, 0, 'Forest filled with low-level spirit beasts', 1),
('Iron Mine', 'dungeon', 10, 25, 'normal', 2500, 10, 5, 60, 1800, 'Abandoned mine with earth elementals', 1),
('Flame Volcano', 'dungeon', 25, 40, 'hard', 8000, 15, 5, 90, 1800, 'Active volcano with fire spirits', 1),
('Frozen Wasteland', 'wilderness', 35, 50, 'hard', 15000, 20, 50, 45, 0, 'Icy plains with frozen horrors', 1),
('Arena of Champions', 'arena', 20, 999, 'normal', 5000, 5, 2, 0, 300, 'PvP combat arena', 1),
('Guild Base Alpha', 'guild_territory', 15, 999, 'easy', 3000, 0, 50, 0, 0, 'Territory for guild members', 1),
('Dragon''s Lair', 'dungeon', 50, 70, 'nightmare', 50000, 30, 10, 120, 3600, 'Lair of the ancient dragon boss', 1),
('God Realm', 'dungeon', 70, 999, 'hell', 200000, 50, 20, 180, 7200, 'Dimension where gods reside', 1),
('Event: Summer Beach', 'event_zone', 1, 999, 'easy', 1000, 10, 100, 60, 3600, 'Limited-time summer event zone', 0);

-- ============================================
-- MONSTERS (Sample)
-- ============================================
INSERT INTO `monsters` (`name`, `monster_type`, `level`, `hp`, `atk`, `def`, `exp_reward`, `gold_reward`, `model_path`, `ai_behavior`, `aggro_range`, `leash_range`, `is_aggressive`, `respawn_minutes`, `max_spawn_count`) VALUES
('Wild Boar', 'normal', 1, 100, 20, 5, 10, 5, 'models/monsters/boar.fbx', 'aggressive', 8.00, 15.00, 1, 3, 20),
('Forest Wolf', 'normal', 3, 150, 30, 8, 20, 10, 'models/monsters/wolf.fbx', 'aggressive', 10.00, 18.00, 1, 4, 15),
('Rock Golem', 'elite', 15, 2000, 100, 50, 200, 100, 'models/monsters/golem.fbx', 'defensive', 6.00, 12.00, 0, 10, 5),
('Flame Spirit', 'normal', 20, 800, 120, 20, 150, 80, 'models/monsters/flame_spirit.fbx', 'aggressive', 12.00, 20.00, 1, 5, 10),
('Ice Witch', 'elite', 30, 3500, 200, 80, 500, 250, 'models/monsters/ice_witch.fbx', 'aggressive', 15.00, 25.00, 1, 15, 3),
('Thunder Dragon', 'boss', 50, 50000, 800, 300, 5000, 2000, 'models/monsters/thunder_dragon.fbx', 'aggressive', 20.00, 30.00, 1, 120, 1),
('Demon Lord', 'world_boss', 70, 500000, 2000, 800, 50000, 20000, 'models/monsters/demon_lord.fbx', 'aggressive', 25.00, 40.00, 1, 360, 1),
('Treasure Goblin', 'event', 10, 500, 10, 50, 100, 5000, 'models/monsters/goblin.fbx', 'passive', 5.00, 10.00, 0, 60, 5);

-- ============================================
-- TITLES
-- ============================================
INSERT INTO `titles` (`name`, `rarity`, `stat bonuses`, `chat_color`, `effect_description`, `acquisition_method`, `is_permanent`) VALUES
('Novice', 'common', '{"atk": 10, "hp": 50}', NULL, 'Starting title', 'Default', 1),
('Warrior', 'common', '{"atk": 20, "hp": 100}', NULL, 'Defeated 100 enemies', 'Achievement', 1),
('Elite Fighter', 'rare', '{"atk": 50, "def": 30, "hp": 200}', '#00FF00', 'Reached level 30', 'Progression', 1),
('Arena Champion', 'epic', '{"atk": 100, "crit_rate": 5}', '#0000FF', 'Reached Arena Rank 1', 'PvP', 1),
('Guild Master', 'epic', '{"atk": 80, "hp": 500, "def": 50}', '#FF00FF', 'Lead a guild to victory', 'Guild War', 1),
('Dragon Slayer', 'legendary', '{"atk': 200, 'crit_dmg': 30, 'penetration': 10}', '#FFA500', 'Defeated Thunder Dragon', 'Boss Kill', 1),
('Server Legend', 'legendary', '{"atk": 300, "all_stats": 50}', '#FF4500', 'Ranked #1 on server', 'Ranking', 1),
('God Emperor', 'divine', '{"atk": 500, "all_stats": 100, "damage_boost": 20}', '#FFD700', 'Reached max level', 'Progression', 1),
('Whale King', 'divine', '{"atk": 400, "gold_boost": 50, "diamond_bonus": 20}', '#00FFFF', 'Spent $10,000+', 'Payment', 1),
('Summer Champion 2024', 'epic', '{"atk": 60, 'hp': 300}', '#FF69B4', 'Won summer event', 'Event', 0);

-- ============================================
-- SERVER CONFIG
-- ============================================
INSERT INTO `server_config` (`config_key`, `config_value`, `description`) VALUES
('game.version', '{"major": 1, "minor": 0, "patch": 0}', 'Current game version'),
('combat.formula_version', 'v2.1', 'Combat calculation formula version'),
('gacha.base_ssr_rate', '0.02', 'Base SSR drop rate'),
('gacha.soft_pity_start', '50', 'Pulls before soft pity begins'),
('gacha.hard_pity', '90', 'Guaranteed SSR at this many pulls'),
('economy.gold_inflation_target', '0.05', 'Target weekly inflation rate'),
('player.max_level', '100', 'Maximum player level'),
('player.stamina_regen_per_min', '1', 'Stamina regeneration rate'),
('guild.max_members', '50', 'Maximum guild size'),
('arena.season_duration_days', '30', 'Arena season length'),
('maintenance.enabled', 'false', 'Maintenance mode flag'),
('maintenance.message', '"Server under maintenance"', 'Message shown during maintenance');

-- End of Seed Data
