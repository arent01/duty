local lastUsed = {} -- Таблица для хранения времени последнего использования для каждого игрока
local unlimitedPlayers = {} -- Таблица для хранения игроков без лимита времени

RegisterNetEvent("GivePedWeapon")
AddEventHandler("GivePedWeapon", function()
    local playerID = GetPlayerServerId(PlayerId())
    local currentTime = GetGameTimer() / 1000 -- Получаем текущее время в секундах

    if not unlimitedPlayers[playerID] and (lastUsed[playerID] and currentTime - lastUsed[playerID] < 1800) then
        -- Если прошло меньше 30 минут (1800 секунд) и игрок не в списке безлимитных, отправляем сообщение игроку
        local remainingTime = 1800 - (currentTime - lastUsed[playerID])
        local remainingMinutes = math.ceil(remainingTime / 60)
        print("Оставшееся время до снятия лимита: " .. remainingMinutes .. " минут.")
        
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0}, -- Красный цвет для "Система"
            multiline = true,
            args = {"^1Система^0", "^7Вы можете использовать эту команду только раз в 30 минут!"} -- ^1 - красный, ^7 - серый
        })
        return
    end

    lastUsed[playerID] = currentTime -- Обновляем время последнего использования для текущего игрока

    local ped = GetPlayerPed(PlayerId())

    -- Удалить все существующее оружие
    RemoveAllPedWeapons(ped, true)

    -- Выдача пистолета
    local pistol = GetHashKey("WEAPON_PISTOL")
    GiveWeaponToPed(ped, pistol, 1000, false, false)

    -- Выдача тайзера
    local taser = GetHashKey("WEAPON_STUNGUN")
    GiveWeaponToPed(ped, taser, 1000, false, false)

    -- Выдача полицейской дубинки
    local nightstick = GetHashKey("WEAPON_NIGHTSTICK")
    GiveWeaponToPed(ped, nightstick, 1, false, false)

    -- Выдача фонарика
    local flashlight = GetHashKey("WEAPON_FLASHLIGHT")
    GiveWeaponToPed(ped, flashlight, 1, false, false)

    -- Выдача автомата (Carbine Rifle)
    local m4 = GetHashKey("WEAPON_CARBINERIFLE")
    GiveWeaponToPed(ped, m4, 1000, false, false)

    -- Выдача дробовика
    local shotgun = GetHashKey("WEAPON_PUMPSHOTGUN")
    GiveWeaponToPed(ped, shotgun, 1000, false, false)

    -- Выдача бронежилета на 100
    SetPedArmour(ped, 100)

    -- Выдача здоровья на 100
    SetEntityHealth(ped, 200) -- 100 здоровья + 100 брони = 200
end)

RegisterNetEvent("updateUnlimitedPlayers")
AddEventHandler("updateUnlimitedPlayers", function(updatedPlayers)
    unlimitedPlayers = updatedPlayers
end)