local L1_1 -- ⚠️ Global variable from outside this file - keeping as is

function parseOutfitData(rawData)
    local lockHash = string.unpack("<i4", rawData, 1)
    local hash = string.unpack("<i4", rawData, 9)
    local price = string.unpack("<i4", rawData, 17)
    local totalProps = string.unpack("<i4", rawData, 25)
    local totalComponents = string.unpack("<i4", rawData, 33)
    local unk2 = string.unpack("<i4", rawData, 41)
    local unk3 = string.unpack("<i4", rawData, 49)
    local label = string.unpack("z", rawData, 57)
    
    return {
        LockHash = lockHash,
        Hash = hash,
        Price = price,
        TotalProps = totalProps,
        TotalComponents = totalComponents,
        Unk2 = unk2,
        Unk3 = unk3,
        Label = label
    }
end
getQueryOutfit = parseOutfitData

function parseComponentData(rawData)
    local lockHash = string.unpack("<i4", rawData, 1)
    local hash = string.unpack("<i4", rawData, 9)
    local locate = string.unpack("<i4", rawData, 17)
    local drawable = string.unpack("<i4", rawData, 25)
    local texture = string.unpack("<i4", rawData, 33)
    local price = string.unpack("<i4", rawData, 41)
    local componentType = string.unpack("<i4", rawData, 49)
    local shopEnum = string.unpack("<i4", rawData, 57)
    local field8 = string.unpack("<i4", rawData, 65)
    local label = string.unpack("z", rawData, 73)
    
    return {
        LockHash = lockHash,
        Hash = hash,
        Locate = locate,
        Drawable = drawable,
        Texture = texture,
        Price = price,
        ComponentType = componentType,
        ShopEnum = shopEnum,
        f_8 = field8,
        Label = label
    }
end
getComponent = parseComponentData

function parseTattooData(rawData)
    local lockHash = string.unpack("<i4", rawData, 1)
    local id = string.unpack("<i4", rawData, 9)
    local collectionHash = string.unpack("<i4", rawData, 17)
    local nameHash = string.unpack("<i4", rawData, 25)
    local price = string.unpack("<i4", rawData, 33)
    local facing = string.unpack("<i4", rawData, 41)
    local updateGroup = string.unpack("<i4", rawData, 49)
    local label = string.unpack("z", rawData, 57)
    
    return {
        LockHash = lockHash,
        Id = id,
        CollectionHash = collectionHash,
        NameHash = nameHash,
        Price = price,
        Facing = facing,
        UpdateGroup = updateGroup,
        Label = label
    }
end
getTattoo = parseTattooData

function parseVariantData(rawData)
    local hash = string.unpack("<i4", rawData, 1)
    local enumValue = string.unpack("<i4", rawData, 9)
    local componentType = string.unpack("<i4", rawData, 17)
    
    return {
        Hash = hash,
        EnumValue = enumValue,
        ComponentType = componentType
    }
end
getVariant = parseVariantData

function createDataBuffer(size)
    return string.rep("\000\000\000\000\000\000\000\000", size)
end

function GetShopPedComponent(componentIndex)
    local dataBuffer = createDataBuffer(25)
    Citizen.InvokeNative(8412973304352499552, componentIndex, dataBuffer)
    return parseComponentData(dataBuffer)
end

function MyGetTattooShopDlcItemData(shopIndex, itemIndex)
    local dataBuffer = createDataBuffer(24)
    Citizen.InvokeNative(-47789068348022650, shopIndex, itemIndex, dataBuffer)
    return parseTattooData(dataBuffer)
end

function GetShopPedProp(propIndex)
    local dataBuffer = createDataBuffer(25)
    Citizen.InvokeNative(6727445416123430652, propIndex, dataBuffer)
    return parseComponentData(dataBuffer)
end

function GetShopPedQueryOutfits(outfitType)
    local outfitCount = SetupShopPedOutfitQuery(outfitType, false)
    if outfitCount == 0 then
        return false
    end
    
    local outfits = {}
    for outfitIndex = 0, outfitCount - 1 do
        local dataBuffer = createDataBuffer(23)
        Citizen.InvokeNative(7888405507221880406, outfitIndex, dataBuffer)
        local outfitData = parseOutfitData(dataBuffer)
        outfits[outfitIndex + 1] = outfitData
    end
    
    return outfits
end

function GetShopPedQueryOutfit(outfitIndex, outfitType)
    local outfitCount = SetupShopPedOutfitQuery(outfitType, false)
    if outfitCount == 0 then
        return false
    end
    
    local dataBuffer = createDataBuffer(23)
    Citizen.InvokeNative(7888405507221880406, outfitIndex, dataBuffer)
    return parseOutfitData(dataBuffer)
end

function GetShopPedOutfit(outfitHash)
    local dataBuffer = createDataBuffer(23)
    Citizen.InvokeNative(-5218228898230921315, outfitHash, dataBuffer)
    return parseOutfitData(dataBuffer)
end

function GetShopPedOutfitComponentVariant(outfitHash, componentIndex)
    local dataBuffer = createDataBuffer(19)
    Citizen.InvokeNative(1869732884373307711, outfitHash, componentIndex, dataBuffer)
    return parseVariantData(dataBuffer)
end

function GetShopPedOutfitPropVariant(outfitHash, propIndex)
    local dataBuffer = createDataBuffer(19)
    Citizen.InvokeNative(-6198709140510925637, outfitHash, propIndex, dataBuffer)
    return parseVariantData(dataBuffer)
end

function GetShopPedQueryComponent(queryIndex, gender, componentType)
    local dataBuffer = createDataBuffer(25)
    Citizen.InvokeNative(2201187712157007926, dataBuffer)
    
    local componentCount = SetupShopPedApparelQueryTu(componentType, 0, -1, 0, -1, gender)
    if queryIndex > componentCount then
        return false
    end
    
    Citizen.InvokeNative(2638600355764635289, queryIndex, dataBuffer)
    return parseComponentData(dataBuffer)
end

function GetShopPedQueryComponents(gender, componentType, specificHash)
    if specificHash == nil then
        specificHash = -1
    end
    
    local dataBuffer = createDataBuffer(25)
    Citizen.InvokeNative(2201187712157007926, dataBuffer)
    
    local componentCount = SetupShopPedApparelQueryTu(componentType, 0, specificHash, 0, -1, gender)
    if componentCount == 0 then
        return false
    end
    
    local components = {}
    for componentIndex = 0, componentCount - 1 do
        Citizen.InvokeNative(2638600355764635289, componentIndex, dataBuffer)
        local componentData = parseComponentData(dataBuffer)
        components[componentIndex + 1] = componentData
    end
    
    return components
end

function QueryGetComponentIndex(targetHash, componentType, gender)
    local dataBuffer = createDataBuffer(25)
    Citizen.InvokeNative(2201187712157007926, dataBuffer)
    
    local componentCount = SetupShopPedApparelQueryTu(componentType, 0, -1, 0, -1, gender)
    if componentCount == 0 then
        return -1
    end
    
    for componentIndex = 0, componentCount - 1 do
        Citizen.InvokeNative(2638600355764635289, componentIndex, dataBuffer)
        local componentData = parseComponentData(dataBuffer)
        if componentData.Hash == targetHash then
            return componentIndex
        end
    end
    
    return -1
end

function GetShopPedQueryProp(propIndex, propType)
    local dataBuffer = createDataBuffer(25)
    Citizen.InvokeNative(2201187712157007926, dataBuffer)
    
    local propCount = SetupShopPedApparelQueryTu(propType, 0, -1, 1, -1, -1)
    if propIndex > propCount then
        return false
    end
    
    Citizen.InvokeNative(-2430641935779462275, propIndex, dataBuffer)
    return parseComponentData(dataBuffer)
end

function GetShopPedQueryProps(propType)
    local dataBuffer = createDataBuffer(25)
    Citizen.InvokeNative(2201187712157007926, dataBuffer)
    
    local propCount = SetupShopPedApparelQueryTu(propType, 0, -1, 1, -1, -1)
    if propCount == 0 then
        return false
    end
    
    local props = {}
    for propIndex = 0, propCount - 1 do
        Citizen.InvokeNative(-2430641935779462275, propIndex, dataBuffer)
        local propData = parseComponentData(dataBuffer)
        props[propIndex + 1] = propData
    end
    
    return props
end

function QueryGetPropIndex(targetHash, propType)
    local dataBuffer = createDataBuffer(25)
    Citizen.InvokeNative(2201187712157007926, dataBuffer)
    
    local propCount = SetupShopPedApparelQueryTu(propType, 0, -1, 1, -1, -1)
    if propCount == 0 then
        return -1
    end
    
    for propIndex = 0, propCount - 1 do
        Citizen.InvokeNative(-2430641935779462275, propIndex, dataBuffer)
        local propData = parseComponentData(dataBuffer)
        if propData.Hash == targetHash then
            return propIndex
        end
    end
    
    return -1
end

function tprint(data, indentLevel)
    if not indentLevel then
        indentLevel = 0
    end
    
    if type(data) == "table" then
        for key, value in pairs(data) do
            local formatting = string.rep("  ", indentLevel) .. key .. ": "
            
            if type(value) == "table" then
                print(formatting)
                tprint(value, indentLevel + 1)
            elseif type(value) == "boolean" then
                print(formatting .. tostring(value))
            else
                print(formatting .. value)
            end
        end
    else
        print(data)
    end
end