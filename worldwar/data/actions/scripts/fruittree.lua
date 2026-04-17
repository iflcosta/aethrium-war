function onUse(cid, item, frompos, item2, topos)

	if item.itemid == 3634 then		-- blueberry bush
		doTransformItem(item.uid, 3635)
		doDecayItem(item.uid)
		doCreateItem(3526, 3, topos)
	end

	return 1
end
