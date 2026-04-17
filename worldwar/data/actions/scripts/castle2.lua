function onUse(cid, item, frompos, item2, topos)

player1pos = {x=412, y=603, z=10, stackpos=253}
player1 = getThingfromPos(player1pos)

piece1pos = {x=412, y=602, z=10, stackpos=1}
getpiece1 = getThingfromPos(piece1pos)
if item.uid == 4004 and item.itemid == 1945 and getpiece1.itemid == 2149 and player1.itemid > 0 then
doRemoveItem(getpiece1.uid,1)
nplayer1pos = {x=412, y=607, z=9}
doTeleportThing(player1.uid,nplayer1pos)
doSendMagicEffect(nplayer1pos,10)
doTransformItem(item.uid,item.itemid+1)
elseif item.uid == 4004 and item.itemid == 1946 then
doTransformItem(item.uid,item.itemid-1)
else
doPlayerSendTextMessage(cid,22,"Sorry, not possible.")
end
return 1
end