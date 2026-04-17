function onUse(cid, item, frompos, item2, topos)

  	-- bright sword quest
  	if item.uid == 5001 then
  		queststatus = getPlayerStorageValue(cid,5001)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 20 then
  				doPlayerSendTextMessage(cid,22,"You have found Bright Sword.")
  				doPlayerAddItem(cid,3233,1)
  				setPlayerStorageValue(cid,5001,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 20 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end

  	-- orc fortress quest
  	elseif item.uid == 5002 then
  		queststatus = getPlayerStorageValue(cid,5002)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 50 then
  				doPlayerSendTextMessage(cid,22,"You have found Golden Armor.")
  				doPlayerAddItem(cid,3298,1)
  				setPlayerStorageValue(cid,5002,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 50 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end

  	-- pharaon quest
  	elseif item.uid == 5003 then
  		queststatus = getPlayerStorageValue(cid,5003)
  		if queststatus == -1 then			if getPlayerLevel(cid) >= 50 then
  				doPlayerSendTextMessage(cid,22,"You have found Dragon Lance.")
  				doPlayerAddItem(cid,3240,1)
  				setPlayerStorageValue(cid,5003,1)
  			else				doPlayerSendTextMessage(cid,22,"You need level 50 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end
  	elseif item.uid == 5004 then
  		queststatus = getPlayerStorageValue(cid,5003)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 50 then
  				doPlayerSendTextMessage(cid,22,"You have found War Hammer.")
  				doPlayerAddItem(cid,3217,1)
  				setPlayerStorageValue(cid,5003,1)
  			else				doPlayerSendTextMessage(cid,22,"You need level 50 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end	elseif item.uid == 5017 then
  		queststatus = getPlayerStorageValue(cid,5003)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 50 then
  				doPlayerSendTextMessage(cid,22,"You have found Giant Sword.")
  				doPlayerAddItem(cid,3219,1)
  				setPlayerStorageValue(cid,5003,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 50 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end

  	-- demon quest
  	elseif item.uid == 5005 then
  		queststatus = getPlayerStorageValue(cid,5005)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 60 then
  				doPlayerSendTextMessage(cid,22,"You have found Steel Boots.")
  				doPlayerAddItem(cid,3492,1)
  				setPlayerStorageValue(cid,5005,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 60 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end

  	-- annihilator
  	elseif item.uid == 5006 then
  		queststatus = getPlayerStorageValue(cid,5010)
  		if queststatus == -1 then
  			doPlayerSendTextMessage(cid,22,"You have found a Demon Armor.")
  			doPlayerAddItem(cid,3326,1)
  			setPlayerStorageValue(cid,5010,1)
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end
  	elseif item.uid == 5007 then
  		queststatus = getPlayerStorageValue(cid,5010)
  		if queststatus == -1 then
  			doPlayerSendTextMessage(cid,22,"You have found a Sword of Valor.")
  			doPlayerAddItem(cid,3226,1)
  			setPlayerStorageValue(cid,5010,1)
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end
  	elseif item.uid == 5008 then
  		queststatus = getPlayerStorageValue(cid,5010)
  		if queststatus == -1 then
  			doPlayerSendTextMessage(cid,22,"You have found a Stonecutter's Axe.")
  			doPlayerAddItem(cid,3257,1)
  			setPlayerStorageValue(cid,5010,1)
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end
  	elseif item.uid == 5009 then
  		queststatus = getPlayerStorageValue(cid,5010)
  		if queststatus == -1 then
  			doPlayerSendTextMessage(cid,22,"You have a Thunder Hammer.")
  			doPlayerAddItem(cid,3247,1)
  			setPlayerStorageValue(cid,5010,1)
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end	-- elf camp quest
  	elseif item.uid == 5013 then
  		queststatus = getPlayerStorageValue(cid,5013)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 20 then
  				doPlayerSendTextMessage(cid,22,"You have found Dragon Hammer.")
  				doPlayerAddItem(cid,3260,1)
  				setPlayerStorageValue(cid,5013,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 20 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end	-- banshee quest
  	elseif item.uid == 5014 then
  		queststatus = getPlayerStorageValue(cid,5014)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 20 then
  				doPlayerSendTextMessage(cid,22,"You have found Amazon Shield.")
  				doPlayerAddItem(cid,3375,1)
  				setPlayerStorageValue(cid,5014,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 20 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end

  	-- slime quest
  	elseif item.uid == 5015 then
  		queststatus = getPlayerStorageValue(cid,5015)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 12 then
  				doPlayerSendTextMessage(cid,22,"You have found Brass Legs and Dark Shield.")
  				doPlayerAddItem(cid,3310,1)
  				doPlayerAddItem(cid,3359,1)
  				setPlayerStorageValue(cid,5015,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 12 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end	-- necro quest
  	elseif item.uid == 5016 then
  		queststatus = getPlayerStorageValue(cid,5016)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 20 then
  				doPlayerSendTextMessage(cid,22,"You have found Knight Legs.")
  				doPlayerAddItem(cid,3309,1)
  				setPlayerStorageValue(cid,5016,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 20 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end

  	-- ship quest
  	elseif item.uid == 5018 then
  		queststatus = getPlayerStorageValue(cid,5018)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 40 then
  				doPlayerSendTextMessage(cid,22,"You have found Helmet of the Ancients.")
  				doPlayerAddItem(cid,3167,1)
  				setPlayerStorageValue(cid,5018,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 40 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end

  	-- steering patent
  	-- storage value 5019

  	-- omegilator
  	elseif item.uid == 5020 then
  		queststatus = getPlayerStorageValue(cid,5020)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 100 then
  				doPlayerSendTextMessage(cid,22,"You have found Helmet of the Ancients.")
  				doPlayerAddItem(cid,3168,1)
  				setPlayerStorageValue(cid,5020,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 100 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end

	-- hydra quest
	elseif item.uid == 5022 then
  		queststatus = getPlayerStorageValue(cid,5022)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 40 then
  				doPlayerSendTextMessage(cid,22,"You have found Shield of Honour.")
  				doPlayerAddItem(cid,3355,1)
  				setPlayerStorageValue(cid,5022,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 40 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end	-- yeti quest
	elseif item.uid == 5023 then
  		queststatus = getPlayerStorageValue(cid,5023)
  		if queststatus == -1 then
  			if getPlayerLevel(cid) >= 20 then
  				doPlayerSendTextMessage(cid,22,"You have found Lady Helmet.")
  				doPlayerAddItem(cid,3331,1)
  				setPlayerStorageValue(cid,5023,1)
  			else
  				doPlayerSendTextMessage(cid,22,"You need level 20 to get prize.")
  			end
  		else
  			doPlayerSendTextMessage(cid,22,"It is empty.")
  		end

  	end
  	return 1
  end
