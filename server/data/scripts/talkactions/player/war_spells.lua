local spellsCmd = TalkAction("!spells")

function spellsCmd.onSay(player, words, param)
    local instantSpells = player:getInstantSpells()
    if #instantSpells == 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You don't have any spells available for your vocation.")
        return false
    end

    local text = "Spellbook for " .. player:getVocation():getName() .. ":\n\n"
    local spellsByLevel = {}

    for _, spell in ipairs(instantSpells) do
        if spell.level and spell.level > 0 then
            table.insert(spellsByLevel, spell)
        end
    end

    -- Sort spells by level
    table.sort(spellsByLevel, function(a, b) return a.level < b.level end)

    for _, spell in ipairs(spellsByLevel) do
        text = text .. string.format("[%d] %-20s : %-20s (Mana: %d)\n", 
            spell.level, spell.name, spell.words, spell.mana)
    end

    player:showTextDialog(2175, text)
    return false
end

spellsCmd:separator(" ")
spellsCmd:register()
