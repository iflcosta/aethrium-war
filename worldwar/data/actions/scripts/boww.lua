-- WaterWalkingSpellWand By Ghettobird -- 


function onUse(cid, item, frompos, item2, topos)


if item2.itemid == 601 or item2.itemid == 690 or item2.itemid == 696 or item2.itemid == 700  or item2.itemid == 602 or item2.itemid == 603 or item2.itemid == 729 or item2.itemid == 730 or item2.itemid == 731 or item2.itemid == 732 or item2.itemid == 733 or item2.itemid == 734 or item2.itemid == 735 or item2.itemid == 736 or item2.itemid == 737 or item2.itemid == 738 or item2.itemid == 739 or item2.itemid == 740 then

doTeleportThing(cid,topos)
doSendMagicEffect(topos,1)
doSendMagicEffect(frompos,1)
doPlayerSendTextMessage(cid,24,"Using Spellwand On Water.")

else
doSendMagicEffect(frompos,2)
doPlayerSendCancel(cid,"You cannot use the wand here.")
end
return 1
end
