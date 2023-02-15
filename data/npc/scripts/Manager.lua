local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local voices = { {text = 'Events are my business!'} }
npcHandler:addModule(VoiceModule:new(voices))

ipsSub = {}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local playerIp = player:getIp()

	if isInArray(ipsSub, playerIp) then
		npcHandler:say("Only 1 IP is allowed to enter events.", cid)
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
		return false
	end
	if msgcontains(msg, "bag") then
		if bagEventIsOpen then
			if player:getLevel() >= 5 then
				if player:getStorageValue(storageBagEvent) < 0 then
					npcHandler:say("You have been successfully registered. Now just wait and you will be automatically transported to the event.", cid)
					player:setStorageValue(storageBagEvent, 1)
					if player:getName() ~= "Ellie" or player:getName() ~= "Unknown Myth" then
						ipsSub[#ipsSub + 1] = playerIp
					end
					npcHandler:releaseFocus(cid)
					npcHandler:resetNpc(cid)
				else
					npcHandler:say("You are already signed up!", cid)
					npcHandler:releaseFocus(cid)
					npcHandler:resetNpc(cid)
				end
			else
				npcHandler:say("You must be at least level 5 to participate!", cid)
				npcHandler:releaseFocus(cid)
				npcHandler:resetNpc(cid)
			end
		else
			npcHandler:say("This event is currently not open!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, "arena") then
		if arenaEventIsOpen then
			if player:getLevel() >= 5 then
				if player:getStorageValue(storageArenaEvent) < 0 then
					npcHandler:say("You have been successfully registered. Now just wait and you will be automatically transported to the event.", cid)
					player:setStorageValue(storageArenaEvent, 1)
					if player:getName() ~= "Ellie" or player:getName() ~= "Unknown Myth"  then
						ipsSub[#ipsSub + 1] = playerIp
					end
					npcHandler:releaseFocus(cid)
					npcHandler:resetNpc(cid)
				else
					npcHandler:say("You are already signed up!", cid)
					npcHandler:releaseFocus(cid)
					npcHandler:resetNpc(cid)
				end
			else
				npcHandler:say("You must be at least level 5 to participate!", cid)
				npcHandler:releaseFocus(cid)
				npcHandler:resetNpc(cid)
			end
		else
			npcHandler:say("This event is currently not open!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, "pvp") then
		if arenaPvpEventIsOpen then
			if player:getLevel() >= 5 then
				if player:getStorageValue(storageArenaPvpEvent) < 0 then
					npcHandler:say("You have been successfully registered. Now just wait and you will be automatically transported to the event.", cid)
					player:setStorageValue(storageArenaPvpEvent, 1)
					if player:getName() ~= "Ellie" or player:getName() ~= "Unknown Myth"  then
						ipsSub[#ipsSub + 1] = playerIp
					end
					npcHandler:releaseFocus(cid)
					npcHandler:resetNpc(cid)
				else
					npcHandler:say("You are already signed up!", cid)
					npcHandler:releaseFocus(cid)
					npcHandler:resetNpc(cid)
				end
			else
				npcHandler:say("You must be at least level 5 to participate!", cid)
				npcHandler:releaseFocus(cid)
				npcHandler:resetNpc(cid)
			end
		else
			npcHandler:say("This event is currently not open!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, "soccer") then
		if soccerEventIsOpen then
			if player:getLevel() >= 5 then
				if player:getStorageValue(storageSoccerEvent) < 0 then
					npcHandler:say("You have been successfully registered. Now just wait and you will be automatically transported to the event.", cid)
					player:setStorageValue(storageSoccerEvent, 1)
					if player:getName() ~= "Ellie" or player:getName() ~= "Unknown Myth"  then
						ipsSub[#ipsSub + 1] = playerIp
					end
					npcHandler:releaseFocus(cid)
					npcHandler:resetNpc(cid)
				else
					npcHandler:say("You are already signed up!", cid)
					npcHandler:releaseFocus(cid)
					npcHandler:resetNpc(cid)
				end
			else
				npcHandler:say("You must be at least level 5 to participate!", cid)
				npcHandler:releaseFocus(cid)
				npcHandler:resetNpc(cid)
			end
		else
			npcHandler:say("This event is currently not open!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, "bye") then
		npcHandler:say("Hm ... bye.", cid)
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
