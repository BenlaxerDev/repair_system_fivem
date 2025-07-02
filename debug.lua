local Debug = {}

-- Debug-Farben
Debug.Colors = {
    INFO = {r = 0, g = 255, b = 0},    -- Grün
    WARNING = {r = 255, 255, 0},       -- Gelb
    ERROR = {r = 255, 0, 0},           -- Rot
    DEBUG = {r = 0, 191, 255}          -- Hellblau
}

-- Debug-Level
Debug.Levels = {
    INFO = 1,
    WARNING = 2,
    ERROR = 3,
    DEBUG = 4
}

-- Aktueller Debug-Level
Debug.CurrentLevel = Config.Debug and Debug.Levels.DEBUG or Debug.Levels.ERROR

-- Funktion zum Loggen von Nachrichten
function Debug.Log(message, level, data)
    if not Config.Debug then return end
    if level < Debug.CurrentLevel then return end

    local color = Debug.Colors.INFO
    local prefix = "[INFO]"

    if level == Debug.Levels.WARNING then
        color = Debug.Colors.WARNING
        prefix = "[WARNING]"
    elseif level == Debug.Levels.ERROR then
        color = Debug.Colors.ERROR
        prefix = "[ERROR]"
    elseif level == Debug.Levels.DEBUG then
        color = Debug.Colors.DEBUG
        prefix = "[DEBUG]"
    end

    -- Nachricht formatieren
    local formattedMessage = string.format("%s %s", prefix, message)
    
    -- In Konsole ausgeben
    print(string.format("^%d%s^7", color.r, formattedMessage))
    
    -- Wenn zusätzliche Daten vorhanden sind, diese auch ausgeben
    if data then
        print("^3[DEBUG DATA]^7")
        print(json.encode(data, {indent = true}))
    end
end

-- Funktion zum Überprüfen der Werkzeuge
function Debug.CheckTools(playerId)
    if not Config.Debug then return end
    
    local tools = {}
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        for _, tool in ipairs(Config.RequiredTools) do
            local item = xPlayer.getInventoryItem(Config.Framework.ESX.items[tool])
            tools[tool] = item and item.count or 0
        end
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(playerId)
        for _, tool in ipairs(Config.RequiredTools) do
            local item = Player.Functions.GetItemByName(Config.Framework.QBCore.items[tool])
            tools[tool] = item and item.amount or 0
        end
    end
    
    Debug.Log("Spieler Werkzeuge überprüft", Debug.Levels.DEBUG, {
        playerId = playerId,
        tools = tools
    })
    
    return tools
end

-- Funktion zum Überprüfen der Fahrzeugschäden
function Debug.CheckVehicleDamage(vehicle)
    if not Config.Debug then return end
    
    local damage = {
        body = GetVehicleBodyHealth(vehicle),
        engine = GetVehicleEngineHealth(vehicle),
        tank = GetVehiclePetrolTankHealth(vehicle),
        wheels = {}
    }
    
    for i = 0, 5 do
        damage.wheels[i] = IsVehicleTyreBurst(vehicle, i, false)
    end
    
    Debug.Log("Fahrzeugschäden überprüft", Debug.Levels.DEBUG, {
        vehicle = vehicle,
        damage = damage
    })
    
    return damage
end

-- Funktion zum Überprüfen der Reparaturzeit
function Debug.CheckRepairTime(vehicleClass)
    if not Config.Debug then return end
    
    local repairTime = Config.VehicleClasses[vehicleClass] and 
        Config.VehicleClasses[vehicleClass].repairTime or 
        Config.RepairTime
    
    Debug.Log("Reparaturzeit überprüft", Debug.Levels.DEBUG, {
        vehicleClass = vehicleClass,
        repairTime = repairTime
    })
    
    return repairTime
end

-- Debug-Befehle
RegisterCommand('repairdebug', function(source, args, rawCommand)
    if not Config.Debug then return end
    
    local playerId = source
    local subCommand = args[1]
    
    if subCommand == 'tools' then
        local tools = Debug.CheckTools(playerId)
        TriggerClientEvent('chat:addMessage', playerId, {
            color = {255, 255, 0},
            multiline = true,
            args = {"Debug", "Werkzeuge: " .. json.encode(tools)}
        })
    elseif subCommand == 'damage' then
        local ped = GetPlayerPed(playerId)
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle then
            local damage = Debug.CheckVehicleDamage(vehicle)
            TriggerClientEvent('chat:addMessage', playerId, {
                color = {255, 255, 0},
                multiline = true,
                args = {"Debug", "Schäden: " .. json.encode(damage)}
            })
        end
    elseif subCommand == 'time' then
        local ped = GetPlayerPed(playerId)
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle then
            local class = GetVehicleClass(vehicle)
            local time = Debug.CheckRepairTime(class)
            TriggerClientEvent('chat:addMessage', playerId, {
                color = {255, 255, 0},
                multiline = true,
                args = {"Debug", "Reparaturzeit: " .. time .. "ms"}
            })
        end
    end
end, false)

-- Exportiere Debug-Funktionen
exports('Debug', function()
    return Debug
end) 