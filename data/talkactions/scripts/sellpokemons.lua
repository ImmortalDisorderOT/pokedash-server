function onSay(player, words, param)
    local priceLinearSlope = 12
    local priceLinearIntercept = 1900
    
    local balls = player:getPokeballs()
    for i=1, #balls do
        local ball = balls[i]
        local name = firstToUpper(ball:getSpecialAttribute("pokeName"))
        local monsterType = MonsterType(name)
        local isBallBeingUsed = ball:getSpecialAttribute("isBeingUsed")
        if isBallBeingUsed and isBallBeingUsed == 1 then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sorry, not possible while using the Pokemon.")
            return false
        end

        local boost = ball:getSpecialAttribute("pokeBoost") or 0
        local level = ball:getSpecialAttribute("pokeLevel")
        local rawPrice = math.abs(( monsterType:getHealth()/10 + monsterType:getBaseSpeed()/2 + monsterType:getMeleeDamage(self) + monsterType:getDefense() +
monsterType:getMoveMagicAttackBase() + monsterType:getMoveMagicDefenseBase())* priceLinearSlope - priceLinearIntercept)
        if rawPrice < 500 then
                rawPrice = 500
        end
        local price = rawPrice + boost * 1000
        if msgcontains(name, 'Shiny')  then
            price = 5 * math.floor(rawPrice/1.5) + boost * 1000
        end
        if ball:remove() then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'Take ' .. price .. 'gp for your ' .. name .. ', at level ' .. level .. ' boost ' .. boost .. '.')
            player:addMoney(price)
        end
    end
    player:refreshPokemonBar({}, {})
    return false
end