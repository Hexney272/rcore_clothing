function containsUnderscore(inputString)
    return string.find(inputString, "_") ~= nil
end

function containsDoubleDash(inputString)
    return string.find(inputString, "%-%-") ~= nil
end

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

function GetUsableHash(componentId, drawableId, textureId, hashName)
    local playerPed = PlayerPedId()
    local collectionName = nil
    local localIndex = nil
    
    if componentId >= 100 then
        -- Handle props (component ID >= 100)
        local propId = componentId - 100
        collectionName = GetPedCollectionNameFromProp(playerPed, propId, drawableId)
        localIndex = GetPedCollectionLocalIndexFromProp(playerPed, propId, drawableId)
    else
        -- Handle clothing components
        collectionName = GetPedCollectionNameFromDrawable(playerPed, componentId, drawableId)
        localIndex = GetPedCollectionLocalIndexFromDrawable(playerPed, componentId, drawableId)
    end
    
    if collectionName == "" then
        collectionName = "nondlcgta5"
    end
    
    if collectionName == nil then
        return
    end
    
    return collectionName .. "--" .. componentId .. "--" .. localIndex .. "--" .. textureId
end

function UsableHashToData(pedEntity, nameHash)
    return ResolveClothingItemToData(pedEntity, {
        name_hash = nameHash
    })
end

function UsableHashOfComponentOrPropToData(pedEntity, nameHash, keepComponentId)
    local clothingData = ResolveClothingItemToData(pedEntity, {
        name_hash = nameHash
    })
    
    if clothingData and clothingData.componentId and clothingData.componentId >= 100 then
        return ResolvePropItemToData(pedEntity, {
            name_hash = nameHash
        }, keepComponentId)
    end
    
    return clothingData
end

function GetUsableClothingHash(componentId, drawableId, textureId)
    local playerPed = PlayerPedId()
    local hashName = nil
    
    if componentId < 100 then
        hashName = GetHashNameForComponent(playerPed, componentId, drawableId, textureId)
    else
        hashName = GetHashNameForProp(playerPed, componentId, drawableId, textureId)
    end
    
    return GetUsableHash(componentId, drawableId, textureId, hashName)
end

function ResolveClothingItemToData(pedEntity, itemData)
    local resolvedData = {}
    
    if containsDoubleDash(itemData.name_hash) then
        -- Parse double-dash format (collection--component--drawable--texture)
        local parts = clothingSplit(itemData.name_hash, "--")
        local collectionName = parts[1]
        local componentId = tonumber(parts[2])
        local drawableId = tonumber(parts[3])
        local textureId = tonumber(parts[4])
        
        if componentId >= 100 then
            return {}
        end
        
        local palette = 0
        if componentId <= 11 then
            palette = GetPedPaletteVariation(pedEntity, componentId)
        end
        
        local globalDrawableId = drawableId
        if collectionName ~= "nondlcgta5" then
            globalDrawableId = GetPedDrawableGlobalIndexFromCollection(pedEntity, componentId, collectionName, drawableId)
        end
        
        resolvedData.componentId = componentId
        resolvedData.drawableId = globalDrawableId
        resolvedData.textureId = textureId
        resolvedData.palette = palette
        
    elseif containsUnderscore(itemData.name_hash) then
        -- Parse underscore format (component_drawable_texture)
        local cleanedHash = itemData.name_hash:gsub("\"", "")
        itemData.name_hash = cleanedHash
        
        local parts = mysplit(itemData.name_hash, "_")
        local palette = 0
        
        local componentId = tonumber(parts[1])
        if componentId <= 11 then
            palette = GetPedPaletteVariation(pedEntity, componentId)
        end
        
        resolvedData.componentId = componentId
        resolvedData.drawableId = tonumber(parts[2])
        resolvedData.textureId = tonumber(parts[3])
        resolvedData.palette = palette
        
    else
        -- Parse numeric hash (shop component ID)
        local numericId = tonumber(itemData.name_hash)
        local shopComponent = GetShopPedComponent(numericId)
        
        if shopComponent.ComponentType and shopComponent.ComponentType > 0 then
            local palette = 0
            if shopComponent.ComponentType <= 11 then
                palette = GetPedPaletteVariation(pedEntity, shopComponent.ComponentType)
            end
            
            resolvedData.componentId = shopComponent.ComponentType
            resolvedData.drawableId = shopComponent.Drawable
            resolvedData.textureId = shopComponent.Texture
            resolvedData.palette = palette
        end
    end
    
    -- Add decal information if present
    if itemData.decal_collection_hash and itemData.decal_collection_hash ~= 0 then
        if itemData.decal_name_hash and itemData.decal_name_hash ~= 0 then
            resolvedData.decalCollectionHash = itemData.decal_collection_hash
            resolvedData.decalNameHash = itemData.decal_name_hash
        end
    end
    
    return resolvedData
end

function UsablePropHashToData(pedEntity, nameHash)
    return ResolvePropItemToData(pedEntity, {
        name_hash = nameHash
    })
end

function ResolvePropItemToData(pedEntity, itemData, keepOriginalComponentId)
    local resolvedData = {}
    
    if containsDoubleDash(itemData.name_hash) then
        -- Parse double-dash format (collection--component--drawable--texture)
        local parts = clothingSplit(itemData.name_hash, "--")
        local collectionName = parts[1]
        local componentId = tonumber(parts[2])
        local drawableId = tonumber(parts[3])
        local textureId = tonumber(parts[4])
        
        local palette = 0
        if componentId <= 11 then
            palette = GetPedPaletteVariation(pedEntity, componentId)
        end
        
        local globalDrawableId = drawableId
        if collectionName ~= "nondlcgta5" then
            globalDrawableId = GetPedPropGlobalIndexFromCollection(pedEntity, componentId - 100, collectionName, drawableId)
        end
        
        if keepOriginalComponentId then
            resolvedData.componentId = componentId
        else
            resolvedData.componentId = componentId - 100
        end
        
        resolvedData.drawableId = globalDrawableId
        resolvedData.textureId = textureId
        resolvedData.palette = palette
        
    elseif containsUnderscore(itemData.name_hash) then
        -- Parse underscore format (component_drawable_texture)
        local parts = mysplit(itemData.name_hash, "_")
        
        if keepOriginalComponentId then
            resolvedData.componentId = compId
        else
            local componentId = tonumber(parts[1])
            resolvedData.componentId = componentId - 100
        end
        
        resolvedData.drawableId = tonumber(parts[2])
        resolvedData.textureId = tonumber(parts[3])
        resolvedData.palette = 0
        
    else
        -- Parse numeric hash (shop prop ID)
        local numericId = tonumber(itemData.name_hash)
        local shopProp = GetShopPedProp(numericId)
        
        if shopProp.Hash and shopProp.Hash ~= 0 then
            resolvedData.componentId = shopProp.ComponentType
            resolvedData.drawableId = shopProp.Drawable
            resolvedData.textureId = shopProp.Texture
            resolvedData.palette = 0
        else
            -- Fallback to item data fields
            resolvedData.componentId = itemData.component_id
            resolvedData.drawableId = itemData.drawable_id
            resolvedData.textureId = itemData.texture_id
            resolvedData.palette = 0
        end
    end
    
    return resolvedData
end

function ResolvePropItemToDataInternalComponent(pedEntity, itemData, keepOriginalComponentId)
    local resolvedData = ResolvePropItemToData(pedEntity, itemData)
    
    if resolvedData.componentId and resolvedData.componentId <= 100 then
        resolvedData.componentId = resolvedData.componentId + 100
    end
    
    return resolvedData
end