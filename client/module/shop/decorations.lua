-- Decoration tracking storage
local appliedDecals = {}

-- Components that trigger decoration cleanup when changed
local MONITORED_COMPONENTS = {8, 11}

-- Large number for unsigned integer conversion
local UINT32_MAX = 4294967296

function GetAppliedDecals()
    return appliedDecals
end

function GetAppliedDecalByComponentId(componentId)
    return appliedDecals[componentId]
end

function ResetAppliedDecals()
    appliedDecals = {}
end

function SetAppliedDecal(componentId, collectionHash, decorationHash)
    local playerPed = PlayerPedId()
    local currentDrawable = GetPedDrawableVariation(playerPed, componentId)
    local currentTexture = GetPedTextureVariation(playerPed, componentId)
    
    appliedDecals[componentId] = {
        collectionHash,
        decorationHash,
        currentDrawable,
        currentTexture
    }
end

function ConvertToUnsignedInt(value)
    if value < 0 then
        return value + UINT32_MAX
    end
    return value
end

function UnsetPedDecorationByComponentId(componentId)
    local decalData = appliedDecals[componentId]
    if not decalData then
        return
    end
    
    local playerPed = PlayerPedId()
    local currentDecorations = GetPedDecorations(playerPed)
    
    -- Clear all decorations temporarily
    ClearPedDecorations(playerPed)
    
    -- Count existing decorations to avoid duplicates
    local decorationCounts = {}
    
    for _, existingDecal in pairs(appliedDecals) do
        local decorationKey = existingDecal[1] .. "_" .. existingDecal[2]
        decorationCounts[decorationKey] = (decorationCounts[decorationKey] or 0) + 1
    end
    
    -- Reapply decorations except the one being removed
    for _, decoration in pairs(currentDecorations) do
        local targetCollectionHash = decalData[1]
        local targetDecorationHash = decalData[2]
        
        -- Convert negative values to unsigned integers for comparison
        local currentCollection = ConvertToUnsignedInt(targetCollectionHash)
        local currentDecoration = ConvertToUnsignedInt(targetDecorationHash)
        
        local decorationKey = targetCollectionHash .. "_" .. targetDecorationHash
        
        local shouldSkip = false
        
        -- Skip if this is the decoration we want to remove and it's not duplicated
        if decoration[1] == currentCollection and decoration[2] == currentDecoration then
            if not decorationCounts[decorationKey] or decorationCounts[decorationKey] <= 1 then
                shouldSkip = true
            end
        end
        
        if not shouldSkip then
            if decorationCounts[decorationKey] then
                decorationCounts[decorationKey] = decorationCounts[decorationKey] - 1
            end
            SetPedDecoration(playerPed, decoration[1], decoration[2])
        end
    end
    
    -- Remove from tracking
    appliedDecals[componentId] = nil
end

-- Background thread to monitor clothing changes and cleanup decorations
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        
        for _, componentId in pairs(MONITORED_COMPONENTS) do
            local currentDrawable = GetPedDrawableVariation(playerPed, componentId)
            local currentTexture = GetPedTextureVariation(playerPed, componentId)
            
            local trackedDecal = appliedDecals[componentId]
            if trackedDecal then
                local trackedDrawable = trackedDecal[3]
                local trackedTexture = trackedDecal[4]
                
                -- If clothing changed, remove the associated decoration
                if trackedDrawable ~= currentDrawable or trackedTexture ~= currentTexture then
                    UnsetPedDecorationByComponentId(componentId)
                end
            end
        end
        
        Wait(1000)
    end
end)

-- Event handler to reapply all tracked decorations
AddEventHandler("rcore_clothing:reapplyDecorations", function()
    local playerPed = PlayerPedId()
    
    for _, decalData in pairs(appliedDecals) do
        SetPedDecoration(playerPed, decalData[1], decalData[2])
    end
end)