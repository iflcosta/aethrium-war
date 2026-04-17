function onUse(cid, item, frompos, item2, topos)

player1pos = {x=492, y=401, z=8, stackpos=253}
player1 = getThingfromPos(player1pos)

piece1pos = {x=491, y=401, z=8, stackpos=1}
getpiece1 = getThingfromPos(piece1pos)
if item.uid == 4006 and item.itemid == 1945 and getpiece1.itemid == 2151 and player1.itemid > 0 then
doRemoveItem(getpiece1.uid,1)
nplayer1pos = {x=491, y=425, z=4}
doTeleportThing(player1.uid,nplayer1pos)
doSendMagicEffect(nplayer1pos,10)
doTransformItem(item.uid,item.itemid+1)
elseif item.uid == 4006 and item.itemid == 1946 then
doTransformItem(item.uid,item.itemid-1)
else
doPlayerSendTextMessage(cid,22,"Sorry, not possible.")
end
return 1
end