function onUse(cid, item, frompos, item2, topos)
	if item.itemid == bushid then
		if getPlayerFood(cid) < maxfood then
			doPlayerFeed(cid,amount)
			doTransformItem(item.uid,emptybushid)
			doDecayItem(item.uid)
			doCreateItem(blueberryid,3,topos)
		else
			doPlayerSendCancel(cid,"You are full.")
		end
	end
	return 1
end