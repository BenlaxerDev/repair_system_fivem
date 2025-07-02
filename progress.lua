local Progress = {}

-- ESX Progress Bar
function Progress.StartESX(duration, label, callback)
    if Config.ProgressBar.system ~= 'esx' then return end
    
    if Config.ProgressBar.esx.useProgressBar then
        exports['progressBars']:startUI(duration, label)
    elseif Config.ProgressBar.esx.useProgressBarWithStartEvent then
        TriggerEvent("mythic_progressbar:client:progress", {
            name = "repair_vehicle",
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if callback then callback(status) end
        end)
    elseif Config.ProgressBar.esx.useProgressBarWithTickEvent then
        exports['progressBars']:startUI(duration, label)
        Citizen.CreateThread(function()
            local tick = 0
            while tick < duration do
                tick = tick + 100
                TriggerEvent("progressBar:tick", tick, duration)
                Citizen.Wait(100)
            end
            if callback then callback(true) end
        end)
    elseif Config.ProgressBar.esx.useProgressBarWithStartAndTick then
        TriggerEvent("mythic_progressbar:client:progress", {
            name = "repair_vehicle",
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if status then
                local tick = 0
                while tick < duration do
                    tick = tick + 100
                    TriggerEvent("progressBar:tick", tick, duration)
                    Citizen.Wait(100)
                end
            end
            if callback then callback(status) end
        end)
    end
end

-- ox_lib Progress Bar
function Progress.StartOxLib(duration, label, callback)
    if Config.ProgressBar.system ~= 'ox_lib' then return end
    
    local options = {
        duration = duration or Config.ProgressBar.ox_lib.duration,
        label = label or Config.ProgressBar.ox_lib.label,
        useWhileDead = Config.ProgressBar.ox_lib.useWhileDead,
        canCancel = Config.ProgressBar.ox_lib.canCancel,
        controlDisables = Config.ProgressBar.ox_lib.controlDisables,
        animation = Config.ProgressBar.ox_lib.animation,
        prop = Config.ProgressBar.ox_lib.prop
    }
    
    if Config.ProgressBar.ox_lib.useCircular then
        if lib.progressCircle({
            duration = options.duration,
            label = options.label,
            position = Config.ProgressBar.ox_lib.position,
            useWhileDead = options.useWhileDead,
            canCancel = options.canCancel,
            disable = options.controlDisables,
            anim = options.animation,
            prop = options.prop
        }) then
            if callback then callback(true) end
        else
            if callback then callback(false) end
        end
    else
        if lib.progressBar({
            duration = options.duration,
            label = options.label,
            position = Config.ProgressBar.ox_lib.position,
            useWhileDead = options.useWhileDead,
            canCancel = options.canCancel,
            disable = options.controlDisables,
            anim = options.animation,
            prop = options.prop
        }) then
            if callback then callback(true) end
        else
            if callback then callback(false) end
        end
    end
end

-- Custom Progress Bar
function Progress.StartCustom(duration, label, callback)
    if Config.ProgressBar.system ~= 'custom' then return end
    
    -- Hier können Sie Ihre eigene Progress-Bar-Implementierung hinzufügen
    -- Beispiel:
    TriggerEvent('customProgressBar:start', {
        duration = duration or Config.ProgressBar.custom.duration,
        label = label or Config.ProgressBar.custom.label,
        position = Config.ProgressBar.custom.position
    }, function(success)
        if callback then callback(success) end
    end)
end

-- Hauptfunktion zum Starten der Progress Bar
function Progress.Start(duration, label, callback)
    if Config.ProgressBar.system == 'esx' then
        Progress.StartESX(duration, label, callback)
    elseif Config.ProgressBar.system == 'ox_lib' then
        Progress.StartOxLib(duration, label, callback)
    elseif Config.ProgressBar.system == 'custom' then
        Progress.StartCustom(duration, label, callback)
    end
end

-- Exportiere Progress-Funktionen
exports('Progress', function()
    return Progress
end) 