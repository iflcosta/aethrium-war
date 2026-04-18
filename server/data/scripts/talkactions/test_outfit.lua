local talkAction = TalkAction("!outfit")

function talkAction.onSay(player, words, param)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Trying to open outfit window...")
    player:sendOutfitWindow()
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "If the window didn't open, the client ignored the server packet!")
    return false
end

talkAction:register()
