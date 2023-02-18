local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local timeBetweenQuests = 60*60*5--20*60*60

local easyItems = {"traces of ghost","piece of steel","pot of moss bug","straw","bottle of poison","seed","essence of fire","water gem","sandbag","screw","snowball","small stone"}
local mediumItems = {"spider legs","dragon tail","seahorse tail","piece of coral","egg shell","ladybug wing","ice orb","dog ears","fire horse foot","wooper horn","strange feather","slow tail","squirrel tail","seal tail" ,"fire ear","yellow flower","strange flower","gem star","blue ball","locksmith of shell","crab claw","bone","psychic spoon","piece of shell","magnet","piece of diglett","bug antenna","wool ball","horn drill","stone orb","electric rat tail","venom flute","sheep wool","gosme","microphone","snake tail","ruby","blue gem","red gem","nail","male ear","female ear", "fur","hot fur", "red scale","bat wing","bird beak","bag of pollem","comb","leaves","bulb","pot of lava","fire tail","water pendant","squirtle hull","feather","strange rock","electric box","kick machine","punch machine","future orb","tooth","horn"}
local hardItems = {"linearly guided hypnose","elephant foot","small tail","plant tail","branch of stone","miss traces","dark beak","strange tail","armadillo claw","monkey paw","insect claw","cow tail","tentacle","pinsir horn","dodrio feather","strange spike","cat ear","steel wings","giant ruby","belt of champion","electric tail","magma foot","luck medallion","bear paw","kanga ear","bug venom","reindeer horn","farfetch'd stick","sticky hand","tongue","gligar claw","ice bra","bull tail","fox tail","blue vines","plant foot","owl feather","scythe","scizor claw","giant piece of fur", "great petals","giant bat wing","steelix tail","mimic clothes","onix tail","dragon tooth","butterfly wing","bee sting","rat tail","red wing", "psyduck mug","gyarados tail","karate duck"}

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local voices = { {text = 'Nao encontro esses itens em lugar algum.'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if not player then
		return false
	end

	if msgcontains(msg, "yes") or msgcontains(msg, "sim") or msgcontains(msg, "quest") or msgcontains(msg, "task") or msgcontains(msg, "ajudar") or msgcontains(msg, "ajuda") and npcHandler.topic[cid] == 0 then
		local timeSinceLast = os.time() - player:getStorageValue(storageItemQuestTime)
		local timeRemaining = timeBetweenQuests - timeSinceLast
		if (timeSinceLast > timeBetweenQuests) then
			npcHandler:say("I can give you an {easy}, {medium} or {hard} quest, but remember that hard quests usually bring better rewards. Which one do you prefer?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(storageItemQuestDay) == 0 then
			local itemId = player:getStorageValue(storageItemQuestItem)
			local number =  player:getStorageValue(storageItemQuestNumber)

			if not player:removeItem(itemId, number) then
				npcHandler:say("Volte com {" .. number .." " .. ItemType(itemId):getName() .. "} ou daqui " .. timeRemaining .. " segundos.", cid)
				npcHandler:releaseFocus(cid)
			else
				local tokens = 1
				if player:getStorageValue(storageItemQuestDifficulty) == 1 then
					tokens = math.random(3,5)
				elseif player:getStorageValue(storageItemQuestDifficulty) == 2 then
					tokens = math.random(5,7)
				elseif player:getStorageValue(storageItemQuestDifficulty) == 3 then
					tokens = math.random(7,9)
				end
				player:addTokens(tokens)
				npcHandler:say("Good job! Take " .. tokens .. " tokens as a reward. New balance: " .. player:getTokens() .. ".", cid)
				player:setStorageValue(storageItemQuestDay, -1)
				npcHandler:releaseFocus(cid)
			end
		else
			npcHandler:say("You already got today's prize. Return from here " .. timeRemaining .. " seconds." , cid)
			npcHandler:releaseFocus(cid)
		end
	elseif (msgcontains(msg, "facil") or msgcontains(msg, "easy") or msgcontains(msg, "media") or msgcontains(msg, "medium") or msgcontains(msg, "dificil") or msgcontains(msg, "hard") )and npcHandler.topic[cid] == 1 then
		player:setStorageValue(storageItemQuestDay, 0)
		player:setStorageValue(storageItemQuestTime, os.time())
		local itemName
		local number = 2
		if msgcontains(msg, "facil") or msgcontains(msg, "easy") then
			number = tostring(25*math.random(4, 8))
			itemName = easyItems[math.random(#easyItems)]
			player:setStorageValue(storageItemQuestDifficulty, 1)
		elseif msgcontains(msg, "media") or msgcontains(msg, "medium") then
			number = tostring(25*math.random(2, 4))
			itemName = mediumItems[math.random(#mediumItems)]
			player:setStorageValue(storageItemQuestDifficulty, 2)
		elseif msgcontains(msg, "dificil") or msgcontains(msg, "hard") then
			number = tostring(25*math.random(1, 2))
			itemName = hardItems[math.random(#hardItems)]
			player:setStorageValue(storageItemQuestDifficulty, 3)
		end
		local itemType = ItemType(itemName)
		if not itemType then
			print("WARNING! Item " .. itemName .. " not found on NPC Nate.")
			npcHandler:say("Encontramos um problema que ja foi reportado para os GMs.", cid)
			npcHandler:releaseFocus(cid)
		end
		player:setStorageValue(storageItemQuestNumber, number)
		player:setStorageValue(storageItemQuestItem, itemType:getId())
		npcHandler:say("I know you are good. Let's see if you can bring me in today {" .. number .." " .. itemName .. "}.", cid)
		npcHandler:releaseFocus(cid)
	else
		if npcHandler.topic[cid] == 0 then
			npcHandler:say("I don't understand. Would you like to help me with a {quest}?", cid)
			return tue
		elseif npcHandler.topic[cid] == 1 then
			npcHandler:say("I don't understand. Would you like an {easy}, {medium} or {hard} task?", cid)
			return tue
		end

	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
