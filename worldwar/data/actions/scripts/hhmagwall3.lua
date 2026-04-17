function onUse(cid, item, frompos, item2, topos)

	mag3pos = {x=609, y=524, z=6, stackpos=1}

	magwall3 = getThingfromPos(mag3pos)

if item.uid == 9993 and item.itemid == 2711 and magwall3.itemid == 2107 then

	doRemoveItem(magwall3.uid,1)

doTransformItem(item.uid,item.itemid+1)
	elseif item.uid == 9993 and item.itemid == 2712 then
		doTransformItem(item.uid,item.itemid-1)
	else
		doPlayerSendTextMessage(cid,22,"Sorry, not possible.")
end
return 1
end