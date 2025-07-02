local ESX = nil
local QBCore = nil

-- Framework Initialisierung
if Config.UseFramework then
    if GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end

-- Funktion zum Überprüfen der Spielerwerkzeuge
local function checkPlayerTools(source)
    if not Config.UseFramework then return true end
    
    local hasTools = true
    
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        for _, tool in ipairs(Config.RequiredTools) do
            local item = xPlayer.getInventoryItem(Config.Framework.ESX.items[tool])
            if not item or item.count < 1 then
                hasTools = false
                break
            end
        end
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        for _, tool in ipairs(Config.RequiredTools) do
            local item = Player.Functions.GetItemByName(Config.Framework.QBCore.items[tool])
            if not item or item.amount < 1 then
                hasTools = false
                break
            end
        end
    end
    
    return hasTools
end

-- Event Handler für Reparaturanfragen
RegisterNetEvent('advanced_repair:requestRepair')
AddEventHandler('advanced_repair:requestRepair', function(vehicleNetId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    
    if not vehicle then return end
    
    -- Überprüfen der Werkzeuge
    if not checkPlayerTools(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", Config.Notifications.noTools}
        })
        return
    end
    
    -- Reparatur erlauben
    TriggerClientEvent('advanced_repair:startRepair', source, vehicleNetId)
end)

-- Event Handler für Reparaturabschluss
RegisterNetEvent('advanced_repair:repairComplete')
AddEventHandler('advanced_repair:repairComplete', function(vehicleNetId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    
    if not vehicle then return end
    
    -- Fahrzeug reparieren
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true)
    
    -- Benachrichtigung
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        multiline = true,
        args = {"System", Config.Notifications.repairComplete}
    })
end)

-- Debug-Modus
if Config.Debug then
    RegisterCommand('checktools', function(source, args, rawCommand)
        local hasTools = checkPlayerTools(source)
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 0},
            multiline = true,
            args = {"Debug", "Werkzeuge vorhanden: " .. tostring(hasTools)}
        })
    end, false)
end 