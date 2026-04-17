function onUse(cid, item, frompos, item2, topos)
if
item2.itemid == 2700 then
rand = math.random(1,2000)
if rand < 900 then
doPlayerAddItem(cid,3873,1)
doSendMagicEffect(topos,3)
else
doPlayerSendCancel(cid,"You cannot lumber here.")
end
return 1
end
end