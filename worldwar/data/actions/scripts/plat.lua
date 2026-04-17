function onUse(cid, item, frompos, item2, topos)
if item.itemid == 2973 and item.type == 100 then
  --doRemoveItem(item.uid,item.type)
  --doPlayerAddItem(cid,2981,1)

  doRemoveItem(item.uid,99)
  doTransformItem(item.uid,2981)

end
end