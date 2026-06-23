local L1_1

function GetFormattedPedHeadblendData(pedHandle)
    -- Create 128-byte buffer (16 * 8 = 128 bytes)
    local dataBuffer = string.rep("\000\000\000\000\000\000\000\000", 16)
    local success = Citizen.InvokeNative(
        2830157900151113168,  -- Native hash for getting headblend data
        pedHandle,
        dataBuffer,
        Citizen.ReturnResultAnyway()
    )
    
    if success then
        local headblendData = {}
        
        -- Extract integer values from buffer (6 int32 values)
        headblendData[1] = string.unpack("<i4", dataBuffer, 1)   -- Shape first
        headblendData[2] = string.unpack("<i4", dataBuffer, 9)   -- Shape second  
        headblendData[3] = string.unpack("<i4", dataBuffer, 17)  -- Shape third
        headblendData[4] = string.unpack("<i4", dataBuffer, 25)  -- Skin first
        headblendData[5] = string.unpack("<i4", dataBuffer, 33)  -- Skin second
        headblendData[6] = string.unpack("<i4", dataBuffer, 41)  -- Skin third
        
        -- Extract float values from buffer (3 float32 values)
        headblendData[7] = string.unpack("<f", dataBuffer, 49)   -- Shape mix
        headblendData[8] = string.unpack("<f", dataBuffer, 57)   -- Skin mix
        headblendData[9] = string.unpack("<f", dataBuffer, 65)   -- Third mix
        
        return headblendData
    end
    
    -- Return default values if native call failed
    return {1, 1, 1, 1, 1, 1, 0.0, 0.0, 0.0}
end

function GetComponentUsableHash(pedHandle, componentType)
    local drawableId = GetPedDrawableVariation(pedHandle, componentType)
    local textureId = GetPedTextureVariation(pedHandle, componentType)
    local componentHash = GetHashNameForComponent(pedHandle, componentType, drawableId, textureId)
    
    return GetUsableHash(componentType, drawableId, textureId, componentHash)
end

function GetPedPropData(pedHandle)
    local propData = {}
    
    -- Loop through all prop slots (0-7: hat, glasses, ears, watch, bracelet, etc.)
    for propSlot = 0, 7 do
        propData[propSlot] = GetPedSinglePropData(pedHandle, propSlot)
    end
    
    return propData
end

function GetPedSinglePropData(pedHandle, propSlot)
    local propIndex = GetPedPropIndex(pedHandle, propSlot)
    local textureIndex = GetPedPropTextureIndex(pedHandle, propSlot)
    
    return {propIndex, textureIndex}
end

function GetPedComponentData(pedHandle)
    local componentData = {}
    
    -- Loop through all component slots (0-11: face, mask, hair, torso, etc.)
    for componentSlot = 0, 11 do
        componentData[componentSlot] = GetPedSingleComponentData(pedHandle, componentSlot)
    end
    
    return componentData
end

function GetPedSingleComponentData(pedHandle, componentSlot)
    local drawableId = GetPedDrawableVariation(pedHandle, componentSlot)
    local textureId = GetPedTextureVariation(pedHandle, componentSlot)
    local paletteId = GetPedPaletteVariation(pedHandle, componentSlot)
    
    return {drawableId, textureId, paletteId}
end

function GetHairColorData(pedHandle)
    local primaryColor = GetPedHairColor(pedHandle)
    local highlightColor = GetPedHairHighlightColor(pedHandle)
    
    return {primaryColor, highlightColor}
end

function GetPedFaceFeatures(pedHandle)
    -- Check if head is shrinked and return pre-shrink data if available
    if IsHeadShrinked() then
        return GetPreShrink()
    end
    
    local faceFeatures = {}
    
    -- Loop through all face feature indices (0-19)
    for featureIndex = 0, 19 do
        faceFeatures[featureIndex] = GetPedFaceFeature(pedHandle, featureIndex)
    end
    
    return faceFeatures
end

function GetPedHeadOverlays(pedHandle)
    local overlayData = {}
    
    -- Loop through all head overlay indices (0-12: blemishes, beard, eyebrows, etc.)
    for overlayIndex = 0, 12 do
        local success, overlayValue, colorType, firstColor, secondColor, opacity = 
            GetPedHeadOverlayData(pedHandle, overlayIndex)
        
        overlayData[overlayIndex] = {
            overlayValue,
            colorType, 
            firstColor,
            secondColor,
            opacity
        }
    end
    
    return overlayData
end

function GetOutfitOptions()
    local shopConfig = GetCurrentShopConfig()
    local isJobChangingRoom = shopConfig and 
                             shopConfig.modifiers and 
                             shopConfig.modifiers[SHOP_MODIFIERS.JOB_CHANGING_ROOM]
    
    local outfitOptions = {}
    
    -- My Outfits category
    local myOutfitsCategory = {
        subtype = "my_outfits",
        id = "my_outfits", 
        type = "category",
        label = _U("outfits.my_outfits"),
        image = "*img/card_img/my_outfits.webp"
    }
    
    -- Global/Shop/Job Outfits category
    local globalOutfitsCategory = {
        subtype = "global_outfits",
        id = "global_outfits",
        type = "category",
        label = isJobChangingRoom and _U("outfits.job_outfits") or _U("outfits.shop_outfits"),
        image = isJobChangingRoom and "*img/card_img/job_outfits.webp" or "*img/card_img/shop_outfits.webp"
    }
    
    outfitOptions[1] = myOutfitsCategory
    outfitOptions[2] = globalOutfitsCategory
    
    return outfitOptions
end

function LoadAndSetModel(modelHash)
    -- Request and wait for model to load
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end
    
    -- Set player model
    SetPlayerModel(PlayerId(), modelHash)
    SetModelAsNoLongerNeeded(modelHash)
    
    -- Reset headblend data for freemode models
    if IsModelFreemode(modelHash) then
        SetPedHeadBlendData(
            PlayerPedId(),
            0, 0, 0,  -- Shape parents
            0, 0, 0,  -- Skin parents  
            0.0, 0.0, 0.0,  -- Mix values
            false  -- Is parent
        )
    end
end

function RcoreSetPedComponentVariation(pedHandle, componentType, drawableId, textureId, paletteId)
    local pedModel = GetEntityModel(pedHandle)
    
    -- Special handling for undershirt component (type 8) and Christmas outfits
    if componentType == 8 then
        local collectionName = GetPedCollectionNameFromDrawable(pedHandle, componentType, drawableId)
        local localIndex = GetPedCollectionLocalIndexFromDrawable(pedHandle, componentType, drawableId)
        
        -- Male ped with Christmas outfit
        if pedModel == 1885233650 then  -- mp_m_freemode_01
            if drawableId == 123 or 
               (collectionName == "mp_m_christmas2017" and localIndex == 1) then
                SetPedConfigFlag(pedHandle, 409, true)
            end
        -- Female ped with Christmas outfit    
        elseif pedModel == -1667301416 then  -- mp_f_freemode_01
            if drawableId == 153 or 
               (collectionName == "mp_f_christmas2017" and localIndex == 1) then
                SetPedConfigFlag(pedHandle, 409, true)
            end
        end
    end
    
    -- Apply the component variation
    SetPedComponentVariation(pedHandle, componentType, drawableId, textureId, paletteId)
    
    -- Handle head shrinking for mask component (type 1)
    if componentType == 1 then
        UnshrinkHead(pedHandle)
        EnsureHeadShrink()
    end
end

function CustomSetDefaultVariations(pedHandle)
    if not Config.PedDefaults then
        return
    end
    
    local pedModel = GetEntityModel(pedHandle)
    local defaultVariations = Config.PedDefaults[pedModel]
    
    if defaultVariations then
        for componentType, variationData in pairs(defaultVariations) do
            if type(variationData) == "table" then
                -- Table format: {drawableId, textureId}
                RcoreSetPedComponentVariation(
                    pedHandle,
                    componentType,
                    variationData[1],  -- drawableId
                    variationData[2],  -- textureId
                    2  -- paletteId
                )
            else
                -- Single value format: just drawableId
                RcoreSetPedComponentVariation(
                    pedHandle,
                    componentType,
                    variationData,  -- drawableId
                    0,  -- textureId
                    2   -- paletteId
                )
            end
        end
    end
end