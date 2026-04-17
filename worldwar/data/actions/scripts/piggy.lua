function onUse(cid, item, frompos, item2, topos)
	doTransformItem(item.uid,item.itemid+1)
	fate = math.random(1,100)
	amount = math.random(1,100)
	if amount == 1 then
		coinText = "coin"
	else
		coinText = "coins"
	end
	if fate == 100 then -- jackpot ! xD
		foundCoins = 1
		coinType = " crystal "
		doPlayerAddItem(cid, 2160, amount)
	elseif fate >= 65 and fate < 100 then
		foundCoins = 1
		coinType = " platinum "
		doPlayerAddItem(cid, 2152, amount)
	elseif fate >= 20 and fate < 65 then
		foundCoins = 1
		coinType = " gold "
		doPlayerAddItem(cid, 2148, amount)
	elseif fate >= 1 and fate < 20 then
		foundCoins = 0
	end
	if foundCoins == 1 then
		doPlayerSendTextMessage(cid,22,"Your fate smiles to you...\nYou have found " .. amount .. coinType .. coinText .. ".")
	else
		doPlayerSendTextMessage(cid,22,"You're just unlucky today.\nYou found nothing...")
	end
	return 1
end