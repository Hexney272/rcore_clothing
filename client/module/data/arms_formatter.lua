function QueryAvailableArms(lastId)
    -- If lastId > 0, return empty (pagination logic)
    if lastId > 0 then
        return {}
    end
    
    local armsList = {}
    local currentPed = GetShopPed()
    if not currentPed then
        currentPed = PlayerPedId()
    end
    
    local pedModel = GetEntityModel(currentPed)
    local baseArmsData = DataGetArms()
    
    for armsIndex, armsHash in pairs(baseArmsData) do
        local armsComponentData = UsableHashToData(currentPed, armsHash)
        
        -- Generate image filename (hash + "_0_0")
        local imageFilename = armsHash .. "_0_0"
        
        table.insert(armsList, {
            type = "clothing_item",
            subtype = "base_arms",
            id = armsIndex,
            label = "",
            price = nil,
            drawable_id = armsComponentData.drawableId,
            texture_id = armsComponentData.textureId,
            image = "https://clothing.rcore.cz/assets/gamedata/" .. pedModel .. "/3/" .. imageFilename .. ".webp",
            colors = "",
            category = "",
            name_hash = armsHash,
            component_id = 3,
            decal_collection_hash = nil,
            decal_name_hash = nil
        })
    end
    
    return armsList
end

function QueryAvailableGloves(lastId)
    -- If lastId > 0, return empty (pagination logic)
    if lastId > 0 then
        return {}
    end
    
    local glovesList = {}
    local currentPed = PlayerPedId()
    local pedModel = GetEntityModel(currentPed)
    
    -- Get current arms component info
    local currentDrawableId = GetPedDrawableVariation(currentPed, 3)
    local currentTextureId = GetPedTextureVariation(currentPed, 3)
    local currentHashName = GetHashNameForComponent(currentPed, 3, currentDrawableId, currentTextureId)
    local currentUsableHash = GetUsableHash(3, currentDrawableId, currentTextureId, currentHashName)
    
    -- Get base arms and available gloves
    local armsIndex, baseArmsHash = GetBaseArmsFromHash(currentUsableHash)
    local availableGloves = GetAvailableGloves(baseArmsHash)
    
    for gloveIndex, gloveHash in pairs(availableGloves) do
        local gloveComponentData = UsableHashToData(currentPed, gloveHash)
        
        -- Generate image filename (hash + "_0_0")
        local imageFilename = gloveHash .. "_0_0"
        
        table.insert(glovesList, {
            type = "clothing_item",
            id = 1000000 + gloveIndex, -- Offset glove IDs by 1 million
            gloves = true,
            label = "",
            price = nil,
            drawable_id = gloveComponentData.drawableId,
            texture_id = gloveComponentData.textureId,
            image = "https://clothing.rcore.cz/assets/gamedata/" .. pedModel .. "/3/" .. imageFilename .. ".webp",
            colors = "",
            category = "",
            name_hash = gloveHash,
            component_id = 3,
            decal_collection_hash = nil,
            decal_name_hash = nil
        })
    end
    
    return glovesList
end