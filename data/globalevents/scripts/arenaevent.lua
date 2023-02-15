local secondsBetweenRaids = 15
local eventFromPos = {646, 1198, 6}
local eventToPos = {670, 1208, 6}
local raids = {"ArenaRaticate", "ArenaOnix", "ArenaVileplume", "ArenaCharizard", "ArenaLendarios", "ArenaLendarios2", "ArenaLendarios4", "ArenaLendarios3", "ArenaLendarios3"}
local prizes = {[1] = {item = "crystal coin", count = 10}, [2] = {item = "empty premierball", count = 50}}

local function cleanArena()
	for x = eventFromPos[1], eventToPos[1] do
		for y = eventFromPos[2], eventToPos[2] do
			local tile = Tile(x, y, eventFromPos[3])
			if tile and tile:getCreatureCount() > 0 then
				for i = 1, tile:getCreatureCount() do
					if tile:getCreatures()[i]:isMonster() and not tile:getCreatures()[i]:isPokemon() then
						tile:getCreatures()[i]:remove()
					end
				end
			end
		end
	end
	return true
end

local function arenaEventStop()
	print("WARNING! Closing gold arena event.")
	isArenaEventRunning = false
	local winner = Player(arenaLastPlayerId)
	if winner then
		broadcastMessage("Gold Arena Event Finished! The winner was: " .. winner:getName() .. ". Congratulations!", MESSAGE_STATUS_WARNING)
		for _,value in pairs(prizes) do
			winner:addItem(value.item, value.count)
		end
	else
		print("WARNING! gold arena without a winner!")
	end
	cleanArena()
	local raids = {"Christmas Saffron", "Halloween Saffron"}
	Game.startRaid(raids[math.random(1, #raids)])
	return true
end

function arenaEventTryStop()
	local playersRemaining = 0
	for x = eventFromPos[1], eventToPos[1] do
		for y = eventFromPos[2], eventToPos[2] do
			local tile = Tile(x, y, eventFromPos[3])
			if tile and tile:getCreatureCount() > 0 then
				for i = 1, tile:getCreatureCount() do
					if tile:getCreatures()[i]:isPlayer() and tile:getCreatures()[i]:getAccountType() < ACCOUNT_TYPE_GAMEMASTER then
						playersRemaining = playersRemaining + 1
					end
				end
			end
		end
	end
	print("WARNING! Players still in the gold event arena: " .. playersRemaining)
	if playersRemaining == 0 then
		arenaEventStop()
	end
end

local function getCreatureCountArena()
	local creaturesRemaining = 0
	for x = eventFromPos[1], eventToPos[1] do
		for y = eventFromPos[2], eventToPos[2] do
			local tile = Tile(x, y, eventFromPos[3])
			if tile and tile:getCreatureCount() > 0 then
				for i = 1, tile:getCreatureCount() do
					if tile:getCreatures()[i]:isMonster() and not tile:getCreatures()[i]:isPokemon() then
						creaturesRemaining = creaturesRemaining + 1
					end
				end
			end
		end
	end
	return creaturesRemaining
end

local function tryStartRaid(actualRaid)
	if isArenaEventRunning then
		local creaturesRemaining = getCreatureCountArena()
		if creaturesRemaining <= 0 and activeRaidsArena[actualRaid] == nil then
			activeRaidsArena[actualRaid] = 1
			Game.startRaid(raids[actualRaid])
			addEvent(tryStartRaid, secondsBetweenRaids * 1000, actualRaid + 1)
		else		
			addEvent(tryStartRaid, secondsBetweenRaids * 1000, actualRaid)
		end
	end
end

local function arenaEventStart()
	broadcastMessage("Registration for the gold arena event is now closed! Players being transported to the event.", MESSAGE_STATUS_WARNING)
	local players = Game.getPlayers()
	for i = 1, #players do
		local player = players[i]
		if player:getStorageValue(storageArenaEvent) > 0 then
			local randomPosx = math.random(eventFromPos[1], eventToPos[1])
			local randomPosy = math.random(eventFromPos[2], eventToPos[2])
			local teleportPosition = Position(randomPosx, randomPosy, eventFromPos[3])
			player:teleportTo(teleportPosition)
			player:setStorageValue(storageArenaEvent, 2)
			player:registerEvent("PrepareDeathArena")
		end
	end
	arenaEventIsOpen = false
	tryStartRaid(1)	
end

local function fifthArenaEventWarning()
	broadcastMessage("Gold arena event will start in 1 minute. To sign up, you must be level 5 and you must say hi and then arena to the NPC Manager in front of the Saffron CP. Registration will be closed in 1 minute.", MESSAGE_STATUS_WARNING)
	addEvent(arenaEventStart, 1 * 60 * 1000)
end

local function fourthArenaEventWarning()
	broadcastMessage("Gold arena event will start in 2 minutes. To sign up, you must be level 5 and you must say hi and then arena to the NPC Manager that is located in front of Saffron's CP.", MESSAGE_STATUS_WARNING)
	addEvent(fifthArenaEventWarning, 1 * 60 * 1000)
end

local function thirdArenaEventWarning()
	broadcastMessage("Gold arena event will start in 4 minutes. To sign up, you must be level 5 and you must say hi and then arena to the NPC Manager that is located in front of Saffron's CP.", MESSAGE_STATUS_WARNING)
	addEvent(fourthArenaEventWarning, 2 * 60 * 1000)
end

local function secondArenaEventWarning()
	broadcastMessage("Gold arena event will start in 6 minutes. To sign up, you must be level 5 and you must say hi and then arena to the NPC Manager that is located in front of Saffron's CP.", MESSAGE_STATUS_WARNING)
	addEvent(thirdArenaEventWarning, 2 * 60 * 1000)
end

local function firstArenaEventWarning()
	broadcastMessage("Gold arena event will start in 8 minutes. To sign up, you must be level 5 and you must say hi and then arena to the NPC Manager that is located in front of Saffron's CP.", MESSAGE_STATUS_WARNING)
	addEvent(secondArenaEventWarning, 2 * 60 * 1000)
end

function onThink(interval)
	local hour = os.date("%H")
	if hour % 2 == 0 then
		return true
	end
	if Game.getPlayerCount() < 2 then
		return true
	end
	ipsSub = {}
	activeRaidsArena = {}
	isArenaEventRunning = true
	broadcastMessage("Gold arena event will start in 10 minutes. To sign up, you must be level 5 and you must say hi and then arena to the NPC Manager that is located in front of Saffron's CP.", MESSAGE_STATUS_WARNING)
	arenaEventIsOpen = true
	addEvent(firstArenaEventWarning, 2 * 60 * 1000)
	return true
end
