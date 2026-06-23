-- Prop component offset for usable hash generation
local PROP_COMPONENT_OFFSET = 100

-- Face feature and head overlay ranges
local MAX_FACE_FEATURES = 19
local MAX_HEAD_OVERLAYS = 12

function GetPropUsableHash(pedHandle, propId)
    local propIndex = GetPedPropIndex(pedHandle, propId)
    local propTexture = GetPedPropTextureIndex(pedHandle, propId)
    local propNameHash = GetHashNameForProp(pedHandle, propId, propIndex, propTexture)
    
    return GetUsableHash(propId + PROP_COMPONENT_OFFSET, propIndex, propTexture, propNameHash)
end

function CollectPedAppearanceData(includeHeadData)
    local appearanceData = {
        props = {},
        components = {}
    }
    
    local playerPed = PlayerPedId()
    
    -- Collect prop data
    appearanceData.props["0"] = GetPropUsableHash(playerPed, 0)  -- Hats
    appearanceData.props["1"] = GetPropUsableHash(playerPed, 1)  -- Glasses
    appearanceData.props["2"] = GetPropUsableHash(playerPed, 2)  -- Earrings
    appearanceData.props["6"] = GetPropUsableHash(playerPed, 6)  -- Watches
    appearanceData.props["7"] = GetPropUsableHash(playerPed, 7)  -- Bracelets
    
    -- Collect clothing component data (skip component 2/hair for now)
    for componentId = 0, 11 do
        if componentId ~= 2 then
            local drawableId = GetPedDrawableVariation(playerPed, componentId)
            local textureId = GetPedTextureVariation(playerPed, componentId)
            local nameHash = GetHashNameForComponent(playerPed, componentId, drawableId, textureId)
            local usableHash = GetUsableHash(componentId, drawableId, textureId, nameHash)
            
            appearanceData.components[tostring(componentId)] = usableHash
        end
    end
    
    -- Collect decoration/decal data
    local appliedDecals = GetAppliedDecals()
    for componentId, decalData in pairs(appliedDecals) do
        if not appearanceData.decals then
            appearanceData.decals = {}
        end
        
        appearanceData.decals[tostring(componentId)] = {
            collection = decalData[1],
            name = decalData[2]
        }
    end
    
    -- Collect eye color
    appearanceData.eyeColor = GetPedEyeColor(playerPed)
    
    -- Collect detailed head data if requested
    if includeHeadData then
        CollectHeadData(appearanceData, playerPed)
    end
    
    return appearanceData
end

function CollectHeadData(appearanceData, playerPed)
    -- Collect head blend data
    local headBlendData = GetFormattedPedHeadblendData(playerPed)
    
    -- Use pre-shrink data if head is shrinked
    if IsHeadShrinked() then
        headBlendData = GetPreShrinkHeadblend()
    end
    
    appearanceData.headblend = {
        maleModel = headBlendData[1],
        femaleModel = headBlendData[2],
        maleTone = headBlendData[4],
        femaleTone = headBlendData[5],
        modelBlend = headBlendData[7],
        toneBlend = headBlendData[8]
    }
    
    -- Collect face features
    appearanceData.faceFeatures = {}
    
    if IsHeadShrinked() then
        local preShrinkData = GetPreShrink()
        for featureIndex = 0, MAX_FACE_FEATURES do
            appearanceData.faceFeatures[tostring(featureIndex)] = preShrinkData[featureIndex]
        end
    else
        for featureIndex = 0, MAX_FACE_FEATURES do
            local featureValue = GetPedFaceFeature(playerPed, featureIndex)
            appearanceData.faceFeatures[tostring(featureIndex)] = featureValue
        end
    end
    
    -- Collect head overlays (makeup, tattoos, etc.)
    appearanceData.headOverlay = {}
    
    for overlayIndex = 0, MAX_HEAD_OVERLAYS do
        local hasOverlay, overlayId, _, color1, color2, opacity = GetPedHeadOverlayData(playerPed, overlayIndex)
        
        if hasOverlay then
            appearanceData.headOverlay[tostring(overlayIndex)] = {
                id = overlayId,
                color1 = color1,
                color2 = color2,
                opacity = opacity
            }
        end
    end
    
    -- Collect hair data (component 2)
    local hairComponentId = 2
    local hairDrawable = GetPedDrawableVariation(playerPed, hairComponentId)
    local hairTexture = GetPedTextureVariation(playerPed, hairComponentId)
    local hairNameHash = GetHashNameForComponent(playerPed, hairComponentId, hairDrawable, hairTexture)
    local hairUsableHash = GetUsableHash(hairComponentId, hairDrawable, hairTexture, hairNameHash)
    
    appearanceData.components["2"] = hairUsableHash
    
    appearanceData.hair = {
        id = hairUsableHash,
        color1 = GetPedHairColor(playerPed),
        color2 = GetPedHairHighlightColor(playerPed)
    }
end

function SaveCurrentAsOutfit(outfitName)
    local outfitData = CollectPedAppearanceData(Config.SaveHeadWithOutfit)
    TriggerServerEvent("rcore_clothing:savePersonalOutfit", outfitName, outfitData)
end

function SaveCurrentAsShopOutfit(shopId, outfitName, price, category, subcategory)
    local outfitData = CollectPedAppearanceData()
    TriggerServerEvent("rcore_clothing:saveShopOutfit", shopId, outfitName, price, category, subcategory, outfitData)
end

-- Event handlers
RegisterNetEvent("rcore_clothing:saveCurrentSkin", function()
    local skinData = CollectPedAppearanceData(true)
    TriggerServerEvent("rcore_clothing:setOutfitAsCurrent", skinData)
end)