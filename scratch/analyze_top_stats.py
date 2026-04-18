import os
import xml.etree.ElementTree as ET
import math

def analyze_76_players(players_dir):
    stats = {
        'knight': {'lvl': [], 'melee': [], 'shield': []},
        'paladin': {'lvl': [], 'dist': [], 'shield': []},
        'mage': {'lvl': [], 'ml': [], 'shield': []}
    }
    
    for f_name in os.listdir(players_dir):
        if not f_name.endswith('.xml'):
            continue
        
        try:
            tree = ET.parse(os.path.join(players_dir, f_name))
            root = tree.getroot()
            
            name = root.get('name')
            if not name or 'God' in name or 'Account Manager' in name:
                continue
                
            voc = int(root.get('voc', 0))
            lvl = int(root.get('level', 1))
            ml = int(root.get('maglevel', 0))
            
            # Map Vocation Groups
            group = None
            if voc in [1, 2]: group = 'mage'
            elif voc == 3: group = 'paladin'
            elif voc == 4: group = 'knight'
            
            if not group: continue
            
            stats[group]['lvl'].append(lvl)
            
            if group == 'mage':
                stats[group]['ml'].append(ml)
            
            skills = root.find('skills')
            if skills is not None:
                for s in skills.findall('skill'):
                    sid = int(s.get('skillid'))
                    slvl = int(s.get('level'))
                    
                    if sid == 5: # Shielding
                        stats[group]['shield'].append(slvl)
                    elif sid in [1, 2, 3] and group == 'knight': # Melee
                        stats[group]['melee'].append(slvl)
                    elif sid == 4 and group == 'paladin': # Distance
                        stats[group]['dist'].append(slvl)
        except Exception as e:
            print(f"Error parsing {f_name}: {e}")

    print("--- 7.6 World War: Current Top Stats ---")
    results = {}
    for group, data in stats.items():
        print(f"\n[{group.upper()}]")
        for key, vals in data.items():
            if vals:
                top = max(vals)
                floor = math.floor(top * 0.7)
                print(f"  Top {key}: {top} (Min 70%: {floor})")
                results[f"{group}_{key}"] = top
            else:
                print(f"  Top {key}: N/A")
    return results

if __name__ == "__main__":
    analyze_76_players('worldwar/data/players/')
