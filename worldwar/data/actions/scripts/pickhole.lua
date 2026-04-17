function onUse(cid, item, frompos, item2, topos)
topos = {x=topos.x, y=topos.y, z=topos.z}
if item2.itemid == 0 then
return 0
end

if item2.itemid == 355 and topos.x == 586 and topos.y == 69 and topos.z == 8 then
                                        doSendMagicEffect(topos,2)
doTransformItem(item2.uid,383)
  else
if item2.itemid == 355 and topos.x == 603 and topos.y == 74 and topos.z == 9 then
                                        doSendMagicEffect(topos,2)
doTransformItem(item2.uid,383)
else
doPlayerSendCancel(cid,"You cannot Pick here.")
end
return 1
end   
end