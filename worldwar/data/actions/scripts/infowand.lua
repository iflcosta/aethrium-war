
function onUse(cid, item, frompos, item2, topos)
if getPlayerAccess(cid) ~=0 then
doPlayerSendTextMessage(cid,22,'ItemID='..item2.itemid..' ItemUID='..item2.uid..' ItemAID='..item2.actionid..' x='..topos.x..' y='..topos.y..' z='..topos.z..'')
end
return 1
end