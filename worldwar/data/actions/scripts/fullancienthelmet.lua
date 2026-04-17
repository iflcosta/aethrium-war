-- Ancient Helmet by Peonso

function onUse(cid, item, frompos, item2, topos)
piece1pos = {x=610, y=524, z=7, stackpos=1}
piece2pos = {x=612, y=524, z=7, stackpos=1}
helmetpos = {x=611, y=524, z=7, stackpos=1}
getpiece1 = getThingfromPos(piece1pos)
getpiece2 = getThingfromPos(piece2pos)

if item.uid == 1338 and item.itemid == 1945 and getpiece1.itemid == 2342 and getpiece2.itemid == 2363 then
 doRemoveItem(getpiece1.uid,1)
doSendMagicEffect(piece1pos,23)
 doRemoveItem(getpiece2.uid,1)
doSendMagicEffect(piece2pos,23)
 doCreateItem(2343,1,helmetpos)
doSendMagicEffect(helmetpos,22)
 doTransformItem(item.uid,item.itemid+1)
 elseif item.uid == 1338 and item.itemid == 1946 then
  doTransformItem(item.uid,item.itemid-1)
 else
doPlayerSendTextMessage(cid,22,"Sorry, not possible.")
end
return 1
end