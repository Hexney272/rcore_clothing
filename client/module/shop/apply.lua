-- Constants
local PRELOAD_TIMEOUT_MS = 3000
local PROP_COMPONENT_OFFSET = 100

function PreloadClothingVariation(pedHandle, componentId, drawableId, textureId)
    SetPedPreloadVariationData(pedHandle, componentId, drawableId, textureId)
    
    local startTime = GetGameTimer()
    
    while not HasPedPreloadVariationDataFinished(pedHandle) do
        local elapsedTime = GetGameTimer() - startTime
        
        if elapsedTime > PRELOAD_TIMEOUT_MS then
            print("[warning] Preload aborted, timeout. The item probably does not have model assigned")
            break
        end
        
        Wait(0)
    end
    
    -- Schedule cleanup in separate thread
    Citizen.CreateThread(function()
        ReleasePedPreloadVariationData(pedHandle)
    end)
end

function PreloadPropVariation(pedHandle, propId, drawableId, textureId)
    SetPedPreloadPropData(pedHandle, propId, drawableId, textureId)
    
    local startTime = GetGameTimer()
    
    while not HasPedPreloadPropDataFinished(pedHandle) do
        local elapsedTime = GetGameTimer() - startTime
        
        if elapsedTime > PRELOAD_TIMEOUT_MS then
            print("[warning] Preload aborted, timeout. The item probably does not have model assigned")
            break
        end
        
        Wait(0)
    end
end

function ResolveItemToClothingOrPropItem(pedHandle, item)
    local resolvedData = nil
    
    if item.component_id then
        if item.component_id < PROP_COMPONENT_OFFSET then
            -- Regular clothing component
            resolvedData = ResolveClothingItemToData(pedHandle, item)
        else
            -- Prop component (100+)
            resolvedData = ResolvePropItemToDataInternalComponent(pedHandle, item)
        end
    else
        -- Try clothing first, then props if clothing fails
        resolvedData = ResolveClothingItemToData(pedHandle, item)
        
        if not resolvedData.componentId then
            resolvedData = ResolvePropItemToDataInternalComponent(pedHandle, item)
        end
    end
    
    return resolvedData
end

function ApplyPropItem(pedHandle, resolvedItem, shouldPreload)
    local propId = resolvedItem.componentId - PROP_COMPONENT_OFFSET
    
    if resolvedItem.drawableId < 0 then
        -- Clear prop if drawable ID is negative
        ClearPedProp(pedHandle, propId)
    else
        if shouldPreload then
            PreloadPropVariation(pedHandle, propId, resolvedItem.drawableId, resolvedItem.textureId)
        end
        
        SetPedPropIndex(pedHandle, propId, resolvedItem.drawableId, resolvedItem.textureId, true)
        
        if shouldPreload then
            ReleasePedPreloadPropData(pedHandle)
        end
    end
end

function ApplyClothingComponent(pedHandle, item, resolvedItem, shouldPreload, skipArms)
    if resolvedItem.componentId == 3 then
        -- Special handling for arms/torso component
        if IsBaseArms(item.name_hash) then
            if not item.gloves and not skipArms then
                ApplyArms(item.name_hash, resolvedItem)
            end
        end
    else
        if shouldPreload then
            PreloadClothingVariation(pedHandle, resolvedItem.componentId, resolvedItem.drawableId, resolvedItem.textureId)
        end
        
        RcoreSetPedComponentVariation(pedHandle, resolvedItem.componentId, resolvedItem.drawableId, resolvedItem.textureId, resolvedItem.palette)
        
        if shouldPreload then
            ReleasePedPreloadVariationData(pedHandle)
        end
    end
    
    -- Apply recommended arms if not in debug mode
    if not IsDebuggingImages() and item.recommended_arms then
        ApplyArms(item.recommended_arms)
    end
end

function ApplyPedClothingItem(pedHandle, item, skipArms, shouldPreload)
    local resolvedItem = ResolveItemToClothingOrPropItem(pedHandle, item)
    
    if not resolvedItem or not resolvedItem.componentId then
        print("Attempting to apply clothing that doesnt exist", item.name_hash)
        return
    end
    
    if resolvedItem.componentId >= PROP_COMPONENT_OFFSET then
        -- Handle props (component ID 100+)
        ApplyPropItem(pedHandle, resolvedItem, shouldPreload)
    else
        -- Handle regular clothing components
        ApplyClothingComponent(pedHandle, item, resolvedItem, shouldPreload, skipArms)
    end
end

function ApplyArms(armsHash, fallbackData)
    local playerPed = PlayerPedId()
    
    -- Get current arms data
    local currentArmsDrawable = GetPedDrawableVariation(playerPed, 3)
    local currentArmsTexture = GetPedTextureVariation(playerPed, 3)
    local currentArmsNameHash = GetHashNameForComponent(playerPed, 3, currentArmsDrawable, currentArmsTexture)
    local currentArmsUsableHash = GetUsableHash(3, currentArmsDrawable, currentArmsTexture, currentArmsNameHash)
    
    -- Get base arms and equivalent gloves
    local baseArmsHash, _ = GetBaseArmsFromHash(currentArmsUsableHash)
    local equivalentGlovesHash = GetEquivalentGlovesFromHash(currentArmsUsableHash, armsHash)
    
    if equivalentGlovesHash then
        local glovesData = UsableHashToData(playerPed, equivalentGlovesHash)
        
        if glovesData.drawableId ~= nil then
            RcoreSetPedComponentVariation(playerPed, 3, glovesData.drawableId, glovesData.textureId, 0)
        elseif fallbackData then
            RcoreSetPedComponentVariation(playerPed, fallbackData.componentId, fallbackData.drawableId, fallbackData.textureId, fallbackData.palette)
        end
    elseif fallbackData then
        RcoreSetPedComponentVariation(playerPed, fallbackData.componentId, fallbackData.drawableId, fallbackData.textureId, fallbackData.palette)
    end
end