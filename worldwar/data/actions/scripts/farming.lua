function onUse(cid, item, frompos, item2, topos)
if
item2.itemid == 804 or item2.itemid == 806 then
rand = math.random(1,2000)
if rand < 900 then
doPlayerAddItem(cid,2686,1)
doSendMagicEffect(topos,3)
else
doPlayerSendCancel(cid,"You cannot farm here.")
end
return 1
end
end