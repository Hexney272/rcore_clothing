-- Animation configuration for different clothing types
local CLOTHING_ANIMATIONS = {
    TOP = {
        components = {11, 3, 33, 10, 9, 5, 8},
        namespace = "clothingshirt",
        anims = {
            "try_shirt_positive_a",
            "try_shirt_positive_b", 
            "try_shirt_positive_c",
            "try_shirt_positive_d"
        }
    },
    BOTTOM = {
        components = {4},
        namespace = "clothingtrousers",
        anims = {
            "try_trousers_positive_a",
            "try_trousers_positive_b",
            "try_trousers_positive_c", 
            "try_trousers_positive_d"
        }
    },
    SHOES = {
        components = {6},
        namespace = "clothingshoes",
        anims = {
            "try_shoes_positive_a",
            "try_shoes_positive_b",
            "try_shoes_positive_c",
            "try_shoes_positive_d"
        }
    }
}

local isAnimationPlaying = false

-- Ped model constants
local MALE_PED_MODEL = -1667301416

function LoadAnimationDictionary(animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
end

function IsPedAnimationDisabled(pedHandle)
    local disabledPeds = ConfigPeds.DisableAnimForPeds
    if not disabledPeds then
        return false
    end
    
    local pedModel = GetEntityModel(pedHandle)
    
    for _, disabledPedName in pairs(disabledPeds) do
        local disabledPedHash = GetHashKey(disabledPedName)
        if pedModel == disabledPedHash then
            return true
        end
    end
    
    return false
end

function GetPedGenderPrefix(pedHandle)
    local pedModel = GetEntityModel(pedHandle)
    
    if pedModel == MALE_PED_MODEL then
        return "f"  -- Note: This appears to be inverted in the original code
    else
        return "m"
    end
end

function AnimSetPedStill(pedHandle, clearTasksFirst)
    if IsPedAnimationDisabled(pedHandle) then
        return
    end
    
    local genderPrefix = GetPedGenderPrefix(pedHandle)
    
    if clearTasksFirst then
        ClearPedTasksImmediately(pedHandle)
    end
    
    local animDict = "move_" .. genderPrefix .. "@generic"
    LoadAnimationDictionary(animDict)
    
    TaskPlayAnim(pedHandle, animDict, "idle", 1.0, -1.0, -1, 1, 1, true, true, true)
end

function AnimPlayPurchaseAnim(pedHandle, animationConfig)
    if isAnimationPlaying then
        return
    end
    
    local animNamespace = animationConfig.namespace
    local animsList = animationConfig.anims
    
    -- Select random animation from the list
    local randomIndex = math.random(1, #animsList)
    local selectedAnim = animsList[randomIndex]
    
    LoadAnimationDictionary(animNamespace)
    
    ClearPedTasks(pedHandle)
    TaskPlayAnim(pedHandle, animNamespace, selectedAnim, 1.0, -1.0, -1, 0, 1, true, true, true)
    
    isAnimationPlaying = true
    
    -- Get animation duration and set up auto-return to idle
    local animDuration = GetAnimDuration(animNamespace, selectedAnim)
    
    Citizen.CreateThread(function()
        Wait(animDuration * 1000)
        
        -- Only return to idle if NUI is still open
        if GetIsNuiOpen() then
            AnimSetPedStill(pedHandle)
        end
        
        isAnimationPlaying = false
    end)
end

function AnimResolveAndPlayPurchaseAnim(pedHandle, componentId)
    if IsPedAnimationDisabled(pedHandle) then
        return
    end
    
    -- Find which clothing type matches the component ID
    for clothingType, config in pairs(CLOTHING_ANIMATIONS) do
        for _, configComponentId in pairs(config.components) do
            if configComponentId == componentId then
                AnimPlayPurchaseAnim(pedHandle, config)
                return
            end
        end
    end
end