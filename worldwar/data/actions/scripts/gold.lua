function onUse(cid, item, frompos, item2, topos)
   	if item.itemid == 2148 and item.type == 100 then
   		doRemoveItem(item.uid,item.type)
   		doPlayerAddItem(cid,2152,1)
   		doPlayerSendTextMessage(cid,22,"You have changed 100 gp to 1 platnium coin")
   end
end