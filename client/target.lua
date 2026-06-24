local targetCounter = 1
local registeredModels = {}
local registeredZones = {}
local targetPrefix = "rcore_clothing_target_"

function GenerateTargetId()
    local targetId = targetCounter
    targetCounter = targetCounter + 1
    return targetPrefix .. targetId
end

TargetType = {
    NO_TARGET = 0,
    Q_TARGET = 1,
    BT_TARGET = 2,
    QB_TARGET = 3,
    OX_TARGET = 4
}

TargetTypeResourceName = {
    [TargetType.NO_TARGET] = "none",
    [TargetType.Q_TARGET] = "qtarget",
    [TargetType.BT_TARGET] = "bt-target",
    [TargetType.QB_TARGET] = "qb-target",
    [TargetType.OX_TARGET] = "ox_target"
}

function CreateTargetZone(coords, length, width, heading, options)
    local resourceName = TargetTypeResourceName[Config.TargetScript]
    local targetId = GenerateTargetId()
    
    local compatibleTargets = {
        [TargetType.Q_TARGET] = true,
        [TargetType.BT_TARGET] = true,
        [TargetType.QB_TARGET] = true
    }
    
    if Config.TargetScript == TargetType.OX_TARGET then
        -- Adjust coordinates for ox_target (lower Z by 0.5)
        local adjustedCoords = vector3(coords.x, coords.y, coords.z - 0.5)
        
        -- Convert qb-target style options to ox_target format
        local oxOptions = {}
        for _, opt in pairs(options) do
            table.insert(oxOptions, {
                name = targetId .. "_" .. (opt.eventAction or "action"),
                label = opt.label,
                icon = opt.icon or 'fas fa-tshirt',
                distance = opt.distance or 2.0,
                canInteract = opt.canInteract,
                onSelect = function(data)
                    if opt.event then
                        TriggerEvent(opt.event, opt)
                    end
                end,
            })
        end
        
        local zoneId = exports.ox_target:addBoxZone({
            name = targetId,
            coords = adjustedCoords,
            size = vector3(width, length, 2.0),
            rotation = heading,
            debug = false,
            options = oxOptions,
        })
        registeredZones[zoneId] = true
    elseif compatibleTargets[Config.TargetScript] then
        local zoneConfig = {
            options = options,
            distance = options.distance or 5.0,
            heading = heading
        }
        
        local zoneOptions = {
            name = targetId,
            heading = heading,
            minZ = coords.z - length,
            maxZ = coords.z + length
        }
        
        exports[resourceName]:AddBoxZone(
            targetId,
            coords,
            length,
            width,
            zoneOptions,
            zoneConfig
        )
    end
end

function CreateTargetModel(modelHash, options)
    local modelKey = tonumber(modelHash)
    if not modelKey then
        modelKey = GetHashKey(modelHash)
        modelHash = modelKey
    end
    
    registeredModels[modelHash] = true
    
    local resourceName = TargetTypeResourceName[Config.TargetScript]
    local targetId = GenerateTargetId()
    
    local compatibleTargets = {
        [TargetType.Q_TARGET] = true,
        [TargetType.BT_TARGET] = true,
        [TargetType.QB_TARGET] = true
    }
    
    if Config.TargetScript == TargetType.OX_TARGET then
        exports.ox_target:addModel(modelHash, options)
    elseif compatibleTargets[Config.TargetScript] then
        local modelConfig = {
            options = options,
            distance = options.distance or 5.0
        }
        
        exports[resourceName]:AddTargetModel(modelHash, modelConfig)
    end
end

function RemoveAllTargetZones()
    local resourceName = TargetTypeResourceName[Config.TargetScript]
    local targetId = GenerateTargetId()
    
    local compatibleTargets = {
        [TargetType.Q_TARGET] = true,
        [TargetType.BT_TARGET] = true,
        [TargetType.QB_TARGET] = true
    }
    
    if Config.TargetScript == TargetType.OX_TARGET then
        -- Remove all registered models
        for modelHash, _ in pairs(registeredModels) do
            exports.ox_target:removeModel(modelHash)
        end
        
        -- Remove all registered zones
        for zoneId, _ in pairs(registeredZones) do
            exports.ox_target:removeZone(zoneId)
        end
    elseif compatibleTargets[Config.TargetScript] then
        -- Remove all zones by counter ID
        for i = 1, targetCounter do
            local zoneName = targetPrefix .. i
            exports[resourceName]:RemoveZone(zoneName)
        end
        
        -- Remove model targets (except for bt-target)
        if Config.TargetScript ~= TargetType.BT_TARGET then
            for modelHash, _ in pairs(registeredModels) do
                exports[resourceName]:RemoveTargetModel(modelHash)
            end
        end
    end
    
    -- Clear tracking tables
    registeredModels = {}
    registeredZones = {}
end