local priceTokens = 100
local levelMinimum = 100

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	if msgcontains(msg, 'bye') or msgcontains(msg, 'no') or msgcontains(msg, 'nao') then
		selfSay('Maybe another time.', cid)
		npcHandler:releaseFocus(cid)
	elseif msgcontains(msg, 'sell') or msgcontains(msg, 'buy') or msgcontains(msg, 'comprar') or msgcontains(msg, 'vender') or msgcontains(msg, 'help') then
		selfSay('Have you decided which job you\'d like to take? I can help you become a {hunter}, {catcher}, {healer}, {blocker} or {explorer}.', cid)
	elseif msgcontains(msg, 'hunter') then
		selfSay('Are you sure you want to become a hunter? The price of this course is ' .. priceTokens .. ' tokens!', cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, 'catcher') then
		selfSay('Are you sure you want to become a catcher? The price of this course is ' .. priceTokens .. ' tokens!', cid)
		npcHandler.topic[cid] = 2
	elseif msgcontains(msg, 'healer') then
		selfSay('Are you sure you want to become a healer? The price of this course is ' .. priceTokens .. ' tokens!', cid)
		npcHandler.topic[cid] = 3
	elseif msgcontains(msg, 'blocker') then
		selfSay('Are you sure you want to become a blocker? The price of this course is ' .. priceTokens .. ' tokens!', cid)
		npcHandler.topic[cid] = 4
	elseif msgcontains(msg, 'explorer') then
		selfSay('Are you sure you want to become an explorer? The price of this course is ' .. priceTokens .. ' tokens!', cid)
		npcHandler.topic[cid] = 5
	elseif (msgcontains(msg, 'sim') or msgcontains(msg, 'yes')) and npcHandler.topic[cid] == 1 then
		local player = Player(cid)
		if player:getLevel() >= levelMinimum then		
		if player:removeTokens(priceTokens) then
			selfSay('Congratulations! Enjoy your new profession.', cid)
			player:setVocation("Hunter")
			npcHandler.topic[cid] = 0
			npcHandler:releaseFocus(cid)
		else
			selfSay('You can\'t afford it!', cid)
			npcHandler.topic[cid] = 0
			npcHandler:releaseFocus(cid)
		end

		else
			selfSay('Sorry, you need to have at least level ' .. levelMinimum .. ".", cid)
			npcHandler.topic[cid] = 0
			npcHandler:releaseFocus(cid)
		end
	elseif (msgcontains(msg, 'sim') or msgcontains(msg, 'yes')) and npcHandler.topic[cid] == 2 then
		local player = Player(cid)
		if player:getLevel() >= levelMinimum then		
			if player:removeTokens(priceTokens) then
				selfSay('Congratulations! Enjoy your new profession.', cid)
				player:setVocation("Catcher")
				npcHandler.topic[cid] = 0
				npcHandler:releaseFocus(cid)
			else
				selfSay('You can\'t afford it!', cid)
				npcHandler.topic[cid] = 0
				npcHandler:releaseFocus(cid)
			end
		else
			selfSay('Sorry, you need to have at least level ' .. levelMinimum .. ".", cid)
			npcHandler.topic[cid] = 0
			npcHandler:releaseFocus(cid)
		end
	elseif (msgcontains(msg, 'sim') or msgcontains(msg, 'yes')) and npcHandler.topic[cid] == 3 then
		local player = Player(cid)
		if player:getLevel() >= levelMinimum then
			if player:removeTokens(priceTokens) then
				selfSay('Congratulations! Enjoy your new profession.', cid)
				player:setVocation("Healer")
				npcHandler.topic[cid] = 0
				npcHandler:releaseFocus(cid)
			else
				selfSay('You can\'t afford it!', cid)
				npcHandler.topic[cid] = 0
				npcHandler:releaseFocus(cid)
			end
		else
			selfSay('Sorry, you need to have at least level ' .. levelMinimum .. ".", cid)
			npcHandler.topic[cid] = 0
			npcHandler:releaseFocus(cid)
		end
	elseif (msgcontains(msg, 'sim') or msgcontains(msg, 'yes')) and npcHandler.topic[cid] == 4 then
		local player = Player(cid)
		if player:getLevel() >= levelMinimum then		
			if player:removeTokens(priceTokens) then
				selfSay('Congratulations! Enjoy your new profession.', cid)
				player:setVocation("Blocker")
				npcHandler.topic[cid] = 0
				npcHandler:releaseFocus(cid)
			else
				selfSay('You can\'t afford it!', cid)
				npcHandler.topic[cid] = 0
				npcHandler:releaseFocus(cid)
			end
		else
			selfSay('Sorry, you need to have at least level ' .. levelMinimum .. ".", cid)
			npcHandler.topic[cid] = 0
			npcHandler:releaseFocus(cid)
		end
	elseif (msgcontains(msg, 'sim') or msgcontains(msg, 'yes')) and npcHandler.topic[cid] == 5 then
		local player = Player(cid)
		if player:getLevel() >= levelMinimum then		
			if player:removeTokens(priceTokens) then
				selfSay('Congratulations! Enjoy your new profession.', cid)
				player:setVocation("Explorer")
				npcHandler.topic[cid] = 0
				npcHandler:releaseFocus(cid)
			else
				selfSay('You can\'t afford it!', cid)
				npcHandler.topic[cid] = 0
				npcHandler:releaseFocus(cid)
			end
		else
			selfSay('Sorry, you need to have at least level ' .. levelMinimum .. ".", cid)
			npcHandler.topic[cid] = 0
			npcHandler:releaseFocus(cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
