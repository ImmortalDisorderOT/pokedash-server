local time = 100
local hits = 1
local damageMultiplier = damageMultiplierMoves.frontlinear*(1+(hits-1)/4)/hits
local areaDamage = createCombatArea(FRONT_AREA_2)
local combat = COMBAT_POISONDAMAGE
local defenseType = COMBAT_PHYSICALDAMAGE

local effects = {}
table.insert(effects, 640) --dir1
table.insert(effects, 638) --dir2
table.insert(effects, 639) --dir3
table.insert(effects, 637) --dir4

local function spellCallback(uid, position, positionDamage, damage, count, dir)
	local creature = Creature(uid)
	if creature then		
		if count <= hits then
			position:sendMagicEffect(effects[dir+1])
			doAreaCombatHealth(uid, combat, positionDamage, areaDamage, -damage, -damage, 0, defenseType)
			count = count + 1
			addEvent(spellCallback, time, uid, position, positionDamage, damage, count, dir)
		end
	end
end

function onCastSpell(creature, variant)

	local damage = damageMultiplier * creature:getTotalMeleeAttack()
	local position = creature:getPosition()
	local positionDamage = creature:getPosition()
	local dir = creature:getDirection()
	position:getNextPosition(dir)
	positionDamage:getNextPosition(dir)
	if dir == 0 or dir == 1 then
		position:getNextPosition(dir+1)
		position:getNextPosition(dir+1)
	else
		position:getNextPosition(dir-1)
		position:getNextPosition(dir-1)
	end
	if dir == 1 or dir == 2 then
		position:getNextPosition(dir)
		position:getNextPosition(dir)
	end

	spellCallback(creature.uid, position, positionDamage, damage, 1, dir)
	return true
end
