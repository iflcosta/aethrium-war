function onUse(cid, item, frompos, item2, topos)

player1pos = {x=649, y=608, z=12, stackpos=253}
player1 = getThingfromPos(player1pos)

piece1pos = {x=648, y=608, z=12, stackpos=1}
getpiece1 = getThingfromPos(piece1pos)
if item.uid == 3255 and item.itemid == 1945 and getpiece1.itemid == 2159 and player1.itemid > 0 then
doRemoveItem(getpiece1.uid,1)
nplayer1pos = {x=651, y=605, z=13}
doTeleportThing(player1.uid,nplayer1pos)
doSendMagicEffect(nplayer1pos,10)
doTransformItem(item.uid,item.itemid+1)
elseif item.uid == 3255 and item.itemid == 1946 then
doTransformItem(item.uid,item.itemid-1)
else
doPlayerSendTextMessage(cid,22,"Sorry, not possible.")
end
return 1
end