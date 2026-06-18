#!/usr/bin/env python3
"""
SL-OMEGA Asset Generator
Tao cau hinh assets cho Unity client dua tren design docs
"""

import json
import os
from datetime import datetime

class AssetGenerator:
    def __init__(self):
        self.output_dir = "/workspace/assets/generated"
        os.makedirs(self.output_dir, exist_ok=True)
        
    def generate_all(self):
        print("Generating SL-OMEGA assets...")
        self.generate_character_configs()
        self.generate_martial_soul_configs()
        self.generate_map_configs()
        self.generate_equipment_configs()
        self.generate_skill_effects()
        self.generate_ui_configs()
        self.generate_audio_configs()
        print(f"Generated all assets in {self.output_dir}")
    
    def generate_character_configs(self):
        characters = {"version": "1.0", "generated_at": datetime.now().isoformat(), "characters": []}
        classes = [
            {"id": "warrior", "name": "Chien Binh", "role": "Tank/DPS", "weapon": "Sword/Shield", "stats": {"str": 90, "agi": 60, "int": 40}, "height_male": 1.85, "height_female": 1.75, "tris_count": 10000, "texture_size": 2048},
            {"id": "mage", "name": "Phap Su", "role": "Ranged DPS", "weapon": "Staff", "stats": {"str": 40, "agi": 50, "int": 95}, "height_male": 1.80, "height_female": 1.70, "tris_count": 12000, "texture_size": 2048, "effects": ["robe_physics", "floating_staff"]},
            {"id": "archer", "name": "Xa Thu", "role": "Physical DPS", "weapon": "Bow", "stats": {"str": 50, "agi": 95, "int": 45}, "height_male": 1.82, "height_female": 1.72, "tris_count": 9000, "texture_size": 2048, "effects": ["bow_string_physics", "long_hair_wind"]},
            {"id": "assassin", "name": "Sat Thu", "role": "Burst DPS", "weapon": "Dual Daggers", "stats": {"str": 70, "agi": 90, "int": 35}, "height_male": 1.78, "height_female": 1.68, "tris_count": 8500, "texture_size": 2048, "effects": ["shadow_trail", "dagger_spin"]}
        ]
        for cls in classes:
            for gender in ["male", "female"]:
                char = {
                    "id": f"{cls['id']}_{gender}", "class_id": cls["id"],
                    "name": f"{cls['name']} ({'Nam' if gender == 'male' else 'Nu'})",
                    "gender": gender, "height": cls[f"height_{gender}"], "role": cls["role"], "weapon": cls["weapon"], "base_stats": cls["stats"],
                    "model": {"mesh": f"Characters/{cls['id']}/{gender}/mesh.fbx", "tris_count": cls["tris_count"], "textures": [f"Characters/{cls['id']}/{gender}/diffuse.png", f"Characters/{cls['id']}/{gender}/normal.png", f"Characters/{cls['id']}/{gender}/metallic.png"], "texture_size": cls["texture_size"]},
                    "animations": {"idle": f"Animations/{cls['id']}/idle.anim", "run": f"Animations/{cls['id']}/run.anim", "attack": f"Animations/{cls['id']}/attack.anim", "skill_1": f"Animations/{cls['id']}/skill1.anim", "skill_2": f"Animations/{cls['id']}/skill2.anim", "ultimate": f"Animations/{cls['id']}/ultimate.anim", "death": f"Animations/{cls['id']}/death.anim"},
                    "vfx": cls.get("effects", [])
                }
                characters["characters"].append(char)
        self._save_json("characters.json", characters)
    
    def generate_martial_soul_configs(self):
        souls = {"version": "1.0", "martial_souls": [
            {"id": "iron_sword", "name": "Thiet Kiem", "rarity": "common", "type": "weapon", "tris": 3000, "effects": ["basic_glow"]},
            {"id": "white_tiger", "name": "Bach Ho", "rarity": "epic", "type": "beast", "tris": 15000, "effects": ["fur_shader", "lightning_aura"]},
            {"id": "clear_sky_hammer", "name": "Thanh Thien Chuy", "rarity": "legendary", "type": "weapon", "tris": 8000, "effects": ["shockwave", "cloud_trail"]},
            {"id": "phoenix", "name": "Phuong Hoang", "rarity": "legendary", "type": "beast", "tris": 20000, "effects": ["fire_feathers", "rebirth_flame"]},
            {"id": "seraphim", "name": "Thien Su", "rarity": "divine", "type": "entity", "tris": 35000, "effects": ["six_wings", "holy_light", "feather_storm"]},
            {"id": "dragon_god", "name": "Long Than", "rarity": "divine", "type": "beast", "tris": 50000, "length": 5.0, "effects": ["dragon_breath", "scale_shimmer", "time_distortion"]}
        ]}
        self._save_json("martial_souls.json", souls)
    
    def generate_map_configs(self):
        maps = {"version": "1.0", "maps": [
            {"id": "novice_village", "name": "Tan Thu Thon", "type": "city", "size": "200x200m", "style": "ancient_chinese", "lighting": "day", "prefabs": ["houses", "npcs", "training_dummies"], "music": "bgm_city_peaceful"},
            {"id": "spirit_forest", "name": "Tam Linh Rung", "type": "wilderness", "size": "500x500m", "style": "magical_forest", "lighting": "dappled", "prefabs": ["trees", "spirit_particles", "monsters_lv5_15"], "music": "bgm_wilderness_mysterious"},
            {"id": "iron_mine", "name": "Thiet Khoang Dong", "type": "dungeon", "size": "300x200m", "style": "cave", "lighting": "torch_lit", "prefabs": ["cave_walls", "ore_nodes", "monsters_lv10_20"], "music": "bgm_dungeon_tense", "floors": 3},
            {"id": "flame_volcano", "name": "Hoa Diem Son", "type": "elite_zone", "size": "400x400m", "style": "volcanic", "lighting": "lava_glow", "prefabs": ["lava_pools", "heat_haze", "monsters_lv30_40"], "music": "bgm_boss_intense", "environmental_damage": "fire"},
            {"id": "arena_champions", "name": "Dau Truong Champions", "type": "pvp", "size": "40x40m", "style": "colosseum", "lighting": "spotlight", "prefabs": ["barriers", "crowd_sounds"], "music": "bgm_combat_epic", "symmetrical": True},
            {"id": "frozen_peaks", "name": "Bang Phong Dinh", "type": "elite_zone", "size": "450x450m", "style": "snow_mountain", "lighting": "cold_blue", "prefabs": ["ice_crystals", "snow_drifts"], "music": "bgm_wilderness_cold", "environmental_damage": "ice"}
        ]}
        self._save_json("maps.json", maps)
    
    def generate_equipment_configs(self):
        equipment = {"version": "1.0", "tiers": {
            "white": {"color": "#FFFFFF", "min_level": 1, "max_stats": 1},
            "green": {"color": "#00FF00", "min_level": 10, "max_stats": 2},
            "blue": {"color": "#0080FF", "min_level": 20, "max_stats": 3},
            "purple": {"color": "#8000FF", "min_level": 40, "max_stats": 4},
            "orange": {"color": "#FF8000", "min_level": 60, "max_stats": 5},
            "red": {"color": "#FF0000", "min_level": 80, "max_stats": 6}
        }, "slots": ["head", "chest", "legs", "boots", "gloves", "weapon", "ring1", "ring2"], "substats": ["attack_percent", "defense_percent", "hp_percent", "crit_rate", "crit_damage", "speed"]}
        self._save_json("equipment.json", equipment)
    
    def generate_skill_effects(self):
        effects = {"version": "1.0", "damage_numbers": {
            "white": {"color": "#FFFFFF", "type": "normal"}, "green": {"color": "#00FF00", "type": "heal"},
            "orange": {"color": "#FF8000", "type": "crit"}, "red": {"color": "#FF0000", "type": "massive_crit"}, "purple": {"color": "#8000FF", "type": "true_damage"}
        }, "element_impacts": {
            "physical": {"prefab": "VFX/Impacts/physical_hit.prefab", "sound": "sfx_metal_clang"},
            "fire": {"prefab": "VFX/Impacts/fire_explosion.prefab", "sound": "sfx_fire_burst"},
            "ice": {"prefab": "VFX/Impacts/ice_shatter.prefab", "sound": "sfx_ice_crack"},
            "lightning": {"prefab": "VFX/Impacts/lightning_strike.prefab", "sound": "sfx_thunder"}
        }}
        self._save_json("skill_effects.json", effects)
    
    def generate_ui_configs(self):
        ui = {"version": "1.0", "rarity_colors": {
            "common": "#FFFFFF", "rare": "#00FF00", "epic": "#0080FF", "legendary": "#8000FF", "divine": "#FFD700", "red": "#FF0000"
        }, "main_hud": {
            "top_bar": ["level", "exp_bar", "gold", "diamonds", "energy"],
            "bottom_bar": ["skills", "chat", "menu", "friends", "guild"]
        }}
        self._save_json("ui_config.json", ui)
    
    def generate_audio_configs(self):
        audio = {"version": "1.0", "bgm": {
            "login": {"file": "Audio/Music/login_theme.mp3", "volume": 0.8, "loop": True},
            "city": {"file": "Audio/Music/city_peaceful.mp3", "volume": 0.6, "loop": True},
            "combat": {"file": "Audio/Music/combat_battle.mp3", "volume": 0.8, "loop": True},
            "boss": {"file": "Audio/Music/boss_epic.mp3", "volume": 0.9, "loop": True}
        }, "sfx_combat": {
            "sword_hit": "Audio/SFX/sword_hit.wav", "metal_clang": "Audio/SFX/metal_clang.wav",
            "crit_shatter": "Audio/SFX/crit_shatter.wav", "skill_cast": "Audio/SFX/skill_cast.wav"
        }}
        self._save_json("audio_config.json", audio)
    
    def _save_json(self, filename, data):
        filepath = os.path.join(self.output_dir, filename)
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"  OK: {filename}")

if __name__ == "__main__":
    generator = AssetGenerator()
    generator.generate_all()
