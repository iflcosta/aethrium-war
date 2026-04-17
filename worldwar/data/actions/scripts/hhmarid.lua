function onUse(cid, item, frompos, item2, topos)

player1pos = {x=435, y=527, z=14, stackpos=253}
player1 = getThingfromPos(player1pos)

piece1pos = {x=435, y=526, z=14, stackpos=1}
getpiece1 = getThingfromPos(piece1pos)
if item.uid == 9995 and item.itemid == 2711 and getpiece1.itemid == 2967 and player1.itemid > 0 then
doRemoveItem(getpiece1.uid,1)
nplayer1pos = {x=441, y=526, z=14}
doTeleportThing(player1.uid,nplayer1pos)
doSendMagicEffect(nplayer1pos,10)
doTransformItem(item.uid,item.itemid+1)
elseif item.uid == 9995 and item.itemid == 2712 then
doTransformItem(item.uid,item.itemid-1)
else
doPlayerSendTextMessage(cid,22,"Sorry, not possible.")
end
return 1
end