local eventPos = {682, 1204, 6}
local rangeTeleport = 5
local npcPos = {649, 1203, 5}

local function cleanArena()
	local tile = Tile(npcPos[1], npcPos[2], npcPos[3])
	if tile and tile:getCreatureCount() > 0 then
		for i = 1, tile:getCreatureCount() do
			if tile:getCreatures()[i]:isMonster() or tile:getCreatures()[i]:isNpc() and not tile:getCreatures()[i]:isPokemon() then
				tile:getCreatures()[i]:remove()
			end
		end
	end
	return true
end

local function bagEventStop()
	print("WARNING! Closing bag event awarded.")
	cleanArena()
	local raids = {"Christmas Saffron", "Halloween Saffron"}
	Game.startRaid(raids[math.random(1, #raids)])
end

local function bagEventTryStop()
	local playersRemaining = 0
	for x = eventPos[1] - rangeTeleport, eventPos[1] + rangeTeleport do
		for y = eventPos[2] - rangeTeleport, eventPos[2] + rangeTeleport do
			local tile = Tile(x, y, eventPos[3])
			if tile and tile:getCreatureCount() > 0 then
				playersRemaining = playersRemaining + tile:getCreatureCount()
			end
		end
	end
	for x = 651, 673 do
		local tile = Tile(x, 1203, 5)
		if tile and tile:getCreatureCount() > 0 then
			playersRemaining = playersRemaining + tile:getCreatureCount()
		end
	end
	print("WARNING! Players still in the awarded bag event arena: " .. playersRemaining)
	if playersRemaining == 0 then
		bagEventStop()
	else
		addEvent(bagEventTryStop, 2 * 60 * 1000)
	end
end

local function bagEventStart()
	broadcastMessage("Registration for bag event closed! Players being transported to the event.", MESSAGE_STATUS_WARNING)
	local players = Game.getPlayers()
	for i = 1, #players do
		local player = players[i]
		if player:getStorageValue(storageBagEvent) > 0 then
			local randomPosx = eventPos[1] + math.random(-rangeTeleport, rangeTeleport)
			local randomPosy = eventPos[2] + math.random(-rangeTeleport, rangeTeleport)
			local teleportPosition = Position(randomPosx, randomPosy, eventPos[3])
			player:teleportTo(teleportPosition)
			player:setStorageValue(storageBagEvent, -1)
		end
	end
	Game.createNpc("Erin", Position(npcPos[1], npcPos[2], npcPos[3]))
	bagEventIsOpen = false
	addEvent(bagEventTryStop, 8 * 60 * 1000)
end

local function fifthBagEventWarning()
	broadcastMessage("Prize bag event will start in 1 minute. To sign up, you must be level 5 and you must say hi and then bag to the NPC Manager at the Saffron CP. Registration will be closed in 1 minute.", MESSAGE_STATUS_WARNING)
	addEvent(bagEventStart, 1 * 60 * 1000)
end

local function fourthBagEventWarning()
	broadcastMessage("Prize bag event will start in 2 minutes. To sign up, you must be level 5 and you must say hi and then bag to the NPC Manager in the Saffron CP.", MESSAGE_STATUS_WARNING)
	addEvent(fifthBagEventWarning, 1 * 60 * 1000)
end

local function thirdBagEventWarning()
	broadcastMessage("Prize bag event will start in 4 minutes. To sign up, you must be level 5 and you must say hi and then bag to the NPC Manager in the Saffron CP.", MESSAGE_STATUS_WARNING)
	addEvent(fourthBagEventWarning, 2 * 60 * 1000)
end

local function secondBagEventWarning()
	broadcastMessage("Prize bag event will start in 6 minutes. To sign up, you must be level 5 and you must say hi and then bag to the NPC Manager in the Saffron CP.", MESSAGE_STATUS_WARNING)
	addEvent(thirdBagEventWarning, 2 * 60 * 1000)
end

local function firstBagEventWarning()
	broadcastMessage("Prize bag event will start in 8 minutes. To sign up, you must be level 5 and you must say hi and then bag to the NPC Manager in the Saffron CP.", MESSAGE_STATUS_WARNING)
	addEvent(secondBagEventWarning, 2 * 60 * 1000)
end

function onThink(interval)
	local hour = os.date("%H")
	if hour % 2 == 1 then
		return true
	end
	if Game.getPlayerCount() < 2 then
		return true
	end
	ipsSub = {}
	broadcastMessage("Prize bag event will start in 10 minutes. To sign up, you must be level 5 and you must say hi and then bag to the NPC Manager in the Saffron CP.", MESSAGE_STATUS_WARNING)
	bagEventIsOpen = true
	addEvent(firstBagEventWarning, 2 * 60 * 1000)
	return true
end
