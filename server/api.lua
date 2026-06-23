local playerRequestCounts = {}

function CheckRateLimit(playerId)
    if not playerRequestCounts[playerId] then
        playerRequestCounts[playerId] = 0
    end
    
    playerRequestCounts[playerId] = playerRequestCounts[playerId] + 1
    
    Citizen.SetTimeout(3000, function()
        playerRequestCounts[playerId] = playerRequestCounts[playerId] - 1
        if playerRequestCounts[playerId] <= 0 then
            playerRequestCounts[playerId] = nil
        end
    end)
    
    return playerRequestCounts[playerId] > 15
end

RegisterNetEvent("rcore_clothing:queryShop", function(callbackId, gender, shopId, queryData)
    local playerId = source
    
    if CheckRateLimit(playerId) then
        TriggerClientEvent("rcore_clothing:queryShopResponse", playerId, callbackId, "ratelimited")
        return
    end
    
    local playerJobData = FwGetPlayerJobData(playerId)
    local jobName = playerJobData.name
    local jobGrade = playerJobData.grade
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    local playerIdentifiers = AppendAces(playerId, GetPlayerIdentifiers(playerId))
    
    local shopConfig = queryData.shopConfig
    local hasChangingRoom = false
    local hasEverything = false
    local isEverythingFree = false
    
    if shopConfig then
        if shopConfig.modifiers then
            hasChangingRoom = shopConfig.modifiers[SHOP_MODIFIERS.CHANGING_ROOM]
            hasEverything = shopConfig.modifiers[SHOP_MODIFIERS.HAS_EVERYTHING]
            isEverythingFree = shopConfig.modifiers[SHOP_MODIFIERS.IS_EVERYTHING_FREE]
        end
    end
    
    local shopItems = {}
    
    if queryData.componentId == 33 then
        print("this shouldnt hit backend component", queryData.componentId)
    else
        queryData.job = jobName
        queryData.jobGrade = jobGrade
        queryData.identifiers = playerIdentifiers
        queryData.showEverything = hasEverything
        queryData.showAll = false
        
        local changingRoomIdentifier = nil
        if hasChangingRoom and playerIdentifier then
            changingRoomIdentifier = playerIdentifier
        end
        queryData.changingRoomIdentifier = changingRoomIdentifier
        
        shopItems = QueryShopFromDb(gender, shopId, queryData)
        
        if isEverythingFree or hasChangingRoom then
            for _, item in pairs(shopItems) do
                item.price = 0
            end
        end
    end
    
    TriggerClientEvent("rcore_clothing:queryShopResponse", playerId, callbackId, shopItems)
end)

RegisterNetEvent("rcore_clothing:queryShopAll", function(callbackId, gender, shopId, queryData)
    local playerId = source
    local shopItems = {}
    
    if queryData.componentId == 33 then
        print("this shouldnt hit backend component", queryData.componentId)
    else
        queryData.job = nil
        queryData.jobGrade = nil
        queryData.identifiers = nil
        queryData.showEverything = false
        queryData.showAll = true
        queryData.changingRoomIdentifier = nil
        
        shopItems = QueryShopFromDb(gender, shopId, queryData)
    end
    
    TriggerClientEvent("rcore_clothing:queryShopResponse", playerId, callbackId, shopItems)
end)

function QueryShopFromDb(gender, shopId, queryData)
    local dbItems = DbGetShopItems(gender, shopId, queryData)
    local enrichedItems = DbEnrichWithRestrictions(dbItems)
    local formattedItems = {}
    
    for _, item in pairs(enrichedItems) do
        table.insert(formattedItems, FormatClothingItem(queryData.showAll, item, gender))
    end
    
    if #formattedItems > 0 then
        AddEmptyClothingItems(formattedItems, queryData, gender)
    end
    
    return formattedItems
end

function AddEmptyClothingItems(itemsList, queryData, gender)
    local componentId = queryData.componentId
    local lastId = queryData.lastId
    
    if lastId >= 1 then
        return
    end
    
    local emptyItemFunctions = {
        [8] = function() return GetEmptyUndershirt(gender) end,
        [6] = function() return GetEmptyShoes(gender) end,
        [4] = function() return GetEmptyPants(gender) end,
        [1] = function() return GetEmptyMask() end,
        [7] = function() return GetEmptyNeckwear() end,
        [11] = function() return GetEmptyTorso(gender) end,
        [9] = function() return GetEmptyVest(gender) end,
        [5] = function() return GetEmptyBag(gender) end,
        [100] = function() return GetEmptyHat() end,
        [107] = function() return GetEmptyBracelet() end,
        [106] = function() return GetEmptyWatches() end,
        [102] = function() return GetEmptyEars() end,
        [101] = function() return GetEmptyGlasses() end
    }
    
    local emptyItemFunction = emptyItemFunctions[componentId]
    if emptyItemFunction then
        table.insert(itemsList, 1, emptyItemFunction())
    end
end

RegisterNetEvent("rcore_clothing:requestOpenClothingShop", function(shopType, shopConfig)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerModel = GetEntityModel(playerPed)
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    
    local hasChangingRoom = false
    local hasEverything = false
    
    if shopConfig then
        if shopConfig.modifiers then
            hasChangingRoom = shopConfig.modifiers[SHOP_MODIFIERS.CHANGING_ROOM]
            hasEverything = shopConfig.modifiers[SHOP_MODIFIERS.HAS_EVERYTHING]
        end
    end
    
    local changingRoomIdentifier = nil
    if hasChangingRoom and playerIdentifier then
        changingRoomIdentifier = playerIdentifier
    end
    
    local availableComponents = GetAvailableComponentsInShop(playerModel, shopType, hasEverything, changingRoomIdentifier)
    local availableClothingTypes = GetAvailableClothingTypes(playerModel, shopType, hasEverything, changingRoomIdentifier)
    local baseMenuData = FormatBaseMenuForComponents(availableComponents)
    local typesPerComponent = FormatTypesPerComponentId(availableClothingTypes)
    local serverJobs = GetAllServerJobs()
    local playerPermissions = GetPlayerPermissions(playerId)
    
    local externalServerData = nil
    if Config.ExternalServer then
        externalServerData = {
            playerJobData = FwGetPlayerJobData(playerId),
            identifier = GetPlayerFwIdentifier(playerId),
            identifiers = AppendAces(playerId, GetPlayerIdentifiers(playerId)),
            apiUrl = Config.ExternalServer,
            shopConfig = shopConfig
        }
    end
    
    TriggerClientEvent("rcore_clothing:openClothingShop", playerId, shopType, baseMenuData, typesPerComponent, playerPermissions, externalServerData)
    
    Wait(0)
    TriggerClientEvent("rcore_clothing:setHairData", playerId, DbGetHair(playerModel))
    
    Wait(0)
    TriggerClientEvent("rcore_clothing:setServerJobs", playerId, serverJobs)
    
    if shopType == "CHARCREATOR" then
        PutPlayerIntoBucket(playerId)
    end
end)

RegisterNetEvent("rcore_clothing:charcreator:done", function()
    local playerId = source
    ResetPlayerBucket(playerId)
end)

RegisterNetEvent("rcore_clothing:requestFullShopStructureExceptHead", function()
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerModel = GetEntityModel(playerPed)
    
    local availableComponents = GetAvailableComponentsInShop(playerModel)
    local availableClothingTypes = GetAvailableClothingTypes(playerModel)
    local baseMenuData = FormatBaseMenuForComponents(availableComponents)
    local typesPerComponent = FormatTypesPerComponentId(availableClothingTypes)
    
    TriggerClientEvent("rcore_clothing:setShopBaseStructure", playerId, baseMenuData, typesPerComponent)
end)

function HandleAdminAction(playerId, permission, action, errorMessage)
    if AceCan(playerId, permission) then
        action()
    else
        print("^1Player with id " .. playerId .. errorMessage)
    end
end

RegisterNetEvent("rcore_clothing:addItemToShop", function(shopData, itemData)
    local playerId = source
    HandleAdminAction(playerId, Permissions.ADMIN_STOCK_MANAGEMENT, function()
        DbAddItemToShop(shopData, itemData)
    end, " tried to add item to shop without permission.")
end)

RegisterNetEvent("rcore_clothing:removeItemFromShop", function(shopData, itemData)
    local playerId = source
    HandleAdminAction(playerId, Permissions.ADMIN_STOCK_MANAGEMENT, function()
        DbRemoveItemFromShop(shopData, itemData)
    end, " tried to remove item from shop without permission.")
end)

RegisterNetEvent("rcore_clothing:addGroupToShop", function(shopData, groupData)
    local playerId = source
    HandleAdminAction(playerId, Permissions.ADMIN_STOCK_MANAGEMENT, function()
        DbAddGroupToShop(shopData, groupData)
    end, " tried to add group to shop without permission.")
end)

RegisterNetEvent("rcore_clothing:removeGroupFromShop", function(shopData, groupData)
    local playerId = source
    HandleAdminAction(playerId, Permissions.ADMIN_STOCK_MANAGEMENT, function()
        DbRemoveGroupFromShop(shopData, groupData)
    end, " tried to remove group from shop without permission.")
end)

RegisterNetEvent("rcore_clothing:editItemMetadata", function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    local playerId = source
    HandleAdminAction(playerId, Permissions.ADMIN_EDIT_METADATA, function()
        DbEditItemMetadata(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    end, " tried to edit item metadata without permission.")
end)

RegisterNetEvent("rcore_clothing:editGroupMetadata", function(arg1, arg2, arg3, arg4)
    local playerId = source
    HandleAdminAction(playerId, Permissions.ADMIN_EDIT_METADATA, function()
        DbEditGroupMetadata(arg1, arg2, arg3, arg4)
    end, " tried to edit group metadata without permission.")
end)

RegisterNetEvent("rcore_clothing:blacklistItem", function(itemData)
    local playerId = source
    HandleAdminAction(playerId, Permissions.ADMIN_IMAGE_DEBUG, function()
        DbBlacklistItem(itemData)
    end, " tried to blacklist item without permission.")
end)

RegisterNetEvent("rcore_clothing:resetItem", function(itemData)
    local playerId = source
    HandleAdminAction(playerId, Permissions.ADMIN_IMAGE_DEBUG, function()
        DbResetItem(itemData)
    end, " tried to reset item without permission.")
end)

RegisterNetEvent("rcore_clothing:setRecommendedArms", function(callbackId, itemHash, armsData, componentData)
    local playerId = source
    local success = false
    
    if AceCan(playerId, Permissions.ADMIN_EDIT_ARMS) then
        DbEditRecommendedArms(itemHash, armsData)
        success = true
    else
        print("^1Player with id " .. playerId .. " tried to edit recommended arms without permission.")
    end
    
    TriggerClientEvent("rcore_clothing:setRecommendedArmsResult", playerId, callbackId, success)
end)

RegisterNetEvent("rcore_clothing:setGroupRecommendedArms", function(callbackId, groupHash, armsData)
    local playerId = source
    local success = false
    
    if AceCan(playerId, Permissions.ADMIN_EDIT_ARMS) then
        DbEditGroupRecommendedArms(groupHash, armsData)
        success = true
    else
        print("^1Player with id " .. playerId .. " tried to edit group recommended arms without permission.")
    end
    
    TriggerClientEvent("rcore_clothing:setRecommendedArmsResult", playerId, callbackId, success)
end)

RegisterNetEvent("rcore_clothing:requestCurrentOutfit", function(callbackId)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerModel = GetEntityModel(playerPed)
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    
    local currentOutfit, outfitModel = DbGetOrCreateCurrentOutfit(playerIdentifier, playerModel)
    
    TriggerClientEvent("rcore_clothing:responseCurrentOutfit", playerId, callbackId, {
        outfit = currentOutfit,
        model = outfitModel
    })
end)

RegisterNetEvent("rcore_clothing:requestRecommendedArmsByHash", function(itemHash, componentHash)
    local playerId = source
    local recommendedArms = DbGetRecommendedArmsByHash(itemHash, componentHash)
    
    TriggerClientEvent("rcore_clothing:setRecommendedArmsByHash", playerId, recommendedArms)
end)