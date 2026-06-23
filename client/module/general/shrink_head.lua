-- Global state variables (preserved for cross-file compatibility)
local originalFaceFeatures = {}
local originalHeadBlendData = {}
local isHeadCurrentlyShrinked = false

-- Check if head is currently shrinked
function IsHeadShrinked()
    return isHeadCurrentlyShrinked
end

-- Get original face features before shrinking
function GetPreShrink()
    return originalFaceFeatures
end

-- Get original head blend data before shrinking
function GetPreShrinkHeadblend()
    return originalHeadBlendData
end

-- Apply head shrinking effect (resets face features to neutral)
function ShrinkHead(playerPed)
    if IsHeadShrinked() then
        return
    end
    
    -- Store original head blend data
    originalHeadBlendData = GetFormattedPedHeadblendData(playerPed)
    
    -- Store original face features (0-19 facial feature indices)
    for featureIndex = 0, 19 do
        originalFaceFeatures[featureIndex] = GetPedFaceFeature(playerPed, featureIndex)
    end
    
    -- Apply neutral head blend for freemode characters
    if IsPedFreemode(playerPed) then
        local playerModel = GetEntityModel(playerPed)
        local skinFirst = (playerModel == 1885233650) and 0 or 21  -- Male vs Female base skin
        
        SetPedHeadBlendData(
            playerPed,
            skinFirst,                        -- skinFirst
            0,                               -- skinSecond
            0,                               -- skinThird
            originalHeadBlendData[4],        -- faceFirst (preserve original)
            originalHeadBlendData[5],        -- faceSecond (preserve original)
            originalHeadBlendData[6],        -- faceThird (preserve original)
            0.0,                             -- skinMix (reset to neutral)
            originalHeadBlendData[8],        -- faceMix (preserve original)
            0.0,                             -- thirdMix (reset to neutral)
            false                            -- isParent
        )
    end
    
    -- Reset all face features to neutral (0.0)
    for featureIndex = 0, 19 do
        SetPedFaceFeature(playerPed, featureIndex, 0.0)
    end
    
    isHeadCurrentlyShrinked = true
end

-- Restore original head appearance
function UnshrinkHead(playerPed)
    if not IsHeadShrinked() then
        return
    end
    
    -- Restore original head blend data for freemode characters
    if IsPedFreemode(playerPed) then
        SetPedHeadBlendData(
            playerPed,
            originalHeadBlendData[1],        -- skinFirst
            originalHeadBlendData[2],        -- skinSecond
            originalHeadBlendData[3],        -- skinThird
            originalHeadBlendData[4],        -- faceFirst
            originalHeadBlendData[5],        -- faceSecond
            originalHeadBlendData[6],        -- faceThird
            originalHeadBlendData[7],        -- skinMix
            originalHeadBlendData[8],        -- faceMix
            originalHeadBlendData[9],        -- thirdMix
            false                            -- isParent
        )
    end
    
    -- Restore all original face features
    for featureIndex = 0, 19 do
        SetPedFaceFeature(playerPed, featureIndex, originalFaceFeatures[featureIndex])
    end
    
    -- Clear stored data and reset state
    originalFaceFeatures = {}
    isHeadCurrentlyShrinked = false
end

-- Check if current mask/clothing requires head shrinking
function ShouldHeadShrink(playerPed)
    local componentSlot = 1  -- Mask component slot
    local drawableId = GetPedDrawableVariation(playerPed, componentSlot)
    local textureId = GetPedTextureVariation(playerPed, componentSlot)
    
    local componentHash = GetHashNameForComponent(playerPed, componentSlot, drawableId, textureId)
    
    -- Check if the current mask has the "head shrink" restriction tag
    local hasRestrictionTag = DoesShopPedApparelHaveRestrictionTag(
        componentHash,
        -921710083,  -- Head shrink restriction tag hash
        componentSlot
    )
    
    return hasRestrictionTag
end

-- Monitor and apply head shrinking automatically
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        EnsureHeadShrink()
        Wait(500)  -- Check every 500ms
    end
end)

-- Ensure proper head shrink state based on current clothing
function EnsureHeadShrink()
    local playerPed = PlayerPedId()
    local shouldShrink = ShouldHeadShrink(playerPed)
    
    if shouldShrink then
        if not IsHeadShrinked() then
            ShrinkHead(playerPed)
        end
    elseif not shouldShrink then
        if IsHeadShrinked() then
            UnshrinkHead(playerPed)
        end
    end
end

-- Cleanup when resource stops
AddEventHandler("onResourceStop", function(resourceName)
    local currentResource = GetCurrentResourceName()
    if resourceName == currentResource then
        local playerPed = PlayerPedId()
        UnshrinkHead(playerPed)
    end
end)