import os
import xml.etree.ElementTree as ET
import math

# Configuration
PLAYERS_DIR = 'worldwar/data/players/'
OUTPUT_SQL = 'database/seed/04_players_final_migration.sql'

TOP_LEVEL = 350
LEVEL_FLOOR = math.floor(TOP_LEVEL * 0.85) # 297

# Fixed Stats Table (New Balance)
STATS = {
    'Mage': { 'ml': 120, 'melee': 10, 'dist': 20, 'shield': 30 },
    'Paladin': { 'ml': 30, 'melee': 10, 'dist': 120, 'shield': 80 },
    'Knight': { 'ml': 10, 'melee': 120, 'dist': 10, 'shield': 100 }
}

def get_vocation_type(voc_id):
    if voc_id in [1, 2]: return 'Mage'
    if voc_id == 3: return 'Paladin'
    if voc_id == 4: return 'Knight'
    return None

def calculate_stats_86(lvl, voc_id):
    # Formulas for HP/Mana/Cap in 8.6 (Standard TFS 1.x / 1.8)
    # Baseline for Level 8 (After Island of Destiny / Rookgaard)
    hp = 185
    cap = 470
    
    # Mana base at level 8 varies because of level 1-8 gains (5 per lvl)
    # Knight: 5 (lvl1) + 7*5 = 40
    # Paladin: 5 (lvl1) + 7*15 = 110
    # Mage: 5 (lvl1) + 7*30 = 215
    
    lvls_beyond_8 = max(0, lvl - 8)
    
    if voc_id in [1, 2, 5, 6]: # Mages
        mana = 215
        hp += lvls_beyond_8 * 5
        mana += lvls_beyond_8 * 30
        cap += lvls_beyond_8 * 10
    elif voc_id in [3, 7]: # Paladin
        mana = 110
        hp += lvls_beyond_8 * 10
        mana += lvls_beyond_8 * 15
        cap += lvls_beyond_8 * 20
    elif voc_id in [4, 8]: # Knight
        mana = 40
        hp += lvls_beyond_8 * 15
        mana += lvls_beyond_8 * 5
        cap += lvls_beyond_8 * 25
    else:
        mana = 40
        
    return hp, mana, cap

def run_migration():
    sql_lines = [
        "-- Final Migration & Normalization Seed (7.6 -> 8.6)",
        "DELETE FROM `players` WHERE `id` >= 100;",
        "DELETE FROM `guild_membership` WHERE `player_id` >= 100;"
    ]
    
    guild_membership_lines = []
    
    # Names already seeded as leaders in setup_aethrium_war.sql
    LEADERS = {
        'Bubble': 1, 'Undead Slayer': 2, 'Irie D': 3, 
        'Eternal Oblivion': 4, 'Cachero': 5, 'Seromontis': 6, 'Mateusz Dragon Wielki': 7
    }
    EXCLUDED_NAMES = set(LEADERS.keys()) | {'Account Manager'}
    
    # 1. First Pass: Find Top 4 players per account (Famous)
    account_players = {} # acc_id -> list of (original_lvl, name)
    
    for f_name in os.listdir(PLAYERS_DIR):
        if not f_name.endswith('.xml'): continue
        try:
            tree = ET.parse(os.path.join(PLAYERS_DIR, f_name))
            root = tree.getroot()
            name = root.get('name')
            acc_id = int(root.get('account', 1))
            lvl = int(root.get('level', 1))
            if name and name not in EXCLUDED_NAMES and acc_id <= 7:
                if acc_id not in account_players: account_players[acc_id] = []
                account_players[acc_id].append((lvl, name))
        except: continue

    famous_players = set()
    for acc_id, players in account_players.items():
        # Sort by level descending and take top 4
        players.sort(key=lambda x: x[0], reverse=True)
        for p in players[:4]:
            famous_players.add(p[1])

    # 2. Migration Pass
    processed_names = set()
    pid = 100 # Starting ID for migrated players
    count = 0
    
    for f_name in os.listdir(PLAYERS_DIR):
        if not f_name.endswith('.xml'):
            continue
            
        try:
            tree = ET.parse(os.path.join(PLAYERS_DIR, f_name))
            root = tree.getroot()
            
            name = root.get('name')
            if not name or name in EXCLUDED_NAMES or name in processed_names or 'God' in name:
                continue
            
            processed_names.add(name)
            
            acc_id = int(root.get('account', 1))
            if acc_id > 7: continue # Only migrate 7 accounts/teams
            
            voc_id = int(root.get('voc', 1))
            lvl = int(root.get('level', 1))
            sex = int(root.get('sex', 0))
            
            # 1. Level Assignment
            # Famous players (and leaders, though they are in EXCLUDED_NAMES) get 300.
            # Others get 260.
            if name in famous_players:
                lvl = 300
            else:
                lvl = 260
            
            # Recalculate Experience for 8.6 (Precise Formula)
            exp = math.floor((50/3) * (lvl**3 - 6*(lvl**2) + 17*lvl - 12))
            
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
        
        f.write('\n\n-- Patch for Official Leaders (Level 300 + Stats)\n')
        for l_name, acc_id in LEADERS.items():
            # Find vocation for leader by reading their xml (quick hack)
            voc_id = 1
            try:
                tree = ET.parse(os.path.join(PLAYERS_DIR, f"{l_name}.xml"))
                voc_id = int(tree.getroot().get('voc', 1))
            except: pass
            
            hp, mana, cap = calculate_stats_86(300, voc_id)
            exp = math.floor((50/3) * (300**3 - 6*(300**2) + 17*300 - 12))
            voc_type = get_vocation_type(voc_id)
            v_stats = STATS[voc_type]
            
            f.write(f"UPDATE `players` SET `level` = 300, `experience` = {exp}, `health` = {hp}, `healthmax` = {hp}, `mana` = {mana}, `manamax` = {mana}, `cap` = {cap}, ")
            f.write(f"`maglevel` = {v_stats['ml']}, `skill_fist` = 10, `skill_club` = {v_stats['melee']}, `skill_sword` = {v_stats['melee']}, `skill_axe` = {v_stats['melee']}, `skill_dist` = {v_stats['dist']}, `skill_shielding` = {v_stats['shield']}, `skill_fishing` = 10 ")
            f.write(f"WHERE `name` = '{l_name}';\n")
        
    print(f"Migration complete! {count} players migrated.")
    print(f"File saved to: {OUTPUT_SQL}")

if __name__ == "__main__":
    run_migration()
