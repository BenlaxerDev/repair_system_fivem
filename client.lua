local isRepairing = false
local repairTools = {}

local function hasRequiredTools(requiredTools)
    for _, tool in ipairs(requiredTools) do
        if not repairTools[tool] then
            return false
        end
    end
    return true
end

local function getVehicleRepairConfig(vehicle)
    local class = GetVehicleClass(vehicle)
    local classConfig = Config.VehicleClasses and Config.VehicleClasses[class]
    if classConfig then
        return classConfig.repairTime or Config.RepairTime, classConfig.requiredTools or Config.RequiredTools, class
    end
    return Config.RepairTime, Config.RequiredTools, class
end

local function startProgressBar(duration, label, cb)
    if Progress and Progress.Start then
        Progress.Start(duration, label, cb)
    else
        Citizen.SetTimeout(duration, function()
            if cb then cb(true) end
        end)
    end
end

local function startRepair(vehicle)
    if isRepairing then return end

    local repairTime, requiredTools, vehicleClass = getVehicleRepairConfig(vehicle)
    local language = Config.Language or 'de'
    local Locales = _G.Locales or {}
    if not hasRequiredTools(requiredTools) then
        exports['ox_lib']:notify({
            type = 'error',
            description = Locales[language] and Locales[language]['no_tools'] or "Du hast nicht alle benötigten Werkzeuge!",
            position = 'top',
            duration = 5000
        })
        return
    end

    TriggerServerEvent('advanced_repair:requestRepair', VehToNet(vehicle), vehicleClass)
end

RegisterNetEvent('advanced_repair:updateTools')
AddEventHandler('advanced_repair:updateTools', function(tools)
    repairTools = tools or {}
end)

RegisterNetEvent('advanced_repair:startRepair')
AddEventHandler('advanced_repair:startRepair', function(vehicleNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if vehicle and not isRepairing then
        isRepairing = true
        local repairTime, requiredTools, vehicleClass = getVehicleRepairConfig(vehicle)
        local language = Config.Language or 'de'
        local Locales = _G.Locales or {}
        TaskStartScenarioInPlace(PlayerPedId(), Config.Animations and Config.Animations.repair or "PROP_HUMAN_BUM_BIN", 0, true)
        startProgressBar(repairTime, Locales[language] and Locales[language]['repairing'] or "Reparatur läuft...", function(success)
            if success then
                TriggerServerEvent('advanced_repair:repairComplete', VehToNet(vehicle))
                ClearPedTasksImmediately(PlayerPedId())
                exports['ox_lib']:notify({
                    type = 'success',
                    description = Locales[language] and Locales[language]['repair_complete'] or "Reparatur abgeschlossen!",
                    position = 'top',
                    duration = 5000
                })
            else
                exports['ox_lib']:notify({
                    type = 'error',
                    description = Locales[language] and Locales[language]['repair_failed'] or "Reparatur fehlgeschlagen!",
                    position = 'top',
                    duration = 5000
                })
            end
            isRepairing = false
        end)
    end
end)

exports('startRepair', function(vehicle)
    startRepair(vehicle)
end)