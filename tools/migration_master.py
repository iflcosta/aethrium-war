import os
import xml.etree.ElementTree as ET
import math

# Configuration
PLAYERS_DIR = 'worldwar/data/players/'
OUTPUT_SQL = 'database/seed/04_players_final_migration.sql'

TOP_LEVEL = 350
LEVEL_FLOOR = math.floor(TOP_LEVEL * 0.85) # 297

# Fixed Stats Table
STATS = {
    'Mage': { 'ml': 100, 'melee': 10, 'dist': 20, 'shield': 30 },
    'Paladin': { 'ml': 30, 'melee': 10, 'dist': 100, 'shield': 80 },
    'Knight': { 'ml': 8, 'melee': 100, 'dist': 10, 'shield': 100 }
}

def get_vocation_type(voc_id):
    if voc_id in [1, 2]: return 'Mage'
    if voc_id == 3: return 'Paladin'
    if voc_id == 4: return 'Knight'
    return None

def calculate_stats_86(lvl, voc_id):
    # Formulas for HP/Mana/Cap in 8.6
    # Base at level 8
    hp = 185
    mana = 90
    cap = 470
    
    levels_beyond_8 = max(0, lvl - 8)
    
    if voc_id in [1, 2]: # Mages
        hp += levels_beyond_8 * 5
        mana += levels_beyond_8 * 30
        cap += levels_beyond_8 * 10
    elif voc_id == 3: # Paladin
        hp += levels_beyond_8 * 10
        mana += levels_beyond_8 * 15
        cap += levels_beyond_8 * 20
    elif voc_id == 4: # Knight
        hp += levels_beyond_8 * 15
        mana += levels_beyond_8 * 5
        cap += levels_beyond_8 * 25
        
    return hp, mana, cap

def run_migration():
    sql_lines = [
        "-- Final Migration & Normalization Seed (7.6 -> 8.6)",
        "DELETE FROM `players`;",
        "DELETE FROM `guild_membership`;"
    ]
    
    guild_membership_lines = []
    
    pid = 100 # Starting ID to avoid conflicts
    count = 0
    
    for f_name in os.listdir(PLAYERS_DIR):
        if not f_name.endswith('.xml'):
            continue
            
        try:
            tree = ET.parse(os.path.join(PLAYERS_DIR, f_name))
            root = tree.getroot()
            
            name = root.get('name')
            if not name or 'God' in name or 'Account Manager' in name:
                continue
            
            acc_id = int(root.get('account', 1))
            if acc_id > 7: continue # Only migrate 7 accounts/teams
            
            voc_id = int(root.get('voc', 1))
            lvl = int(root.get('level', 1))
            sex = int(root.get('sex', 0))
            
            # 1. Level Normalization (15% Gap)
            if lvl < LEVEL_FLOOR:
                lvl = LEVEL_FLOOR
            
            # Simple 8.6 XP formula for level
            exp = math.floor((50 * (lvl**3) - 150 * (lvl**2) + 400 * lvl) / 3)
            
            # 2. Vocation Mapping & Standard Stats
            voc_type = get_vocation_type(voc_id)
            if not voc_type: continue
            
            v_stats = STATS[voc_type]
            ml = v_stats['ml']
            melee = v_stats['melee']
            dist = v_stats['dist']
            shield = v_stats['shield']
            
            # 3. Recalculate HP/Mana/Cap (8.6 rules)
            hp_val, mana_val, cap_val = calculate_stats_86(lvl, voc_id)
            
            # 4. Look
            look = root.find('look')
            look_type = look.get('type', 128) if look is not None else 128
            look_head = look.get('head', 0) if look is not None else 0
            look_body = look.get('body', 0) if look is not None else 0
            look_legs = look.get('legs', 0) if look is not None else 0
            look_feet = look.get('feet', 0) if look is not None else 0
            
            # Escape name for SQL
            safe_name = name.replace("'", "''")
            
            # Generate one INSERT per player for SQLite stability
            sql_lines.append(
                f"INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `maglevel`, `mana`, `manamax`, `town_id`, `posx`, `posy`, `posz`, `cap`, `sex`, `skill_fist`, `skill_club`, `skill_sword`, `skill_axe`, `skill_dist`, `skill_shielding`, `skill_fishing`) VALUES "
                f"({pid}, '{safe_name}', 1, {acc_id}, {lvl}, {voc_id}, {hp_val}, {hp_val}, {exp}, "
                f"{look_body}, {look_feet}, {look_head}, {look_legs}, {look_type}, "
                f"{ml}, {mana_val}, {mana_val}, 1, 1000, 1000, 7, {cap_val}, {sex}, "
                f"10, {melee}, {melee}, {melee}, {dist}, {shield}, 10);"
            )
            
            # 5. Guild Membership (Each acc is a guild)
            guild_membership_lines.append(f"INSERT INTO `guild_membership` (`player_id`, `guild_id`, `rank_id`) VALUES ({pid}, {acc_id}, 3);")
            
            pid += 1
            count += 1
            
        except Exception as e:
            print(f"Error processing {f_name}: {e}")

    with open(OUTPUT_SQL, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_lines))
        f.write('\n\n-- Guild Memberships\n')
        f.write('\n'.join(guild_membership_lines))
        
    print(f"Migration complete! {count} players migrated.")
    print(f"File saved to: {OUTPUT_SQL}")

if __name__ == "__main__":
    run_migration()
