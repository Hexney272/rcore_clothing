local callbackCounter = 0
local pendingCallbacks = {}

function NotifyUser(message, isError)
    if Config.UseFrameworkNotify then
        if Config.Framework == 1 or Config.Framework == 2 then
            local notificationType = nil
            if isError then
                notificationType = "error"
            end
            ShowNotification(message, notificationType)
        end
    else
        UINotify(message, isError)
    end
end

function GetCurrentOutfit()
    local callbackId = callbackCounter
    callbackCounter = callbackCounter + 1
    
    TriggerServerEvent("rcore_clothing:requestCurrentOutfit", callbackId)
    
    while pendingCallbacks[callbackId] == nil do
        Wait(0)
    end
    
    local outfitData = pendingCallbacks[callbackId]
    pendingCallbacks[callbackId] = nil
    
    local skinData = outfitData.outfit or outfitData.skin
    outfitData.skin = skinData
    
    return outfitData
end

RegisterNetEvent("rcore_clothing:responseCurrentOutfit", function(callbackId, outfitData)
    pendingCallbacks[callbackId] = outfitData
end)

RegisterNetEvent("rcore_clothing:internal:itemPurchased", function(purchasedItems, additionalHashes)
    for _, item in pairs(purchasedItems) do
        local resolvedItem = ResolveItemToClothingOrPropItem(PlayerPedId(), item)
        
        TriggerEvent("rcore_clothing:onItemPurchase", 
            resolvedItem.componentId,
            resolvedItem.drawableId,
            resolvedItem.textureId,
            item.label,
            {
                name_hash = item.name_hash,
                arms = item.arms,
                isProp = resolvedItem.component_id and resolvedItem.component_id >= 100
            }
        )
    end
    
    for _, nameHash in pairs(additionalHashes) do
        local itemData = { name_hash = nameHash }
        local resolvedItem = ResolveItemToClothingOrPropItem(PlayerPedId(), itemData)
        
        TriggerEvent("rcore_clothing:onItemPurchase",
            resolvedItem.componentId,
            resolvedItem.drawableId,
            resolvedItem.textureId,
            nameHash.label,
            {
                name_hash = nameHash
            }
        )
    end
end)

RegisterNetEvent("rcore_clothing:clearPed", function()
    local allObjects = GetGamePool("CObject")
    local playerPed = PlayerPedId()
    
    for i = 1, #allObjects do
        local object = allObjects[i]
        if IsEntityAttachedToEntity(object, playerPed) then
            DeleteEntity(object)
        end
    end
    
    ShowNotification(_U("clear_ped"))
end)

RegisterNetEvent("rcore_clothing:openShop", function(shopType, shopConfig)
    if string.len(shopType) == 0 then
        print("rcore_clothing:openShop: shopType can't be empty!")
        return
    end
    
    RequestOpenClothingShopUI(shopType, shopConfig)
end)

RegisterNetEvent("rcore_clothing:openJobChangingRoom", function(jobName, roomConfig)
    if string.len(jobName) == 0 then
        print("rcore_clothing:openJobChangingRoom: job can't be empty!")
        return
    end
    
    local shopType = "job_" .. jobName
    
    if not roomConfig then
        roomConfig = {}
    end
    
    if not roomConfig.modifiers then
        roomConfig.modifiers = {}
    end
    
    roomConfig.modifiers[SHOP_MODIFIERS.IS_EVERYTHING_FREE] = true
    roomConfig.modifiers[SHOP_MODIFIERS.JOB_CHANGING_ROOM] = true
    
    if Config.JobChangingRoomActsAsPersonalChangingRoom then
        roomConfig.modifiers[SHOP_MODIFIERS.CHANGING_ROOM] = true
    end
    
    if not roomConfig.structure then
        roomConfig.structure = SHOP_CONFIG_ALIAS.CLOTHING.structure
    end
    
    RequestOpenClothingShopUI(shopType, roomConfig)
end)

function FixArmsForCurrentTop()
    local currentOutfit = GetCurrentOutfit()
    
    if not currentOutfit or not currentOutfit.skin or not currentOutfit.skin.components then
        return
    end
    
    local topComponentHash = currentOutfit.skin.components["11"]
    if not topComponentHash then
        return
    end
    
    local playerModel = GetEntityModel(PlayerPedId())
    TriggerServerEvent("rcore_clothing:requestRecommendedArmsByHash", topComponentHash, playerModel)
end

RegisterNetEvent("rcore_clothing:setRecommendedArmsByHash", function(armsData)
    if not armsData or not armsData[1] then
        return
    end
    
    local recommendedArms = armsData[1].recommended_arms
    if not recommendedArms then
        return
    end
    
    local playerPed = PlayerPedId()
    local armsComponentData = UsableHashToData(playerPed, recommendedArms)
    
    SetPedComponentVariation(playerPed, 3, armsComponentData.drawableId, armsComponentData.textureId, 0)
    TriggerEvent("rcore_clothing:saveCurrentSkin")
end)