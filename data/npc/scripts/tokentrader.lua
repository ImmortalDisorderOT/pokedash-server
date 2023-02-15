local tradeItems = {
	["box 1"] = {id = 26764, price = 5},
	["box 2"] = {id = 26812, price = 25},
	["box 3"] = {id = 26813, price = 50},
	["box 4"] = {id = 26814, price = 75},
	["box 5"] = {id = 26816, price = 200},
	["token"] = {id = 0, price = 25000}
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local tokensToBuy = 0

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, 'bye') or msgcontains(msg, 'no') or msgcontains(msg, 'nao') then
		selfSay('Maybe another time.', cid)
		npcHandler.topic[cid] = 0
	elseif npcHandler.topic[cid] == 1 then
		if tonumber(msg) ~= nil then
			selfSay('Would you like to buy ' .. msg .. " tokens for " .. msg * tradeItems["token"].price .. " gp?", cid)
			tokensToBuy = msg
			npcHandler.topic[cid] = 2
		else
			selfSay("Please only input a number")
			npcHandler.topic[cid] = 1
		end
	elseif npcHandler.topic[cid] == 2 and msgcontains(msg, "yes") then
		local player = Player(cid)
		if player:removeMoney(tokensToBuy * tradeItems["token"].price) then
			player:addTokens(tokensToBuy)
			selfSay("Enjoy!", cid)
			npcHandler.topic[cid] = 0
		else
			selfSay("Come back when you have the money!", cid)
		end	
	elseif msgcontains(msg, "box 1") then
		selfSay("Would you like to buy a box 1 for 5 tokens?", cid)
		npcHandler.topic[cid] = 3
	elseif npcHandler.topic[cid] == 3 and msgcontains(msg, "yes") then
		local player = Player(cid)
		if player:removeTokens(tradeItems["box 1"].price) then
			selfSay('Enjoy!', cid)
			player:addItem(tradeItems["box 1"].id)
			npcHandler.topic[cid] = 0
		else
			selfSay('You can\'t afford it!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "box 2") then
		selfSay("Would you like to buy a box 2 for 25 tokens?", cid)
		npcHandler.topic[cid] = 4
	elseif npcHandler.topic[cid] == 4 and msgcontains(msg, "yes") then
		local player = Player(cid)
		if player:removeTokens(tradeItems["box 2"].price) then
			selfSay('Enjoy!', cid)
			player:addItem(tradeItems["box 2"].id)
			npcHandler.topic[cid] = 0
		else
			selfSay('You can\'t afford it!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "box 3") then
		selfSay("Would you like to buy a box 3 for 50 tokens?", cid)
		npcHandler.topic[cid] = 5
	elseif npcHandler.topic[cid] == 5 and msgcontains(msg, "yes") then
		local player = Player(cid)
		if player:removeTokens(tradeItems["box 3"].price) then
			selfSay('Enjoy!', cid)
			player:addItem(tradeItems["box 3"].id)
			npcHandler.topic[cid] = 0
		else
			selfSay('You can\'t afford it!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "box 4") then
		selfSay("Would you like to buy a box 4 for 75 tokens?", cid)
		npcHandler.topic[cid] = 6
	elseif npcHandler.topic[cid] == 6 and msgcontains(msg, "yes") then
		local player = Player(cid)
		if player:removeTokens(tradeItems["box 4"].price) then
			selfSay('Enjoy!', cid)
			player:addItem(tradeItems["box 4"].id)
			npcHandler.topic[cid] = 0
		else
			selfSay('You can\'t afford it!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "box 5") then
		selfSay("Would you like to buy a box 5 for 200 tokens?", cid)
		npcHandler.topic[cid] = 7
	elseif npcHandler.topic[cid] == 7 and msgcontains(msg, "yes") then
		local player = Player(cid)
		if player:removeTokens(tradeItems["box 5"].price) then
			selfSay('Enjoy!', cid)
			player:addItem(tradeItems["box 5"].id)
			npcHandler.topic[cid] = 0
		else
			selfSay('You can\'t afford it!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'trade') then
		selfSay('You can purchase {token}s for 25k a piece, or {box}es!', cid)
	elseif msgcontains(msg, 'box') or msgcontains(msg, 'boxes') then
		selfSay('You can purchase {box 1} for 5 tokens, {box 2} for 25, {box 3} for 50, {box 4} for 75, or {box 5} for 200!', cid)
	elseif msgcontains(msg, 'token') or msgcontains(msg, 'tokens') then
		selfSay('How many tokens would you like to buy?', cid)
		npcHandler.topic[cid] = 1
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
