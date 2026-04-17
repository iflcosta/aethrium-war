-- annihilator lever

function onUse(cid, item, frompos, item2, topos)

   	if item.uid == 7000 and item.itemid == 1945 then
 		player1pos = {x=1066, y=531, z=7, stackpos=253}
 		player1 = getThingfromPos(player1pos)

 		player2pos = {x=1065, y=531, z=7, stackpos=253}
		player2 = getThingfromPos(player2pos)

 		player3pos = {x=1064, y=531, z=7, stackpos=253}
 		player3 = getThingfromPos(player3pos)

 		player4pos = {x=1063, y=531, z=7, stackpos=253}
 		player4 = getThingfromPos(player4pos)


		if player1.itemid > 0 and player2.itemid > 0 and player3.itemid > 0 and player4.itemid > 0 then
			queststatus1 = getPlayerStorageValue(player1.uid,7000)
			queststatus2 = getPlayerStorageValue(player2.uid,7000)
			queststatus3 = getPlayerStorageValue(player3.uid,7000)
			queststatus4 = getPlayerStorageValue(player4.uid,7000)

			if queststatus1 == -1 and queststatus2 == -1 and queststatus3 == -1 and queststatus4 == -1 then
	demon1pos = {x=1059, y=483, z=7}
	demon2pos = {x=1062, y=487, z=7}
	demon3pos = {x=1060, y=487, z=7}
	demon4pos = {x=1061, y=483, z=7}
	demon5pos = {x=1063, y=485, z=7}
	demon6pos = {x=1064, y=485, z=7}
 
   doSummonCreature("Demon", demon1pos)
   doSummonCreature("Demon", demon2pos)
   doSummonCreature("Demon", demon3pos)
   doSummonCreature("Demon", demon4pos)
   doSummonCreature("Orshabaal", demon5pos)
   doSummonCreature("Demon", demon6pos)

	nplayer1pos = {x=1062, y=485, z=7}
	nplayer2pos = {x=1061, y=485, z=7}
	nplayer3pos = {x=1060, y=485, z=7}
	nplayer4pos = {x=1059, y=485, z=7}

				doSendMagicEffect(player1pos,2)
				doSendMagicEffect(player2pos,2)
				doSendMagicEffect(player3pos,2)
				doSendMagicEffect(player4pos,2)

				doTeleportThing(player1.uid,nplayer1pos)
				doTeleportThing(player2.uid,nplayer2pos)
				doTeleportThing(player3.uid,nplayer3pos)
				doTeleportThing(player4.uid,nplayer4pos)

				doSendMagicEffect(nplayer1pos,10)
				doSendMagicEffect(nplayer2pos,10)
				doSendMagicEffect(nplayer3pos,10)
				doSendMagicEffect(nplayer4pos,10)

				doTransformItem(item.uid,item.itemid+1)
			end
		else
			doPlayerSendCancel(cid,"You need four players for this quest.")
		end

	elseif item.uid ==7000 and item.itemid == 1946 then
		if getPlayerAccess(cid) > 0 then
			doTransformItem(item.uid,item.itemid-1)
		else
			doPlayerSendCancel(cid,"Sorry, not possible.")
		end
	else
		return 0
	end

	return 1
end
