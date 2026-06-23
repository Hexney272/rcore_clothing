function GetClothingCollectionInfo(pedHandle, clothingItem)
    local collectionName = GetPedCollectionNameFromDrawable(pedHandle, clothingItem.componentId, clothingItem.drawableId)
    local collectionIndex = GetPedCollectionLocalIndexFromDrawable(pedHandle, clothingItem.componentId, clothingItem.drawableId)
    
    if collectionName == "" then
        collectionName = "nondlcgta5"
    end
    
    return collectionName, collectionIndex
end

function GetItemCollectionData(pedHandle, itemData, resolvedItem)
    local componentId = itemData.component_id
    
    if componentId >= 100 then
        -- Handle props (componentId >= 100)
        local propComponentId = resolvedItem.componentId - 100
        local propCollectionName = GetPedCollectionNameFromProp(pedHandle, propComponentId, resolvedItem.drawableId)
        local propCollectionIndex = GetPedCollectionLocalIndexFromProp(pedHandle, propComponentId, resolvedItem.drawableId)
        
        if propCollectionName == "" then
            propCollectionName = "nondlcgta5"
        end
        
        return {
            collection = propCollectionName,
            index = propCollectionIndex
        }
    else
        -- Handle regular clothing
        local clothingCollectionName, clothingCollectionIndex = GetClothingCollectionInfo(pedHandle, resolvedItem)
        
        return {
            collection = clothingCollectionName,
            index = clothingCollectionIndex
        }
    end
end

function ProcessRecommendedArms(pedHandle, itemData)
    local recommendedArms = itemData.recommended_arms
    
    if not recommendedArms or recommendedArms == "" then
        return nil
    end
    
    local armsData = UsableHashToData(pedHandle, recommendedArms)
    
    if not armsData.componentId or armsData.componentId <= 0 then
        return nil
    end
    
    local armsCollectionName, armsCollectionIndex = GetClothingCollectionInfo(pedHandle, armsData)
    
    return armsCollectionName .. "--" .. armsData.componentId .. "--" .. armsCollectionIndex .. "--" .. armsData.textureId
end

function CreateNewHashString(collectionData, resolvedItem, itemIndex)
    local collectionName = collectionData.collection
    
    if not collectionName then
        collectionName = "delme__" .. itemIndex
    end
    
    local componentId = resolvedItem.componentId or 0
    local textureId = resolvedItem.textureId or 0
    
    return collectionName .. "--" .. componentId .. "--" .. collectionData.index .. "--" .. textureId
end

RegisterNetEvent("rcore_clothing:stage00:processItems", function(itemsList, remainingCount)
    print("Processing", #itemsList, "remaining", remainingCount)
    
    local processedItems = {}
    
    for itemIndex, itemData in pairs(itemsList) do
        local currentPed = PlayerPedId()
        local currentPedModel = GetEntityModel(currentPed)
        
        -- Load correct ped model if different
        if itemData.ped_model ~= currentPedModel then
            LoadAndSetModel(itemData.ped_model)
            currentPed = PlayerPedId()
        end
        
        -- Resolve the item to clothing/prop format
        local resolvedItem = ResolveItemToClothingOrPropItem(currentPed, itemData)
        
        -- Get collection data for the resolved item
        local collectionData = GetItemCollectionData(currentPed, itemData, resolvedItem)
        
        -- Process recommended arms if present
        local recommendedArmsHash = ProcessRecommendedArms(currentPed, itemData)
        
        -- Create new hash string
        local newHashString = CreateNewHashString(collectionData, resolvedItem, itemIndex)
        
        -- Add processed item to results
        table.insert(processedItems, {
            oldHash = itemData.name_hash,
            pedModel = itemData.ped_model,
            newHash = newHashString,
            recArms = recommendedArmsHash
        })
    end
    
    TriggerServerEvent("rcore_clothing:stage00:resolveItems", processedItems)
end)