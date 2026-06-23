-- Default clothing configuration for male characters
local MALE_INVISIBLE_OUTFIT = {}
MALE_INVISIBLE_OUTFIT[0] = 45  -- Head (face)
MALE_INVISIBLE_OUTFIT[1] = {hash = 166057222, drawable = 0}    -- Mask
MALE_INVISIBLE_OUTFIT[2] = {hash = 137479525, drawable = 0}    -- Hair
MALE_INVISIBLE_OUTFIT[3] = {hash = -816754991, drawable = 13}  -- Torso
MALE_INVISIBLE_OUTFIT[4] = {hash = 308310148, drawable = 11}   -- Legs
MALE_INVISIBLE_OUTFIT[5] = {hash = 1925574525, drawable = 0}   -- Bags/Parachutes
MALE_INVISIBLE_OUTFIT[6] = {hash = 1572157304, drawable = 13}  -- Shoes
MALE_INVISIBLE_OUTFIT[7] = {hash = -1099335869, drawable = 0}  -- Accessories
MALE_INVISIBLE_OUTFIT[8] = {hash = -84053433, drawable = 15}   -- Undershirt
MALE_INVISIBLE_OUTFIT[9] = {hash = -1813973659, drawable = 0}  -- Body Armor
MALE_INVISIBLE_OUTFIT[10] = {hash = -1409690663, drawable = 0} -- Decals
MALE_INVISIBLE_OUTFIT[11] = {hash = -1845631030, drawable = 15} -- Tops

-- Default clothing configuration for female characters
local FEMALE_INVISIBLE_OUTFIT = {}
FEMALE_INVISIBLE_OUTFIT[0] = 45  -- Head (face)
FEMALE_INVISIBLE_OUTFIT[1] = {hash = -1890584569, drawable = 0}  -- Mask
FEMALE_INVISIBLE_OUTFIT[2] = {hash = -2079230364, drawable = 0}  -- Hair
FEMALE_INVISIBLE_OUTFIT[3] = {hash = 551818905, drawable = 8}    -- Torso
FEMALE_INVISIBLE_OUTFIT[4] = {hash = 1165574076, drawable = 13}  -- Legs
FEMALE_INVISIBLE_OUTFIT[5] = {hash = 1333836801, drawable = 0}   -- Bags/Parachutes
FEMALE_INVISIBLE_OUTFIT[6] = {hash = -529650958, drawable = 12}  -- Shoes
FEMALE_INVISIBLE_OUTFIT[7] = {hash = -151102289, drawable = 0}   -- Accessories
FEMALE_INVISIBLE_OUTFIT[8] = {hash = 1786656489, drawable = 2}   -- Undershirt
FEMALE_INVISIBLE_OUTFIT[9] = {hash = -1184316816, drawable = 0}  -- Body Armor
FEMALE_INVISIBLE_OUTFIT[10] = {hash = 1321565075, drawable = 0}  -- Decals
FEMALE_INVISIBLE_OUTFIT[11] = {hash = 779029149, drawable = 440} -- Tops

-- Prop slots to clear (accessories like hats, glasses, etc.)
local PROP_SLOTS_TO_CLEAR = {0, 1, 2, 6, 7}

-- Apply invisibility outfit to player based on their model
function InvisibilityMakeInvisible(playerModel)
    local playerPed = PlayerPedId()
    
    -- Clear all existing decorations/tattoos
    ClearPedDecorations(playerPed)
    
    -- Select outfit based on player model (female hash: -1667301416)
    local outfitConfig = MALE_INVISIBLE_OUTFIT
    if playerModel == -1667301416 then
        outfitConfig = FEMALE_INVISIBLE_OUTFIT
    end
    
    -- Apply clothing components (0-11)
    for componentSlot = 0, 11 do
        local componentData = outfitConfig[componentSlot]
        
        if type(componentData) == "table" then
            -- Handle hash-based clothing items
            local clothingData = UsableHashToData(playerPed, componentData.hash)
            SetPedComponentVariation(
                playerPed,
                clothingData.componentId,
                clothingData.drawableId,
                clothingData.textureId,
                0
            )
        else
            -- Handle direct drawable ID
            SetPedComponentVariation(
                playerPed,
                componentSlot,
                componentData,
                0,
                0
            )
        end
    end
    
    -- Clear all props (hats, glasses, etc.)
    for _, propSlot in pairs(PROP_SLOTS_TO_CLEAR) do
        ClearPedProp(playerPed, propSlot)
    end
    
    -- Set head blend to base appearance (skin tone 45, no mixing)
    SetPedHeadBlendData(
        playerPed,
        45,    -- skinFirst
        0,     -- skinSecond  
        0,     -- skinThird
        0,     -- faceFirst
        0,     -- faceSecond
        0,     -- faceThird
        0.0,   -- skinMix
        0.0,   -- faceMix
        0.0,   -- thirdMix
        true   -- isParent
    )
end