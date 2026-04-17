--Invasion script
-- By Tworn
--Variables that need to be set according to your map/desire:
--topleft=the top left cordinate of the invasion area
--bottonright= the botton right cordinate of the invasion area
--maxmonsters= the maximum number of monsters that will appear. Set it "nil" for no monster limit.
--spawnrate= the chance of a monster appearing in a square of the invasion area
--species= the odds that determine what kind of monster will be summoned
-- DO NOT CHANGE THE FOLLOWING VARIABLES: checking, summonedtotal, checkforsummon.

function onUse(cid, item, frompos, item2, topos)
if getPlayerAccess(cid) ~=0 then
topleft={x=431, y=490, z=7}
bottonright={x=472, y=509, z=7}
maxmonsters= 50

checking={x=topleft.x, y=topleft.y, z=topleft.z} --Do Not Change
summonedtotal=0 --Do Not Change
repeat
checkforsummon=0 --Do Not Change
spawnrate=math.random(0,10)
if spawnrate==0 and summonedtotal ~= maxmonsters then
species=math.random(1,10)
				if species == 1 then
					checkforsummon = doSummonCreature("necromancer",checking)
				elseif species == 2 then					
					checkforsummon = doSummonCreature("vampire",checking)
				elseif species == 3 then
					checkforsummon = doSummonCreature("priestess",checking)
				elseif species == 4 then
					checkforsummon = doSummonCreature("demon skeleton",checking)
				elseif species == 5 then
					checkforsummon = doSummonCreature("crypt shambler",checking)
				elseif species == 6 then
					checkforsummon = doSummonCreature("lich",checking)
				elseif species == 7 then
					checkforsummon = doSummonCreature("ghoul",checking)
				elseif species == 8 then
					checkforsummon = doSummonCreature("banshee",checking)
				else
					checkforsummon = doSummonCreature("Skeleton",checking)
				end
if checkforsummon~= 0 then
summonedtotal=summonedtotal+1
end
end
checking.x=checking.x+1
  if checking.x>bottonright.x then
  checking.x=topleft.x
  checking.y=checking.y+1
 end
until checking.y>bottonright.y
doPlayerSay(cid,"/B The undead raised from their graves to plague the Chaos Plains!, 1")
print("Undead Invasion Triggered. Number of Creatures Summoned:",summonedtotal)
end
return 1
end