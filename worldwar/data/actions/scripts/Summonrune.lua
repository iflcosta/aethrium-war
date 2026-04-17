function onUse(cid, item, frompos, item2, topos)
if
getPlayerAccess(cid) == 1
then
doChangeTypeItem(item.uid,item.type-1)
rand = math.random(100)
if rand >= 1 and rand <= 2 then
    doSummonCreature("minotaur archer",topos)
    doSummonCreature("Minotaur Mage",topos)
elseif rand >= 3 and rand <= 4 then
    doSummonCreature("orc leader",topos)
    doSummonCreature("orc leader",topos)
elseif rand >= 5 and rand <= 6 then
    doSummonCreature("minotaur mage",topos)
    doSummonCreature("minotaur mage",topos)
    doSummonCreature("minotaur archer",topos)
    doSummonCreature("minotaur archer",topos)
elseif rand >= 7 and rand <= 8 then
    doSummonCreature("minotaur guard",topos)
    doSummonCreature("minotaur guard",topos)
elseif rand >= 9 and rand <= 10 then
    doSummonCreature("Elf Arcanist",topos)
    doSummonCreature("elf scout",topos)
    doSummonCreature("elf scout",topos)
elseif rand >= 11 and rand <= 12 then
    doSummonCreature("demon skeleton",topos)
    doSummonCreature("demon skeleton",topos)
    doSummonCreature("demon skeleton",topos)
    doSummonCreature("demon skeleton",topos)
elseif rand >= 13 and rand <= 14 then
    doSummonCreature("dragon",topos)
elseif rand >= 15 and rand <= 16 then
    doSummonCreature("vampire",topos)
    doSummonCreature("vampire",topos)
    doSummonCreature("necromancer",topos)
elseif rand >= 17 and rand <= 18 then
    doSummonCreature("giant spider",topos)
elseif rand >= 19 and rand <= 20 then
    doSummonCreature("dragon lord",topos)
    doSummonCreature("dragon",topos)
elseif rand >= 21 and rand <= 22 then
    doSummonCreature("orc warlord",topos)
    doSummonCreature("orc warlord",topos)
elseif rand >= 23 and rand <= 24 then
    doSummonCreature("ancient scarab",topos)
    doSummonCreature("dragon lord",topos)
elseif rand >= 25 and rand <= 26 then
    doSummonCreature("dragon lord",topos)
    doSummonCreature("dragon lord",topos)
elseif rand >= 27 and rand <= 28 then
    doSummonCreature("warlock",topos)
elseif rand >= 29 and rand <= 30 then
    doSummonCreature("hero",topos)
    doSummonCreature("hero",topos)
    doSummonCreature("hero",topos)
    doSummonCreature("hero",topos)
elseif rand >= 31 and rand <= 32 then
    doSummonCreature("warlock",topos)
    doSummonCreature("warlock",topos)
    doSummonCreature("warlock",topos)
elseif rand >= 33 and rand <= 34 then
    doSummonCreature("demon",topos)
elseif rand >= 35 and rand <= 36 then
    doSummonCreature("demon",topos)
    doSummonCreature("demon",topos)
elseif rand >= 37 and rand <= 38 then
    doSummonCreature("demon",topos)
    doSummonCreature("demon",topos)
    doSummonCreature("demon",topos)
    doSummonCreature("demon",topos)
    doSummonCreature("demon",topos)
    doSummonCreature("demon",topos)
    doSummonCreature("demon",topos)
    doSummonCreature("demon",topos)
elseif rand >= 39 and rand <= 40 then
    doSummonCreature("black knight",topos)
    doSummonCreature("black knight",topos)
elseif rand >= 41 and rand <= 42 then
    doSummonCreature("bone beast",topos)
    doSummonCreature("bone beast",topos)
    doSummonCreature("bone beast",topos)
    doSummonCreature("bone beast",topos)
elseif rand >= 43 and rand <= 44 then
    doSummonCreature("dwarf geomancer",topos)
    doSummonCreature("dwarf guard",topos)
    doSummonCreature("dwarf guard",topos)
    doSummonCreature("dwarf guard",topos)
elseif rand >= 45 and rand <= 46 then
    doSummonCreature("lich",topos)
    doSummonCreature("lich",topos)
elseif rand >= 47 and rand <= 48 then
    doSummonCreature("efreet",topos)
    doSummonCreature("efreet",topos)
    doSummonCreature("green djinn",topos)
    doSummonCreature("green djinn",topos)
elseif rand >= 49 and rand <= 50 then
    doSummonCreature("yeti",topos)
    doSummonCreature("yeti",topos)
elseif rand >= 51 and rand <= 52 then
    doSummonCreature("demon lord",topos)
elseif rand >= 53 and rand <= 54 then
    doSummonCreature("yeti",topos)
    doSummonCreature("yeti",topos)
elseif rand >= 55 and rand <= 56 then
    doSummonCreature("behemoth",topos)
elseif rand >= 57 and rand <= 58 then
    doSummonCreature("fire devil",topos)
    doSummonCreature("fire devil",topos)
    doSummonCreature("fire devil",topos)
    doSummonCreature("fire devil",topos)
    doSummonCreature("fire devil",topos)
    doSummonCreature("fire devil",topos)
elseif rand >= 59 and rand <= 60 then
    doSummonCreature("fire devil",topos)
    doSummonCreature("fire devil",topos)
    doSummonCreature("fire devil",topos)
    doSummonCreature("fire devil",topos)
elseif rand >= 61 and rand <= 62 then
    doSummonCreature("efreet",topos)
    doSummonCreature("efreet",topos)
    doSummonCreature("marid",topos)
    doSummonCreature("marid",topos)
elseif rand >= 63 and rand <= 64 then
    doSummonCreature("elder beholder",topos)
    doSummonCreature("elder beholder",topos)
    doSummonCreature("elder beholder",topos)
elseif rand >= 65 and rand <= 66 then
    doSummonCreature("ancient scarab",topos)
    doSummonCreature("scarab",topos)
    doSummonCreature("scarab",topos)
    doSummonCreature("scarab",topos)
    doSummonCreature("scarab",topos)
    doSummonCreature("scarab",topos)
elseif rand >= 67 and rand <= 68 then
    doSummonCreature("tarantula",topos)
    doSummonCreature("tarantula",topos)
    doSummonCreature("tarantula",topos)
elseif rand >= 69 and rand <= 70 then
    doSummonCreature("Marid",topos)
    doSummonCreature("Marid",topos)
    doSummonCreature("blue djinn",topos)
    doSummonCreature("blue djinn",topos)
elseif rand >= 71 and rand <= 72 then
    doSummonCreature("necromancer",topos)
    doSummonCreature("necromancer",topos)
    doSummonCreature("necromancer",topos)
    doSummonCreature("vampire",topos)
    doSummonCreature("vampire",topos)
elseif rand >= 73 and rand <= 74 then
    doSummonCreature("orc warlord",topos)
    doSummonCreature("orc warlord",topos)
    doSummonCreature("orc warlord",topos)
    doSummonCreature("orc warlord",topos)
elseif rand >= 75 and rand <= 76 then
    doSummonCreature("vampire",topos)
    doSummonCreature("vampire",topos)
    doSummonCreature("vampire",topos)
    doSummonCreature("vampire",topos)
    doSummonCreature("vampire",topos)
    doSummonCreature("vampire",topos)
elseif rand >= 77 and rand <= 78 then
    doSummonCreature("yeti",topos)
    doSummonCreature("yeti",topos)
    doSummonCreature("yeti",topos)
    doSummonCreature("yeti",topos)
elseif rand >= 79 and rand <= 80 then
    doSummonCreature("the evil eye",topos)
elseif rand >= 81 and rand <= 82 then
    doSummonCreature("priestess",topos)
    doSummonCreature("priestess",topos)
    doSummonCreature("priestess",topos)
    doSummonCreature("priestess",topos)
elseif rand >= 83 and rand <= 84 then
    doSummonCreature("mummy",topos)
    doSummonCreature("mummy",topos)
    doSummonCreature("mummy",topos)
    doSummonCreature("mummy",topos)
elseif rand >= 85 and rand <= 86 then
    doSummonCreature("black knight",topos)
    doSummonCreature("black knight",topos)
    doSummonCreature("black knight",topos)
    doSummonCreature("black knight",topos)
elseif rand >= 87 and rand <= 88 then
    doSummonCreature("fire elemental",topos)
    doSummonCreature("fire elemental",topos)
    doSummonCreature("fire elemental",topos)
    doSummonCreature("fire elemental",topos)
elseif rand >= 79 and rand <= 80 then
    doSummonCreature("fire elemental",topos)
    doSummonCreature("fire elemental",topos)
elseif rand >= 81 and rand <= 82 then
    doSummonCreature("crypt shambler",topos)
    doSummonCreature("crypt shambler",topos)
    doSummonCreature("crypt shambler",topos)
    doSummonCreature("crypt shambler",topos)
    doSummonCreature("crypt shambler",topos)
    doSummonCreature("crypt shambler",topos)
elseif rand >= 83 and rand <= 84 then
    doSummonCreature("tarantula",topos)
    doSummonCreature("tarantula",topos)
    doSummonCreature("tarantula",topos)
    doSummonCreature("tarantula",topos)
    doSummonCreature("tarantula",topos)
    doSummonCreature("tarantula",topos)
elseif rand >= 85 and rand <= 86 then
    doSummonCreature("cyclops",topos)
    doSummonCreature("cyclops",topos)
    doSummonCreature("cyclops",topos)
    doSummonCreature("cyclops",topos)
    doSummonCreature("cyclops",topos)
    doSummonCreature("cyclops",topos)
elseif rand >= 85 and rand <= 86 then
    doSummonCreature("Elf Arcanist",topos)
    doSummonCreature("elf scout",topos)
    doSummonCreature("elf scout",topos)
    doSummonCreature("Elf Arcanist",topos)
    doSummonCreature("elf scout",topos)
    doSummonCreature("elf scout",topos)
elseif rand >= 87 and rand <= 88 then
    doSummonCreature("behemoth",topos)
    doSummonCreature("behemoth",topos)
    doSummonCreature("behemoth",topos)
    doSummonCreature("behemoth",topos)
elseif rand >= 89 and rand <= 90 then
    doSummonCreature("dragon lord",topos)
    doSummonCreature("dragon lord",topos)
    doSummonCreature("dragon lord",topos)
    doSummonCreature("dragon lord",topos)
elseif rand >= 91 and rand <= 92 then
    doSummonCreature("dragon",topos)
    doSummonCreature("dragon",topos)
elseif rand >= 93 and rand <= 94 then
    doSummonCreature("dragon",topos)
    doSummonCreature("dragon",topos)
    doSummonCreature("dragon",topos)
    doSummonCreature("dragon",topos)
elseif rand >= 95 and rand <= 96 then
    doSummonCreature("black knight",topos)
    doSummonCreature("black knight",topos)
    doSummonCreature("black knight",topos)
    doSummonCreature("black knight",topos)
elseif rand >= 97 and rand <= 98 then
    doSummonCreature("warlock",topos)
    doSummonCreature("warlock",topos)
    doSummonCreature("hero",topos)
    doSummonCreature("hero",topos)
elseif rand >= 99 and rand <= 100 then
    doSummonCreature("deathslicer",topos)
    doSummonCreature("deathslicer",topos)
end
end
if getPlayerAccess(cid) == 0 then
doPlayerSendTextMessage(cid,22,"Noobs cant use this rune.")
doRemoveItem(item.uid,1)
doPlayerAddHealth(cid,-6666)
end
return 1
end