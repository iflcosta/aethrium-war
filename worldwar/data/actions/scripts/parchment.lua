--parchment by peonso

function onUse(cid, item, frompos, item2, topos)
playerpos = getPlayerPosition(cid)

if item.uid == 7030 then
queststatus = getPlayerStorageValue(cid,6001)
if queststatus == -1 or queststatus == 0 then
 doPlayerSendTextMessage(cid,22,"You have found a frozen starlight.")

player2pos = {x=72, y=43, z=7}

 doTeleportThing(cid,player2pos)

demon1pos = {x=459, y=729, z=14}
demon2pos = {x=465, y=729, z=14}
demon3pos = {x=459, y=732, z=14}
demon4pos = {x=465, y=732, z=14}

 doSummonCreature("Demon", demon1pos)
 doSummonCreature("Demon", demon2pos)
 doSummonCreature("Demon", demon3pos)
 doSummonCreature("Demon", demon4pos)

 doTeleportThing(cid,playerpos)

doSendMagicEffect(topos,12)
coins_uid = doPlayerAddItem(cid,2361,1)
setPlayerStorageValue(cid,6000,1)

else
doPlayerSendTextMessage(cid,22,"Nothing Here.")
end
return 0
end
return 1
end