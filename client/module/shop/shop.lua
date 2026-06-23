-- Shop state management
local initialPedData = nil
local currentShopPed = nil
local currentShopConfig = nil

-- Preview state flags
local isPreviewingHeadblend = false
local isPreviewingFaceFeatures = false
local isPreviewingEyeColor = false
local isPreviewingHair = false
local isPreviewingHeadOverlay = false
local currentOverlayIndex = false
local isPreviewingPedModel = false

-- Ped model constants
local MALE_PED_MODEL = 1885233650
local FEMALE_PED_MODEL = -1667301416

-- Prop component offset
local PROP_COMPONENT_OFFSET = 100

-- Shop configuration functions
function SetCurrentShopConfig(shopConfig)
    currentShopConfig = shopConfig
end

function GetCurrentShopConfig()
    return currentShopConfig
end

function ClearCurrentShopConfig()
    currentShopConfig = nil
end

function HasCurrentShopGotEverything()
    local shopConfig = GetCurrentShopConfig()
    
    if shopConfig and shopConfig.modifiers then
        return shopConfig.modifiers[SHOP_MODIFIERS.HAS_EVERYTHING]
    end
    
    return false
end

function HasCurrentShopGotEverythingIdMode()
    local shopConfig = GetCurrentShopConfig()
    
    if shopConfig and shopConfig.modifiers then
        return shopConfig.modifiers[SHOP_MODIFIERS.ID_MODE_HAS_EVERYTHING]
    end
    
    return false
end

function HasCurrentShopEverythingFree()
    local shopConfig = GetCurrentShopConfig()
    
    if shopConfig and shopConfig.modifiers then
        return shopConfig.modifiers[SHOP_MODIFIERS.IS_EVERYTHING_FREE]
    end
    
    return false
end

-- Ped model utilities
function IsModelFreemode(pedModel)
    return pedModel == FEMALE_PED_MODEL or pedModel == MALE_PED_MODEL
end

function IsPedFreemode(pedHandle)
    return IsModelFreemode(GetEntityModel(pedHandle))
end

-- Default head blend data
function GetDefaultHeadblend(pedModel)
    if not IsModelFreemode(pedModel) then
        return nil
    end
    
    local defaultHeadblends = {
        [FEMALE_PED_MODEL] = {
            maleModel = 0,
            femaleModel = 45,
            maleTone = 0,
            femaleTone = 0,
            modelBlend = 0.0,
            toneBlend = 0.0
        },
        [MALE_PED_MODEL] = {
            maleModel = 0,
            femaleModel = 45,
            maleTone = 0,
            femaleTone = 0,
            modelBlend = 1.0,
            toneBlend = 0.0
        }
    }
    
    -- Use config override if available
    if Config.DefaultHeadblend and Config.DefaultHeadblend[pedModel] then
        return Config.DefaultHeadblend[pedModel]
    end
    
    return defaultHeadblends[pedModel]
end

function ApplyDefaultHeadblend(pedModel, pedHandle)
    if not IsModelFreemode(pedModel) then
        return
    end
    
    local headblendData = GetDefaultHeadblend(pedModel)
    if headblendData then
        SetPedHeadBlendData(pedHandle, headblendData.maleModel, headblendData.femaleModel, 0, headblendData.maleTone, headblendData.femaleTone, 0, headblendData.modelBlend, headblendData.toneBlend, 0.0, false)
    end
end

-- Shop initialization and ped management
function GetInitialPedSetup()
    return initialPedData
end

function GetShopPed()
    return currentShopPed
end

function SpawnPedRefreshWorker()
    CreateThread(function()
        while currentShopConfig do
            currentShopPed = PlayerPedId()
            Wait(500)
        end
    end)
end

function GetCurrentPedHeadblendData(pedHandle)
    if IsHeadShrinked() then
        return GetPreShrinkHeadblend()
    end
    
    return GetFormattedPedHeadblendData(pedHandle)
end

function GetCurrentPedData(pedHandle)
    local componentData = GetPedComponentData(pedHandle)
    local hairUsableHash = GetUsableHash(2, componentData[2][1], componentData[2][2])
    
    return {
        headblend = GetCurrentPedHeadblendData(pedHandle),
        props = GetPedPropData(pedHandle),
        components = componentData,
        hair = hairUsableHash,
        hairColor = GetHairColorData(pedHandle),
        face = GetPedFaceFeatures(pedHandle),
        eyeColor = GetPedEyeColor(pedHandle),
        headOverlay = GetPedHeadOverlays(pedHandle),
        pedModel = GetEntityModel(pedHandle),
        decal8 = GetAppliedDecalByComponentId(8),
        decal11 = GetAppliedDecalByComponentId(11)
    }
end

function SendCurrentPedDataNUI()
    local shopPed = GetShopPed()
    local pedData = GetCurrentPedData(shopPed)
    SendReactMessage("setCurrentPedData", pedData)
end

function ShopInit(pedHandle)
    currentShopPed = pedHandle
    SpawnPedRefreshWorker()
    initialPedData = GetCurrentPedData(pedHandle)
end

-- Preview functions
function ShopHeadblendPreview(maleModel, femaleModel, modelBlend, maleTone, femaleTone, toneBlend)
    isPreviewingHeadblend = true
    SetPedHeadBlendData(currentShopPed, maleModel, femaleModel, 0, maleTone, femaleTone, 0, modelBlend, toneBlend, 0.0, false)
end

function ShopHeadblendIsPreviewing()
    return isPreviewingHeadblend
end

function ShopHeadblendReset()
    if not IsModelFreemode(GetEntityModel(PlayerPedId())) then
        return
    end
    
    isPreviewingHeadblend = false
    local headblendData = initialPedData.headblend
    SetPedHeadBlendData(currentShopPed, headblendData[1], headblendData[2], headblendData[3], headblendData[4], headblendData[5], headblendData[6], headblendData[7], headblendData[8], headblendData[9], false)
end

function ShopFaceFeaturePreview(featureIndex, featureValue)
    isPreviewingFaceFeatures = true
    SetPedFaceFeature(currentShopPed, featureIndex, featureValue)
end

function ShopFaceFeatureIsPreviewing()
    return isPreviewingFaceFeatures
end

function ShopFaceFeatureReset()
    local shopPed = GetShopPed()
    UnshrinkHead(shopPed)
    
    isPreviewingFaceFeatures = false
    
    for featureIndex, featureValue in pairs(initialPedData.face) do
        SetPedFaceFeature(currentShopPed, featureIndex, featureValue)
    end
    
    EnsureHeadShrink()
end

function ShopEyeColorPreview(eyeColor)
    isPreviewingEyeColor = true
    SetPedEyeColor(currentShopPed, eyeColor)
end

function ShopEyeColorIsPreviewing()
    return isPreviewingEyeColor
end

function ShopEyeColorReset()
    isPreviewingEyeColor = false
    SetPedEyeColor(currentShopPed, initialPedData.eyeColor)
end

function ShopHairPreview(drawableId, color1, color2, textureId)
    isPreviewingHair = true
    RcoreSetPedComponentVariation(currentShopPed, 2, drawableId, textureId or 0, 0)
    SetPedHairColor(currentShopPed, color1, color2)
end

function ShopHairIsPreviewing()
    return isPreviewingHair
end

function ShopHairReset()
    isPreviewingHair = false
    local hairComponent = initialPedData.components[2]
    RcoreSetPedComponentVariation(currentShopPed, 2, hairComponent[1], hairComponent[2], hairComponent[3])
    SetPedHairColor(currentShopPed, initialPedData.hairColor[1], initialPedData.hairColor[2])
end

function ShopHeadOverlayPreview(overlayIndex, overlayId, opacity, color1, color2)
    currentOverlayIndex = overlayIndex
    
    if overlayId == -1 then
        overlayId = 255
    end
    
    SetPedHeadOverlay(currentShopPed, overlayIndex, overlayId, opacity or 1.0)
    
    -- Determine color type based on overlay
    local colorType = 0
    if overlayIndex == 2 or overlayIndex == 1 or overlayIndex == 10 then
        colorType = 1
    elseif overlayIndex == 5 or overlayIndex == 8 or overlayIndex == 4 then
        colorType = 2
    end
    
    if color1 then
        SetPedHeadOverlayColor(currentShopPed, overlayIndex, colorType, color1, color2 or 0)
    end
end

function ShopHeadOverlayIsPreviewing()
    return currentOverlayIndex ~= false
end

function ShopHeadOverlayReset()
    if currentOverlayIndex ~= false then
        local overlayData = initialPedData.headOverlay[currentOverlayIndex]
        if overlayData then
            SetPedHeadOverlay(currentShopPed, currentOverlayIndex, overlayData[1], overlayData[5])
            SetPedHeadOverlayColor(currentShopPed, currentOverlayIndex, overlayData[2], overlayData[3], overlayData[4])
        end
        currentOverlayIndex = false
    end
end

function ShopPreviewPedModel(pedModel)
    LoadAndSetModel(pedModel)
    currentShopPed = PlayerPedId()
    
    if IsModelFreemode(pedModel) then
        ApplyDefaultHeadblend(pedModel, currentShopPed)
    end
    
    SetPedDefaultComponentVariation(currentShopPed)
    
    if IsModelFreemode(pedModel) then
        RcoreSetPedComponentVariation(currentShopPed, 2, 2, 0, 0)
        CustomSetDefaultVariations(currentShopPed)
    end
    
    isPreviewingPedModel = pedModel
end

function ShopIsPrevieweingPedModel()
    return isPreviewingPedModel ~= false
end

function ShopConfirmPedModel()
    isPreviewingPedModel = false
    initialPedData.pedModel = GetEntityModel(currentShopPed)
    ShopInit(PlayerPedId())
end

function ShopResetPedModel()
    if ShopIsPrevieweingPedModel() then
        LoadAndSetModel(initialPedData.pedModel)
        currentShopPed = PlayerPedId()
        isPreviewingPedModel = false
        ResetEverything()
    end
end

-- Component and prop management
function ShopSetComponentPurchasedByHash(items)
    local shopPed = currentShopPed
    
    for _, item in pairs(items) do
        ApplyPedClothingItem(shopPed, item)
        
        -- Handle decal tracking
        if item.component_id == 8 then
            if item.decal_collection_hash ~= nil then
                initialPedData.decal8 = {item.decal_collection_hash, item.decal_name_hash}
            else
                initialPedData.decal8 = nil
            end
        elseif item.component_id == 11 then
            if item.decal_collection_hash ~= nil then
                initialPedData.decal11 = {item.decal_collection_hash, item.decal_name_hash}
            else
                initialPedData.decal11 = nil
            end
        end
        
        -- Update initial data
        if item.component_id >= PROP_COMPONENT_OFFSET then
            local propId = item.component_id - PROP_COMPONENT_OFFSET
            initialPedData.props[propId] = GetPedSinglePropData(shopPed, propId)
        else
            initialPedData.components[item.component_id] = GetPedSingleComponentData(shopPed, item.component_id)
        end
    end
end

function ShopSetComponentByHash(componentId, nameHash, decalCollection, decalName, skipArms)
    local shopPed = GetShopPed()
    
    ApplyPedClothingItem(shopPed, {
        name_hash = nameHash,
        decal_collection_hash = decalCollection,
        decal_name_hash = decalName
    }, skipArms)
    
    initialPedData.components[componentId] = GetPedSingleComponentData(shopPed, componentId)
    
    -- Handle decal tracking
    if componentId == 8 then
        if decalCollection == nil or decalCollection == 0 then
            initialPedData.decal8 = nil
        else
            initialPedData.decal8 = {decalCollection, decalName}
        end
    elseif componentId == 11 then
        if decalCollection == nil or decalCollection == 0 then
            initialPedData.decal11 = nil
        else
            initialPedData.decal11 = {decalCollection, decalName}
        end
    end
end

function ShopSetPropByHash(propId, propHash)
    local shopPed = GetShopPed()
    local propData = UsablePropHashToData(shopPed, propHash)
    
    if propData.drawableId < 0 then
        ClearPedProp(shopPed, propId)
    else
        SetPedPropIndex(shopPed, propId, propData.drawableId, propData.textureId, true)
    end
    
    initialPedData.props[propId] = GetPedSinglePropData(shopPed, propId)
end

-- Confirmation functions
function ShopConfirmHead()
    initialPedData.components[0] = GetPedSingleComponentData(currentShopPed, 0)
end

function ShopConfirmHeadblend()
    isPreviewingHeadblend = false
    initialPedData.headblend = GetFormattedPedHeadblendData(currentShopPed)
end

function ShopConfirmHair()
    isPreviewingHair = false
    initialPedData.components[2] = GetPedSingleComponentData(currentShopPed, 2)
    initialPedData.hairColor = GetHairColorData(currentShopPed)
end

function ShopConfirmFaceFeatures()
    isPreviewingFaceFeatures = false
    initialPedData.face = GetPedFaceFeatures(currentShopPed)
end

function ShopConfirmEyeColor()
    isPreviewingEyeColor = false
    initialPedData.eyeColor = GetPedEyeColor(currentShopPed)
end

function ShopConfirmHeadOverlay()
    currentOverlayIndex = false
    initialPedData.headOverlay = GetPedHeadOverlays(currentShopPed)
end

-- Outfit preview and application
function ShopPreviewOutfit(outfitData, updateInitialData)
    local shopPed = GetShopPed()
    
    if shopPed then
        if IsPedFreemode(shopPed) then
            ClearAllPedProps(shopPed)
            
            if Config.ResetAllOnOutfitChange then
                CustomSetDefaultVariations(shopPed)
            else
                RcoreSetPedComponentVariation(shopPed, 1, 0, 0, 2)
            end
        end
    end
    
    if outfitData.headblend then
        -- Complete outfit with head data
        ApplyPedClothingOutfit(shopPed, outfitData)
        
        if updateInitialData then
            initialPedData = GetCurrentPedData(shopPed)
        end
    else
        -- Clothing-only outfit
        for componentIdStr, componentHash in pairs(outfitData.components) do
            local componentId = tonumber(componentIdStr)
            local decalCollection = nil
            local decalName = nil
            
            if outfitData.decals then
                local decalData = outfitData.decals[tostring(componentId)]
                if decalData then
                    decalCollection = decalData.collection
                    decalName = decalData.name
                end
            end
            
            if updateInitialData then
                ShopSetComponentByHash(componentId, componentHash, decalCollection, decalName, true)
            else
                ApplyPedClothingItem(shopPed, {
                    name_hash = componentHash,
                    decal_collection_hash = decalCollection,
                    decal_name_hash = decalName
                }, true)
            end
        end
        
        for propIdStr, propHash in pairs(outfitData.props) do
            local propId = tonumber(propIdStr)
            local propData = UsablePropHashToData(shopPed, propHash)
            
            if propData.drawableId < 0 then
                ClearPedProp(GetShopPed(), propId)
            else
                SetPedPropIndex(GetShopPed(), propId, propData.drawableId, propData.textureId, true)
            end
            
            if updateInitialData then
                ShopSetPropByHash(propId, propHash)
            end
        end
    end
    
    if updateInitialData then
        initialPedData = GetCurrentPedData(shopPed)
    end
end

-- Reset functions
function ResetComponent(componentList)
    for _, componentId in pairs(componentList) do
        if componentId >= PROP_COMPONENT_OFFSET then
            -- Handle props
            local propId = componentId - PROP_COMPONENT_OFFSET
            local propData = initialPedData.props[propId]
            if propData then
                if propData[1] < 0 then
                    ClearPedProp(currentShopPed, propId)
                else
                    SetPedPropIndex(currentShopPed, propId, propData[1], propData[2], true)
                end
            end
        else
            -- Handle components
            local decalCollection = nil
            local decalName = nil
            
            if componentId == 8 and initialPedData.decal8 then
                decalCollection = initialPedData.decal8[1]
                decalName = initialPedData.decal8[2]
            elseif componentId == 11 and initialPedData.decal11 then
                decalCollection = initialPedData.decal11[1]
                decalName = initialPedData.decal11[2]
            end
            
            local componentData = initialPedData.components[componentId]
            ApplyPedClothingItem(currentShopPed, {
                name_hash = componentId .. "_" .. componentData[1] .. "_" .. componentData[2],
                decal_collection_hash = decalCollection,
                decal_name_hash = decalName
            }, true)
        end
    end
end

function ResetEverything()
    if IsDebuggingImages() then
        InvisibilityMakeInvisible(GetEntityModel(PlayerPedId()))
        return
    end
    
    local shopPed = GetShopPed()
    UnshrinkHead(shopPed)
    
    -- Reset all props (0-7)
    for propId = 0, 7 do
        ResetComponent({propId + PROP_COMPONENT_OFFSET})
    end
    
    -- Reset all components (0-11)
    for componentId = 0, 11 do
        ResetComponent({componentId})
    end
    
    -- Reset all preview states
    ShopHeadblendReset()
    ShopFaceFeatureReset()
    ShopEyeColorReset()
    ShopHairReset()
    ShopHeadOverlayReset()
    ShopResetPedModel()
    
    EnsureHeadShrink()
end