const fs = require('fs');
const path = require('path');

const ACCOUNTS_DIR = path.join(__dirname, '../worldwar/data/accounts');
const PLAYERS_DIR = path.join(__dirname, '../worldwar/data/players');
const OUTPUT_FILE = path.join(__dirname, '../database/seed/04_players_all.sql');

const ACCOUNT_MAP = { 1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7 };
const LEADERS_ALREADY_INSERTED = new Set([
    "Bubble", "Undead Slayer", "Irie D", "Eternal Oblivion",
    "Cachero", "Seromontis", "Mateusz Dragon Wielki"
]);

const DEFAULT_POS = { x: 1024, y: 633, z: 7 };

function buildAccountIndex() {
    const index = {};
    for (let accno = 1; accno <= 7; accno++) {
        const filePath = path.join(ACCOUNTS_DIR, `${accno}.xml`);
        if (!fs.existsSync(filePath)) continue;

        const content = fs.readFileSync(filePath, 'utf8');
        const matches = content.matchAll(/<character name="([^"]+)"/g);
        for (const match of matches) {
            index[match[1]] = accno;
        }
    }
    return index;
}

function parsePlayer(filePath) {
    const content = fs.readFileSync(filePath, 'latin1');

    const getAttr = (regex, def = "") => {
        const m = content.match(regex);
        return m ? m[1] : def;
    };

    const name = getAttr(/<player name="([^"]+)"/);
    if (!name) return null;

    const p = {
        name: name,
        vocation: parseInt(getAttr(/voc="(\d+)"/, "0")),
        level: parseInt(getAttr(/level="(\d+)"/, "1")),
        experience: parseInt(getAttr(/exp="(\d+)"/, "0")),
        maglevel: parseInt(getAttr(/maglevel="(\d+)"/, "0")),
        cap: parseInt(getAttr(/cap="(\d+)"/, "400")),
        sex: parseInt(getAttr(/sex="(\d+)"/, "0")),
        looktype: parseInt(getAttr(/<look type="(\d+)"/, "136")),
        lookhead: parseInt(getAttr(/head="(\d+)"/, "0")),
        lookbody: parseInt(getAttr(/body="(\d+)"/, "0")),
        looklegs: parseInt(getAttr(/legs="(\d+)"/, "0")),
        lookfeet: parseInt(getAttr(/feet="(\d+)"/, "0")),
        posx: parseInt(getAttr(/<spawn x="(\d+)"/, DEFAULT_POS.x.toString())),
        posy: parseInt(getAttr(/y="(\d+)"/, DEFAULT_POS.y.toString())),
        posz: parseInt(getAttr(/z="(\d+)"/, DEFAULT_POS.z.toString())),
    };

    const healthMatch = content.match(/<health now="(\d+)" max="(\d+)"/);
    p.health = healthMatch ? parseInt(healthMatch[1]) : 150;
    p.healthmax = healthMatch ? parseInt(healthMatch[2]) : 150;

    const manaMatch = content.match(/<mana now="(\d+)" max="(\d+)"/);
    p.mana = manaMatch ? parseInt(manaMatch[1]) : 0;
    p.manamax = manaMatch ? parseInt(manaMatch[2]) : 0;

    const skills = { 0: 10, 1: 10, 2: 10, 3: 10, 4: 10, 5: 10, 6: 10 };
    const skillMatches = content.matchAll(/<skill skillid="(\d+)" level="(\d+)"/g);
    for (const match of skillMatches) {
        skills[parseInt(match[1])] = parseInt(match[2]);
    }
    p.skills = skills;

    return p;
}

function escape(s) {
    return s.replace(/'/g, "''");
}

function main() {
    console.log("=== Aethrium War Phase 3 (Node.js) ===");
    const accountIndex = buildAccountIndex();
    const files = fs.readdirSync(PLAYERS_DIR).filter(f => f.endsWith('.xml'));

    let idCounter = 9;
    const rows = [];

    for (const file of files) {
        const playerName = file.replace('.xml', '');
        if (LEADERS_ALREADY_INSERTED.has(playerName)) continue;
        if (/^(Knight|Paladin|Sorcerer|Druid)\d*\.xml$/i.test(file)) continue;

        const p = parsePlayer(path.join(PLAYERS_DIR, file));
        if (!p) continue;

        let accNo = accountIndex[p.name];
        if (!accNo) {
            // Case-insensitive fallback
            const lowerName = p.name.toLowerCase();
            for (const n in accountIndex) {
                if (n.toLowerCase() === lowerName) {
                    accNo = accountIndex[n];
                    break;
                }
            }
        }
        if (!accNo) accNo = 1;

        const accountId = ACCOUNT_MAP[accNo];
        const sk = p.skills;

        const row = `(${idCounter}, '${escape(p.name)}', 1, ${accountId}, ` +
            `${p.level}, ${p.vocation}, ` +
            `${p.health}, ${p.healthmax}, ` +
            `${p.experience}, ` +
            `${p.lookbody}, ${p.lookfeet}, ${p.lookhead}, ${p.looklegs}, ` +
            `${p.looktype}, 0, ` +
            `0, 0, 2, ` +
            `${p.maglevel}, ${p.mana}, ${p.manamax}, 0, 100, ` +
            `1, ${p.posx}, ${p.posy}, ${p.posz}, ` +
            `NULL, ${p.cap}, ${p.sex}, ` +
            `0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 43200, -1, 2520, ` +
            `${sk[0]}, 0, ${sk[1]}, 0, ${sk[2]}, 0, ${sk[3]}, 0, ` +
            `${sk[4]}, 0, ${sk[5]}, 0, ${sk[6]}, 0)`;
        rows.push(row);
        idCounter++;
    }

    const output = `-- Phase 3: Character Migration\n` +
        `INSERT INTO \`players\` (\`id\`, \`name\`, \`group_id\`, \`account_id\`, \`level\`, \`vocation\`, \`health\`, \`healthmax\`, \`experience\`, \`lookbody\`, \`lookfeet\`, \`lookhead\`, \`looklegs\`, \`looktype\`, \`lookaddons\`, \`currentmount\`, \`randomizemount\`, \`direction\`, \`maglevel\`, \`mana\`, \`manamax\`, \`manaspent\`, \`soul\`, \`town_id\`, \`posx\`, \`posy\`, \`posz\`, \`conditions\`, \`cap\`, \`sex\`, \`lastlogin\`, \`lastip\`, \`save\`, \`skull\`, \`skulltime\`, \`lastlogout\`, \`blessings\`, \`onlinetime\`, \`deletion\`, \`balance\`, \`offlinetraining_time\`, \`offlinetraining_skill\`, \`stamina\`, \`skill_fist\`, \`skill_fist_tries\`, \`skill_club\`, \`skill_club_tries\`, \`skill_sword\`, \`skill_sword_tries\`, \`skill_axe\`, \`skill_axe_tries\`, \`skill_dist\`, \`skill_dist_tries\`, \`skill_shielding\`, \`skill_shielding_tries\`, \`skill_fishing\`, \`skill_fishing_tries\`) VALUES\n` +
        rows.join(',\n') + `\nON DUPLICATE KEY UPDATE \`level\` = VALUES(\`level\`);\n`;

    fs.writeFileSync(OUTPUT_FILE, output);
    console.log(`Successfully migrated ${rows.length} players to ${OUTPUT_FILE}`);
}

main();
