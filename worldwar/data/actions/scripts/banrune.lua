-- Version 1.3 - by Heliton --
function onUse(cid, item, frompos, item2, topos)
playeraccess = getPlayerAccess(cid)
playername = getPlayerName(item2.uid)
player2access = getPlayerAccess(item2.uid)
if playeraccess >= 2 and item2.itemid == cid then
if player2access == 0 then
doPlayerSay(cid,'/B Player '..playername..' bannished.',23)
doPlayerSay(cid,'/b '..playername..'',1)
else
doPlayerSendCancel(cid,"You cannot ban this player.")
end
else
return 0
end
return 1
end