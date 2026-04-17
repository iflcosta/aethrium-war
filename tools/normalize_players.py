import re
import math
import os

# --- Configuration ---
INPUT_FILE = r'database/seed/04_players_all.sql'
OUTPUT_FILE = r'database/seed/04_players_normalized.sql'

# Stat Gains per Vocation (including promotions)
# Format: {vocation_id: (gain_hp, gain_mana, gain_cap)}
VOCATION_GAINS = {
    0: (5, 5, 10),    # None
    1: (5, 30, 10),   # Sorcerer
    2: (5, 30, 10),   # Druid
    3: (10, 15, 20),  # Paladin
    4: (15, 5, 25),   # Knight
    5: (5, 30, 10),   # Master Sorcerer
    6: (5, 30, 10),   # Elder Druid
    7: (10, 15, 20),  # Royal Paladin
    8: (15, 5, 25),   # Elite Knight
}

# Standard TFS 1.x / Tibia 8.6 Base Stats (at level 8)
BASE_LVL = 8
BASE_HP = 185
BASE_MANA = 40
BASE_CAP = 470

def get_exp_by_level(level):
    if level <= 1: return 0
    return int((50 / 3) * (level**3 - 6 * level**2 + 17 * level - 12))

def get_level_by_exp(exp):
    if exp <= 0: return 1
    # Binary search for level because the formula is cubic
    low, high = 1, 1000
    while low <= high:
        mid = (low + high) // 2
        if get_exp_by_level(mid) <= exp:
            low = mid + 1
        else:
            high = mid - 1
    return high

def calculate_stats(vocation_id, level):
    gains = VOCATION_GAINS.get(vocation_id, (5, 5, 10))
    lvl_diff = max(0, level - BASE_LVL)
    
    hp = BASE_HP + (lvl_diff * gains[0])
    mana = BASE_MANA + (lvl_diff * gains[1])
    cap = BASE_CAP + (lvl_diff * gains[2])
    
    return int(hp), int(mana), int(cap)

def normalize():
    if not os.path.exists(INPUT_FILE):
        print(f"Error: {INPUT_FILE} not found.")
        return

    with open(INPUT_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex to capture individual player rows in the SQL INSERT
    # Format: (id, 'name', group, account, level, vocation, hp, hpmax, experience, ... )
    # Note: We need to capture level (idx 4), vocation (idx 5), hp (idx 6), hpmax (idx 7), exp (idx 8)
    # The pattern matches the start of the row data
    pattern = re.compile(r"\((\d+), '([^']+)', (\d+), (\d+), (\d+), (\d+), (\d+), (\d+), (\d+),")
    
    matches = pattern.findall(content)
    if not matches:
        print("No players found in seed file.")
        return

    # 1. Find the Global Top Level
    player_data = []
    top_level = 0
    # We ignore levels over 1000 or characters with "God"/"Admin" in name
    for m in matches:
        pid, name, group, acc, lvl, voc, hp, hpmax, exp = m
        lvl_val = int(lvl)
        name_lower = name.lower()
        
        is_staff = "god" in name_lower or "admin" in name_lower or lvl_val > 1000
        
        if not is_staff and lvl_val > top_level:
            top_level = lvl_val
        
        player_data.append({
            'id': pid,
            'name': name,
            'lvl': lvl_val,
            'voc': int(voc),
            'exp': int(exp)
        })

    if top_level == 0:
        top_level = 300 # Fallback

    print(f"Max Level Found: {top_level}")
    min_threshold_lvl = math.floor(top_level * 0.7)
    print(f"Normalization Threshold (70%): Level {min_threshold_lvl}")

    # 2. Process and Replace
    new_content = content
    processed_count = 0
    adjusted_count = 0

    # We iterate through the matches to perform string replacements safely
    for m in matches:
        pid, name, group, acc, lvl, voc, hp, hpmax, exp = m
        voc_id = int(voc)
        old_lvl = int(lvl)
        
        # Rule: If below threshold, adjust to 70% of top.
        # Otherwise keep original.
        if old_lvl < min_threshold_lvl:
            target_lvl = min_threshold_lvl
            adjusted_count += 1
        else:
            target_lvl = old_lvl
        
        new_exp = get_exp_by_level(target_lvl)
        new_hp, new_mana, new_cap = calculate_stats(voc_id, target_lvl)

        # We construct the original raw string piece to replace it
        # (id, 'name', group, account, level, vocation, hp, hpmax, experience,
        old_row_start = f"({pid}, '{name}', {group}, {acc}, {lvl}, {voc}, {hp}, {hpmax}, {exp},"
        
        # New values for the columns involved in normalization
        # We also need to update Mana and Cap which come later in the row
        # Row structure: 
        # (id, name, group_id, account_id, level, vocation, health, healthmax, experience, 
        #  lookbody, lookfeet, lookhead, looklegs, looktype, lookaddons, lookmount, currentmount, 
        #  randomizemount, direction, maglevel, mana, manamax, ...
        #
        # Instead of partial string replacement which is risky, let's rebuild the whole row if possible
        # but the content has other fields. 
        # Actually, let's use a regex replace on each individual match to find the full row.
        
        # Find the full line for this player
        # A more robust way: find the block starting with (pid, 'name' and ending with )
        row_pattern = f"\\({pid}, '{re.escape(name)}', {group}, {acc}.*?\\)"
        full_row_match = re.search(row_pattern, new_content)
        
        if full_row_match:
            row_str = full_row_match.group(0)
            parts = [p.strip() for p in row_str[1:-1].split(',')]
            
            # parts[4] = level
            # parts[6] = health
            # parts[7] = healthmax
            # parts[8] = experience
            # parts[19] = maglevel
            # parts[20] = mana
            # parts[21] = manamax
            # parts[28] = cap (calculated usually, let's find it)
            
            parts[4] = str(target_lvl)
            parts[6] = str(new_hp)
            parts[7] = str(new_hp)
            parts[8] = str(new_exp)
            parts[20] = str(new_mana)
            parts[21] = str(new_mana)
            parts[28] = str(new_cap)
            
            new_row_str = "(" + ", ".join(parts) + ")"
            new_content = new_content.replace(row_str, new_row_str)
            processed_count += 1

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write(new_content)

    print(f"Processed: {processed_count} players.")
    print(f"Adjusted: {adjusted_count} players (bumped up to threshold).")
    print(f"Normalization complete. Output saved to: {OUTPUT_FILE}")

if __name__ == "__main__":
    normalize()
