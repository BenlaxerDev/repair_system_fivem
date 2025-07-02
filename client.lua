local isRepairing = false
local repairTools = {
    wrench = true,
    repairkit = true
}

-- Konfiguration
local Config = {
    repairTime = 15000, -- Zeit in ms
    repairDistance = 3.0,
    requiredTools = {
        "wrench",
        "repairkit"
    },
    Language = "en",
    Animations = {
        repair = "PROP_HUMAN_BUM_BIN"
    },
    RepairTime = 15000,
    RequiredTools = {
        "wrench",
        "repairkit"
    }
}

-- Funktion zum Überprüfen der Werkzeuge
local function hasRequiredTools()
    for _, tool in ipairs(Config.RequiredTools) do
        if not repairTools[tool] then
            return false
        end
    end
    return true
end

-- Funktion zum Starten der Reparatur
local function startRepair(vehicle)
    if isRepairing then return end
    if not hasRequiredTools() then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", Locales[Config.Language]['no_tools']}
        })
        return
    end

    isRepairing = true
    
    -- Animation starten
    TaskStartScenarioInPlace(PlayerPedId(), Config.Animations.repair, 0, true)
    
    -- Progress Bar starten
    Progress.Start(Config.RepairTime, Locales[Config.Language]['repairing'], function(success)
        if success then
            -- Fahrzeug reparieren
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, true)
            
            -- Animation beenden
            ClearPedTasksImmediately(PlayerPedId())
            
            -- Benachrichtigung
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = true,
                args = {"System", Locales[Config.Language]['repair_complete']}
            })
        else
            -- Benachrichtigung bei Abbruch
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {"System", Locales[Config.Language]['repair_failed']}
            })
        end
        
        isRepairing = false
    end)
end

-- Hauptthread für die Reparaturfunktion
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        -- Überprüfen, ob Spieler in einem Fahrzeug ist
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            -- Reparatur-Taste (E)
            if IsControlJustPressed(0, 38) and not isRepairing then
                startRepair(vehicle)
            end
        end
    end
end)

-- Event Handler für Werkzeuge
RegisterNetEvent('advanced_repair:updateTools')
AddEventHandler('advanced_repair:updateTools', function(tools)
    repairTools = tools
end) 