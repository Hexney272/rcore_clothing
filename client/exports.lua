function SetPedSkin(pedEntity, skinData, additionalOptions)
    if IsEntityAPed(pedEntity) then
        if skinData.skin and type(skinData.skin) == "table" then
            skinData = skinData.skin
        end
        
        ApplyPedClothing(pedEntity, skinData, additionalOptions)
    else
        print("ERROR: Entity is not a ped")
    end
end

function GetPlayerSkin()
    return GetCurrentOutfit()
end

function GetPlayerClothing()
    local currentOutfit = GetPlayerSkin()
    local clothingData = {}
    
    if currentOutfit and currentOutfit.skin then
        clothingData = {
            components = currentOutfit.skin.components,
            props = currentOutfit.skin.props
        }
    end
    
    -- Remove head and hair components (0 and 2) for clothing-only data
    if clothingData.components then
        clothingData.components["0"] = nil
        clothingData.components["2"] = nil
    end
    
    return clothingData
end

function SetPlayerSkin(skinData, additionalOptions)
    ApplyPlayerClothingOnSpawn(skinData.ped_model, skinData.skin, additionalOptions)
end

function GetSkinchangerSkin()
    return PedToSkinchanger()
end

function GetPedList()
    return {
        "mp_m_freemode_01",
        "mp_f_freemode_01"
    }
end

function SetPedComponent(pedEntity, componentData)
    if not componentData then
        return
    end
    
    if IsPedFreemode(pedEntity) then
        -- Skip head (0) and hair (2) components for freemode peds
        if componentData.component_id == 0 or componentData.component_id == 2 then
            return
        end
    end
    
    SetPedComponentVariation(
        pedEntity,
        componentData.component_id,
        componentData.drawable,
        componentData.texture,
        0
    )
end

function SetPedProp(pedEntity, propData)
    if not propData then
        return
    end
    
    if propData.drawable == -1 then
        ClearPedProp(pedEntity, propData.prop_id)
    else
        SetPedPropIndex(
            pedEntity,
            propData.prop_id,
            propData.drawable,
            propData.texture,
            false
        )
    end
end

function SetClothingByHash(pedEntity, nameHash)
    ApplyPedClothingItem(pedEntity, {
        name_hash = nameHash
    })
end

-- Export all functions for external resource access
exports("getSkinByIdentifier", function(playerIdentifier)
    return GetSkinByIdentifier(playerIdentifier)
end)

exports("getPlayerSkin", GetPlayerSkin)
exports("setPedSkin", SetPedSkin)
exports("setPlayerSkin", SetPlayerSkin)
exports("getSkinchangerSkin", GetSkinchangerSkin)
exports("getPlayerClothing", GetPlayerClothing)
exports("GetPedList", GetPedList)
exports("setPedComponent", SetPedComponent)
exports("setPedProp", SetPedProp)
exports("setClothingByHash", SetClothingByHash)
exports("fixArms", FixArmsForCurrentTop)