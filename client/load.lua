RegisterNetEvent("rcore_clothing:setPlayerClothing", function(clothingData, pedModel, additionalOptions)
    local playerPed = PlayerPedId()
    
    -- Preserve player health and armor during clothing change
    local currentHealth = GetEntityHealth(playerPed)
    local currentArmor = GetPedArmour(playerPed)
    
    ApplyPlayerClothingOnSpawn(pedModel, clothingData, additionalOptions)
    
    -- Restore health and armor
    SetEntityHealth(playerPed, currentHealth)
    SetPedArmour(playerPed, currentArmor)
end)

function ApplyPlayerClothingOnSpawn(targetModel, outfitData, additionalOptions)
    local playerPed = PlayerPedId()
    local currentModel = GetEntityModel(playerPed)
    
    -- Change ped model if different or forced
    if currentModel ~= targetModel or additionalOptions then
        LoadAndSetModel(targetModel)
        SetPedDefaultComponentVariation(playerPed)
    end
    
    playerPed = PlayerPedId()
    ApplyPedClothingOutfit(playerPed, outfitData)
    TriggerEvent("rcore_clothing:afterSkinLoaded")
end

function ApplyPedClothing(pedEntity, outfitData, additionalOptions)
    ApplyPedClothingOutfit(pedEntity, outfitData, additionalOptions)
    TriggerEvent("rcore_clothing:afterSkinLoaded")
end

function ApplyPedClothingOutfit(pedEntity, outfitData, keepCurrentVariations)
    -- Apply head blend data for freemode peds
    if IsPedFreemode(pedEntity) then
        if outfitData.headblend then
            local headblend = outfitData.headblend
            local modelBlend = (headblend.modelBlend / 10) * 10
            local toneBlend = (headblend.toneBlend / 10) * 10
            
            SetPedHeadBlendData(
                pedEntity,
                headblend.maleModel,
                headblend.femaleModel,
                0,
                headblend.maleTone,
                headblend.femaleTone,
                0,
                modelBlend,
                toneBlend,
                0.0,
                false
            )
        elseif not keepCurrentVariations then
            -- Reset head blend if no data provided
            SetPedHeadBlendData(pedEntity, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, false)
        end
        
        if not keepCurrentVariations then
            SetPedDefaultComponentVariation(pedEntity)
            CustomSetDefaultVariations(pedEntity)
            ClearAllPedProps(pedEntity)
        end
    end
    
    -- Apply face features
    if outfitData.faceFeatures then
        for featureId, featureValue in pairs(outfitData.faceFeatures) do
            local featureIndex = tonumber(featureId)
            local featureFloat = tonumber(featureValue) + 0.0
            SetPedFaceFeature(pedEntity, featureIndex, featureFloat)
        end
    end
    
    -- Apply clothing components
    if outfitData.components then
        for componentIdStr, nameHash in pairs(outfitData.components) do
            -- Skip hair component if hair data exists separately
            if componentIdStr == "2" and outfitData.hair then
                goto continue
            end
            
            local componentId = tonumber(componentIdStr)
            local itemData = UsableHashToData(pedEntity, nameHash)
            
            -- Resolve decal data for this component
            local decCol = nil
            local decName = nil
            if outfitData.decals and outfitData.decals[componentIdStr] then
                decCol = outfitData.decals[componentIdStr].collection
                decName = outfitData.decals[componentIdStr].name
            end
            
            if itemData and itemData.componentId then
                ApplyPedClothingItem(pedEntity, {
                    name_hash = nameHash,
                    decal_collection_hash = decCol,
                    decal_name_hash = decName
                })
            end
            
            ::continue::
        end
    end
    
    -- Apply props
    if outfitData.props then
        for propIdStr, nameHash in pairs(outfitData.props) do
            local propId = tonumber(propIdStr)
            local propData = UsablePropHashToData(pedEntity, nameHash)
            
            if propData and propData.componentId then
                SetPedPropIndex(
                    pedEntity,
                    propData.componentId,
                    propData.drawableId,
                    propData.textureId,
                    true
                )
            end
        end
    end
    
    -- Apply head overlays
    if outfitData.headOverlay then
        for overlayIdStr, overlayData in pairs(outfitData.headOverlay) do
            local overlayId = tonumber(overlayIdStr)
            
            SetPedHeadOverlay(pedEntity, overlayId, overlayData.id, overlayData.opacity)
            
            -- Determine color type based on overlay ID
            local colorType = 0
            if overlayId == 2 or overlayId == 1 or overlayId == 10 then
                colorType = 1  -- Hair color
            elseif overlayId == 5 or overlayId == 8 or overlayId == 4 then
                colorType = 2  -- Makeup color
            end
            
            SetPedHeadOverlayColor(
                pedEntity,
                overlayId,
                colorType,
                overlayData.color1 or 0,
                overlayData.color2 or 0
            )
        end
    end
    
    -- Apply eye color
    if outfitData.eyeColor then
        SetPedEyeColor(pedEntity, outfitData.eyeColor)
    end
    
    -- Apply hair
    if outfitData.hair and outfitData.hair.id then
        local hairId = outfitData.hair.id
        
        -- Convert numeric hair ID to hash format
        if type(hairId) == "number" then
            hairId = "2_" .. hairId .. "_0"
            outfitData.hair.id = hairId
        end
        
        ApplyPedClothingItem(pedEntity, {
            name_hash = hairId
        })
        
        SetPedHairColor(pedEntity, outfitData.hair.color1, outfitData.hair.color2)
    end
end