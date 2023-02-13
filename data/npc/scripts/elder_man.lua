local storage = quests.elderManQuest.prizes[1].uid

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
		selfSay('Go, young man, live your life to the fullest!', cid)
		npcHandler:releaseFocus(cid)
	elseif msgcontains(msg, 'mission') or msgcontains(msg, 'quest') then
		selfSay('See, I don\'t need your help with quests, because in my life I have already completed them all.', cid)
	elseif msgcontains(msg, 'pokemon') or msgcontains(msg, 'pokemons') then
		selfSay('During my lifetime I have been able to see all pokemons, including their rarest ancestors.', cid)
	elseif msgcontains(msg, 'ancestral') or msgcontains(msg, 'ancestrais') or msgcontains(msg, 'ancient') or msgcontains(msg, 'elder') then
		selfSay('Yes, long ago there were the ancestral pokemons, known as {ancient}s or {elder}s. They had extraordinary power. I wonder... maybe there is a way for a pokemon to return to its ancestral form? Ah... if only I had a clue...', cid)
	elseif msgcontains(msg, 'track') or msgcontains(msg, 'tracks') then
		selfSay('You see, young man, if you bring me clues or information I might be able to figure out how to regress a pokemon to its ancestral form.', cid)
	elseif msgcontains(msg, 'hieroglifo') or msgcontains(msg, 'hieroglyph') then
		local player = Player(cid)
		if player:removeItem("ancient hieroglyph", 1) then
			selfSay('By Arceus! How did you get this glyph? It doesn\'t matter, I think I might be able to make a stone with it to regress a pokemon to its ancestral form, but I need time... Okay, here is a {stone} that can regress pokemons, but maybe just one is not enough', cid)
			player:giveQuestPrize(storage)
			npcHandler:releaseFocus(cid)
		else
			selfSay('True, young man. Perhaps an ancient hieroglyphic holds the answer to what I have spent most of my life searching for. If you get one, please give it to me and I will reward you with some of my knowledge!', cid)
			npcHandler:releaseFocus(cid)
		end	
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
