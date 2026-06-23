local isBackdropActive = false
local backdropPositions = {}
local forcedBackdropColor = nil

function BackdropStop()
    isBackdropActive = false
end

function BackdropForceColor(colorData)
    forcedBackdropColor = colorData
end

function ResetBackdropColor()
    forcedBackdropColor = nil
end

function BackdropSetupForPed(pedEntity, backdropColor, enableMask)
    isBackdropActive = true
    
    -- Calculate backdrop positions around the ped
    backdropPositions.leftPos = GetOffsetFromEntityInWorldCoords(pedEntity, 1.0, -0.5, 0.0)
    backdropPositions.rightPos = GetOffsetFromEntityInWorldCoords(pedEntity, -1.0, -0.5, 0.0)
    backdropPositions.fwdRightPos = GetOffsetFromEntityInWorldCoords(pedEntity, -2.0, 1.5, 0.0)
    backdropPositions.fwdLeftPos = GetOffsetFromEntityInWorldCoords(pedEntity, 2.0, 1.5, 0.0)
    backdropPositions.fwdPos = GetOffsetFromEntityInWorldCoords(pedEntity, 0.0, 1.5, 0.0)
    backdropPositions.leftPosMirror = GetOffsetFromEntityInWorldCoords(pedEntity, 1.0, 3.5, 0.0)
    backdropPositions.rightPosMirror = GetOffsetFromEntityInWorldCoords(pedEntity, -1.0, 3.5, 0.0)
    
    -- Calculate mask positions (for face close-ups)
    local headBoneIndex = GetPedBoneIndex(pedEntity, 24818) -- Head bone
    local headPosition = GetWorldPositionOfEntityBone(pedEntity, headBoneIndex)
    local pedHeading = GetEntityHeading(pedEntity)
    
    backdropPositions.squareMaskStart = _ENV["GetOffsetFromCoordAndHeadingInWorldCoords"](
        headPosition, pedHeading, 0.04, 0.04, 0.03
    )
    backdropPositions.squareMaskEnd = _ENV["GetOffsetFromCoordAndHeadingInWorldCoords"](
        headPosition, pedHeading, -0.04, 0.04, -0.06
    )
    
    -- Start backdrop rendering thread
    Citizen.CreateThread(function()
        while isBackdropActive do
            Wait(0)
            
            -- Skip rendering if backdrop is disabled or specific conditions are met
            if Config.DisableShopBackdrop then
                if GetIsNuiOpen() and not GetIsImageDebugging() then
                    goto continue
                end
            end
            
            -- Determine backdrop color
            local currentColor = backdropColor
            if forcedBackdropColor then
                currentColor = forcedBackdropColor
            end
            
            local colorAdjustmentR = 0
            local colorAdjustmentG = 0
            
            -- Adjust color for free camera mode
            if IsClothingFreeCamControlled() then
                colorAdjustmentR = 0
                colorAdjustmentG = -20
            end
            
            -- Draw extended backdrop for white backgrounds (alpha 255)
            if currentColor[2] == 255 then
                DrawExtendedBackdrop(currentColor, colorAdjustmentR, colorAdjustmentG)
            end
            
            -- Draw main backdrop polygons
            DrawMainBackdrop(currentColor, colorAdjustmentR, colorAdjustmentG)
            
            -- Draw mask overlay if enabled
            if enableMask then
                DrawMaskOverlay(currentColor)
            end
            
            ::continue::
        end
    end)
end

function DrawExtendedBackdrop(color, adjustR, adjustG)
    local r = color[1] + adjustR
    local g = color[2] + adjustG
    local b = color[3]
    local a = color[4]
    
    -- Back wall polygons for extended backdrop
    DrawPoly(
        backdropPositions.leftPosMirror.x, backdropPositions.leftPosMirror.y, backdropPositions.leftPosMirror.z - 0.99,
        backdropPositions.leftPosMirror.x, backdropPositions.leftPosMirror.y, backdropPositions.leftPosMirror.z + 2.99,
        backdropPositions.rightPosMirror.x, backdropPositions.rightPosMirror.y, backdropPositions.rightPosMirror.z + 2.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.leftPosMirror.x, backdropPositions.leftPosMirror.y, backdropPositions.leftPosMirror.z - 0.99,
        backdropPositions.rightPosMirror.x, backdropPositions.rightPosMirror.y, backdropPositions.rightPosMirror.z + 2.99,
        backdropPositions.rightPosMirror.x, backdropPositions.rightPosMirror.y, backdropPositions.rightPosMirror.z - 0.99,
        r, g, b, a
    )
    
    -- Side walls for extended backdrop
    DrawPoly(
        backdropPositions.fwdLeftPos.x, backdropPositions.fwdLeftPos.y, backdropPositions.fwdLeftPos.z + 2.99,
        backdropPositions.leftPosMirror.x, backdropPositions.leftPosMirror.y, backdropPositions.leftPosMirror.z + 2.99,
        backdropPositions.leftPosMirror.x, backdropPositions.leftPosMirror.y, backdropPositions.leftPosMirror.z - 0.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.fwdLeftPos.x, backdropPositions.fwdLeftPos.y, backdropPositions.fwdLeftPos.z - 0.99,
        backdropPositions.fwdLeftPos.x, backdropPositions.fwdLeftPos.y, backdropPositions.fwdLeftPos.z + 2.99,
        backdropPositions.leftPosMirror.x, backdropPositions.leftPosMirror.y, backdropPositions.leftPosMirror.z - 0.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.rightPosMirror.x, backdropPositions.rightPosMirror.y, backdropPositions.rightPosMirror.z - 0.99,
        backdropPositions.rightPosMirror.x, backdropPositions.rightPosMirror.y, backdropPositions.rightPosMirror.z + 2.99,
        backdropPositions.fwdRightPos.x, backdropPositions.fwdRightPos.y, backdropPositions.fwdRightPos.z + 2.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.fwdRightPos.x, backdropPositions.fwdRightPos.y, backdropPositions.fwdRightPos.z - 0.99,
        backdropPositions.rightPosMirror.x, backdropPositions.rightPosMirror.y, backdropPositions.rightPosMirror.z - 0.99,
        backdropPositions.fwdRightPos.x, backdropPositions.fwdRightPos.y, backdropPositions.fwdRightPos.z + 2.99,
        r, g, b, a
    )
    
    -- Floor and ceiling for extended backdrop
    DrawPoly(
        backdropPositions.fwdPos.x, backdropPositions.fwdPos.y, backdropPositions.fwdPos.z - 0.99,
        backdropPositions.leftPosMirror.x, backdropPositions.leftPosMirror.y, backdropPositions.leftPosMirror.z - 0.99,
        backdropPositions.rightPosMirror.x, backdropPositions.rightPosMirror.y, backdropPositions.rightPosMirror.z - 0.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.fwdLeftPos.x, backdropPositions.fwdLeftPos.y, backdropPositions.fwdLeftPos.z - 0.99,
        backdropPositions.leftPosMirror.x, backdropPositions.leftPosMirror.y, backdropPositions.leftPosMirror.z - 0.99,
        backdropPositions.fwdPos.x, backdropPositions.fwdPos.y, backdropPositions.fwdPos.z - 0.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.fwdPos.x, backdropPositions.fwdPos.y, backdropPositions.fwdPos.z - 0.99,
        backdropPositions.rightPosMirror.x, backdropPositions.rightPosMirror.y, backdropPositions.rightPosMirror.z - 0.99,
        backdropPositions.fwdRightPos.x, backdropPositions.fwdRightPos.y, backdropPositions.fwdRightPos.z - 0.99,
        r, g, b, a
    )
end

function DrawMainBackdrop(color, adjustR, adjustG)
    local r = color[1] + adjustR
    local g = color[2] + adjustG
    local b = color[3]
    local a = color[4]
    
    -- Main backdrop walls
    DrawPoly(
        backdropPositions.leftPos.x, backdropPositions.leftPos.y, backdropPositions.leftPos.z + 2.99,
        backdropPositions.leftPos.x, backdropPositions.leftPos.y, backdropPositions.leftPos.z - 0.99,
        backdropPositions.rightPos.x, backdropPositions.rightPos.y, backdropPositions.rightPos.z + 2.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.rightPos.x, backdropPositions.rightPos.y, backdropPositions.rightPos.z + 2.99,
        backdropPositions.leftPos.x, backdropPositions.leftPos.y, backdropPositions.leftPos.z - 0.99,
        backdropPositions.rightPos.x, backdropPositions.rightPos.y, backdropPositions.rightPos.z - 0.99,
        r, g, b, a
    )
    
    -- Side walls
    DrawPoly(
        backdropPositions.leftPos.x, backdropPositions.leftPos.y, backdropPositions.leftPos.z + 2.99,
        backdropPositions.fwdLeftPos.x, backdropPositions.fwdLeftPos.y, backdropPositions.fwdLeftPos.z + 2.99,
        backdropPositions.leftPos.x, backdropPositions.leftPos.y, backdropPositions.leftPos.z - 0.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.fwdLeftPos.x, backdropPositions.fwdLeftPos.y, backdropPositions.fwdLeftPos.z + 2.99,
        backdropPositions.fwdLeftPos.x, backdropPositions.fwdLeftPos.y, backdropPositions.fwdLeftPos.z - 0.99,
        backdropPositions.leftPos.x, backdropPositions.leftPos.y, backdropPositions.leftPos.z - 0.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.rightPos.x, backdropPositions.rightPos.y, backdropPositions.rightPos.z + 2.99,
        backdropPositions.rightPos.x, backdropPositions.rightPos.y, backdropPositions.rightPos.z - 0.99,
        backdropPositions.fwdRightPos.x, backdropPositions.fwdRightPos.y, backdropPositions.fwdRightPos.z + 2.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.rightPos.x, backdropPositions.rightPos.y, backdropPositions.rightPos.z - 0.99,
        backdropPositions.fwdRightPos.x, backdropPositions.fwdRightPos.y, backdropPositions.fwdRightPos.z - 0.99,
        backdropPositions.fwdRightPos.x, backdropPositions.fwdRightPos.y, backdropPositions.fwdRightPos.z + 2.99,
        r, g, b, a
    )
    
    -- Floor
    DrawPoly(
        backdropPositions.leftPos.x, backdropPositions.leftPos.y, backdropPositions.leftPos.z - 0.99,
        backdropPositions.fwdPos.x, backdropPositions.fwdPos.y, backdropPositions.fwdPos.z - 0.99,
        backdropPositions.rightPos.x, backdropPositions.rightPos.y, backdropPositions.rightPos.z - 0.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.leftPos.x, backdropPositions.leftPos.y, backdropPositions.leftPos.z - 0.99,
        backdropPositions.fwdLeftPos.x, backdropPositions.fwdLeftPos.y, backdropPositions.fwdLeftPos.z - 0.99,
        backdropPositions.fwdPos.x, backdropPositions.fwdPos.y, backdropPositions.fwdPos.z - 0.99,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.rightPos.x, backdropPositions.rightPos.y, backdropPositions.rightPos.z - 0.99,
        backdropPositions.fwdPos.x, backdropPositions.fwdPos.y, backdropPositions.fwdPos.z - 0.99,
        backdropPositions.fwdRightPos.x, backdropPositions.fwdRightPos.y, backdropPositions.fwdRightPos.z - 0.99,
        r, g, b, a
    )
end

function DrawMaskOverlay(color)
    local r = color[1]
    local g = color[2]
    local b = color[3]
    local a = color[4]
    
    -- Draw mask overlay rectangles
    DrawPoly(
        backdropPositions.squareMaskStart.x, backdropPositions.squareMaskStart.y, backdropPositions.squareMaskStart.z,
        backdropPositions.squareMaskStart.x, backdropPositions.squareMaskStart.y, backdropPositions.squareMaskEnd.z,
        backdropPositions.squareMaskEnd.x, backdropPositions.squareMaskEnd.y, backdropPositions.squareMaskEnd.z,
        r, g, b, a
    )
    
    DrawPoly(
        backdropPositions.squareMaskEnd.x, backdropPositions.squareMaskEnd.y, backdropPositions.squareMaskEnd.z,
        backdropPositions.squareMaskEnd.x, backdropPositions.squareMaskEnd.y, backdropPositions.squareMaskStart.z,
        backdropPositions.squareMaskStart.x, backdropPositions.squareMaskStart.y, backdropPositions.squareMaskStart.z,
        r, g, b, a
    )
end