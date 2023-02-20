function canJoin(player)
	if player:getGroup():getAccess() then
		return true
	end

	return false
end

local function cleanGlobalVariables()
	_G["cid"] = nil
	_G["player"] = nil
	_G["creature"] = nil
	_G["pos"] = nil
	_G["tile"] = nil
	_G["container"] = nil
	_G["group"] = nil
	_G["vocation"] = nil
	_G["town"] = nil
	_G["house"] = nil
	_G["party"] = nil
end

function onSpeak(player, type, message)
	local pos = Position(player:getPosition())
	local tile = Tile(pos)

	_G["cid"] = player:getId()
	_G["player"] = player
	_G["creature"] = Creature(player:getId())
	_G["pos"] = pos
	_G["tile"] = tile
	_G["container"] = player:getSlotItem(CONST_SLOT_BACKPACK)
	_G["group"] = player:getGroup()
	_G["vocation"] = player:getVocation()
	_G["town"] = player:getTown()
	_G["house"] = tile:getHouse()
	_G["party"] = player:getParty()

	local res, err = loadstring(message)
	if res then
		local ret, err = pcall(res)
		if not ret then
			player:sendChannelMessage(player:getName(), "Lua Script Error: " .. err .. ".", TALKTYPE_CHANNEL_O, CHANNEL_LUATESTING)
			cleanGlobalVariables()
			return false
		end
	else
		player:sendChannelMessage(player:getName(), "Lua Script Error: " .. err .. ".", TALKTYPE_CHANNEL_O, CHANNEL_LUATESTING)
		cleanGlobalVariables()
		return false
	end

	player:sendChannelMessage("", player:getName() .. ">>  " .. message, TALKTYPE_CHANNEL_Y, CHANNEL_LUATESTING)
	cleanGlobalVariables()
	return false
end