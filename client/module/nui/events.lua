-- Global state variables (preserved for cross-file compatibility)
local requestIdCounter = 0
local asyncResponseStorage = {}
local defaultPlayerRotation = nil
local requestRateLimitCounter = 0

-- Server response handlers for async operations
RegisterNetEvent("rcore_clothing:queryShopResponse", function(requestId, responseData)
    asyncResponseStorage[requestId] = responseData
end)

RegisterNetEvent("rcore_clothing:checkoutResult", function(requestId, success, purchasedItems, moneyMissing)
    asyncResponseStorage[requestId] = {
        result = success,
        moneyMissing = moneyMissing,
        purchased = purchasedItems
    }
end)

RegisterNetEvent("rcore_clothing:headModResult", function(requestId, success)
    asyncResponseStorage[requestId] = {
        result = success
    }
end)

RegisterNetEvent("rcore_clothing:setPedModelResult", function(requestId, success)
    asyncResponseStorage[requestId] = {
        result = success
    }
end)

RegisterNetEvent("rcore_clothing:setPersonalOutfits", function(requestId, outfits)
    asyncResponseStorage[requestId] = {
        result = outfits
    }
end)

RegisterNetEvent("rcore_clothing:setShopOutfits", function(requestId, outfits)
    asyncResponseStorage[requestId] = {
        result = outfits
    }
end)

-- NUI Callback handlers

-- Get current player character data
RegisterNUICallback("getCurrentPedData", function(data, callback)
    local shopPed = GetShopPed()
    local pedData = GetCurrentPedData(shopPed)
    callback(pedData)
end)

-- Close UI handler
RegisterNUICallback("close", function(data, callback)
    local shopConfig = GetCurrentShopConfig()
    local isForceClose = data and data.forceClose or false
    
    StopImageDebug()
    
    -- Check if shop can be closed
    if not isForceClose and shopConfig and shopConfig.modifiers then
        if shopConfig.modifiers[SHOP_MODIFIERS.CAN_NOT_BE_CLOSED] then
            callback("ok")
            return
        end
    end
    
    -- Play closing sound and close UI
    local quitSound = SOUNDS_BY_TYPE.QUIT_UI
    PlaySoundFrontend(-1, quitSound.name, quitSound.soundset, false)
    CloseNUI()
    StartRenderingMarkers()
    
    callback("ok")
end)

-- Info dialog confirmation handler
RegisterNUICallback("onInfoDialogConfirm", function(data, callback)
    if not GetIsNuiOpen() then
        SetNUIFocus(false)
    end
    callback("ok")
end)

-- Set shop base structure (categories and menu data)
RegisterNetEvent("rcore_clothing:setShopBaseStructure", function(menuData, clothingCategories)
    SendReactMessage("setMenuData", menuData)
    SendReactMessage("setClothingCategories", clothingCategories)
end)

-- Process fetched items to add drawable/texture IDs
function ProcessFetchedItems(items)
    local processedItems = {}
    local processingBatch = 10
    
    for index, item in pairs(items) do
        local itemData = ResolveItemToClothingOrPropItem(GetShopPed(), item)
        
        processedItems[index] = item
        processedItems[index].drawable_id = itemData.drawableId
        processedItems[index].texture_id = itemData.textureId
        
        processingBatch = processingBatch - 1
        if processingBatch <= 0 then
            Wait(0)
            processingBatch = 10
        end
    end
    
    return processedItems
end

-- Fetch clothing items from backend
RegisterNUICallback("fetchItems", function(data, callback)
    local shopType = data.shopType
    local componentId = data.componentId
    local lastId = data.lastId
    local category = data.category
    local colors = data.colors
    local searchQuery = data.searchQuery
    local fetchAllItems = data.fetchAllItems
    local groupByDrawable = data.groupByDrawable
    local onlyAddons = data.onlyAddons
    local notInAnyShop = data.notInAnyShop
    local isFirstFetch = data.isFirstFetch
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    -- Rate limiting
    requestRateLimitCounter = requestRateLimitCounter + 1
    Citizen.SetTimeout(3000, function()
        requestRateLimitCounter = requestRateLimitCounter - 1
    end)
    
    if requestRateLimitCounter > 10 then
        callback({rateLimit = true})
        return
    end
    
    -- Query backend for items
    QueryBackend(shopType, currentRequestId, componentId, category, colors, searchQuery, 
                lastId, fetchAllItems, groupByDrawable, onlyAddons, notInAnyShop, isFirstFetch)
    
    local response = AwaitAsyncResponse(currentRequestId)
    
    if response.timeout then
        callback({timeout = true})
        return
    end
    
    if response == "ratelimited" then
        callback({rateLimit = true})
        return
    end
    
    local processedItems = ProcessFetchedItems(response)
    callback({items = processedItems})
end)

-- Resolve external items (process already fetched items)
RegisterNUICallback("resolveExternalItems", function(items, callback)
    local processedItems = ProcessFetchedItems(items)
    callback({items = processedItems})
end)

-- Wait for async server response
function AwaitAsyncResponse(requestId)
    local timeoutTime = GetGameTimer() + 3000
    
    while true do
        local response = asyncResponseStorage[requestId]
        if response then
            break
        end
        
        if timeoutTime < GetGameTimer() then
            print("Request timed out")
            return {timeout = true}
        end
        
        Wait(0)
    end
    
    local response = asyncResponseStorage[requestId]
    asyncResponseStorage[requestId] = nil
    return response
end

-- Preview single clothing item
RegisterNUICallback("previewItem", function(data, callback)
    local item = data.item
    
    if IsDebuggingImages() then
        InvisibilityMakeInvisible(GetEntityModel(PlayerPedId()))
    end
    
    AnimResolveAndPlayPurchaseAnim(PlayerPedId(), item.component_id)
    ApplyPedClothingItem(PlayerPedId(), item)
    
    callback("ok")
end)

-- Preview non-freemode head variations
RegisterNUICallback("previewNonFreemodeHead", function(data, callback)
    local drawable = data.values.number
    local texture = data.values.number_2
    
    SetPedComponentVariation(PlayerPedId(), 0, drawable, texture, 2)
    callback("ok")
end)

-- Preview head blend (skin mixing)
RegisterNUICallback("previewHeadBlend", function(data, callback)
    local maleModel = data.maleModel
    local femaleModel = data.femaleModel
    local modelBlend = (data.modelBlend or 0) + 0.0
    local maleTone = data.maleTone
    local femaleTone = data.femaleTone
    local toneBlend = (data.toneBlend or 0) + 0.0
    
    ShopHeadblendPreview(maleModel, femaleModel, modelBlend, maleTone, femaleTone, toneBlend)
    callback("ok")
end)

-- Preview head overlay (makeup, facial hair, etc.)
RegisterNUICallback("previewHeadOverlay", function(data, callback)
    local overlayId = data.headOverlayId
    local values = data.values
    local overlayIndex = values.number
    local opacity = values.size / 10.0
    local color1 = tonumber(values.color or 0)
    local color2 = tonumber(values.color_2 or 0)
    
    ShopHeadOverlayPreview(overlayId, overlayIndex, opacity, color1, color2)
    callback("ok")
end)

-- Preview hair style and color
RegisterNUICallback("previewHair", function(data, callback)
    local values = data.values
    local hairId = values.number
    local color1 = tonumber(values.color or 0)
    local color2 = tonumber(values.color_2 or 0)
    
    local hairData = UsableHashToData(GetShopPed(), hairId)
    ShopHairPreview(hairData.drawableId, color1, color2, hairData.textureId)
    
    callback("ok")
end)

-- Preview eye color
RegisterNUICallback("previewEyeColor", function(data, callback)
    local values = data.values
    local eyeColor = tonumber(values.type_eye_color or 0)
    
    ShopEyeColorPreview(eyeColor)
    callback("ok")
end)

-- Confirm and purchase head blend changes
RegisterNUICallback("confirmHeadBlend", function(data, callback)
    local maleModel = data.maleModel
    local femaleModel = data.femaleModel
    local modelBlend = (data.modelBlend or 0) + 0.0
    local maleTone = data.maleTone
    local femaleTone = data.femaleTone
    local toneBlend = (data.toneBlend or 0) + 0.0
    local paymentType = data.paymentType
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    TriggerServerEvent("rcore_clothing:attemptHeadMod", currentRequestId, SHOP_STRUCTURE.CHAR_HEADBLEND, {
        maleModel = maleModel,
        femaleModel = femaleModel,
        modelBlend = modelBlend,
        maleTone = maleTone,
        femaleTone = femaleTone,
        toneBlend = toneBlend
    }, paymentType)
    
    local response = AwaitAsyncResponse(currentRequestId)
    
    if response.result then
        ShopConfirmHeadblend()
        SendCurrentPedDataNUI()
        callback("ok")
    else
        callback(false)
    end
end)

-- Confirm and purchase head overlay changes
RegisterNUICallback("confirmHeadOverlay", function(data, callback)
    local overlayId = data.headOverlayId
    local values = data.values
    local paymentType = data.paymentType
    local overlayIndex = values.number
    local opacity = values.size / 10.0
    local color1 = tonumber(values.color or 0)
    local color2 = tonumber(values.color_2 or 0)
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    TriggerServerEvent("rcore_clothing:attemptHeadMod", currentRequestId, "headOverlay", {
        overlayId = overlayId,
        id = overlayIndex,
        opacity = opacity,
        color1 = color1,
        color2 = color2
    }, paymentType)
    
    local response = AwaitAsyncResponse(currentRequestId)
    
    if response.result then
        ShopConfirmHeadOverlay()
        SendCurrentPedDataNUI()
        callback("ok")
    else
        callback(false)
    end
end)

-- Confirm and purchase hair changes
RegisterNUICallback("confirmHair", function(data, callback)
    local values = data.values
    local hairId = values.number
    local color1 = tonumber(values.color or 0)
    local color2 = tonumber(values.color_2 or 0)
    local paymentType = data.paymentType
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    TriggerServerEvent("rcore_clothing:attemptHeadMod", currentRequestId, SHOP_STRUCTURE.HAIR_HAIR, {
        id = hairId,
        color1 = color1,
        color2 = color2
    }, paymentType)
    
    local response = AwaitAsyncResponse(currentRequestId)
    
    if response.result then
        ShopConfirmHair()
        SendCurrentPedDataNUI()
        callback("ok")
    else
        callback(false)
    end
end)

-- Confirm and purchase eye color changes
RegisterNUICallback("confirmEyeColor", function(data, callback)
    local values = data.values
    local eyeColor = tonumber(values.type_eye_color or 0)
    local paymentType = data.paymentType
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    TriggerServerEvent("rcore_clothing:attemptHeadMod", currentRequestId, SHOP_STRUCTURE.CHAR_EYE_COLOR, {
        id = eyeColor
    }, paymentType)
    
    local response = AwaitAsyncResponse(currentRequestId)
    
    if response.result then
        ShopConfirmEyeColor()
        SendCurrentPedDataNUI()
        callback("ok")
    else
        callback(false)
    end
end)

-- Confirm and purchase face features changes
RegisterNUICallback("confirmFaceFeaturse", function(data, callback)
    local faceValues = data.values
    local paymentType = data.paymentType
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    TriggerServerEvent("rcore_clothing:attemptHeadMod", currentRequestId, SHOP_STRUCTURE.CHAR_FACE_FEATURES, {
        values = faceValues
    }, paymentType)
    
    local response = AwaitAsyncResponse(currentRequestId)
    
    if response.result then
        ShopConfirmFaceFeatures()
        SendCurrentPedDataNUI()
        callback("ok")
    else
        callback(false)
    end
end)

-- Confirm and purchase ped model change
RegisterNUICallback("confirmPed", function(data, callback)
    local pedModel = data.ped
    local paymentType = data.paymentType
    local currentComponents = {}
    
    -- Store current component configuration
    for componentSlot = 0, 11 do
        local drawableId = GetPedDrawableVariation(PlayerPedId(), componentSlot)
        local textureId = GetPedTextureVariation(PlayerPedId(), componentSlot)
        local componentHash = GetUsableHash(componentSlot, drawableId, textureId)
        currentComponents[componentSlot] = componentHash
    end
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    local defaultHeadblend = GetDefaultHeadblend(pedModel)
    
    TriggerServerEvent("rcore_clothing:setPedModel", currentRequestId, pedModel, currentComponents, defaultHeadblend, paymentType)
    
    local response = AwaitAsyncResponse(currentRequestId)
    
    if response.result then
        ShopConfirmPedModel()
        SendCurrentPedDataNUI()
        AnimSetPedStill(PlayerPedId(), true)
        callback("ok")
    else
        callback(false)
    end
end)

-- Confirm non-freemode head change
RegisterNUICallback("confirmHead", function(data, callback)
    local drawable = data.values.number
    local texture = data.values.number_2
    local componentHash = GetUsableHash(0, drawable, texture)
    local paymentType = data.paymentType
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    TriggerServerEvent("rcore_clothing:attemptHeadMod", currentRequestId, SHOP_STRUCTURE.CHAR_NONFREEMODE_HEAD, {
        values = componentHash
    }, paymentType)
    
    local response = AwaitAsyncResponse(currentRequestId)
    
    if response.result then
        ShopConfirmHead()
        SendCurrentPedDataNUI()
        callback("ok")
    else
        callback(false)
    end
end)

-- Reset character but keep cart items
RegisterNUICallback("resetKeepCart", function(data, callback)
    ResetEverything()
    
    for _, item in pairs(data.items) do
        ApplyPedClothingItem(PlayerPedId(), item)
    end
    
    callback("ok")
end)

-- Reset specific components
RegisterNUICallback("resetComponents", function(data, callback)
    local componentIds = data.componentIds
    if #componentIds then
        ResetComponent(componentIds)
    end
    callback("ok")
end)

-- Reset all components
RegisterNUICallback("resetAllComponents", function(data, callback)
    ResetEverything()
    callback("ok")
end)

-- Request complete menu data
RegisterNUICallback("requestCompleteMenuData", function(data, callback)
    RequestFullShopStructureExceptHead()
    callback("ok")
end)

-- Refresh menu data for specific shop type
RegisterNUICallback("refreshMenuData", function(data, callback)
    local shopType = data.shopType
    if not shopType then
        return
    end
    
    RefreshClothingShop(shopType)
    callback("ok")
end)

-- Toggle item stock in shop
RegisterNUICallback("toggleItemStock", function(data, callback)
    local itemId = data.id
    local addToStock = data.addToStock
    local shopType = data.shopType
    local isGroupByDrawable = data.groupByDrawable
    
    if isGroupByDrawable then
        if addToStock then
            TriggerServerEvent("rcore_clothing:addGroupToShop", itemId, shopType)
        else
            TriggerServerEvent("rcore_clothing:removeGroupFromShop", itemId, shopType)
        end
    else
        if addToStock then
            TriggerServerEvent("rcore_clothing:addItemToShop", itemId, shopType)
        else
            TriggerServerEvent("rcore_clothing:removeItemFromShop", itemId, shopType)
        end
    end
    
    callback("ok")
end)

-- Edit item metadata
RegisterNUICallback("editItemMetadata", function(data, callback)
    local itemId = data.id
    local label = data.label
    local price = data.price
    local category = data.category
    local colors = data.colors
    local isBlacklisted = data.isBlacklisted
    local jobs = data.jobs
    local identifiers = data.identifiers
    local isGroupByDrawable = data.groupByDrawable
    local resetImg = data.resetImg
    
    if isGroupByDrawable then
        TriggerServerEvent("rcore_clothing:editGroupMetadata", itemId, price, category, isBlacklisted)
    else
        TriggerServerEvent("rcore_clothing:editItemMetadata", itemId, label, price, category, colors, isBlacklisted, jobs, identifiers, resetImg)
    end
    
    callback("ok")
end)

-- Preview face feature adjustment
RegisterNUICallback("previewFaceFeature", function(data, callback)
    ShopFaceFeaturePreview(data.faceFeatureId, data.value + 0.0)
    callback("ok")
end)

-- Preview ped model change
RegisterNUICallback("previewPed", function(data, callback)
    local pedModel = data.ped
    ShopPreviewPedModel(pedModel)
    callback("ok")
end)

-- Handle component/category change
RegisterNUICallback("onComponentChange", function(data, callback)
    local playerPed = PlayerPedId()
    local componentId = data.componentId
    local characterSettingsId = data.characterSettingsId
    local pedModel = data.pedModel or GetEntityModel(playerPed)
    
    -- Determine camera position based on component
    if componentId == -1 then
        ClothingCamTransitionToComponent(playerPed, CAM_OFFSETS_CLOTHING_SHOP, 11)
    elseif characterSettingsId == "headOverlay_10" or characterSettingsId == "headOverlay_11" then
        ClothingCamTransitionToComponent(playerPed, CAM_OFFSETS_CLOTHING_SHOP, 7)
    elseif characterSettingsId == "eye_color" then
        ClothingCamTransitionToComponent(playerPed, CAM_OFFSETS_CLOTHING_SHOP, 518)
    else
        ClothingCamTransitionToComponent(playerPed, CAM_OFFSETS_CLOTHING_SHOP, componentId)
    end
    
    -- Apply empty items for category if available
    local emptyItems = GetEmptyItemsForCategoryId(characterSettingsId, pedModel)
    if emptyItems then
        Wait(0)
        for _, item in pairs(emptyItems) do
            ApplyPedClothingItem(playerPed, item)
        end
        Wait(0)
        for _, item in pairs(emptyItems) do
            ApplyPedClothingItem(playerPed, item)
        end
    end
    
    AnimateEntityRotation(defaultPlayerRotation)
    callback("ok")
end)

-- Attempt checkout/purchase
RegisterNUICallback("attemptCheckout", function(data, callback)
    local purchaseType = data.type
    local items = data.items
    local outfitName = data.outfitName
    local shopName = data.shopName
    local shoplessData = {}
    local itemIds = {}
    
    -- Process items for checkout
    for _, item in pairs(items) do
        if item.component_id == 3 then
            -- Skip arms component (handled separately)
        elseif item.isUnset then
            -- Handle unset/removed items
            if item.component_id >= 100 then
                if not shoplessData.shoplessProp then
                    shoplessData.shoplessProp = {}
                end
                shoplessData.shoplessProp[item.component_id - 100] = item.name_hash
            else
                if not shoplessData.shoplessComponent then
                    shoplessData.shoplessComponent = {}
                end
                shoplessData.shoplessComponent[item.component_id] = item.name_hash
            end
        else
            table.insert(itemIds, item.id)
        end
    end
    
    -- Get current arms component
    shoplessData.arms = GetComponentUsableHash(GetShopPed(), 3)
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    TriggerServerEvent("rcore_clothing:attemptCheckout", currentRequestId, shopName, purchaseType, itemIds, shoplessData, GetCurrentShopConfig())
    
    local response = AwaitAsyncResponse(currentRequestId)
    
    if response.result then
        -- Apply purchased items
        ShopSetComponentPurchasedByHash(response.purchased)
        
        if shoplessData.arms then
            ShopSetComponentByHash(3, shoplessData.arms)
        end
        
        if shoplessData.shoplessComponent then
            for componentId, componentHash in pairs(shoplessData.shoplessComponent) do
                ShopSetComponentByHash(componentId, componentHash)
            end
        end
        
        if shoplessData.shoplessProp then
            for propId, propHash in pairs(shoplessData.shoplessProp) do
                ShopSetPropByHash(propId, propHash)
            end
        end
        
        -- Save outfit if name provided
        if outfitName and string.len(outfitName) > 0 then
            SaveCurrentAsOutfit(outfitName)
        end
    end
    
    callback("ok")
    SendReactMessage("checkoutResult", response.result)
    
    if response.result then
        SendCurrentPedDataNUI()
        
        -- Handle character creation completion
        if shopName == "CHARCREATOR" then
            TriggerEvent("rcore_clothing:charcreator:done")
            TriggerServerEvent("rcore_clothing:charcreator:done")
            SaveCurrentAsOutfit(_U("outfits.default_outfit"))
            ESXSetIsCreatingChar(false)
        end
    end
end)

-- Save personal outfit
RegisterNUICallback("saveOutfit", function(data, callback)
    local outfitName = data.outfitName
    SaveCurrentAsOutfit(outfitName)
    callback("ok")
end)

-- Save shop outfit
RegisterNUICallback("saveShopOutfit", function(data, callback)
    local outfitId = data.id
    local outfitName = data.name
    local price = data.price
    local jobs = data.jobs
    local identifiers = data.identifiers
    local shopName = data.shopName
    
    if not outfitId or string.len(outfitId) == 0 then
        SaveCurrentAsShopOutfit(outfitName, shopName, price, jobs, identifiers)
    else
        TriggerServerEvent("rcore_clothing:editShopOutfit", outfitId, outfitName, price, jobs, identifiers)
    end
    
    callback("ok")
end)

-- Preview outfit
RegisterNUICallback("previewOutfit", function(data, callback)
    local outfit = json.decode(data.outfit)
    ShopPreviewOutfit(outfit)
    callback("ok")
end)

-- Select and apply outfit
RegisterNUICallback("selectOutfit", function(data, callback)
    local outfit = json.decode(data.outfit)
    ShopPreviewOutfit(outfit, true)
    TriggerEvent("rcore_clothing:saveCurrentSkin")
    TriggerEvent("rcore_clothing:outfitChanged")
    callback("ok")
end)

-- Remove outfit
RegisterNUICallback("removeOutfit", function(data, callback)
    local outfitId = data.id
    local outfitType = data.type
    
    if outfitType == "my_outfits" then
        TriggerServerEvent("rcore_clothing:removePersonalOutfit", outfitId)
    else
        TriggerServerEvent("rcore_clothing:removeShopOutfit", outfitId)
    end
    
    callback("ok")
end)

-- Buy outfit
RegisterNUICallback("buyOutfit", function(data, callback)
    local outfitId = data.id
    local outfit = json.decode(data.outfit)
    
    TriggerServerEvent("rcore_clothing:buyOutfit", outfitId, outfit)
    SendCurrentPedDataNUI()
    callback("ok")
end)

-- Handle outfit purchase completion
RegisterNetEvent("rcore_clothing:outfitBought", function(outfit)
    ShopPreviewOutfit(outfit, true)
end)

-- Get outfits (personal or shop)
RegisterNUICallback("getOutfits", function(data, callback)
    local outfitType = data.type
    local shopName = data.shopName
    
    if outfitType == "my_outfits" then
        local personalOutfits = GetPersonalOutfits()
        callback(personalOutfits)
        return
    elseif outfitType == "global_outfits" and shopName and string.len(shopName) > 0 then
        local shopOutfits = GetShopOutfits(shopName)
        callback(shopOutfits)
        return
    end
    
    callback("ok")
end)

-- Play UI sound
RegisterNUICallback("playSound", function(soundType, callback)
    local soundData = SOUNDS_BY_TYPE[soundType]
    if soundData then
        PlaySoundFrontend(-1, soundData.name, soundData.soundset, false)
    end
    callback("ok")
end)

-- Get numbers-only data for direct component editing
RegisterNUICallback("getNumbersOnlyData", function(data, callback)
    local componentId = data.componentId
    local shopName = data.shopName
    local playerPed = PlayerPedId()
    
    local componentData = {
        minDrawable = 0,
        maxDrawable = nil,
        minTexture = 0,
        maxTexture = nil,
        currentDrawable = nil,
        currentTexture = nil
    }
    
    if componentId < 100 then
        -- Handle clothing components
        componentData.maxDrawable = GetNumberOfPedDrawableVariations(playerPed, componentId) - 1
        componentData.currentDrawable = GetPedDrawableVariation(playerPed, componentId)
        componentData.currentTexture = GetPedTextureVariation(playerPed, componentId)
        componentData.maxTexture = GetNumberOfPedTextureVariations(playerPed, componentId, componentData.currentDrawable) - 1
    else
        -- Handle prop components
        local propSlot = componentId - 100
        componentData.minDrawable = -1
        componentData.maxDrawable = GetNumberOfPedPropDrawableVariations(playerPed, propSlot) - 1
        componentData.currentDrawable = GetPedPropIndex(playerPed, propSlot)
        componentData.currentTexture = GetPedPropTextureIndex(playerPed, propSlot)
        componentData.maxTexture = GetNumberOfPedPropTextureVariations(playerPed, propSlot, componentData.currentDrawable) - 1
    end
    
    -- Ensure valid values
    componentData.maxTexture = math.max(componentData.maxTexture, 0)
    componentData.currentTexture = math.max(componentData.currentTexture, 0)
    
    local isPropComponent = componentId >= 100
    callback(componentData)
    
    -- Request metadata for current item
    if IsModelFreemode(GetEntityModel(playerPed)) and not isPropComponent then
        local clothingHash = GetUsableClothingHash(componentId, componentData.currentDrawable, componentData.currentTexture)
        TriggerServerEvent("rcore_clothing:getSingleItemMetadata", shopName, clothingHash, HasCurrentShopGotEverythingIdMode(), HasCurrentShopEverythingFree())
    else
        Wait(100)
        
        if isPropComponent then
            local propHash = "nondlcgta5--" .. componentId .. "--m1--0"
            TriggerEvent("rcore_clothing:receiveSingleItemMetadata", {
                name_hash = propHash,
                component_id = componentId,
                drawable_id = -1,
                texture_id = 0,
                price = 0,
                id = "~" .. propHash,
                in_shop = true,
                isUnset = isPropComponent
            })
        else
            local componentHash = GetUsableHash(componentId, componentData.currentDrawable, componentData.currentTexture)
            
            if componentHash == nil then
                TriggerEvent("rcore_clothing:receiveSingleItemMetadata", {
                    name_hash = componentId .. "_" .. componentData.currentDrawable .. "_" .. componentData.currentTexture,
                    component_id = componentId,
                    drawable_id = componentData.currentDrawable,
                    texture_id = componentData.currentTexture,
                    price = 0,
                    id = "~" .. componentId .. "_" .. componentData.currentDrawable .. "_" .. componentData.currentTexture,
                    is_blacklisted = 1,
                    in_shop = Config.EveryShopHasEverything or Config.IdModeHasEverything
                })
            else
                TriggerEvent("rcore_clothing:receiveSingleItemMetadata", {
                    name_hash = componentHash,
                    component_id = componentId,
                    drawable_id = componentData.currentDrawable,
                    texture_id = componentData.currentTexture,
                    price = 0,
                    id = "~" .. componentHash,
                    in_shop = Config.EveryShopHasEverything or Config.IdModeHasEverything
                })
            end
        end
    end
end)

-- Handle numbers-only component changes
RegisterNUICallback("handleNumbersOnlyChange", function(data, callback)
    local componentId = data.componentId
    local drawableId = data.drawableId
    local textureId = data.textureId
    local shopName = data.shopName
    local playerPed = PlayerPedId()
    
    -- Get max texture variations for this drawable
    local maxTextures = 0
    if componentId < 100 then
        maxTextures = GetNumberOfPedTextureVariations(playerPed, componentId, drawableId) - 1
    else
        maxTextures = GetNumberOfPedPropTextureVariations(playerPed, componentId - 100, drawableId) - 1
    end
    
    -- Clamp texture ID to valid range
    if textureId > maxTextures then
        textureId = maxTextures
    end
    
    maxTextures = math.max(maxTextures, 0)
    textureId = math.max(textureId, 0)
    
    local isUnsetProp = componentId >= 100 and drawableId < 0
    local componentHash = nil
    
    if isUnsetProp then
        -- Clear prop
        ClearPedProp(playerPed, componentId - 100)
        componentHash = "nondlcgta5--" .. componentId .. "--m1--0"
        callback(0)
    else
        -- Apply clothing/prop
        componentHash = GetUsableHash(componentId, drawableId, textureId)
        ApplyPedClothingItem(playerPed, {name_hash = componentHash})
        callback(maxTextures)
    end
    
    -- Request metadata for new item
    if IsModelFreemode(GetEntityModel(playerPed)) and not isUnsetProp then
        local clothingHash = GetUsableClothingHash(componentId, drawableId, textureId)
        TriggerServerEvent("rcore_clothing:getSingleItemMetadata", shopName, clothingHash, HasCurrentShopGotEverythingIdMode(), HasCurrentShopEverythingFree())
    else
        TriggerEvent("rcore_clothing:receiveSingleItemMetadata", {
            name_hash = componentHash,
            component_id = componentId,
            drawable_id = drawableId,
            texture_id = textureId,
            price = 0,
            id = "~" .. componentHash,
            in_shop = Config.EveryShopHasEverything or Config.IdModeHasEverything or isUnsetProp,
            isUnset = isUnsetProp
        })
    end
end)

-- Set recommended arms for clothing item
RegisterNUICallback("setRecommendedArms", function(data, callback)
    local armsHash = data.armsHash
    local clothingId = data.clothingId
    local isGroupByDrawable = data.groupByDrawable
    
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    if isGroupByDrawable then
        TriggerServerEvent("rcore_clothing:setGroupRecommendedArms", currentRequestId, clothingId, armsHash)
    else
        TriggerServerEvent("rcore_clothing:setRecommendedArms", currentRequestId, clothingId, armsHash, isGroupByDrawable)
    end
    
    AwaitAsyncResponse(currentRequestId)
    callback("ok")
end)

-- Camera control functions

-- Set camera rotation
RegisterNUICallback("setCameraRotation", function(rotationDelta, callback)
    local playerPed = PlayerPedId()
    local currentHeading = GetEntityHeading(playerPed)
    local adjustedRotation = rotationDelta / 3
    local newHeading = currentHeading + adjustedRotation
    
    if newHeading > 360 then
        newHeading = newHeading - 360
    elseif newHeading < 0 then
        newHeading = newHeading + 360
    end
    
    SetEntityHeading(playerPed, newHeading)
    callback("ok")
end)

-- Set camera vertical position
RegisterNUICallback("setCameraVerticalPosition", function(data, callback)
    local changeBy = data.changeBy
    local componentId = data.componentId or 11
    
    if componentId == -1 or not componentId then
        componentId = 11
    end
    
    local verticalAdjustment = (changeBy / 300) * -1 * -1
    CamSetVerticalScroll(componentId, GetCamVerticalScroll() + verticalAdjustment)
    
    callback("ok")
end)

-- Set camera zoom
RegisterNUICallback("setCameraZoom", function(data, callback)
    local componentId = data.componentId or 11
    local changeBy = data.changeBy
    
    if componentId == -1 or not componentId then
        componentId = 11
    end
    
    if changeBy > 0 then
        CamSetZoom(componentId, CamGetZoom() - GetZoomStep(componentId))
    else
        CamSetZoom(componentId, CamGetZoom() + GetZoomStep(componentId))
    end
    
    callback("ok")
end)

-- Reset camera position
RegisterNUICallback("resetCamera", function(data, callback)
    local componentId = data.componentId
    
    AnimateEntityRotation(defaultPlayerRotation)
    
    if componentId then
        ClothingCamTransitionToComponent(PlayerPedId(), CAM_OFFSETS_CLOTHING_SHOP, componentId)
    end
    
    callback("ok")
end)

-- Zoom out camera to full body view
RegisterNUICallback("zoomOutCamera", function(data, callback)
    local playerPed = PlayerPedId()
    ClothingCamTransitionToComponent(playerPed, CAM_OFFSETS_CLOTHING_SHOP, 11)
    callback("ok")
end)

-- Show processing camera
RegisterNUICallback("showProcessingCamera", function(data, callback)
    local playerPed = PlayerPedId()
    local componentId = data.componentId or 11
    
    AnimateEntityRotation(defaultPlayerRotation)
    ClothingCamTransitionToComponent(playerPed, CAM_OFFSETS_PROCESSING_SHOP, componentId)
    
    callback("ok")
end)

-- Pipeline confirmation result
RegisterNUICallback("pipelineConfirmResult", function(confirmed, callback)
    SetNUIFocus(false)
    
    if confirmed then
        if IsStage4() then
            OnPipeline4DialogConfirm()
        else
            OnPipeline2DialogConfirm()
        end
    else
        OnPipeline2DialogCancel()
    end
    
    callback("ok")
end)

-- Set image debug mode
RegisterNUICallback("setImageDebugMode", function(enabled, callback)
    if enabled then
        StartImageDebug()
    else
        StopImageDebug()
    end
    callback("ok")
end)

-- Blacklist current item
RegisterNUICallback("blacklistCurrent", function(itemData, callback)
    TriggerServerEvent("rcore_clothing:blacklistItem", itemData)
    callback("ok")
end)

-- Reset current item
RegisterNUICallback("resetCurrent", function(itemData, callback)
    TriggerServerEvent("rcore_clothing:resetItem", itemData)
    SendReactMessage("resetClothingItemById", itemData)
    callback("ok")
end)

-- Reset character creator structure
RegisterNUICallback("resetCharCreatorStructure", function(data, callback)
    local playerPed = PlayerPedId()
    callback(GetHeadOptions(playerPed))
end)

-- Backend query function
function QueryBackend(shopType, requestId, componentId, category, colors, searchQuery, lastId, fetchAllItems, groupByDrawable, onlyAddons, notInAnyShop, isFirstFetch)
    -- Handle special cases
    if componentId == 3 then
        if isFirstFetch then
            asyncResponseStorage[requestId] = QueryAvailableArms(lastId)
            return
        else
            onlyAddons = true
            fetchAllItems = true
        end
    end
    
    if componentId == 33 then
        asyncResponseStorage[requestId] = QueryAvailableGloves(lastId)
    else
        local shopConfig = GetCurrentShopConfig()
        local eventName = fetchAllItems and "rcore_clothing:queryShopAll" or "rcore_clothing:queryShop"
        
        TriggerServerEvent(eventName, requestId, shopType, GetEntityModel(PlayerPedId()), {
            componentId = componentId,
            category = category,
            colors = colors,
            searchQuery = searchQuery,
            lastId = lastId,
            groupByDrawable = groupByDrawable,
            onlyAddons = onlyAddons,
            shopConfig = shopConfig,
            notInAnyShop = notInAnyShop
        })
    end
end

-- Open clothing shop event
RegisterNetEvent("rcore_clothing:openClothingShop", function(shopType, menuStructure, clothingCategories, permissions, serverData)
    local playerPed = PlayerPedId()
    
    -- Add head/character options to menu
    table.insert(menuStructure, 1, {
        id = "head",
        label = _U("shop_structure.first_level.character"),
        type = "category",
        subtype = "head",
        items = GetHeadOptions(playerPed),
        image = "*img/card_img/pedselect.webp"
    })
    
    -- Add outfits to menu
    table.insert(menuStructure, 1, {
        id = "outfits",
        label = _U("shop_structure.first_level.outfits"),
        type = "category",
        subtype = "outfits",
        items = GetOutfitOptions(),
        image = "*img/card_img/my_outfits.webp"
    })
    
    -- Filter shop structure based on configuration
    local shopConfig = GetCurrentShopConfig()
    if shopConfig and shopConfig.structure and next(shopConfig.structure) then
        menuStructure = FilterShopStructure(menuStructure, shopConfig.structure)
    end
    
    -- Send data to UI
    SendReactMessage("setMenuData", menuStructure)
    SendReactMessage("setShopData", {
        type = shopType,
        logo = Config.ClothingShopLogos[shopType] or Config.ClothingShopLogos.default,
        modifiers = shopConfig and shopConfig.modifiers or {},
        externalServerData = serverData
    })
    SendReactMessage("setPermissions", permissions)
    SendReactMessage("setClothingCategories", clothingCategories)
    
    -- Open UI if not already open
    if not GetIsNuiOpen() then
        ShopInit(playerPed)
        OpenNUI()
        StopRenderingMarkers()
        defaultPlayerRotation = GetEntityHeading(playerPed)
        Wait(1)
        currentZoom = 0
    end
end)

-- Set hair data
RegisterNetEvent("rcore_clothing:setHairData", function(hairData)
    SendReactMessage("setHairData", hairData)
end)

-- Set server jobs
RegisterNetEvent("rcore_clothing:setServerJobs", function(jobs)
    SendReactMessage("setServerJobs", jobs)
end)

-- Receive single item metadata
RegisterNetEvent("rcore_clothing:receiveSingleItemMetadata", function(itemData)
    -- Ensure arms and decals are always in shop
    if itemData and itemData.component_id and (itemData.component_id == 3 or itemData.component_id == 10) then
        itemData.in_shop = true
    end
    
    -- Handle not found items
    if itemData.not_found then
        local resolvedData = UsableHashOfComponentOrPropToData(GetShopPed(), itemData.not_found, true)
        local fallbackData = {
            name_hash = itemData.not_found,
            component_id = resolvedData.componentId,
            drawable_id = resolvedData.drawableId,
            texture_id = resolvedData.textureId,
            price = 0,
            id = "~" .. itemData.not_found,
            in_shop = Config.EveryShopHasEverything or Config.IdModeHasEverything or (resolvedData.componentId == 3)
        }
        
        SendReactMessage("setNumbersOnlyCurrentProduct", {
            item = fallbackData,
            componentId = resolvedData.componentId,
            drawableId = resolvedData.drawableId,
            textureId = resolvedData.textureId
        })
    else
        local resolvedData = UsableHashOfComponentOrPropToData(GetShopPed(), itemData.name_hash, true)
        
        SendReactMessage("setNumbersOnlyCurrentProduct", {
            item = itemData,
            componentId = resolvedData.componentId,
            drawableId = resolvedData.drawableId,
            textureId = resolvedData.textureId
        })
    end
end)

-- Set recommended arms result
RegisterNetEvent("rcore_clothing:setRecommendedArmsResult", function(requestId, success)
    asyncResponseStorage[requestId] = {
        result = success
    }
end)

-- UI notification function
function UINotify(title, isError)
    SendReactMessage("notify", {
        title = title,
        isError = isError
    })
end

-- Handle UI notifications
RegisterNUICallback("notify", function(data, callback)
    NotifyUser(data.title, data.isError)
    callback("ok")
end)

-- Get personal outfits
function GetPersonalOutfits()
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    TriggerServerEvent("rcore_clothing:getPersonalOutfits", currentRequestId)
    local response = AwaitAsyncResponse(currentRequestId)
    
    return response.result
end

-- Get shop outfits
function GetShopOutfits(shopName)
    requestIdCounter = requestIdCounter + 1
    local currentRequestId = requestIdCounter
    
    TriggerServerEvent("rcore_clothing:getShopOutfits", currentRequestId, shopName)
    local response = AwaitAsyncResponse(currentRequestId)
    
    return response.result
end