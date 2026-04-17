function onUse(cid, item, frompos, item2, topos)

	mag2pos = {x=609, y=524, z=6, stackpos=1}

	magwall2 = getThingfromPos(mag2pos)

if item.uid == 9992 and item.itemid == 2711 and magwall2.itemid == 2107 then

	doRemoveItem(magwall2.uid,1)

doTransformItem(item.uid,item.itemid+1)
	elseif item.uid == 9992 and item.itemid == 2712 then
		doTransformItem(item.uid,item.itemid-1)
	else
		doPlayerSendTextMessage(cid,22,"Sorry, not possible.")
end
return 1
end