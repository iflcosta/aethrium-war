
function onUse(cid, item, frompos, item2, topos)

 if item.uid == 1000 then 
	queststatus = getPlayerStorageValue(cid,1000) 
	if queststatus == -1 then 
		doPlayerSendTextMessage(cid,22,"You have found a demon helmet.") 
		doPlayerAddItem(cid,2493,1) 
		setPlayerStorageValue(cid,1000,1) 
 	else 
		doPlayerSendTextMessage(cid,22,"It is empty.") 
 	end 
 end 
 if item.uid == 1001 then 
	queststatus = getPlayerStorageValue(cid,1001) 
	if queststatus == -1 then 
		doPlayerSendTextMessage(cid,22,"You have found a demon shield.") 
		doPlayerAddItem(cid,2520,1) 
		setPlayerStorageValue(cid,1001,1) 
 	else 
		doPlayerSendTextMessage(cid,22,"It is empty.") 
 	end 
 end 

 if item.uid == 1002 then 
	queststatus = getPlayerStorageValue(cid,1002) 
	if queststatus == -1 then 
		doPlayerSendTextMessage(cid,22,"You have found steel boots.") 
		doPlayerAddItem(cid,2645,1) 
		setPlayerStorageValue(cid,1002,1) 
 	else 
		doPlayerSendTextMessage(cid,22,"It is empty.") 
 	end 
 end 

 if item.uid == 1003 then 
	queststatus = getPlayerStorageValue(cid,1003) 
	if queststatus == -1 then 
		doPlayerSendTextMessage(cid,22,"You have found a blue robe.") 
		doPlayerAddItem(cid,2656,1) 
		setPlayerStorageValue(cid,1003,1) 
 	else 
		doPlayerSendTextMessage(cid,22,"It is empty.") 
 	end 
 end 

 if item.uid == 1004 then 
	queststatus = getPlayerStorageValue(cid,1004) 
	if queststatus == -1 then 
		doPlayerSendTextMessage(cid,22,"You have found crown legs.") 
		doPlayerAddItem(cid,2488,1) 
		setPlayerStorageValue(cid,1004,1) 
 	else 
		doPlayerSendTextMessage(cid,22,"It is empty.") 
 	end 
 end 

 if item.uid == 1005 then 
	queststatus = getPlayerStorageValue(cid,1005) 
	if queststatus == -1 then 
		doPlayerSendTextMessage(cid,22,"You have found a pharao sword.") 
		doPlayerAddItem(cid,3272,1) 
		setPlayerStorageValue(cid,1005,1) 
 	else 
		doPlayerSendTextMessage(cid,22,"It is empty.") 
 	end 
 end 

if item.uid == 5001 then
 queststatus = getPlayerStorageValue(cid,5001)
 if queststatus == -1 then
  doPlayerSendTextMessage(cid,22,"You have found a demon armor.")
  doPlayerAddItem(cid,2494,1)
  setPlayerStorageValue(cid,5001,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 5002 then
 queststatus = getPlayerStorageValue(cid,5001)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a magic sword.")
  doPlayerAddItem(cid,2400,1)
  setPlayerStorageValue(cid,5001,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 5003 then
 queststatus = getPlayerStorageValue(cid,5001)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a stonecutter axe.")
  doPlayerAddItem(cid,2431,1)
  setPlayerStorageValue(cid,5001,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 5004 then
 queststatus = getPlayerStorageValue(cid,5001)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a thunder hammer.")
  doPlayerAddItem(cid,2421,1)
  setPlayerStorageValue(cid,5001,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 6623 then
 queststatus = getPlayerStorageValue(cid,6623)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a dragon scale mail.")
  doPlayerAddItem(cid,2492,1)
  setPlayerStorageValue(cid,6623,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 7779 then
 queststatus = getPlayerStorageValue(cid,7779)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found an eagle shield.")
  doPlayerAddItem(cid,2538,1)
  setPlayerStorageValue(cid,7779,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 7778 then
 queststatus = getPlayerStorageValue(cid,7778)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found traper boots.")
  doPlayerAddItem(cid,2641,1)
  setPlayerStorageValue(cid,7778,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 2432 then
 queststatus = getPlayerStorageValue(cid,2432)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found an amazon armor.")
  doPlayerAddItem(cid,2500,1)
  setPlayerStorageValue(cid,2432,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 6430 then
 queststatus = getPlayerStorageValue(cid,6430)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a crystal wand.")
  doPlayerAddItem(cid,2184,1)
  setPlayerStorageValue(cid,6430,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 6431 then
 queststatus = getPlayerStorageValue(cid,6431)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a sudden death rune.")
  doPlayerAddItem(cid,2268,2)
  setPlayerStorageValue(cid,6431,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 4444 then
 queststatus = getPlayerStorageValue(cid,4444)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a dragon lance.")
  doPlayerAddItem(cid,2414,1)
  setPlayerStorageValue(cid,4444,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 1111 then
 queststatus = getPlayerStorageValue(cid,1111)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a golden armor.")
  doPlayerAddItem(cid,2466,1)
  setPlayerStorageValue(cid,1111,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 1112 then
 queststatus = getPlayerStorageValue(cid,1112)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a demon shield.")
  doPlayerAddItem(cid,2520,1)
  setPlayerStorageValue(cid,1112,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 1113 then
 queststatus = getPlayerStorageValue(cid,1113)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a giant sword.")
  doPlayerAddItem(cid,2393,1)
  setPlayerStorageValue(cid,1113,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 3333 then
 queststatus = getPlayerStorageValue(cid,3333)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a soul ruby.")
  doPlayerAddItem(cid,2363,1)
  setPlayerStorageValue(cid,3333,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 2221 then
 queststatus = getPlayerStorageValue(cid,2221)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a crown armor.")
  doPlayerAddItem(cid,2487,1)
  setPlayerStorageValue(cid,2221,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 2222 then
 queststatus = getPlayerStorageValue(cid,2222)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a crown shield.")
  doPlayerAddItem(cid,2519,1)
  setPlayerStorageValue(cid,2222,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 4531 then
 queststatus = getPlayerStorageValue(cid,4531)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a dragon lance.")
  doPlayerAddItem(cid,2414,1)
  setPlayerStorageValue(cid,4531,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 4532 then
 queststatus = getPlayerStorageValue(cid,4532)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a vampire shield.")
  doPlayerAddItem(cid,2534,1)
  setPlayerStorageValue(cid,4532,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 5413 then
 queststatus = getPlayerStorageValue(cid,5413)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a mastermind shield.")
  doPlayerAddItem(cid,2514,1)
  setPlayerStorageValue(cid,5413,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

if item.uid == 5325 then
 queststatus = getPlayerStorageValue(cid,5325)
 if queststatus ~= 1 then
  doPlayerSendTextMessage(cid,22,"You have found a bright sword.")
  doPlayerAddItem(cid,2407,1)
  setPlayerStorageValue(cid,5325,1)
 else
  doPlayerSendTextMessage(cid,22,"It is empty.")
 end
end

 return 1 
end

