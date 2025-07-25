local ESX = nil
local QBCore = nil

if Config.UseFramework then
    if GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end

local function getRequiredToolsForClass(class)
    if Config.VehicleClasses and Config.VehicleClasses[class] then
        return Config.VehicleClasses[class].requiredTools or Config.RequiredTools
    end
    return Config.RequiredTools
end

local function checkPlayerTools(source, class)
    if not Config.UseFramework then return true end
    local hasTools = true
    local requiredTools = getRequiredToolsForClass(class)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        for _, tool in ipairs(requiredTools) do
            local item = xPlayer.getInventoryItem(tool)
            if not item or item.count < 1 then
                hasTools = false
                break
            end
        end
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        for _, tool in ipairs(requiredTools) do
            local item = Player.Functions.GetItemByName(tool)
            if not item or item.amount < 1 then
                hasTools = false
                break
            end
        end
    end
    return hasTools
end

RegisterNetEvent('advanced_repair:requestRepair')
AddEventHandler('advanced_repair:requestRepair', function(vehicleNetId, vehicleClass)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if not vehicle then return end
    if not checkPlayerTools(source, vehicleClass) then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = Config.Notifications and Config.Notifications.noTools or "Du hast nicht alle benötigten Werkzeuge!",
            position = 'top',
            duration = 5000
        })
        return
    end
    TriggerClientEvent('advanced_repair:startRepair', source, vehicleNetId)
end)

RegisterNetEvent('advanced_repair:repairComplete')
AddEventHandler('advanced_repair:repairComplete', function(vehicleNetId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    
    if not vehicle then return end
    
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true, false)
    
    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = Config.Notifications and Config.Notifications.repairComplete or "Reparatur abgeschlossen!",
        position = 'top',
        duration = 5000
    })
end)

if Config.Debug then
    RegisterCommand('checktools', function(source, args, rawCommand)
        local hasTools = checkPlayerTools(source)
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'info',
            description = "Werkzeuge vorhanden: " .. tostring(hasTools),
            position = 'top',
            duration = 5000
        })
    end, false)
end 