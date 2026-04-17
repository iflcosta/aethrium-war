function onUse(cid, item, frompos, item2, topos)
playerpos = getPlayerPosition(cid)

if item.uid == 5553 then

demodraspos = {x=401, y=518, z=10}

 doSummonCreature("Demodras", demodraspos)

doPlayerSay(cid,"/B Abnormal heat at the 4 Dragon Lord broodplace detected!",1)
print("Demodras Spawn triggered.")
end
end