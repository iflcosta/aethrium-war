-- Coin Machine made by geen idee 19:59 23-7-2006 CET --
function onUse(cid, item, frompos, item2, topos)

win = math.random(1,2)
cashtype = math.random(1,55)
cash = 100

		if item.itemid == 1946 then
		doTransformItem(item.uid,item.itemid-1)
		elseif item.itemid == 1945 then
		doTransformItem(item.uid,item.itemid+1)
		end
	-->How much it costs	if doPlayerRemoveMoney(cid,100) == 1 and win > 0 and win < 2 then
			doPlayerSendTextMessage(cid,22,"You bet 100 coins and got nothing!")
	-->How much it costs	elseif doPlayerRemoveMoney(cid,100) == 1 and win > 1 and win < 3 then
				if cashtype > 0 and cashtype < 2 then
	--> all winnings	doPlayerAddItem(cid,2160,1)
				doPlayerSendTextMessage(cid,22,"CONGRATULATIONS! You bet 100 coins and won 10000 gps!")
				elseif cashtype > 1 and cashtype < 4 then
				doPlayerAddItem(cid,2152,50)
				doPlayerSendTextMessage(cid,22,"Congratulations! You bet 100 coins and won 5000 gps!")
				elseif cashtype > 3 and cashtype < 7 then
				doPlayerAddItem(cid,2152,30)
				doPlayerSendTextMessage(cid,22,"You bet 100 coins and won 3000 gps!")
				elseif cashtype > 6 and cashtype < 11 then
				doPlayerAddItem(cid,2152,10)
				doPlayerSendTextMessage(cid,22,"You bet 100 coins and won 1000 gps!")
				elseif cashtype > 10 and cashtype < 16 then
				doPlayerAddItem(cid,2152,5)
				doPlayerSendTextMessage(cid,22,"You bet 100 coins and won 500 gps!")
				elseif cashtype > 15 and cashtype < 23 then
				doPlayerAddItem(cid,2152,2)
				doPlayerSendTextMessage(cid,22,"You bet 100 coins and won 200 gps!")
				elseif cashtype > 22 and cashtype < 31 then
				doPlayerAddItem(cid,2148,100)
				doPlayerSendTextMessage(cid,22,"You bet 100 coins and won 100 gps!")
				elseif cashtype > 30 and cashtype < 40 then
				doPlayerAddItem(cid,2148,50)
				doPlayerSendTextMessage(cid,22,"You bet 100 coins and won 50 gps!")
				elseif cashtype > 39 and cashtype < 51 then
				doPlayerAddItem(cid,2148,25)
				doPlayerSendTextMessage(cid,22,"You bet 100 coins and won 25 gps!")
			else
				doPlayerSendCancel(cid,"You need 100 Gold Coins to bet.")
				end
		end
end