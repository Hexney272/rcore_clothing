local activePeds = {}

-- Ped model constants
local FEMALE_PED_MODEL = 1885233650
local MALE_PED_MODEL = -1667301416

function ProcessClothingComponents(pedModel)
    local maxArmsComponent = (pedModel == FEMALE_PED_MODEL) and 3 or 4
    
    -- Define clothing component IDs to process
    local clothingComponents = {1, 2, 3, 4, 5, 6, 7, 80, 81, 9, 10, 110, 111}
    local processingTasks = {}
    
    for index, componentId in pairs(clothingComponents) do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        Citizen.CreateThread(function()
            -- Position peds in a grid pattern
            local offsetPosition = playerCoords + vector3(index / 3, (index % 3) / 2, 1.0)
            
            local tempPed = CreatePed(0, pedModel, offsetPosition, 0.0, false, false)
            SetBlockingOfNonTemporaryEvents(tempPed, true)
            SetPedHeadBlendData(tempPed, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, false)
            
            processingTasks[componentId] = {
                ped = tempPed,
                done = false
            }
            
            activePeds[tempPed] = tempPed
            
            Wait(500)
            
            HandleClothingComponent(tempPed, pedModel, componentId, maxArmsComponent)
            
            activePeds[tempPed] = nil
            DeletePed(tempPed)
            processingTasks[componentId].done = true
        end)
    end
end

function HandleProps(pedModel)
    -- Define prop component IDs to process (hats, glasses, earrings, watches, bracelets)
    local propComponents = {0, 1, 2, 6, 7}
    local processingTasks = {}
    
    for index, propId in pairs(propComponents) do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        Citizen.CreateThread(function()
            -- Position peds in a grid pattern (slightly different from clothing)
            local offsetPosition = playerCoords + vector3(index / 3, -((index % 3) / 2) + 2.0, 1.0)
            
            local tempPed = CreatePed(0, pedModel, offsetPosition, 0.0, false, false)
            SetBlockingOfNonTemporaryEvents(tempPed, true)
            SetPedHeadBlendData(tempPed, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, false)
            
            processingTasks[propId] = {
                ped = tempPed,
                done = false
            }
            
            activePeds[tempPed] = tempPed
            
            Wait(500)
            
            HandlePropsComponent(tempPed, pedModel, propId)
            
            activePeds[tempPed] = nil
            DeletePed(tempPed)
            processingTasks[propId].done = true
        end)
    end
end

function HandleClothingComponent(pedHandle, pedModel, componentId, maxArmsComponent)
    local mappingData = {}
    
    IterateOverVariations(pedHandle, componentId, 0, 0, function(ped, compId, drawableId, textureId)
        print("Processing", compId, drawableId)
        
        local nameHash = GetHashNameForComponent(pedModel, compId, drawableId, textureId)
        local shopData = GetShopPedComponent(nameHash)
        local decalVariations = GetDecalVariations(maxArmsComponent, pedModel, nameHash)
        local forcedComponents = GetForcedComponents(pedModel, nameHash)
        local recommendedArms = ResolveRecommendedArms(pedModel, forcedComponents)
        
        local collectionName = GetPedCollectionNameFromDrawable(pedHandle, compId, drawableId)
        local collectionIndex = GetPedCollectionLocalIndexFromDrawable(pedHandle, compId, drawableId)
        
        if collectionName == "" then
            collectionName = "nondlcgta5"
        end
        
        if not collectionName or not collectionIndex then
            print("No collection name/index for", compId, drawableId)
        end
        
        -- Add base clothing item
        table.insert(mappingData, {
            nameHash = nameHash,
            componentId = compId,
            drawableId = drawableId,
            textureId = textureId,
            pedModel = pedModel,
            collectionName = collectionName,
            collectionIndex = collectionIndex,
            labelGxt = shopData.Label,
            label = GetLabelText(shopData.Label),
            price = ResolvePrice(shopData.Price),
            recommendedArms = recommendedArms,
            setComponents = forcedComponents
        })
        
        -- Add decal variations
        for _, decalVariation in ipairs(decalVariations) do
            local decalPrice = decalVariation.Price
            if decalPrice == nil then
                decalPrice = ResolvePrice(shopData.Price) or decalVariation.Price
            end
            
            table.insert(mappingData, {
                nameHash = nameHash,
                componentId = compId,
                drawableId = drawableId,
                textureId = textureId,
                pedModel = pedModel,
                collectionName = collectionName,
                collectionIndex = collectionIndex,
                decalCollectionHash = decalVariation.CollectionHash,
                decalNameHash = decalVariation.DecorationNameHash,
                labelGxt = decalVariation.Label,
                label = GetLabelText(decalVariation.Label),
                price = decalPrice,
                recommendedArms = recommendedArms,
                setComponents = forcedComponents
            })
            
            -- Send data in batches to avoid overwhelming server
            if #mappingData > 40 then
                print("Sending to server...")
                TriggerServerEvent("rcore_clothing:sendClothingMappingData", mappingData)
                Wait(1000)
                mappingData = {}
            end
        end
        
        -- Check batch size after processing base item too
        if #mappingData > 40 then
            print("Sending to server...")
            TriggerServerEvent("rcore_clothing:sendClothingMappingData", mappingData)
            Wait(1000)
            mappingData = {}
        end
    end)
    
    -- Send remaining data
    print("Sending rest...")
    TriggerServerEvent("rcore_clothing:sendClothingMappingData", mappingData)
end

function HandlePropsComponent(pedHandle, pedModel, propId)
    local mappingData = {}
    
    IterateOverProps(pedHandle, propId, 0, 0, function(ped, anchorPoint, drawableId, textureId)
        print("Processing", anchorPoint, drawableId, textureId)
        
        local nameHash = GetHashNameForProp(pedModel, propId, drawableId, textureId)
        local shopData = GetShopPedProp(nameHash)
        
        local collectionName = GetPedCollectionNameFromProp(pedHandle, propId, drawableId)
        local collectionIndex = GetPedCollectionLocalIndexFromProp(pedHandle, propId, drawableId)
        
        if collectionName == "" then
            collectionName = "nondlcgta5"
        end
        
        table.insert(mappingData, {
            nameHash = nameHash,
            componentId = 100 + propId, -- Props use component IDs 100+
            drawableId = drawableId,
            textureId = textureId,
            pedModel = pedModel,
            collectionName = collectionName,
            collectionIndex = collectionIndex,
            labelGxt = shopData.Label,
            label = GetLabelText(shopData.Label),
            price = ResolvePrice(shopData.Price)
        })
        
        -- Send data in batches
        if #mappingData > 40 then
            print("Sending to server...")
            TriggerServerEvent("rcore_clothing:sendPropMappingData", mappingData)
            Wait(1000)
            mappingData = {}
        end
    end)
    
    -- Send remaining data
    print("Sending rest...")
    TriggerServerEvent("rcore_clothing:sendPropMappingData", mappingData)
end

function ResolveLabel(labelGxt)
    if labelGxt and labelGxt ~= "" then
        return GetLabelText(labelGxt)
    end
    return nil
end

function ResolvePrice(price)
    if price and price > 0 then
        return price
    end
    return nil
end

function ResolveRecommendedArms(pedModel, forcedComponents)
    local armsComponentId = 3
    
    for _, component in ipairs(forcedComponents) do
        if component.componentId == armsComponentId then
            local nameHash = component.nameHash
            local drawableId = component.drawableId
            local textureId = component.textureId
            local shopData = GetShopPedComponent(nameHash)
            
            return GetUsableHash(3, drawableId, textureId, shopData.Hash)
        end
    end
    
    return nil
end

-- Event handlers
RegisterNetEvent("rcore_clothing:pipelineInitStage1", function()
    -- Precompute tattoo cache for both male and female
    PrecomputeTattooCache(3)
    PrecomputeTattooCache(4)
    
    -- Wait for tattoo cache to be ready
    while not IsTattooCacheReady() do
        Wait(0)
    end
    
    -- Request both ped models
    RequestModel(FEMALE_PED_MODEL)
    RequestModel(MALE_PED_MODEL)
    
    -- Wait for models to load
    while not (HasModelLoaded(FEMALE_PED_MODEL) and HasModelLoaded(MALE_PED_MODEL)) do
        Wait(0)
    end
    
    -- Process props for both models
    HandleProps(FEMALE_PED_MODEL)
    HandleProps(MALE_PED_MODEL)
    
    -- Process clothing components for both models
    ProcessClothingComponents(FEMALE_PED_MODEL)
    ProcessClothingComponents(MALE_PED_MODEL)
    
    Wait(1000)
    
    -- Wait for all processing to complete
    while true do
        local stillProcessing = false
        
        for pedHandle, _ in pairs(activePeds) do
            stillProcessing = true
        end
        
        if not stillProcessing then
            ShowInfoDialog("pipeline_recalib_done", "Recalibration done", "Recalibration done! 🎉 You can now close this window.")
            break
        end
        
        Wait(100)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    local currentResource = GetCurrentResourceName()
    
    if resourceName == currentResource then
        -- Clean up any remaining peds
        for pedHandle, _ in pairs(activePeds) do
            DeleteEntity(pedHandle)
        end
    end
end)