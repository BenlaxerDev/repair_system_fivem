Config = {}

--[[
    ============================================
    ============== DEUTSCHE ERKLÄRUNG ==========
    ============================================
    
    Diese Konfigurationsdatei enthält alle Einstellungen für das Advanced Vehicle Repair System.
    Sie können hier alle wichtigen Parameter anpassen, um das System an Ihre Bedürfnisse anzupassen.
    
    WICHTIG: Ändern Sie nur die Werte nach den Kommentaren, nicht die Struktur selbst!
]]

--[[
    ============================================
    ============= ENGLISH EXPLANATION ==========
    ============================================
    
    This configuration file contains all settings for the Advanced Vehicle Repair System.
    You can adjust all important parameters here to customize the system to your needs.
    
    IMPORTANT: Only change the values after the comments, not the structure itself!
]]

--[[
    ============================================
    ============== GRUNDEINSTELLUNGEN ==========
    ============================================
    
    Debug: Aktiviert/Deaktiviert den Debug-Modus
    UseFramework: Aktiviert/Deaktiviert die Framework-Integration
    Language: Legt die Sprache fest ('de' für Deutsch, 'en' für Englisch)
    ProgressBar: Legt das zu verwendende Progress-Bar-System fest
]]

--[[
    ============================================
    ============== BASIC SETTINGS ==============
    ============================================
    
    Debug: Enables/Disables debug mode
    UseFramework: Enables/Disables framework integration
    Language: Sets the language ('de' for German, 'en' for English)
    ProgressBar: Sets the progress bar system to use
]]

Config.Debug = false
Config.UseFramework = true
Config.Language = 'de'

-- Progress Bar Einstellungen
Config.ProgressBar = {
    -- Verfügbare Systeme: 'esx', 'ox_lib', 'custom'
    system = 'esx',
    
    -- ESX Progress Bar Einstellungen
    esx = {
        useProgressBar = true,
        useProgressBarWithStartEvent = false,
        useProgressBarWithTickEvent = false,
        useProgressBarWithStartAndTick = false
    },
    
    -- ox_lib Progress Bar Einstellungen
    ox_lib = {
        useCircular = false,
        useLinear = true,
        position = 'bottom', -- 'bottom', 'middle', 'top'
        duration = 15000,
        label = 'Repariere Fahrzeug...',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "mini@repair",
            anim = "fixing_a_ped",
            flags = 49,
        },
        prop = {
            model = `prop_weld_torch`,
            pos = {0.0, 0.0, 0.0},
            rot = {0.0, 0.0, 0.0}
        }
    },
    
    -- Custom Progress Bar Einstellungen
    custom = {
        -- Hier können Sie Ihre eigenen Progress-Bar-Einstellungen definieren
        duration = 15000,
        label = 'Repariere Fahrzeug...',
        position = 'bottom'
    }
}

--[[
    ============================================
    ============ REPARATUR-EINSTELLUNGEN =======
    ============================================
    
    RepairTime: Zeit in Millisekunden für die Standardreparatur
    RepairDistance: Maximale Entfernung zum Fahrzeug in Metern
    RequiredTools: Liste der benötigten Werkzeuge für die Standardreparatur
]]

--[[
    ============================================
    ============ REPAIR SETTINGS ===============
    ============================================
    
    RepairTime: Time in milliseconds for standard repair
    RepairDistance: Maximum distance to vehicle in meters
    RequiredTools: List of required tools for standard repair
]]

Config.RepairTime = 15000
Config.RepairDistance = 3.0
Config.RequiredTools = {
    "wrench",
    "repairkit"
}

--[[
    ============================================
    ============ FAHRZEUGKLASSEN ===============
    ============================================
    
    Hier können Sie für jede Fahrzeugklasse spezifische Einstellungen vornehmen:
    - repairTime: Spezifische Reparaturzeit für diese Klasse
    - requiredTools: Spezifische Werkzeuge für diese Klasse
    
    Klassen-IDs:
    0 = Kompakt
    1 = Limousine
    2 = SUV
    3 = Coupé
    4 = Muscle Car
    5 = Sportklassiker
]]

--[[
    ============================================
    ============ VEHICLE CLASSES ===============
    ============================================
    
    Here you can set specific settings for each vehicle class:
    - repairTime: Specific repair time for this class
    - requiredTools: Specific tools for this class
    
    Class IDs:
    0 = Compact
    1 = Sedan
    2 = SUV
    3 = Coupe
    4 = Muscle Car
    5 = Sports Classic
]]

Config.VehicleClasses = {
    [0] = { -- Compacts
        repairTime = 12000,
        requiredTools = {"wrench", "repairkit"}
    },
    [1] = { -- Sedans
        repairTime = 15000,
        requiredTools = {"wrench", "repairkit"}
    },
    [2] = { -- SUVs
        repairTime = 18000,
        requiredTools = {"wrench", "repairkit", "jack"}
    },
    [3] = { -- Coupes
        repairTime = 13000,
        requiredTools = {"wrench", "repairkit"}
    },
    [4] = { -- Muscle
        repairTime = 16000,
        requiredTools = {"wrench", "repairkit", "jack"}
    },
    [5] = { -- Sports Classics
        repairTime = 20000,
        requiredTools = {"wrench", "repairkit", "jack", "special_tools"}
    }
}

--[[
    ============================================
    ============ BENACHRICHTIGUNGEN ============
    ============================================
    
    Die Benachrichtigungen werden automatisch aus den Übersetzungsdateien geladen.
    Ändern Sie diese Werte nicht direkt hier, sondern in den entsprechenden
    Übersetzungsdateien (locales/de.lua oder locales/en.lua).
]]

--[[
    ============================================
    ============ NOTIFICATIONS =================
    ============================================
    
    Notifications are automatically loaded from the translation files.
    Do not change these values directly here, but in the corresponding
    translation files (locales/de.lua or locales/en.lua).
]]

Config.Notifications = {
    noTools = Locales[Config.Language]['no_tools'],
    repairComplete = Locales[Config.Language]['repair_complete'],
    repairFailed = Locales[Config.Language]['repair_failed'],
    tooFar = Locales[Config.Language]['too_far']
}

--[[
    ============================================
    ============ ANIMATIONEN ===================
    ============================================
    
    Hier können Sie die Animationen für verschiedene Aktionen anpassen.
    Verfügbare Animationen finden Sie in der FiveM-Dokumentation.
]]

--[[
    ============================================
    ============ ANIMATIONS ====================
    ============================================
    
    Here you can customize the animations for different actions.
    Available animations can be found in the FiveM documentation.
]]

Config.Animations = {
    repair = "PROP_HUMAN_BUM_BIN",
    check = "WORLD_HUMAN_CLIPBOARD"
}

--[[
    ============================================
    ============ FRAMEWORK-EINSTELLUNGEN =======
    ============================================
    
    Hier können Sie die Item-Namen für verschiedene Frameworks anpassen.
    Unterstützt werden ESX und QBCore.
]]

--[[
    ============================================
    ============ FRAMEWORK SETTINGS ============
    ============================================
    
    Here you can customize the item names for different frameworks.
    ESX and QBCore are supported.
]]

Config.Framework = {
    ESX = {
        items = {
            wrench = "repair_wrench",
            repairkit = "repair_kit",
            jack = "car_jack",
            special_tools = "special_repair_tools"
        }
    },
    QBCore = {
        items = {
            wrench = "repair_wrench",
            repairkit = "repair_kit",
            jack = "car_jack",
            special_tools = "special_repair_tools"
        }
    }
} 