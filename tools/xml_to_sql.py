#!/usr/bin/env python3
"""
Aethrium War — Phase 3: XML → SQL Migration Tool
Converts all 235 player XML files from the 7.6 YurOTS server into a TFS 1.8-compatible SQL seed file.
"""
import os
import re
import xml.etree.ElementTree as ET

# ─────────────────────────── Configuration ────────────────────────────────
ACCOUNTS_DIR = "../worldwar/data/accounts"
PLAYERS_DIR  = "../worldwar/data/players"
OUTPUT_FILE  = "../database/seed/04_players_all.sql"

# 7.6 account number → TFS 1.8 account id (from seed 01_accounts.sql)
ACCOUNT_MAP = {1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7}

# Leader player_ids already inserted in seed 02 — skip them
LEADERS_ALREADY_INSERTED = {
    "Bubble", "Undead Slayer", "Irie D", "Eternal Oblivion",
    "Cachero", "Seromontis", "Mateusz Dragon Wielki"
}

# 7.6 skill IDs → TFS 1.8 column names
SKILL_COLUMNS = {
    0: "skill_fist",
    1: "skill_club",
    2: "skill_sword",
    3: "skill_axe",
    4: "skill_dist",
    5: "skill_shielding",
    6: "skill_fishing",
}

# Template/admin files to skip
SKIP_PATTERNS = re.compile(
    r"^(Knight|Paladin|Sorcerer|Druid)\d*\.xml$"
    r"|^(Kopie von .+)\.xml$"
    r"|^zu\.xml$",
    re.IGNORECASE
)

# Default spawn position (Thais arena)
DEFAULT_X, DEFAULT_Y, DEFAULT_Z = 1024, 633, 7
# ─────────────────────────────────────────────────────────────────────────


def build_account_index():
    """Build dict: player_name -> account_number (1-7)"""
    index = {}
    for accno in range(1, 8):
        path = os.path.join(ACCOUNTS_DIR, f"{accno}.xml")
        if not os.path.exists(path):
            continue
        try:
            tree = ET.parse(path)
            for char in tree.getroot().findall("characters/character"):
                name = char.get("name", "").strip()
                if name:
                    index[name] = accno
        except ET.ParseError as e:
            print(f"  [WARN] Could not parse {path}: {e}")
    return index


def parse_player(filepath):
    """Parse a single player XML and return a dict of fields."""
    with open(filepath, "r", encoding="latin-1") as f:
        raw = f.read().strip()

    # Some files have leading whitespace / BOM — strip and normalise
    if not raw.startswith("<?xml") and "<player" in raw:
        raw = '<?xml version="1.0"?>' + raw[raw.index("<player"):]

    try:
        root = ET.fromstring(raw)
    except ET.ParseError:
        # Try to find the <player ...> element directly
        m = re.search(r"<player\b.*?</player>", raw, re.DOTALL)
        if not m:
            return None
        root = ET.fromstring(m.group(0))

    # If root is not <player>, try to find it inside
    if root.tag != "player":
        player_el = root.find(".//player")
        if player_el is None:
            return None
        root = player_el

    p = {}
    p["name"]      = root.get("name", "").strip()
    p["vocation"]  = int(root.get("voc", 0))
    p["level"]     = int(root.get("level", 1))
    p["experience"]= int(root.get("exp", 0))
    p["maglevel"]  = int(root.get("maglevel", 0))
    p["cap"]       = int(root.get("cap", 400))
    p["sex"]       = int(root.get("sex", 0))

    health_el = root.find("health")
    p["health"]    = int(health_el.get("now", 150)) if health_el is not None else 150
    p["healthmax"] = int(health_el.get("max", 150)) if health_el is not None else 150

    mana_el = root.find("mana")
    p["mana"]      = int(mana_el.get("now", 0)) if mana_el is not None else 0
    p["manamax"]   = int(mana_el.get("max", 0)) if mana_el is not None else 0

    look_el = root.find("look")
    p["looktype"]  = int(look_el.get("type", 136)) if look_el is not None else 136
    p["lookhead"]  = int(look_el.get("head", 0))   if look_el is not None else 0
    p["lookbody"]  = int(look_el.get("body", 0))   if look_el is not None else 0
    p["looklegs"]  = int(look_el.get("legs", 0))   if look_el is not None else 0
    p["lookfeet"]  = int(look_el.get("feet", 0))   if look_el is not None else 0

    spawn_el = root.find("spawn")
    p["posx"] = int(spawn_el.get("x", DEFAULT_X)) if spawn_el is not None else DEFAULT_X
    p["posy"] = int(spawn_el.get("y", DEFAULT_Y)) if spawn_el is not None else DEFAULT_Y
    p["posz"] = int(spawn_el.get("z", DEFAULT_Z)) if spawn_el is not None else DEFAULT_Z

    # Skills
    skills = {0: 10, 1: 10, 2: 10, 3: 10, 4: 10, 5: 10, 6: 10}
    for sk in root.findall(".//skill"):
        sid = int(sk.get("skillid", -1))
        if sid in skills:
            skills[sid] = int(sk.get("level", 10))
    p["skills"] = skills

    return p


def escape(s):
    return s.replace("'", "''")


def main():
    print("=== Aethrium War — Phase 3 Character Migration ===\n")

    account_index = build_account_index()
    print(f"  Account index loaded: {len(account_index)} players mapped\n")

    player_files = sorted(os.listdir(PLAYERS_DIR))
    rows = []
    skipped = []
    player_id_counter = 9  # Leaders occupied ids 2-8; Account Manager = 1

    for filename in player_files:
        if not filename.endswith(".xml"):
            continue
        if SKIP_PATTERNS.match(filename):
            skipped.append(filename)
            continue

        player_name = filename[:-4]  # strip .xml
        if player_name in LEADERS_ALREADY_INSERTED:
            print(f"  [SKIP] {player_name} — already in leaders seed")
            continue

        filepath = os.path.join(PLAYERS_DIR, filename)
        p = parse_player(filepath)

        if p is None:
            print(f"  [ERR]  Could not parse {filename}")
            skipped.append(filename)
            continue

        if not p["name"]:
            skipped.append(filename)
            continue

        # Resolve account_id
        acc_no = account_index.get(p["name"])
        if acc_no is None:
            # Try case-insensitive match
            for k, v in account_index.items():
                if k.lower() == p["name"].lower():
                    acc_no = v
                    break
        if acc_no is None:
            print(f"  [WARN] {p['name']} — not found in any account; defaulting to account 1")
            acc_no = 1

        account_id = ACCOUNT_MAP[acc_no]
        sk = p["skills"]

        row = (
            f"({player_id_counter}, '{escape(p['name'])}', 1, {account_id}, "
            f"{p['level']}, {p['vocation']}, "
            f"{p['health']}, {p['healthmax']}, "
            f"{p['experience']}, "
            f"{p['lookbody']}, {p['lookfeet']}, {p['lookhead']}, {p['looklegs']}, "
            f"{p['looktype']}, 0, "
            f"0, 0, 2, "
            f"{p['maglevel']}, {p['mana']}, {p['manamax']}, 0, 100, "
            f"1, {p['posx']}, {p['posy']}, {p['posz']}, "
            f"NULL, {p['cap']}, {p['sex']}, "
            f"0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, "
            f"{sk[0]}, 0, {sk[1]}, 0, {sk[2]}, 0, {sk[3]}, 0, "
            f"{sk[4]}, 0, {sk[5]}, 0, {sk[6]}, 0)"
        )
        rows.append(row)
        player_id_counter += 1

    print(f"\n  {len(rows)} players serialized. {len(skipped)} files skipped.\n")

    # ── Write output ──────────────────────────────────────────────────────
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        f.write("-- Phase 3: Full Character Migration (228+ players)\n")
        f.write("-- Generated by tools/xml_to_sql.py\n\n")
        f.write(
            "INSERT INTO `players` ("
            "`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, "
            "`health`, `healthmax`, `experience`, "
            "`lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, "
            "`currentmount`, `randomizemount`, `direction`, "
            "`maglevel`, `mana`, `manamax`, `manaspent`, `soul`, "
            "`town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, "
            "`lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `lastlogout`, "
            "`blessings`, `onlinetime`, `deletion`, `balance`, "
            "`offlinetraining_time`, `offlinetraining_skill`, `stamina`, "
            "`skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, "
            "`skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, "
            "`skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, "
            "`skill_fishing`, `skill_fishing_tries`"
            ") VALUES\n"
        )
        f.write(",\n".join(rows))
        f.write("\nON DUPLICATE KEY UPDATE `level` = VALUES(`level`);\n")

    print(f"  Output written to: {OUTPUT_FILE}")
    print("\n=== Migration Complete ===")


if __name__ == "__main__":
    main()
