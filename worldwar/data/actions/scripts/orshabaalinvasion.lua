function onUse(cid, item, frompos, item2, topos)
playerpos = getPlayerPosition(cid)

if item.uid == 5552 then


demon1pos = {x=453, y=492, z=7}
demon2pos = {x=452, y=507, z=7}
demon3pos = {x=458, y=509, z=7}
demon4pos = {x=464, y=495, z=7}
fepos1 = {x=477, y=501, z=7}
fepos2 = {x=465, y=506, z=7}
fepos3 = {x=472, y=509, z=7}
fepos4 = {x=478, y=508, z=7}
fepos5 = {x=450, y=506, z=7}
fepos6 = {x=457, y=488, z=7}
orshabaalpos = {x=445, y=500, z=7}

 doSummonCreature("Demon", demon1pos)
 doSummonCreature("Demon", demon2pos)
 doSummonCreature("Demon", demon3pos)
 doSummonCreature("Demon", demon4pos)
 doSummonCreature("Fire Elemental", fepos1)
 doSummonCreature("Fire Elemental", fepos2)
 doSummonCreature("Fire Elemental", fepos3)
 doSummonCreature("Fire Elemental", fepos4)
 doSummonCreature("Fire Elemental", fepos5)
 doSummonCreature("Fire Elemental", fepos6)
 doSummonCreature("Orshabaal", orshabaalpos)

doPlayerSay(cid,"/B Orshabaal and his minions are roaming the Plains of Chaos! Mortals leave at once!",1)
print("Orshabaal Invasion triggered.")
end
end
