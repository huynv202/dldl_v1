-- SL-OMEGA Complete Database Schema
-- MySQL 8.0+ Optimized for Game Performance
-- Based on Design Docs v1.0.0

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- CORE TABLES
-- ============================================

-- Players table
CREATE TABLE IF NOT EXISTS `players` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `level` INT UNSIGNED DEFAULT 1,
  `exp` BIGINT UNSIGNED DEFAULT 0,
  `battle_power` BIGINT UNSIGNED DEFAULT 0,
  `gold` BIGINT UNSIGNED DEFAULT 0,
  `diamonds_free` BIGINT UNSIGNED DEFAULT 0,
  `diamonds_paid` BIGINT UNSIGNED DEFAULT 0,
  `stamina` INT UNSIGNED DEFAULT 100,
  `stamina_max` INT UNSIGNED DEFAULT 100,
  `vip_level` INT UNSIGNED DEFAULT 0,
  `vip_exp` INT UNSIGNED DEFAULT 0,
  `guild_id` BIGINT UNSIGNED DEFAULT NULL,
  `martial_soul_id` INT UNSIGNED DEFAULT NULL,
  `class_type` ENUM('warrior', 'mage', 'archer', 'assassin') DEFAULT NULL,
  `gender` ENUM('male', 'female') DEFAULT 'male',
  `avatar_id` INT UNSIGNED DEFAULT 1,
  `title_id` INT UNSIGNED DEFAULT NULL,
  `last_login` DATETIME DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_banned` TINYINT(1) DEFAULT 0,
  `ban_reason` VARCHAR(255) DEFAULT NULL,
  `region` VARCHAR(50) DEFAULT 'server1',
  `device_id` VARCHAR(100) DEFAULT NULL,
  `ip_address` VARCHAR(45) DEFAULT NULL,
  
  INDEX idx_level_exp (level DESC, exp DESC),
  INDEX idx_battle_power (battle_power DESC),
  INDEX idx_guild (guild_id),
  INDEX idx_last_login (last_login DESC),
  INDEX idx_region_active (region, last_login DESC, level) WHERE is_banned = 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Stats
CREATE TABLE IF NOT EXISTS `player_stats` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `base_atk` BIGINT UNSIGNED DEFAULT 0,
  `base_def` BIGINT UNSIGNED DEFAULT 0,
  `base_hp` BIGINT UNSIGNED DEFAULT 0,
  `crit_rate` DECIMAL(5,2) DEFAULT 0.00,
  `crit_dmg` DECIMAL(6,2) DEFAULT 50.00,
  `penetration` DECIMAL(5,2) DEFAULT 0.00,
  `accuracy` DECIMAL(5,2) DEFAULT 0.00,
  `dodge` DECIMAL(5,2) DEFAULT 0.00,
  `cc_resistance` DECIMAL(5,2) DEFAULT 0.00,
  `elemental_mastery` INT UNSIGNED DEFAULT 0,
  `attack_speed` DECIMAL(5,2) DEFAULT 1.00,
  `cooldown_reduction` DECIMAL(5,2) DEFAULT 0.00,
  `damage_boost` DECIMAL(5,2) DEFAULT 0.00,
  `damage_reduction` DECIMAL(5,2) DEFAULT 0.00,
  
  UNIQUE KEY uk_player (player_id),
  CONSTRAINT fk_player_stats FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- MARTIAL SOUL SYSTEM
-- ============================================

-- Martial Souls Master Table
CREATE TABLE IF NOT EXISTS `martial_souls` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `rarity` ENUM('common', 'rare', 'epic', 'legendary', 'divine') NOT NULL,
  `soul_type` ENUM('control', 'attack', 'tank', 'support', 'speed_dps') NOT NULL,
  `base_atk` INT UNSIGNED DEFAULT 0,
  `base_def` INT UNSIGNED DEFAULT 0,
  `base_hp` INT UNSIGNED DEFAULT 0,
  `crit_rate` DECIMAL(5,2) DEFAULT 0.00,
  `crit_dmg` DECIMAL(6,2) DEFAULT 0.00,
  `description` TEXT DEFAULT NULL,
  `unlock_level` INT UNSIGNED DEFAULT 1,
  `gacha_weight` INT UNSIGNED DEFAULT 100,
  `model_path` VARCHAR(255) DEFAULT NULL,
  `icon_path` VARCHAR(255) DEFAULT NULL,
  `skill_ids` JSON DEFAULT NULL,
  `is_obtainable` TINYINT(1) DEFAULT 1,
  
  INDEX idx_rarity (rarity),
  INDEX idx_type (soul_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Martial Souls
CREATE TABLE IF NOT EXISTS `player_martial_souls` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `martial_soul_id` INT UNSIGNED NOT NULL,
  `level` INT UNSIGNED DEFAULT 1,
  `star_level` INT UNSIGNED DEFAULT 0,
  `awakening_level` INT UNSIGNED DEFAULT 0,
  `duplicate_count` INT UNSIGNED DEFAULT 0,
  `is_equipped` TINYINT(1) DEFAULT 0,
  `obtained_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE KEY uk_player_soul (player_id, martial_soul_id),
  INDEX idx_equipped (player_id, is_equipped),
  CONSTRAINT fk_pms_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_pms_soul FOREIGN KEY (martial_soul_id) REFERENCES martial_souls(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- SOUL RING SYSTEM
-- ============================================

-- Soul Rings Master Table
CREATE TABLE IF NOT EXISTS `soul_rings` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `tier` ENUM('white', 'yellow', 'purple', 'black', 'red', 'gold') NOT NULL,
  `min_years` INT UNSIGNED DEFAULT 0,
  `max_years` INT UNSIGNED DEFAULT 0,
  `stat_multiplier` DECIMAL(5,2) DEFAULT 1.00,
  `skill_id` INT UNSIGNED DEFAULT NULL,
  `color_hex` VARCHAR(7) DEFAULT '#FFFFFF',
  `icon_path` VARCHAR(255) DEFAULT NULL,
  `model_path` VARCHAR(255) DEFAULT NULL,
  `effect_description` TEXT DEFAULT NULL,
  `gacha_weight` INT UNSIGNED DEFAULT 100,
  
  INDEX idx_tier (tier),
  INDEX idx_years (min_years, max_years)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Soul Ring Substats Template
CREATE TABLE IF NOT EXISTS `soul_ring_substats` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `substat_type` ENUM('atk_percent', 'def_percent', 'hp_percent', 'crit_rate', 'crit_dmg', 'penetration', 'accuracy', 'dodge', 'cooldown_reduction', 'attack_speed') NOT NULL,
  `min_value` DECIMAL(6,2) DEFAULT 0.00,
  `max_value` DECIMAL(6,2) DEFAULT 0.00,
  `weight` INT UNSIGNED DEFAULT 100,
  `applicable_tiers` JSON DEFAULT NULL,
  
  INDEX idx_type (substat_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Soul Rings
CREATE TABLE IF NOT EXISTS `player_soul_rings` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `soul_ring_id` INT UNSIGNED NOT NULL,
  `years` INT UNSIGNED DEFAULT 0,
  `slot_position` TINYINT UNSIGNED DEFAULT NULL,
  `substat_1_type` VARCHAR(50) DEFAULT NULL,
  `substat_1_value` DECIMAL(6,2) DEFAULT 0.00,
  `substat_2_type` VARCHAR(50) DEFAULT NULL,
  `substat_2_value` DECIMAL(6,2) DEFAULT 0.00,
  `substat_3_type` VARCHAR(50) DEFAULT NULL,
  `substat_3_value` DECIMAL(6,2) DEFAULT 0.00,
  `is_locked` TINYINT(1) DEFAULT 0,
  `obtained_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_player (player_id),
  INDEX idx_slot (player_id, slot_position),
  CONSTRAINT fk_psr_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_psr_ring FOREIGN KEY (soul_ring_id) REFERENCES soul_rings(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- EQUIPMENT SYSTEM
-- ============================================

-- Equipment Types
CREATE TABLE IF NOT EXISTS `equipment_types` (
  `id` TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` ENUM('weapon', 'armor', 'helm', 'pants', 'boots', 'gloves', 'necklace', 'ring1', 'ring2', 'artifact') NOT NULL,
  `slot_index` TINYINT UNSIGNED NOT NULL UNIQUE,
  `description` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Equipment Master Table
CREATE TABLE IF NOT EXISTS `equipments` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `type_id` TINYINT UNSIGNED NOT NULL,
  `rarity` ENUM('common', 'rare', 'epic', 'legendary', 'red') NOT NULL,
  `min_level` INT UNSIGNED DEFAULT 1,
  `base_atk` INT UNSIGNED DEFAULT 0,
  `base_def` INT UNSIGNED DEFAULT 0,
  `base_hp` INT UNSIGNED DEFAULT 0,
  `set_id` INT UNSIGNED DEFAULT NULL,
  `set_piece_count` TINYINT UNSIGNED DEFAULT 1,
  `icon_path` VARCHAR(255) DEFAULT NULL,
  `model_path` VARCHAR(255) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `sell_price` INT UNSIGNED DEFAULT 0,
  `is_tradable` TINYINT(1) DEFAULT 1,
  
  INDEX idx_type (type_id),
  INDEX idx_rarity (rarity),
  INDEX idx_set (set_id),
  INDEX idx_level (min_level),
  CONSTRAINT fk_equip_type FOREIGN KEY (type_id) REFERENCES equipment_types(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Equipment Set Bonuses
CREATE TABLE IF NOT EXISTS `equipment_set_bonuses` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `set_id` INT UNSIGNED NOT NULL,
  `pieces_required` TINYINT UNSIGNED NOT NULL,
  `bonus_type` ENUM('atk_percent', 'def_percent', 'hp_percent', 'crit_rate', 'crit_dmg', 'cooldown_reduction', 'damage_boost') NOT NULL,
  `bonus_value` DECIMAL(6,2) NOT NULL,
  `description` VARCHAR(255) DEFAULT NULL,
  
  INDEX idx_set_pieces (set_id, pieces_required),
  CONSTRAINT fk_set_bonus FOREIGN KEY (set_id) REFERENCES equipments(set_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Equipment
CREATE TABLE IF NOT EXISTS `player_equipments` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `equipment_id` INT UNSIGNED NOT NULL,
  `enhancement_level` TINYINT UNSIGNED DEFAULT 0,
  `refinement_stars` TINYINT UNSIGNED DEFAULT 0,
  `awakening_level` TINYINT UNSIGNED DEFAULT 0,
  `transcendence_tier` TINYINT UNSIGNED DEFAULT 0,
  `socket_count` TINYINT UNSIGNED DEFAULT 0,
  `gem_ids` JSON DEFAULT NULL,
  `is_equipped` TINYINT(1) DEFAULT 0,
  `durability` INT UNSIGNED DEFAULT 100,
  `obtained_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_player (player_id),
  INDEX idx_equipped (player_id, is_equipped),
  CONSTRAINT fk_pe_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_pe_equip FOREIGN KEY (equipment_id) REFERENCES equipments(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gems
CREATE TABLE IF NOT EXISTS `gems` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL,
  `type` ENUM('ruby', 'sapphire', 'topaz', 'emerald', 'diamond', 'amethyst') NOT NULL,
  `level` TINYINT UNSIGNED DEFAULT 1,
  `stat_type` ENUM('atk', 'def', 'hp', 'crit_rate', 'crit_dmg', 'penetration') NOT NULL,
  `stat_value` DECIMAL(8,2) NOT NULL,
  `combine_material_count` INT UNSIGNED DEFAULT 3,
  `icon_path` VARCHAR(255) DEFAULT NULL,
  
  INDEX idx_type_level (type, level),
  UNIQUE KEY uk_gem_unique (type, level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- SKILLS SYSTEM
-- ============================================

-- Skills Master Table
CREATE TABLE IF NOT EXISTS `skills` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `skill_type` ENUM('basic', 'active', 'ultimate', 'passive') NOT NULL,
  `element` ENUM('physical', 'fire', 'water', 'earth', 'wind', 'light', 'dark') DEFAULT 'physical',
  `base_damage` DECIMAL(8,2) DEFAULT 0.00,
  `scaling_coefficient` DECIMAL(5,2) DEFAULT 1.00,
  `cooldown_seconds` DECIMAL(6,2) DEFAULT 0.00,
  `energy_cost` INT UNSIGNED DEFAULT 0,
  `cast_range` DECIMAL(6,2) DEFAULT 0.00,
  `aoe_radius` DECIMAL(6,2) DEFAULT 0.00,
  `duration_seconds` DECIMAL(6,2) DEFAULT 0.00,
  `effect_type` ENUM('damage', 'heal', 'buff', 'debuff', 'cc', 'shield') DEFAULT NULL,
  `cc_type` ENUM('stun', 'freeze', 'silence', 'root', 'fear', 'charm', 'knockback') DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `animation_path` VARCHAR(255) DEFAULT NULL,
  `effect_path` VARCHAR(255) DEFAULT NULL,
  `icon_path` VARCHAR(255) DEFAULT NULL,
  `sound_path` VARCHAR(255) DEFAULT NULL,
  `max_level` INT UNSIGNED DEFAULT 10,
  
  INDEX idx_type (skill_type),
  INDEX idx_element (element),
  INDEX idx_effect (effect_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Skills
CREATE TABLE IF NOT EXISTS `player_skills` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `skill_id` INT UNSIGNED NOT NULL,
  `level` INT UNSIGNED DEFAULT 1,
  `is_unlocked` TINYINT(1) DEFAULT 0,
  `is_equipped` TINYINT(1) DEFAULT 0,
  `skill_slot` TINYINT UNSIGNED DEFAULT NULL,
  `last_used` DATETIME DEFAULT NULL,
  `usage_count` BIGINT UNSIGNED DEFAULT 0,
  
  UNIQUE KEY uk_player_skill (player_id, skill_id),
  INDEX idx_equipped (player_id, is_equipped),
  CONSTRAINT fk_ps_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_ps_skill FOREIGN KEY (skill_id) REFERENCES skills(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- MAPS & ZONES
-- ============================================

-- Maps/Zones
CREATE TABLE IF NOT EXISTS `maps` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `map_type` ENUM('city', 'wilderness', 'dungeon', 'arena', 'guild_territory', 'event_zone') NOT NULL,
  `min_level` INT UNSIGNED DEFAULT 1,
  `max_level` INT UNSIGNED DEFAULT 999,
  `difficulty` ENUM('easy', 'normal', 'hard', 'nightmare', 'hell') DEFAULT 'normal',
  `recommended_bp` BIGINT UNSIGNED DEFAULT 0,
  `stamina_cost` INT UNSIGNED DEFAULT 0,
  `max_players` INT UNSIGNED DEFAULT 1,
  `respawn_time_seconds` INT UNSIGNED DEFAULT 0,
  `time_limit_seconds` INT UNSIGNED DEFAULT 0,
  `scene_path` VARCHAR(255) DEFAULT NULL,
  `music_path` VARCHAR(255) DEFAULT NULL,
  `ambient_sound_path` VARCHAR(255) DEFAULT NULL,
  `lighting_profile` VARCHAR(100) DEFAULT 'default',
  `weather_effects` JSON DEFAULT NULL,
  `spawn_points` JSON DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  
  INDEX idx_type (map_type),
  INDEX idx_level (min_level, max_level),
  INDEX idx_difficulty (difficulty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Monsters/NPCs
CREATE TABLE IF NOT EXISTS `monsters` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `monster_type` ENUM('normal', 'elite', 'boss', 'world_boss', 'event') NOT NULL,
  `level` INT UNSIGNED DEFAULT 1,
  `hp` BIGINT UNSIGNED DEFAULT 0,
  `atk` BIGINT UNSIGNED DEFAULT 0,
  `def` BIGINT UNSIGNED DEFAULT 0,
  `exp_reward` BIGINT UNSIGNED DEFAULT 0,
  `gold_reward` BIGINT UNSIGNED DEFAULT 0,
  `drop_table_id` INT UNSIGNED DEFAULT NULL,
  `model_path` VARCHAR(255) DEFAULT NULL,
  `animations` JSON DEFAULT NULL,
  `skill_ids` JSON DEFAULT NULL,
  `ai_behavior` VARCHAR(50) DEFAULT 'aggressive',
  `aggro_range` DECIMAL(6,2) DEFAULT 10.00,
  `leash_range` DECIMAL(6,2) DEFAULT 20.00,
  `is_aggressive` TINYINT(1) DEFAULT 1,
  `spawn_maps` JSON DEFAULT NULL,
  `respawn_minutes` INT UNSIGNED DEFAULT 5,
  `max_spawn_count` INT UNSIGNED DEFAULT 1,
  
  INDEX idx_type (monster_type),
  INDEX idx_level (level),
  INDEX idx_maps (spawn_maps, CAST(1 AS CHAR))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Monster Drops
CREATE TABLE IF NOT EXISTS `monster_drops` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `monster_id` INT UNSIGNED NOT NULL,
  `item_type` ENUM('gold', 'exp', 'equipment', 'soul_ring', 'gem', 'material', 'consumable') NOT NULL,
  `item_id` INT UNSIGNED DEFAULT NULL,
  `min_quantity` INT UNSIGNED DEFAULT 1,
  `max_quantity` INT UNSIGNED DEFAULT 1,
  `drop_rate` DECIMAL(6,4) DEFAULT 0.0000,
  `is_guaranteed` TINYINT(1) DEFAULT 0,
  `min_player_level` INT UNSIGNED DEFAULT 1,
  
  INDEX idx_monster (monster_id),
  INDEX idx_item_type (item_type),
  CONSTRAINT fk_md_monster FOREIGN KEY (monster_id) REFERENCES monsters(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- GACHA SYSTEM
-- ============================================

-- Gacha Banners
CREATE TABLE IF NOT EXISTS `gacha_banners` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `banner_type` ENUM('standard', 'limited_rate_up', 'beginner', 'weapon', 'soul_ring') NOT NULL,
  `ssr_rate` DECIMAL(5,4) DEFAULT 0.0200,
  `sr_rate` DECIMAL(5,4) DEFAULT 0.1800,
  `r_rate` DECIMAL(5,4) DEFAULT 0.8000,
  `soft_pity_start` INT UNSIGNED DEFAULT 50,
  `hard_pity` INT UNSIGNED DEFAULT 90,
  `rate_up_item_ids` JSON DEFAULT NULL,
  `rate_up_probability` DECIMAL(5,4) DEFAULT 0.5000,
  `cost_per_pull` INT UNSIGNED DEFAULT 160,
  `cost_per_10pull` INT UNSIGNED DEFAULT 1600,
  `currency_type` ENUM('diamond_free', 'diamond_paid', 'ticket') DEFAULT 'diamond_paid',
  `start_date` DATETIME DEFAULT NULL,
  `end_date` DATETIME DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `priority` INT UNSIGNED DEFAULT 0,
  `banner_image_path` VARCHAR(255) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  
  INDEX idx_type (banner_type),
  INDEX idx_active_dates (is_active, start_date, end_date),
  INDEX idx_priority (priority DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Gacha Items Pool
CREATE TABLE IF NOT EXISTS `gacha_items` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `banner_id` INT UNSIGNED NOT NULL,
  `item_type` ENUM('martial_soul', 'soul_ring', 'equipment', 'material') NOT NULL,
  `item_id` INT UNSIGNED NOT NULL,
  `rarity` ENUM('r', 'sr', 'ssr') NOT NULL,
  `weight` INT UNSIGNED NOT NULL,
  `is_featured` TINYINT(1) DEFAULT 0,
  
  INDEX idx_banner_rarity (banner_id, rarity),
  CONSTRAINT fk_gi_banner FOREIGN KEY (banner_id) REFERENCES gacha_banners(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Gacha History
CREATE TABLE IF NOT EXISTS `player_gacha_history` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `banner_id` INT UNSIGNED NOT NULL,
  `pull_type` ENUM('single', 'multi_10') NOT NULL,
  `results` JSON NOT NULL,
  `pity_counter` INT UNSIGNED DEFAULT 0,
  `had_guarantee` TINYINT(1) DEFAULT 0,
  `diamonds_spent` INT UNSIGNED DEFAULT 0,
  `pulled_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_player (player_id),
  INDEX idx_banner (banner_id),
  INDEX idx_date (pulled_at DESC),
  CONSTRAINT fk_pgh_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_pgh_banner FOREIGN KEY (banner_id) REFERENCES gacha_banners(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Pity Counters
CREATE TABLE IF NOT EXISTS `player_pity_counters` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `banner_id` INT UNSIGNED NOT NULL,
  `pulls_since_ssr` INT UNSIGNED DEFAULT 0,
  `last_ssr_was_featured` TINYINT(1) DEFAULT 1,
  `guarantee_available` TINYINT(1) DEFAULT 0,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  UNIQUE KEY uk_player_banner (player_id, banner_id),
  CONSTRAINT fk_ppc_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_ppc_banner FOREIGN KEY (banner_id) REFERENCES gacha_banners(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- GUILD SYSTEM
-- ============================================

-- Guilds
CREATE TABLE IF NOT EXISTS `guilds` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  `leader_id` BIGINT UNSIGNED NOT NULL,
  `level` INT UNSIGNED DEFAULT 1,
  `exp` BIGINT UNSIGNED DEFAULT 0,
  `total_battle_power` BIGINT UNSIGNED DEFAULT 0,
  `member_count` INT UNSIGNED DEFAULT 1,
  `max_members` INT UNSIGNED DEFAULT 50,
  `treasury_gold` BIGINT UNSIGNED DEFAULT 0,
  `treasury_diamonds` BIGINT UNSIGNED DEFAULT 0,
  `territory_id` INT UNSIGNED DEFAULT NULL,
  `logo_id` INT UNSIGNED DEFAULT 1,
  `announcement` TEXT DEFAULT NULL,
  `requirements` JSON DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_power (total_battle_power DESC),
  INDEX idx_level (level DESC),
  INDEX idx_leader (leader_id),
  CONSTRAINT fk_guild_leader FOREIGN KEY (leader_id) REFERENCES players(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Guild Members
CREATE TABLE IF NOT EXISTS `guild_members` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `guild_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `role` ENUM('leader', 'officer', 'elder', 'member') NOT NULL DEFAULT 'member',
  `contribution_points` BIGINT UNSIGNED DEFAULT 0,
  `donation_count` INT UNSIGNED DEFAULT 0,
  `joined_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `last_active` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE KEY uk_guild_member (guild_id, player_id),
  INDEX idx_guild (guild_id),
  INDEX idx_player (player_id),
  INDEX idx_contribution (guild_id, contribution_points DESC),
  CONSTRAINT fk_gm_guild FOREIGN KEY (guild_id) REFERENCES guilds(id) ON DELETE CASCADE,
  CONSTRAINT fk_gm_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Guild Skills/Tech
CREATE TABLE IF NOT EXISTS `guild_skills` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `skill_type` ENUM('atk_boost', 'def_boost', 'hp_boost', 'exp_boost', 'gold_boost', 'crit_boost') NOT NULL,
  `max_level` INT UNSIGNED DEFAULT 10,
  `base_value` DECIMAL(6,2) DEFAULT 0.00,
  `value_per_level` DECIMAL(6,2) DEFAULT 0.00,
  `upgrade_cost_formula` VARCHAR(100) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  
  INDEX idx_type (skill_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Guild Skill Levels
CREATE TABLE IF NOT EXISTS `guild_skill_levels` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `guild_id` BIGINT UNSIGNED NOT NULL,
  `skill_id` INT UNSIGNED NOT NULL,
  `current_level` INT UNSIGNED DEFAULT 0,
  `upgraded_by` BIGINT UNSIGNED DEFAULT NULL,
  `upgraded_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE KEY uk_guild_skill (guild_id, skill_id),
  CONSTRAINT fk_gsl_guild FOREIGN KEY (guild_id) REFERENCES guilds(id) ON DELETE CASCADE,
  CONSTRAINT fk_gsl_skill FOREIGN KEY (skill_id) REFERENCES guild_skills(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- DAILY QUESTS & RETENTION
-- ============================================

-- Daily Quests Template
CREATE TABLE IF NOT EXISTS `daily_quests` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `quest_type` ENUM('kill_mobs', 'enhance_gear', 'arena_fight', 'guild_donate', 'dungeon_clear', 'login', 'spend_currency', 'gacha_pull') NOT NULL,
  `target_count` INT UNSIGNED DEFAULT 1,
  `activity_points` INT UNSIGNED DEFAULT 10,
  `gold_reward` INT UNSIGNED DEFAULT 0,
  `diamond_reward` INT UNSIGNED DEFAULT 0,
  `item_rewards` JSON DEFAULT NULL,
  `exp_reward` BIGINT UNSIGNED DEFAULT 0,
  `min_level` INT UNSIGNED DEFAULT 1,
  `max_daily_completions` INT UNSIGNED DEFAULT 1,
  `priority` INT UNSIGNED DEFAULT 0,
  `is_enabled` TINYINT(1) DEFAULT 1,
  
  INDEX idx_type (quest_type),
  INDEX idx_priority (priority DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Daily Quest Progress
CREATE TABLE IF NOT EXISTS `player_daily_quests` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `quest_id` INT UNSIGNED NOT NULL,
  `current_progress` INT UNSIGNED DEFAULT 0,
  `is_completed` TINYINT(1) DEFAULT 0,
  `is_claimed` TINYINT(1) DEFAULT 0,
  `reset_date` DATE DEFAULT NULL,
  
  UNIQUE KEY uk_player_quest (player_id, quest_id, reset_date),
  INDEX idx_player (player_id),
  INDEX idx_reset (reset_date),
  CONSTRAINT fk_pdq_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_pdq_quest FOREIGN KEY (quest_id) REFERENCES daily_quests(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Login Rewards
CREATE TABLE IF NOT EXISTS `login_rewards` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `day_number` TINYINT UNSIGNED NOT NULL,
  `reward_type` ENUM('gold', 'diamonds', 'exp', 'item', 'stamina') NOT NULL,
  `reward_id` INT UNSIGNED DEFAULT NULL,
  `reward_quantity` INT UNSIGNED DEFAULT 1,
  `is_special_day` TINYINT(1) DEFAULT 0,
  `special_multiplier` DECIMAL(5,2) DEFAULT 1.00,
  
  UNIQUE KEY uk_day (day_number),
  INDEX idx_special (is_special_day)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Login History
CREATE TABLE IF NOT EXISTS `player_login_history` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `login_date` DATE NOT NULL,
  `login_timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `streak_count` INT UNSIGNED DEFAULT 1,
  `rewards_claimed` JSON DEFAULT NULL,
  `device_info` VARCHAR(255) DEFAULT NULL,
  `ip_address` VARCHAR(45) DEFAULT NULL,
  
  UNIQUE KEY uk_player_date (player_id, login_date),
  INDEX idx_player (player_id),
  INDEX idx_date (login_date DESC),
  CONSTRAINT fk_plh_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Activity Chests
CREATE TABLE IF NOT EXISTS `activity_chests` (
  `id` TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `activity_threshold` INT UNSIGNED NOT NULL,
  `chest_type` ENUM('bronze', 'silver', 'gold', 'diamond') NOT NULL,
  `rewards` JSON NOT NULL,
  `claim_order` TINYINT UNSIGNED NOT NULL,
  
  UNIQUE KEY uk_threshold (activity_threshold),
  INDEX idx_order (claim_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Activity Progress
CREATE TABLE IF NOT EXISTS `player_activity_progress` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `activity_points` INT UNSIGNED DEFAULT 0,
  `claimed_chests` JSON DEFAULT NULL,
  `reset_date` DATE DEFAULT NULL,
  
  UNIQUE KEY uk_player_date (player_id, reset_date),
  INDEX idx_player (player_id),
  CONSTRAINT fk_pap_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- EVENTS SYSTEM
-- ============================================

-- Events
CREATE TABLE IF NOT EXISTS `events` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `event_type` ENUM('weekly', 'bi_weekly', 'monthly', 'quarterly', 'seasonal', 'special') NOT NULL,
  `category` ENUM('spend_accumulative', 'ranking_contest', 'server_goal', 'gacha_rate_up', 'boss_spawn', 'treasure_hunt') NOT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `description` TEXT DEFAULT NULL,
  `rules` JSON DEFAULT NULL,
  `rewards` JSON DEFAULT NULL,
  `participation_requirements` JSON DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 0,
  `banner_image_path` VARCHAR(255) DEFAULT NULL,
  `ui_theme` VARCHAR(50) DEFAULT 'default',
  
  INDEX idx_dates (start_date, end_date),
  INDEX idx_type (event_type, category),
  INDEX idx_active (is_active, start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Event Player Progress
CREATE TABLE IF NOT EXISTS `event_player_progress` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `event_id` INT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `progress_value` BIGINT UNSIGNED DEFAULT 0,
  `rank` INT UNSIGNED DEFAULT NULL,
  `rewards_claimed` JSON DEFAULT NULL,
  `last_updated` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  UNIQUE KEY uk_event_player (event_id, player_id),
  INDEX idx_event (event_id),
  INDEX idx_rank (event_id, rank),
  CONSTRAINT fk_epp_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
  CONSTRAINT fk_epp_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Event Leaderboards
CREATE TABLE IF NOT EXISTS `event_leaderboards` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `event_id` INT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `score` BIGINT UNSIGNED DEFAULT 0,
  `rank` INT UNSIGNED DEFAULT NULL,
  `guild_id` BIGINT UNSIGNED DEFAULT NULL,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  UNIQUE KEY uk_event_player_lb (event_id, player_id),
  INDEX idx_event_rank (event_id, rank),
  INDEX idx_score (event_id, score DESC),
  CONSTRAINT fk_el_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
  CONSTRAINT fk_el_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- PvP & ARENA
-- ============================================

-- Arena Seasons
CREATE TABLE IF NOT EXISTS `arena_seasons` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `season_number` INT UNSIGNED NOT NULL UNIQUE,
  `name` VARCHAR(100) NOT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `min_level` INT UNSIGNED DEFAULT 20,
  `reward_pool` JSON DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 0,
  
  INDEX idx_dates (start_date, end_date),
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Arena Players
CREATE TABLE IF NOT EXISTS `arena_players` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `season_id` INT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `rating` INT UNSIGNED DEFAULT 1000,
  `wins` INT UNSIGNED DEFAULT 0,
  `losses` INT UNSIGNED DEFAULT 0,
  `daily_tickets` TINYINT UNSIGNED DEFAULT 5,
  `last_fight_time` DATETIME DEFAULT NULL,
  `rank` INT UNSIGNED DEFAULT NULL,
  `highest_rating` INT UNSIGNED DEFAULT 1000,
  `reward_tier` ENUM('bronze', 'silver', 'gold', 'platinum', 'diamond', 'master', 'grandmaster') DEFAULT 'bronze',
  
  UNIQUE KEY uk_season_player (season_id, player_id),
  INDEX idx_season_rating (season_id, rating DESC),
  INDEX idx_rank (season_id, rank),
  CONSTRAINT fk_ap_season FOREIGN KEY (season_id) REFERENCES arena_seasons(id),
  CONSTRAINT fk_ap_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Arena Fight History
CREATE TABLE IF NOT EXISTS `arena_fight_history` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `season_id` INT UNSIGNED NOT NULL,
  `attacker_id` BIGINT UNSIGNED NOT NULL,
  `defender_id` BIGINT UNSIGNED NOT NULL,
  `attacker_rating_before` INT UNSIGNED DEFAULT 0,
  `defender_rating_before` INT UNSIGNED DEFAULT 0,
  `rating_change` INT DEFAULT 0,
  `winner_id` BIGINT UNSIGNED NOT NULL,
  `fight_data` JSON DEFAULT NULL,
  `fight_duration_seconds` INT UNSIGNED DEFAULT 0,
  `fought_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_season (season_id),
  INDEX idx_attacker (attacker_id),
  INDEX idx_defender (defender_id),
  INDEX idx_date (fought_at DESC),
  CONSTRAINT fk_afh_season FOREIGN KEY (season_id) REFERENCES arena_seasons(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- INVENTORY & MAIL
-- ============================================

-- Items Master
CREATE TABLE IF NOT EXISTS `items` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `item_type` ENUM('material', 'consumable', 'fragment', 'token', 'currency', 'key', 'decoration') NOT NULL,
  `rarity` ENUM('common', 'rare', 'epic', 'legendary') DEFAULT 'common',
  `stack_size` INT UNSIGNED DEFAULT 999,
  `sell_price` INT UNSIGNED DEFAULT 0,
  `use_effect` JSON DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `icon_path` VARCHAR(255) DEFAULT NULL,
  `model_path` VARCHAR(255) DEFAULT NULL,
  `is_tradable` TINYINT(1) DEFAULT 0,
  `is_sellable` TINYINT(1) DEFAULT 1,
  `is_destroyable` TINYINT(1) DEFAULT 1,
  
  INDEX idx_type (item_type),
  INDEX idx_rarity (rarity)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Inventory
CREATE TABLE IF NOT EXISTS `player_inventory` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `item_id` INT UNSIGNED NOT NULL,
  `quantity` BIGINT UNSIGNED DEFAULT 1,
  `slot_index` INT UNSIGNED DEFAULT NULL,
  `is_locked` TINYINT(1) DEFAULT 0,
  `obtained_from` VARCHAR(50) DEFAULT NULL,
  `obtained_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `expires_at` DATETIME DEFAULT NULL,
  
  UNIQUE KEY uk_player_item (player_id, item_id),
  INDEX idx_player (player_id),
  INDEX idx_item (item_id),
  CONSTRAINT fk_pi_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_pi_item FOREIGN KEY (item_id) REFERENCES items(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Mail System
CREATE TABLE IF NOT EXISTS `mail` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `recipient_id` BIGINT UNSIGNED DEFAULT NULL,
  `sender_type` ENUM('system', 'gm', 'player', 'guild') NOT NULL,
  `sender_id` BIGINT UNSIGNED DEFAULT NULL,
  `subject` VARCHAR(200) NOT NULL,
  `content` TEXT DEFAULT NULL,
  `attachments` JSON DEFAULT NULL,
  `is_read` TINYINT(1) DEFAULT 0,
  `is_claimed` TINYINT(1) DEFAULT 0,
  `sent_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `expires_at` DATETIME DEFAULT NULL,
  `priority` TINYINT UNSIGNED DEFAULT 0,
  
  INDEX idx_recipient (recipient_id),
  INDEX idx_read (recipient_id, is_read),
  INDEX idx_expires (expires_at),
  CONSTRAINT fk_mail_recipient FOREIGN KEY (recipient_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- ACHIEVEMENTS & TITLES
-- ============================================

-- Achievements
CREATE TABLE IF NOT EXISTS `achievements` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `category` ENUM('progression', 'combat', 'collection', 'social', 'pvp', 'event', 'whale') NOT NULL,
  `requirement_type` VARCHAR(50) NOT NULL,
  `requirement_value` BIGINT UNSIGNED DEFAULT 0,
  `reward_type` ENUM('title', 'gold', 'diamonds', 'item', 'achievement_points') NOT NULL,
  `reward_id` INT UNSIGNED DEFAULT NULL,
  `reward_quantity` INT UNSIGNED DEFAULT 1,
  `achievement_points` INT UNSIGNED DEFAULT 10,
  `is_hidden` TINYINT(1) DEFAULT 0,
  `description` TEXT DEFAULT NULL,
  
  INDEX idx_category (category),
  INDEX idx_points (achievement_points DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Achievements
CREATE TABLE IF NOT EXISTS `player_achievements` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `achievement_id` INT UNSIGNED NOT NULL,
  `progress` BIGINT UNSIGNED DEFAULT 0,
  `is_completed` TINYINT(1) DEFAULT 0,
  `is_claimed` TINYINT(1) DEFAULT 0,
  `completed_at` DATETIME DEFAULT NULL,
  
  UNIQUE KEY uk_player_achievement (player_id, achievement_id),
  INDEX idx_player (player_id),
  INDEX idx_completed (player_id, is_completed),
  CONSTRAINT fk_pa_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_pa_achievement FOREIGN KEY (achievement_id) REFERENCES achievements(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Titles
CREATE TABLE IF NOT EXISTS `titles` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `rarity` ENUM('common', 'rare', 'epic', 'legendary', 'divine') NOT NULL,
  `stat bonuses` JSON DEFAULT NULL,
  `chat_color` VARCHAR(7) DEFAULT NULL,
  `icon_path` VARCHAR(255) DEFAULT NULL,
  `effect_description` TEXT DEFAULT NULL,
  `acquisition_method` VARCHAR(100) DEFAULT NULL,
  `duration_days` INT UNSIGNED DEFAULT NULL,
  `is_permanent` TINYINT(1) DEFAULT 1,
  
  INDEX idx_rarity (rarity)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Titles
CREATE TABLE IF NOT EXISTS `player_titles` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `title_id` INT UNSIGNED NOT NULL,
  `is_equipped` TINYINT(1) DEFAULT 0,
  `obtained_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `expires_at` DATETIME DEFAULT NULL,
  
  UNIQUE KEY uk_player_title (player_id, title_id),
  INDEX idx_player (player_id),
  INDEX idx_equipped (player_id, is_equipped),
  CONSTRAINT fk_pt_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_pt_title FOREIGN KEY (title_id) REFERENCES titles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- VIP SYSTEM
-- ============================================

-- VIP Levels
CREATE TABLE IF NOT EXISTS `vip_levels` (
  `vip_level` TINYINT UNSIGNED PRIMARY KEY,
  `required_exp` BIGINT UNSIGNED NOT NULL,
  `privileges` JSON NOT NULL,
  `daily_diamond_bonus` INT UNSIGNED DEFAULT 0,
  `stamina_buy_limit` INT UNSIGNED DEFAULT 0,
  `gacha_discount_percent` DECIMAL(5,2) DEFAULT 0.00,
  `exp_boost_percent` DECIMAL(5,2) DEFAULT 0.00,
  `gold_boost_percent` DECIMAL(5,2) DEFAULT 0.00,
  `skip_ticket_limit` INT UNSIGNED DEFAULT 0,
  `auto_battle_unlock` TINYINT(1) DEFAULT 0,
  `description` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- PAYMENTS & IAP
-- ============================================

-- Payment Packages
CREATE TABLE IF NOT EXISTS `payment_packages` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `package_id` VARCHAR(100) NOT NULL UNIQUE,
  `name` VARCHAR(100) NOT NULL,
  `price_usd` DECIMAL(10,2) NOT NULL,
  `diamonds` INT UNSIGNED DEFAULT 0,
  `bonus_items` JSON DEFAULT NULL,
  `first_purchase_only` TINYINT(1) DEFAULT 0,
  `daily_limit` INT UNSIGNED DEFAULT NULL,
  `weekly_limit` INT UNSIGNED DEFAULT NULL,
  `monthly_limit` INT UNSIGNED DEFAULT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `priority` INT UNSIGNED DEFAULT 0,
  `banner_image_path` VARCHAR(255) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  
  INDEX idx_active (is_active),
  INDEX idx_priority (priority DESC),
  INDEX idx_price (price_usd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player Purchases
CREATE TABLE IF NOT EXISTS `player_purchases` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `package_id` INT UNSIGNED NOT NULL,
  `transaction_id` VARCHAR(100) NOT NULL UNIQUE,
  `receipt_data` TEXT DEFAULT NULL,
  `amount_usd` DECIMAL(10,2) NOT NULL,
  `currency` VARCHAR(10) DEFAULT 'USD',
  `platform` ENUM('ios', 'android', 'web', 'pc') DEFAULT 'web',
  `status` ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
  `purchased_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `processed_at` DATETIME DEFAULT NULL,
  
  INDEX idx_player (player_id),
  INDEX idx_transaction (transaction_id),
  INDEX idx_status (status),
  INDEX idx_date (purchased_at DESC),
  CONSTRAINT fk_pp_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_pp_package FOREIGN KEY (package_id) REFERENCES payment_packages(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- COMBAT LOGS & ANALYTICS
-- ============================================

-- Combat Logs
CREATE TABLE IF NOT EXISTS `combat_logs` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED NOT NULL,
  `combat_type` ENUM('pve', 'pvp', 'arena', 'guild_boss', 'world_boss', 'dungeon') NOT NULL,
  `map_id` INT UNSIGNED DEFAULT NULL,
  `monster_id` INT UNSIGNED DEFAULT NULL,
  `opponent_player_id` BIGINT UNSIGNED DEFAULT NULL,
  `damage_dealt` BIGINT UNSIGNED DEFAULT 0,
  `damage_taken` BIGINT UNSIGNED DEFAULT 0,
  `kills` INT UNSIGNED DEFAULT 0,
  `deaths` INT UNSIGNED DEFAULT 0,
  `duration_seconds` INT UNSIGNED DEFAULT 0,
  `result` ENUM('win', 'lose', 'draw', 'timeout') DEFAULT NULL,
  `battle_data` JSON DEFAULT NULL,
  `fought_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_player (player_id),
  INDEX idx_type (combat_type),
  INDEX idx_date (fought_at DESC),
  CONSTRAINT fk_cl_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Analytics Events
CREATE TABLE IF NOT EXISTS `analytics_events` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED DEFAULT NULL,
  `event_type` VARCHAR(50) NOT NULL,
  `event_data` JSON NOT NULL,
  `session_id` VARCHAR(100) DEFAULT NULL,
  `occurred_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_player (player_id),
  INDEX idx_type (event_type),
  INDEX idx_date (occurred_at DESC),
  INDEX idx_session (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- SYSTEM CONFIGURATION
-- ============================================

-- Server Configuration
CREATE TABLE IF NOT EXISTS `server_config` (
  `config_key` VARCHAR(100) PRIMARY KEY,
  `config_value` JSON NOT NULL,
  `description` VARCHAR(255) DEFAULT NULL,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Maintenance Schedule
CREATE TABLE IF NOT EXISTS `maintenance_schedule` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `reason` TEXT DEFAULT NULL,
  `message` TEXT DEFAULT NULL,
  `is_completed` TINYINT(1) DEFAULT 0,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Rate Limiting
CREATE TABLE IF NOT EXISTS `rate_limits` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `player_id` BIGINT UNSIGNED DEFAULT NULL,
  `ip_address` VARCHAR(45) DEFAULT NULL,
  `device_id` VARCHAR(100) DEFAULT NULL,
  `action_type` VARCHAR(50) NOT NULL,
  `attempt_count` INT UNSIGNED DEFAULT 1,
  `last_attempt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `blocked_until` DATETIME DEFAULT NULL,
  
  INDEX idx_player (player_id),
  INDEX idx_ip (ip_address),
  INDEX idx_action (action_type),
  INDEX idx_blocked (blocked_until)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- End of Schema
