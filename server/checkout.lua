function IsNearPaidShop(playerPosition)
    for i = 1, #Config.ClothingShops do
        local shop = Config.ClothingShops[i]
        local shopPosition = shop.pos.xyz
        local distance = #(playerPosition - shopPosition)
        
        local isShopFree = false
        if shop.config and shop.config.modifiers and shop.config.modifiers.IS_EVERYTHING_FREE then
            isShopFree = true
        elseif Config.EverythingEverywhereIsFree then
            isShopFree = true
        end
        
        if distance < 10.0 then
            return not isShopFree
        end
    end
    
    return false
end

function ResolveFreemodeItems(itemsList, purchaseData)
    for _, item in pairs(purchaseData) do
        if type(item) == "string" then
            local firstChar = string.sub(item, 1, 1)
            if firstChar == "~" then
                local itemString = string.sub(item, 2)
                local itemData = CheckoutSimpleResolveClothingItemToData(itemString)
                itemData.price = 0
                itemData.label = "Clothing item"
                table.insert(itemsList, itemData)
            end
        end
    end
    
    return itemsList
end

function FilterFreemodeItems(purchaseData)
    local filteredItems = {}
    
    for _, item in pairs(purchaseData) do
        if type(item) == "number" then
            table.insert(filteredItems, item)
        else
            local firstChar = string.sub(item, 1, 1)
            if firstChar ~= "~" then
                table.insert(filteredItems, item)
            end
        end
    end
    
    return filteredItems
end

RegisterNetEvent("rcore_clothing:attemptCheckout", function(callbackId, gender, moneyType, purchaseData, additionalData, shopConfig)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerModel = GetEntityModel(playerPed)
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    
    local filteredItems = FilterFreemodeItems(purchaseData)
    local dbItems = DbGetItemsById(filteredItems)
    
    local hasChangingRoom = false
    local isEverythingFree = false
    
    if shopConfig then
        if shopConfig.modifiers then
            hasChangingRoom = shopConfig.modifiers[SHOP_MODIFIERS.CHANGING_ROOM]
            isEverythingFree = shopConfig.modifiers[SHOP_MODIFIERS.IS_EVERYTHING_FREE]
        end
    end
    
    local purchasedItems = {}
    local resolvedItems = ResolveFreemodeItems(dbItems, purchaseData)
    local totalCost = 0
    
    if isEverythingFree or hasChangingRoom then
        local playerPosition = GetEntityCoords(playerPed)
        if IsNearPaidShop(playerPosition) then
            print("ERROR: Unable to make changing room free as player is near paid shop")
        else
            for i = 1, #resolvedItems do
                resolvedItems[i].price = 0
            end
        end
    else
        for i = 1, #resolvedItems do
            local item = resolvedItems[i]
            if item.price then
                local finalPrice = item.price
                if not item.custom_price then
                    finalPrice = CalculateItemPrice(item.id, gender, item.component_id, item.drawable_id, item.type, item.price)
                end
                totalCost = totalCost + finalPrice
            end
        end
    end
    
    if totalCost > 0 then
        local playerMoney = FrameworkGetPlayerMoney(playerId, moneyType)
        if totalCost > playerMoney then
            TriggerClientEvent("rcore_clothing:checkoutResult", playerId, callbackId, false, {}, totalCost - playerMoney)
            return
        end
        
        local paymentSuccess = FrameworkTakePlayerMoney(playerId, moneyType, totalCost)
        if not paymentSuccess then
            TriggerClientEvent("rcore_clothing:checkoutResult", playerId, callbackId, false, {}, totalCost)
            return
        end
    end
    
    local currentOutfit = DbGetOrCreateCurrentOutfit(playerIdentifier, playerModel)
    
    if not currentOutfit.components then
        currentOutfit.components = {}
    end
    if not currentOutfit.props then
        currentOutfit.props = {}
    end
    if not currentOutfit.decals then
        currentOutfit.decals = {}
    end
    
    local purchasedHashes = {}
    
    for i = 1, #resolvedItems do
        local item = resolvedItems[i]
        local nameHash = item.name_hash
        local componentId = item.component_id
        
        if item.id and item.id > 0 then
            DbAddToPurchased(playerIdentifier, item.id)
        end
        
        if componentId < 100 then
            currentOutfit.components[tostring(componentId)] = nameHash
            
            if item.decal_name_hash then
                currentOutfit.decals[tostring(componentId)] = {
                    collection = item.decal_collection_hash,
                    name = item.decal_name_hash
                }
            else
                if currentOutfit.decals and currentOutfit.decals[tostring(componentId)] then
                    currentOutfit.decals[tostring(componentId)] = nil
                end
            end
        else
            local propId = componentId - 100
            if item.drawable_id < 0 then
                currentOutfit.props[tostring(propId)] = nil
            else
                currentOutfit.props[tostring(propId)] = nameHash
            end
        end
    end
    
    if additionalData.arms then
        currentOutfit.components[tostring(3)] = additionalData.arms
        table.insert(purchasedHashes, additionalData.arms)
    end
    
    if additionalData.shoplessComponent then
        for componentId, nameHash in pairs(additionalData.shoplessComponent) do
            currentOutfit.components[tostring(componentId)] = nameHash
            table.insert(purchasedHashes, nameHash)
            
            if componentId == 8 or componentId == 11 then
                if currentOutfit.decals and currentOutfit.decals[tostring(componentId)] then
                    currentOutfit.decals[tostring(componentId)] = nil
                end
            end
        end
    end
    
    if additionalData.shoplessProp then
        for propId, nameHash in pairs(additionalData.shoplessProp) do
            currentOutfit.props[tostring(propId)] = nameHash
            table.insert(purchasedHashes, nameHash)
        end
    end
    
    local purchaseResults = {}
    for i = 1, #resolvedItems do
        local item = resolvedItems[i]
        local armsData = nil
        
        if item.component_id == 11 then
            armsData = additionalData.arms
        end
        
        table.insert(purchaseResults, {
            component_id = item.component_id,
            name_hash = item.name_hash,
            decal_collection_hash = item.decal_collection_hash,
            decal_name_hash = item.decal_name_hash,
            drawable_id = item.drawable_id,
            texture_id = item.texture_id,
            label = item.label,
            arms = armsData
        })
    end
    
    DbSaveCurrentOutfit(playerIdentifier, playerModel, currentOutfit)
    
    TriggerClientEvent("rcore_clothing:checkoutResult", playerId, callbackId, true, purchaseResults, nil)
    TriggerClientEvent("rcore_clothing:internal:itemPurchased", playerId, purchaseResults, purchasedHashes)
end)

function HandleCharacterFeaturePurchase(playerId, moneyType, featureType)
    local playerMoney = FrameworkGetPlayerMoney(playerId, moneyType)
    local featurePrice = Config.CharFeaturesPrices[featureType]
    
    if not featurePrice then
        featurePrice = 0
    end
    
    if featurePrice == 0 then
        return true
    end
    
    if playerMoney < featurePrice then
        return false
    end
    
    local paymentSuccess = FrameworkTakePlayerMoney(playerId, moneyType, featurePrice)
    return paymentSuccess
end

RegisterNetEvent("rcore_clothing:attemptHeadMod", function(callbackId, modificationType, modificationData, moneyType)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerModel = GetEntityModel(playerPed)
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    local currentOutfit = DbGetOrCreateCurrentOutfit(playerIdentifier, playerModel)
    
    if moneyType then
        local featureName = modificationType
        if modificationType == "headOverlay" then
            featureName = "headOverlay_" .. modificationData.overlayId
        end
        
        local purchaseSuccess = HandleCharacterFeaturePurchase(playerId, moneyType, featureName)
        if not purchaseSuccess then
            TriggerClientEvent("rcore_clothing:headModResult", playerId, callbackId, false)
            return
        end
    end
    
    if modificationType == SHOP_STRUCTURE.CHAR_NONFREEMODE_HEAD then
        if not currentOutfit.components then
            currentOutfit.components = {}
        end
        currentOutfit.components["0"] = modificationData.values
    end
    
    if modificationType == SHOP_STRUCTURE.CHAR_HEADBLEND then
        currentOutfit.headblend = modificationData
    end
    
    if modificationType == "headOverlay" then
        if not currentOutfit.headOverlay then
            currentOutfit.headOverlay = {}
        end
        currentOutfit.headOverlay[tostring(modificationData.overlayId)] = {
            id = modificationData.id,
            opacity = modificationData.opacity,
            color1 = modificationData.color1,
            color2 = modificationData.color2
        }
    end
    
    if modificationType == SHOP_STRUCTURE.HAIR_HAIR then
        currentOutfit.hair = {
            id = modificationData.id,
            color1 = modificationData.color1,
            color2 = modificationData.color2
        }
    end
    
    if modificationType == SHOP_STRUCTURE.CHAR_EYE_COLOR then
        currentOutfit.eyeColor = modificationData.id
    end
    
    if modificationType == SHOP_STRUCTURE.CHAR_FACE_FEATURES then
        currentOutfit.faceFeatures = modificationData.values
    end
    
    DbSaveCurrentOutfit(playerIdentifier, playerModel, currentOutfit)
    TriggerClientEvent("rcore_clothing:headModResult", playerId, callbackId, true)
end)

RegisterNetEvent("rcore_clothing:setPedModel", function(callbackId, newModel, componentsData, headblendData, moneyType)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local currentModel = GetEntityModel(playerPed)
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    
    if moneyType then
        local purchaseSuccess = HandleCharacterFeaturePurchase(playerId, moneyType, SHOP_STRUCTURE.CHAR_PED_SELECT)
        if not purchaseSuccess then
            TriggerClientEvent("rcore_clothing:setPedModelResult", playerId, callbackId, false)
            return
        end
    end
    
    local newOutfitData = {
        components = componentsData,
        headblend = headblendData
    }
    
    DbChangePedModelOutfit(playerIdentifier, newModel, newOutfitData)
    TriggerClientEvent("rcore_clothing:setHairData", playerId, DbGetHair(currentModel))
    TriggerClientEvent("rcore_clothing:setPedModelResult", playerId, callbackId, true)
end)

RegisterNetEvent("rcore_clothing:selectOutfit", function(outfitId)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerModel = GetEntityModel(playerPed)
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    
    local outfitData = DbGetOutfitById(outfitId)
    
    if outfitData then
        local currentOutfit = DbGetOrCreateCurrentOutfit(playerIdentifier, playerModel)
        
        if not currentOutfit.components then
            currentOutfit.components = {}
        end
        if not currentOutfit.props then
            currentOutfit.props = {}
        end
        
        local decodedOutfit = json.decode(outfitData.outfit)
        
        for componentId, nameHash in pairs(decodedOutfit.components) do
            currentOutfit.components[tostring(componentId)] = nameHash
        end
        
        for propId, nameHash in pairs(decodedOutfit.props) do
            currentOutfit.props[tostring(propId)] = nameHash
        end
        
        DbSaveCurrentOutfit(playerIdentifier, playerModel, currentOutfit)
    else
        print("Error: outfit not found", outfitId)
    end
end)

RegisterNetEvent("rcore_clothing:removePersonalOutfit", function(outfitId)
    local playerId = source
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    DbRemovePersonalOutfit(playerIdentifier, outfitId)
end)

RegisterNetEvent("rcore_clothing:removeShopOutfit", function(outfitId)
    DbRemoveShopOutfit(outfitId)
end)

RegisterNetEvent("rcore_clothing:buyOutfit", function(outfitId)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerModel = GetEntityModel(playerPed)
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    
    local outfitData = DbGetOutfitById(outfitId)
    
    if outfitData then
        DbSavePersonalOutfit(playerIdentifier, playerModel, outfitData.name, json.decode(outfitData.outfit))
        
        local currentOutfit = DbGetOrCreateCurrentOutfit(playerIdentifier, playerModel)
        
        if not currentOutfit.components then
            currentOutfit.components = {}
        end
        if not currentOutfit.props then
            currentOutfit.props = {}
        end
        
        local decodedOutfit = json.decode(outfitData.outfit)
        
        for componentId, nameHash in pairs(decodedOutfit.components) do
            currentOutfit.components[tostring(componentId)] = nameHash
        end
        
        for propId, nameHash in pairs(decodedOutfit.props) do
            currentOutfit.props[tostring(propId)] = nameHash
        end
        
        DbSaveCurrentOutfit(playerIdentifier, playerModel, currentOutfit)
        TriggerClientEvent("rcore_clothing:outfitBought", playerId, decodedOutfit)
    else
        print("Error: outfit not found", outfitId)
    end
end)

function mysplit(inputString, delimiter)
    if delimiter == nil then
        delimiter = "%s"
    end
    
    local result = {}
    for match in string.gmatch(inputString, "([^" .. delimiter .. "]+)") do
        table.insert(result, match)
    end
    
    return result
end

function handleSmartMinus(inputString)
    local firstChar = string.sub(inputString, 1, 1)
    if firstChar == "m" then
        local numberPart = tonumber(string.sub(inputString, 2))
        return tostring(-numberPart)
    end
    
    return inputString
end

function clothingSplit(inputString)
    local parts = {}
    local currentPart = ""
    local i = 1
    
    while i <= #inputString do
        local currentChar = string.sub(inputString, i, i)
        local nextChar = string.sub(inputString, i + 1, i + 1)
        
        if currentChar == "-" and nextChar == "-" then
            table.insert(parts, currentPart)
            currentPart = ""
            i = i + 1
        else
            currentPart = currentPart .. currentChar
        end
        i = i + 1
    end
    
    table.insert(parts, currentPart)
    
    if #parts < 4 then
        return parts
    end
    
    local formattedParts = {}
    local namePart = parts[#parts - 3]
    local componentPart = parts[#parts - 2]
    local drawablePart = handleSmartMinus(parts[#parts - 1]) or parts[#parts - 1]
    local texturePart = parts[#parts]
    
    formattedParts[1] = namePart
    formattedParts[2] = componentPart
    formattedParts[3] = drawablePart
    formattedParts[4] = texturePart
    
    return formattedParts
end

function CheckoutSimpleResolveClothingItemToData(itemString)
    local itemData = {}
    local splitParts = clothingSplit(itemString, "--")
    
    itemData.name_hash = itemString
    itemData.component_id = tonumber(splitParts[2])
    itemData.drawable_id = tonumber(splitParts[3])
    itemData.texture_id = tonumber(splitParts[4])
    itemData.palette = 2
    
    return itemData
end