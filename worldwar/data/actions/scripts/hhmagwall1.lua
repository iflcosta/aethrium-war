function onUse(cid, item, frompos, item2, topos)

	mag1pos = {x=609, y=524, z=6, stackpos=1}

	magwall1 = getThingfromPos(mag1pos)

if item.uid == 9991 and item.itemid == 2711 and magwall1.itemid == 2107 then

	doRemoveItem(magwall1.uid,1)

doTransformItem(item.uid,item.itemid+1)
	elseif item.uid == 9991 and item.itemid == 2712 then
		doTransformItem(item.uid,item.itemid-1)
	else
		doPlayerSendTextMessage(cid,22,"Sorry, not possible.")
end
return 1
end