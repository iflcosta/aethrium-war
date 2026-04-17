-- example of fishing script--

function onUse(cid, item, frompos, item2, topos)
	-- itemid means that is a creature
	if item2.itemid == 1381 then
		doRemoveItem(item.uid,1)
                doPlayerAddItem(cid,2692,1)
                end
	
	return 1
end