local adminIDs = { -- Идентификаторы админов по типу fivem:id
    "fivem:1234567890" 
}

local unlimitedPlayers = {} -- Таблица для хранения игроков без лимита времени

-- Проверка на наличие прав администратора
local function isAdmin(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in ipairs(identifiers) do
        for _, adminID in ipairs(adminIDs) do
            if identifier == adminID then
                return true
            end
        end
    end
    return false
end

RegisterCommand("dutylimit", function(source, args, rawCommand)
    if isAdmin(source) then
        local targetID = tonumber(args[1])
        if targetID then
            if not unlimitedPlayers[targetID] then
                unlimitedPlayers[targetID] = true
                TriggerClientEvent('chat:addMessage', source, {
                    color = {0, 255, 0}, -- Зеленый цвет для "Система"
                    multiline = true,
                    args = {"^1Система^0", "^7Игрок с ID " .. targetID .. " теперь может использовать команду без ограничения по времени!"} -- ^1 - красный, ^7 - серый
                })
                TriggerClientEvent('updateUnlimitedPlayers', -1, unlimitedPlayers)
            else
                TriggerClientEvent('chat:addMessage', source, {
                    color = {255, 165, 0}, -- Оранжевый цвет для "Система"
                    multiline = true,
                    args = {"^1Система^0", "^7Игрок с ID " .. targetID .. " уже имеет неограниченное время!"} -- ^1 - красный, ^7 - серый
                })
            end
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0}, -- Красный цвет для "Система"
                multiline = true,
                args = {"^1Система^0", "^7Неверный ID игрока!"} -- ^1 - красный, ^7 - серый
            })
        end
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0}, -- Красный цвет для "Система"
            multiline = true,
            args = {"^1Система^0", "^7У вас нет прав для выполнения этой команды!"} -- ^1 - красный, ^7 - серый
        })
    end
end, false)

RegisterCommand("duty", function(source, args, rawCommand)
    TriggerClientEvent("GivePedWeapon", source)
end, false)
