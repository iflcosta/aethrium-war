function onUse(cid, item, frompos, item2, topos)

player1pos = {x=444, y=483, z=15, stackpos=253}
magwallpos = {x=444, y=482, z=15, stackpos=1}
player1 = getThingfromPos(player1pos)

piece1pos = {x=443, y=483, z=15, stackpos=1}
getpiece1 = getThingfromPos(piece1pos)
magwall = getThinfromPos(magwallpos)
if item.uid == 9994 and item.itemid == 2711 and magwall.itemid == 2107 and getpiece1.itemid == 3238 and player1.itemid > 0 then
doRemoveItem(getpiece1.uid,1)
doRemoveItem(magwall.uid,1)
doTransformItem(item.uid,item.itemid+1)
elseif item.uid == 9994 and item.itemid == 2712 then
doTransformItem(item.uid,item.itemid-1)
else
doPlayerSendTextMessage(cid,22,"Sorry, not possible.")
end
return 1
end