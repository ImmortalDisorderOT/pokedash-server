local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local prizes = 
	{
		[1] = {name = "crystal coin", count = 30},
		[2] = {name = "box 3", count = 1},
		[3] = {name = "fire stone", count = 50},
		[4] = {name = "water stone", count = 50},
		[5] = {name = "enigma stone", count = 50},
		[6] = {name = "thunder stone", count = 50},
		[7] = {name = "punch stone", count = 50},
		[8] = {name = "leaf stone", count = 50},
		[9] = {name = "box 4", count = 1}
	}
local prizesNumber = math.random(1, 3)
local idDie = {23582, 5792, 5793, 5794, 5795, 5796, 5797}
local number
local numberTook
local maxTime = 5 * 60 --segundos
local generateBags = true
local idBag = 26760
local minPosBags = {-3, -5}
local maxPosBags = {0, 5}

local function doTeleportPlayerTemple(cid)
	local player = Player(cid)
	if player then
		local templePosition = player:getTown():getTemplePosition()
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		templePosition:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(templePosition)
	end
	return true
end

local function creatureGreetCallback(cid, message)
	if message == nil then
		return true
	end
	selfSay("Wait your turn!")
	return false
end

local function creatureOnThinkCallback()
	local npc = Npc()
	local lookDir = npc:getDirection()
	if lookDir ~= 1 then npc:setDirection(1) end
	local npcPosition = npc:getPosition()
	if generateBags then
		for x = npcPosition.x + minPosBags[1], npcPosition.x + maxPosBags[1] do
			for y = npcPosition.y + minPosBags[2], npcPosition.y + maxPosBags[2] do				
				Game.createItem(idBag, 1, Position(x, y, npcPosition.z))
			end
		end
		generateBags = false
	end
	local dicePosition = npc:getPosition()
	local playerPosition = npc:getPosition()
	dicePosition:getNextPosition(npc:getDirection())
	playerPosition:getNextPosition(npc:getDirection())
	playerPosition:getNextPosition(npc:getDirection())
	local diceTile = Tile(dicePosition)
	local dice = diceTile:getTopDownItem()
	local playerTile = Tile(playerPosition)
	local creatures = playerTile:getCreatures()
	if creatures and #creatures > 0 then
		local creature = creatures[1]
		if creature:isPlayer() then
			local cid = creature:getId()
			if not npcHandler:isFocused(cid) then
				if NpcHandler:isInRange(cid) then
					creature:setStorageValue(storageDelayBag, os.time() + maxTime)
					npcHandler:greet(cid)
					npcHandler.topic[cid] = 1
				end
			end

			if npcHandler.topic[cid] == 1 then
				npcHandler.topic[cid] = 2
				selfSay("Next player to try: " .. creature:getName() .. ". Wish him good luck!")
			end

			if npcHandler.topic[cid] == 3 then
				Game.createItem(idDie[1], 1, dicePosition)
				npcHandler.topic[cid] = 4
			end

			if npcHandler.topic[cid] == 4 then
				if dice and dice:getId() ~= idDie[1] then
					if isInArray(idDie, dice:getId()) then
						for key, value in pairs(idDie) do
							if value == dice:getId() then numberTook = key - 1 end
						end					
						selfSay("Player " .. creature:getName() .. " drew the number " .. numberTook .. ".")
						npcHandler.topic[cid] = 5
					end
				end
			end

			if npcHandler.topic[cid] == 5 then	
				if numberTook == number then
					selfSay("Congratulations, " .. creature:getName() .. "! You won a prize!")
					local msg = "Player " .. creature:getName() .. " picked the number  " .. number .. " and won: " 
					local container = Container(creature:addItem(idBag, 1).uid)
					for i = 1, prizesNumber do
						local random = math.random(1, #prizes)
						container:addItem(prizes[random].name, prizes[random].count)
						if i < prizesNumber then
							msg = msg .. prizes[random].count .. " " .. prizes[random].name .. ", "
						else
							msg = msg .. prizes[random].count .. " " .. prizes[random].name .. ". Congratulations!"
						end
					end
					broadcastMessage(msg, MESSAGE_STATUS_WARNING)
					doTeleportPlayerTemple(cid)
				else
					selfSay("Not this time, " .. creature:getName() .. "!")
					dice:remove()
					doTeleportPlayerTemple(cid)
					local msg = "Player " .. creature:getName() .. " picked the number " .. number .. " and drew the number " .. numberTook .. ". Not this time!"
					broadcastMessage(msg, MESSAGE_STATUS_WARNING)
				end
			end

			if os.time() > creature:getStorageValue(storageDelayBag) then
				selfSay("Your time has run out, " .. creature:getName() .. "!")
				if dice then
					dice:remove()
				end
				doTeleportPlayerTemple(cid)
			end
		else
			creature:remove()
		end
	else
		if dice then
			dice:remove()
		end
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	if npcHandler.topic[cid] == 2 then
		number = tonumber(msg)
		if not number then return true end
		if number > 6 then number = nil end
		if number ~= nil then
			selfSay("Player " .. player:getName() .. " chose the number " .. number .. ". Now roll the die!")
			npcHandler.topic[cid] = 3
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, creatureGreetCallback)
npcHandler:setCallback(CALLBACK_ONTHINK, creatureOnThinkCallback)

npcHandler:addModule(FocusModule:new())
