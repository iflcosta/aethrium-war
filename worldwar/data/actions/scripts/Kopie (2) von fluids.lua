-- fluids by atolon and Danger II --

   function onUse(cid, item, frompos, item2, topos)
   	-- itemid means that is a creature
   	if item2.itemid == 1 then
   		if item.type == 0 then
   			doPlayerSendCancel(cid,"It is empty.")
   		else
   			if item2.uid == cid then
   				doChangeTypeItem(item.uid,0)
   				if item.type == 2 then
   					doPlayerSay(cid,"it was blood....",16)
   				elseif item.type == 4 then
   					doPlayerSay(cid,"it was slime!!",16)
                                           doSendMagicEffect(topos,8)
   				elseif item.type == 3 then
					doPlayerSay(cid,"hit! hit! fresh beer!!",16)
					doPlayerSetDrunk(cid, 60*1000)
   				elseif item.type == 5 then
   					doPlayerSay(cid,"it was fresh lemonade!!",16)
   				elseif item.type == 11 then
   					doPlayerSay(cid,"arrg is oil!!",16)
   				elseif item.type == 15 then
					doPlayerSay(cid,"hit! hit! is wine",16)
					doPlayerSetDrunk(cid, 60*1000)
   				elseif item.type == 6 then
   					doPlayerSay(cid,"ohh is milk!",16)
   				elseif item.type == 10 then
   					doPlayerAddHealth(cid,100)
                                           doSendMagicEffect(topos,12)
   				elseif item.type == 13 then
   					doPlayerSay(cid,"arrg is urine!",16)
   				elseif item.type == 7 then
   					doPlayerAddMana(cid,300)
                                           doSendMagicEffect(topos,12)
  							 doRemoveItem(item.uid,1)
   					doPlayerSay(cid,"Aaaaah...",1)
   				elseif item.type == 19 then
   					doPlayerSay(cid,"arrg is mud!",16)
   				elseif item.type == 26 then
   					doPlayerSay(cid,"arrg hot on my mouth!",16)
                                           doSendMagicEffect(topos,6)
   				elseif item.type == 28 then
   					doPlayerSay(cid,"arrg swamp water!",16)
                                           doSendMagicEffect(topos,8)
   				else
   					doPlayerSay(cid,"Gulp.",1)
   				end
   			else
			doPlayerSendCancel(cid, "You can not put this on the ground.")
   			end
end

   -- Blood/swamp in decayto corpse --NO FINISH--


   -- End Blood/swamp in decayto corpse --NO FINISH--

   	else
   		if item.type == 0 then
   			doPlayerSendCancel(cid,"It is empty.")
   		else
			doPlayerSendCancel(cid, "You can not put this on the ground.")
   	end

   	return 1
   end
end