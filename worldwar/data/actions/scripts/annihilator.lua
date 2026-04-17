 -- Annihilator script by GriZzm0
 -- Room check and monster removal by Tworn
 
 --Variables used:

 -- player?pos  = The position of the players before teleport.
 -- player?  = Get the thing from playerpos.
 --player?level = Get the players levels.
 --questslevel  = The level you have to be to do this quest.
 --questtatus?  = Get the quest status of the players.
 --demon?pos  = The position of the demons.
 --nplayer?pos  = The position where the players should be teleported too.
 --trash= position to send the demons to when clearing, 1 sqm in middle of nowhere is enough
 -- starting = Upper left point of the annihilator room area.
 -- ending = Bottom right point of the annihilator room area.
 
 --UniqueIDs used:

 --5000 = The switch.
 --5001 = Demon Armor chest.
 --5002 = Magic Sword chest.
 --5003 = Stonecutter Axe chest.
 --5004 = Present chest.


function onUse(cid, item, frompos, item2, topos)
if item.uid == 5000 then
 if item.itemid == 1946 then

 player1pos = {x=1066, y=531, z=7, stackpos=253}
 player1 = getThingfromPos(player1pos)

 player2pos = {x=1065, y=531, z=7, stackpos=253}
 player2 = getThingfromPos(player2pos)

 player3pos = {x=1064, y=531, z=7, stackpos=253}
 player3 = getThingfromPos(player3pos)

 player4pos = {x=1063, y=531, z=7, stackpos=253}
 player4 = getThingfromPos(player4pos)


	 if player1.itemid > 0 and player2.itemid > 0 and player3.itemid > 0 and player4.itemid > 0 then

  player1level = getPlayerLevel(player1.uid)
  player2level = getPlayerLevel(player2.uid)
  player3level = getPlayerLevel(player3.uid)
  player4level = getPlayerLevel(player4.uid)

  questlevel = 100

  if player1level >= questlevel and player2level >= questlevel and player3level >= questlevel and player4level >= questlevel then

	  queststatus1 = getPlayerStorageValue(player1.uid,100)
	  queststatus2 = getPlayerStorageValue(player2.uid,100)
	  queststatus3 = getPlayerStorageValue(player3.uid,100)
	  queststatus4 = getPlayerStorageValue(player4.uid,100)

	  if queststatus1 == -1 and queststatus2 == -1 and queststatus3 == -1 and queststatus4 == -1 then
	--if 1==1 then
	demon1pos = {x=1059, y=483, z=7}
	demon2pos = {x=1058, y=487, z=7}
	demon3pos = {x=1060, y=487, z=7}
	demon4pos = {x=1061, y=483, z=7}
	demon5pos = {x=1063, y=485, z=7}
	demon6pos = {x=1064, y=485, z=7}
 
   doSummonCreature("Orshabaal", demon1pos)
   doSummonCreature("Orshabaal", demon2pos)
   doSummonCreature("Orshabaal", demon3pos)
   doSummonCreature("Orshabaal", demon4pos)
   doSummonCreature("Orshabaal", demon5pos)
   doSummonCreature("Orshabaal", demon6pos)

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

	 doTransformItem(item.uid,1945)

	else
	 doPlayerSendCancel(cid,"Sorry, not possible.")
	end
   else
	doPlayerSendCancel(cid,"Sorry, not possible.")
   end
  else
  doPlayerSendCancel(cid,"Sorry, not possible.")
  end
 end
 if item.itemid == 1945 then
-- Here is the code start:
starting={x=541, y=709, z=10, stackpos=253}
checking={x=starting.x, y=starting.y, z=starting.z, stackpos=starting.stackpos}
ending={x=559, y=716, z=10, stackpos=253}
players=0
totalmonsters=0
monster = {}
repeat
creature= getThingfromPos(checking)
 if creature.itemid > 0 then
 if getPlayerAccess(creature.uid) == 0 then
 players=players+1
 end
  if getPlayerAccess(creature.uid) ~= 0 and getPlayerAccess(creature.uid) ~= 3 then
 totalmonsters=totalmonsters+1
  monster[totalmonsters]=creature.uid
   end
 end
checking.x=checking.x+1
  if checking.x>ending.x then
  checking.x=starting.x
  checking.y=checking.y+1
 end
until checking.y>ending.y
if players==0 then
trash= {x=557, y=722, z=10}
current=0
repeat
current=current+1
doTeleportThing(monster[current],trash)
until current>=totalmonsters
doTransformItem(item.uid,1946)
end
end
end
end
-- Here is the end of it