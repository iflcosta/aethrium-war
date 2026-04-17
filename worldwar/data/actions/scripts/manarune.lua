function onUse(cid, item, frompos, item2, topos)
mag = getPlayerMagLevel(cid)
if mag >= 4 then
doSendMagicEffect(topos,12)
doPlayerSendTextMessage(cid,22,"You Have Gain Some Mana!")
doPlayerAddMana(cid, 250)
if item.type > 1 then
doChangeTypeItem(item.uid,item.type-1)
end


else
doSendMagicEffect(frompos,2)
doPlayerSendCancel(cid,"Your magic is not strong enough to wield this power.")
end
return 1
end