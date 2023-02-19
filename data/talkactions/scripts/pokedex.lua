function onSay(player, words, param)
    local monsterType = MonsterType(param)
    if not monsterType then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Please type a valid pokemon name")
        return false
    end

    local monsterNumber = monsterType:dexEntry()
    local storage = baseStorageDex + monsterNumber
    if player:getStorageValue(storage) == -1 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You need to pokedex this pokemon first!")
        return false
    end
    
	local output = "Pokedex of " .. param .. "\n"

	local race = monsterType:getRaceName()
	local race2 = monsterType:getRace2Name()
	local raceName = race
	if race2 ~= "none" then
		raceName = raceName .. "/" .. race2
	end

	local moveList = monsterType:getMoveList()
	if #moveList >= 1 then
		output = output .. "Moves:"
		for i = 1, #moveList do
			local move = moveList[i]
			if move then
				output = output .. "\n" .. moveWords[i] .. " - \t" .. move.name .. ". Cooldown: \t" .. move.speed / 1000 .. " seconds."
			else
				break
			end
		end
	end
	local evolutionList = monsterType:getEvolutionList()
	if #evolutionList >= 1 then
		output = output .. "\n\nEvolutions:" .. "\n"
		for i = 1, #evolutionList do
			local evolution = evolutionList[i]
			local evolutionName = evolution.name
			if evolutionName ~= "" then
				output = output .. "\nEvolves to " .. evolutionName .. " at level " .. evolution.level .. " with probability of " .. evolution.chance .. " percent "
				if evolution.itemName then
					output = output .. "or by using " .. evolution.count .. " " .. evolution.itemName
				end
			end
		end
	else
		output = output .. "\n\nThis monster does not evolve.\n"
	end
	if monsterType:isFlyable() > 0 or monsterType:isRideable() > 0 or monsterType:isSurfable() > 0 or monsterType:canTeleport() > 0 or race == "rock" or race2 == "rock" or race == "grass" or race2 == "grass" or race == "ground" or race2 == "ground" or race == "fighting" or race2 == "fighting" or param == "Ditto" or param == "Shiny Ditto" then
		output = output .. "\nHabilities:"
		if monsterType:isFlyable() > 0 then 
			output = output .. "\nFly"
		end
		if monsterType:isRideable() > 0 then 
			output = output .. "\nRide"
		end
		if monsterType:isSurfable() > 0 then 
			output = output .. "\nSurf"
		end
		if monsterType:canTeleport() > 0 then 
			output = output .. "\nTeleport"
		end
		if monsterType:getRaceName() == "rock" or monsterType:getRace2Name() == "rock" or monsterType:getRaceName() == "fighting" or monsterType:getRace2Name() == "fighting" then 
			output = output .. "\nRock Smash"
		end
		if monsterType:getRaceName() == "grass" or monsterType:getRace2Name() == "grass" then 
			output = output .. "\nCut"
		end
		if monsterType:getRaceName() == "ground" or monsterType:getRace2Name() == "ground" then 
			output = output .. "\nDig"
		end
		if param == "Ditto" or param == "Shiny Ditto" then 
			output = output .. "\nTransform"
		end
	else
		output = output .. "\nThis monster has no habilities."
	end

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, output)
    return false
end