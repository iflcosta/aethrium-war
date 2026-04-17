function onUse(cid, item, frompos, item2, topos)
playerpos = getPlayerPosition(cid)

if item.uid == 5554 then

doverlordpos = {x=644, y=660, z=11}

 doSummonCreature("Demon Overlord", doverlordpos)

doPlayerSay(cid,"/B The Demon Overlord has spawned from hell to assist his minions in Demon Hell!",1)
print("Demon Overlord Spawn triggered.")
end
end