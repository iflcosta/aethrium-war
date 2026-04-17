function onUse(cid, item, frompos, item2, topos)
playerpos = getPlayerPosition(cid)

if item.uid == 7766 then

warriorpos1 = {x=505, y=505, z=7}
warriorpos2 = {x=505, y=519, z=7}
warriorpos3 = {x=519, y=516, z=7}
warriorpos4 = {x=534, y=511, z=7}
warriorpos5 = {x=538, y=517, z=7}
warriorpos6 = {x=537, y=506, z=7}
warriorpos7 = {x=544, y=518, z=7}
warriorpos8 = {x=518, y=502, z=7}
warriorpos9 = {x=525, y=529, z=7}
warriorpos10 = {x=511, y=522, z=7}

magicianpos1 = {x=522, y=529, z=7}
magicianpos2 = {x=530, y=512, z=7}
magicianpos3 = {x=501, y=520, z=7}
magicianpos4 = {x=550, y=517, z=7}
magicianpos5 = {x=536, y=530, z=7}

tamerpos1 = {x=518, y=505, z=7}
tamerpos2 = {x=504, y=502, z=7}
tamerpos3 = {x=502, y=504, z=7}
tamerpos4 = {x=520, y=512, z=7}
tamerpos5 = {x=537, y=512, z=7}

archerpos1 = {x=552, y=506, z=7}
archerpos2 = {x=550, y=519, z=7}
archerpos3 = {x=543, y=521, z=7}
archerpos4 = {x=503, y=510, z=7}
archerpos5 = {x=503, y=521, z=7}
archerpos6 = {x=512, y=499, z=7}
archerpos7 = {x=512, y=501, z=7}
archerpos8 = {x=518, y=519, z=7}
archerpos9 = {x=530, y=506, z=7}
archerpos10 = {x=523, y=530, z=7}

assassinpos1 = {x=509, y=525, z=7}
assassinpos2 = {x=507, y=525, z=7}
assassinpos3 = {x=501, y=523, z=7}
assassinpos4 = {x=514, y=522, z=7}
assassinpos5 = {x=525, y=528, z=7}
assassinpos6 = {x=522, y=503, z=7}
assassinpos7 = {x=535, y=510, z=7}
assassinpos8 = {x=534, y=522, z=7}
assassinpos9 = {x=551, y=512, z=7}
assassinpos10 = {x=510, y=502, z=7}

 doSummonCreature("Dragonclan Warrior", warriorpos1)
 doSummonCreature("Dragonclan Warrior", warriorpos2)
 doSummonCreature("Dragonclan Warrior", warriorpos3)
 doSummonCreature("Dragonclan Warrior", warriorpos4)
 doSummonCreature("Dragonclan Warrior", warriorpos5)
 doSummonCreature("Dragonclan Warrior", warriorpos6)
 doSummonCreature("Dragonclan Warrior", warriorpos7)
 doSummonCreature("Dragonclan Warrior", warriorpos8)
 doSummonCreature("Dragonclan Warrior", warriorpos9)
 doSummonCreature("Dragonclan Warrior", warriorpos10)

 doSummonCreature("Dragonclan Magician", magicianpos1)
 doSummonCreature("Dragonclan Magician", magicianpos2)
 doSummonCreature("Dragonclan Magician", magicianpos3)
 doSummonCreature("Dragonclan Magician", magicianpos4)
 doSummonCreature("Dragonclan Magician", magicianpos5)
 doSummonCreature("Dragonclan Dragontamer", tamerpos1)
 doSummonCreature("Dragonclan Dragontamer", tamerpos2)
 doSummonCreature("Dragonclan Dragontamer", tamerpos3)
 doSummonCreature("Dragonclan Dragontamer", tamerpos4)
 doSummonCreature("Dragonclan Dragontamer", tamerpos5)

 doSummonCreature("Dragonclan Archer", archerpos1)
 doSummonCreature("Dragonclan Archer", archerpos2)
 doSummonCreature("Dragonclan Archer", archerpos3)
 doSummonCreature("Dragonclan Archer", archerpos4)
 doSummonCreature("Dragonclan Archer", archerpos5)
 doSummonCreature("Dragonclan Archer", archerpos6)
 doSummonCreature("Dragonclan Archer", archerpos7)
 doSummonCreature("Dragonclan Archer", archerpos8)
 doSummonCreature("Dragonclan Archer", archerpos9)
 doSummonCreature("Dragonclan Archer", archerpos10)

 doSummonCreature("Dragonclan Assassin", assassinpos1)
 doSummonCreature("Dragonclan Assassin", assassinpos2)
 doSummonCreature("Dragonclan Assassin", assassinpos3)
 doSummonCreature("Dragonclan Assassin", assassinpos4)
 doSummonCreature("Dragonclan Assassin", assassinpos5)
 doSummonCreature("Dragonclan Assassin", assassinpos6)
 doSummonCreature("Dragonclan Assassin", assassinpos7)
 doSummonCreature("Dragonclan Assassin", assassinpos8)
 doSummonCreature("Dragonclan Assassin", assassinpos9)
 doSummonCreature("Dragonclan Assassin", assassinpos10)

doPlayerSay(cid,"/B The Dragon Clan is attacking the Town of Survival!",1)
print("Dragon Clan invasion triggered.")
end
end