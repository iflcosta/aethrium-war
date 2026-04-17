import os
import re

VOC_MAP = {1: "Sorcerer", 2: "Druid", 3: "Paladin", 4: "Knight"}
ACCOUNT_MAP = {1:"Antica",2:"Nova",3:"Secura",4:"Amera",5:"Calmera",6:"Hiberna",7:"Harmonia"}

players_dir = r"c:\aethrium-war\worldwar\data\players"
results = []

for fname in os.listdir(players_dir):
    if not fname.endswith(".xml"):
        continue
    path = os.path.join(players_dir, fname)
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    
    level_match = re.search(r'level="(\d+)"', content)
    voc_match   = re.search(r'voc="(\d+)"', content)
    acc_match   = re.search(r'account="(\d+)"', content)
    
    if level_match and voc_match and acc_match:
        level = int(level_match.group(1))
        voc   = int(voc_match.group(1))
        acc   = int(acc_match.group(1))
        name  = fname.replace(".xml", "")
        team  = ACCOUNT_MAP.get(acc, f"Conta {acc}")
        voc_name = VOC_MAP.get(voc, f"Voc{voc}")
        results.append((level, name, voc_name, team, acc))

results.sort(key=lambda x: (-x[0], x[4]))

print(f"{'Nome':<35} {'Level':>5} {'Voc':<12} {'Time':<15} {'Conta':>5}")
print("-" * 80)
for level, name, voc_name, team, acc in results:
    print(f"{name:<35} {level:>5} {voc_name:<12} {team:<15} {acc:>5}")

print(f"\nTotal: {len(results)} personagens")

# Stats
from collections import Counter
team_count  = Counter(r[3] for r in results)
voc_count   = Counter(r[2] for r in results)
levels = [r[0] for r in results]
print(f"\nPor time: {dict(team_count)}")
print(f"Por vocação: {dict(voc_count)}")
print(f"Nível min: {min(levels)}, max: {max(levels)}, média: {sum(levels)/len(levels):.0f}")
