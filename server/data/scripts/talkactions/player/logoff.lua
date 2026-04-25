local logoff = TalkAction("!logoff")

function logoff.onSay(player, words, param)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "Force logging off...")
	player:remove()
	return false
end

logoff:register()
