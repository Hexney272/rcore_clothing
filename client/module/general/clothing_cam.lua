-- Global variables (preserved for cross-file compatibility)
local currentCamera = nil
local currentZoomLevel = 0.0
local currentVerticalScroll = 0.0
local currentCameraComponent = nil

-- Camera offset configurations for different clothing components
local CLOTHING_CAMERA_OFFSETS = {}

-- Base camera offsets for processing/preview mode
CLOTHING_CAMERA_OFFSETS[1] = {
    camOffset = vector3(-0.1, 0.8, 0.6),
    lookAtOffset = vector3(0.0, 0.0, 0.7)
}
CLOTHING_CAMERA_OFFSETS[2] = {
    camOffset = vector3(0.2, 0.4, 0.8),
    lookAtOffset = vector3(0.0, 0.0, 0.7)
}
CLOTHING_CAMERA_OFFSETS[3] = {
    camOffset = vector3(0.4, 1.2, 0.2),
    lookAtOffset = vector3(0.0, 0.0, 0.1)
}
CLOTHING_CAMERA_OFFSETS[4] = {
    camOffset = vector3(0.4, 1.2, -0.1),
    lookAtOffset = vector3(0.0, 0.0, -0.4)
}
CLOTHING_CAMERA_OFFSETS[5] = {
    camOffset = vector3(0.4, 1.2, 0.5),
    lookAtOffset = vector3(0.0, 0.0, 0.4)
}
CLOTHING_CAMERA_OFFSETS[6] = {
    camOffset = vector3(0.3, 0.7, -0.6),
    lookAtOffset = vector3(0.0, 0.0, -0.9)
}
CLOTHING_CAMERA_OFFSETS[7] = {
    camOffset = vector3(0.4, 5.2, 0.6),
    lookAtOffset = vector3(0.0, 0.0, 0.3)
}
CLOTHING_CAMERA_OFFSETS[8] = {
    camOffset = vector3(0.4, 1.2, 0.6),
    lookAtOffset = vector3(0.0, 0.0, 0.3)
}
CLOTHING_CAMERA_OFFSETS[9] = {
    camOffset = vector3(0.4, 1.2, 0.6),
    lookAtOffset = vector3(0.0, 0.0, 0.3)
}
CLOTHING_CAMERA_OFFSETS[10] = {
    camOffset = vector3(0.4, 2.2, 0.6),
    lookAtOffset = vector3(0.0, 0.0, 0.3)
}
CLOTHING_CAMERA_OFFSETS[11] = {
    camOffset = vector3(0.0, 2.0, 0.6),
    lookAtOffset = vector3(0.0, 0.0, 0.3)
}
CLOTHING_CAMERA_OFFSETS[100] = {
    camOffset = vector3(0.45, 0.5, 1.1),
    lookAtOffset = vector3(0.0, 0.0, 0.8)
}
CLOTHING_CAMERA_OFFSETS[101] = {
    camOffset = vector3(0.1, 0.4, 0.8),
    lookAtOffset = vector3(0.0, 0.0, 0.7)
}
CLOTHING_CAMERA_OFFSETS[102] = {
    camOffset = vector3(0.25, 0.09, 0.65),
    lookAtOffset = vector3(0.0, 0.0, 0.65)
}
CLOTHING_CAMERA_OFFSETS[106] = {
    camOffset = vector3(-0.5, 0.3, 0.1),
    lookAtOffset = vector3(0.0, -0.3, 0.0)
}
CLOTHING_CAMERA_OFFSETS[107] = {
    camOffset = vector3(0.5, 0.15, -0.1),
    lookAtOffset = vector3(0.0, -0.3, 0.1)
}
CLOTHING_CAMERA_OFFSETS[888] = {
    camOffset = vector3(0.0, 3.0, 0.4),
    lookAtOffset = vector3(0.0, 0.0, 0.2)
}
CLOTHING_CAMERA_OFFSETS[999] = {
    camOffset = vector3(0.0, 0.4, 0.7),
    lookAtOffset = vector3(0.0, 0.0, 0.7)
}

-- Global table for processing mode (preserved for external access)
CAM_OFFSETS_PROCESSING = CLOTHING_CAMERA_OFFSETS

-- Camera offset adjustments for clothing shop mode (with bone tracking)
local rightHandOffset = vector3(0.5, 0.0, 0.0)
local CLOTHING_SHOP_CAMERA_OFFSETS = {}

CLOTHING_SHOP_CAMERA_OFFSETS[1] = {
    camOffset = vector3(-0.4, 0.8, 0.6) + rightHandOffset,
    lookAtOffset = vector3(-0.3, 0.0, 0.7) + rightHandOffset,
    bone = "BONETAG_HEAD",
    maxZoomMult = 0.5
}
CLOTHING_SHOP_CAMERA_OFFSETS[2] = {
    camOffset = vector3(0.2, 0.4, 0.8),
    lookAtOffset = vector3(0.0, 0.0, 0.7),
    bone = "BONETAG_HEAD"
}
CLOTHING_SHOP_CAMERA_OFFSETS[3] = {
    camOffset = vector3(0.4, 1.2, 0.2) + rightHandOffset,
    lookAtOffset = vector3(0.0, 0.0, 0.1) + rightHandOffset,
    bone = "BONETAG_SPINE3",
    maxZoomMult = 0.35
}
CLOTHING_SHOP_CAMERA_OFFSETS[33] = {
    camOffset = vector3(0.4, 1.2, 0.2) + rightHandOffset,
    lookAtOffset = vector3(0.0, 0.0, 0.1) + rightHandOffset,
    bone = "BONETAG_R_HAND",
    maxZoomMult = 0.35
}
CLOTHING_SHOP_CAMERA_OFFSETS[4] = {
    camOffset = vector3(0.4, 1.2, -0.1) + rightHandOffset,
    lookAtOffset = vector3(0.0, 0.0, -0.4) + rightHandOffset,
    bone = "BONETAG_R_CALF",
    maxZoomMult = 0.4
}
CLOTHING_SHOP_CAMERA_OFFSETS[5] = {
    camOffset = vector3(0.4, 0.9, 0.5) + rightHandOffset,
    lookAtOffset = vector3(0.0, 0.0, 0.4) + rightHandOffset,
    bone = "BONETAG_SPINE3",
    maxZoomMult = 0.45
}
CLOTHING_SHOP_CAMERA_OFFSETS[6] = {
    camOffset = vector3(0.3, 0.7, -0.6) + rightHandOffset,
    lookAtOffset = vector3(0.0, 0.0, -0.9) + rightHandOffset,
    bone = "BONETAG_R_FOOT",
    maxZoomMult = 0.45
}
CLOTHING_SHOP_CAMERA_OFFSETS[7] = {
    camOffset = vector3(-0.4, 0.8, 0.6) + rightHandOffset,
    lookAtOffset = vector3(-0.3, 0.0, 0.7) + rightHandOffset,
    bone = "BONETAG_NECK",
    maxZoomMult = 0.5
}
CLOTHING_SHOP_CAMERA_OFFSETS[8] = {
    camOffset = vector3(0.0, 1.5, 0.6) + rightHandOffset,
    lookAtOffset = vector3(0.0, 0.0, 0.3) + rightHandOffset,
    bone = "BONETAG_SPINE3",
    maxZoomMult = 0.3
}
CLOTHING_SHOP_CAMERA_OFFSETS[9] = {
    camOffset = vector3(0.4, 1.2, 0.6) + rightHandOffset,
    lookAtOffset = vector3(0.0, 0.0, 0.3) + rightHandOffset,
    bone = "BONETAG_SPINE3",
    maxZoomMult = 0.4
}
CLOTHING_SHOP_CAMERA_OFFSETS[10] = {
    camOffset = vector3(0.4, 2.2, 0.6) + rightHandOffset,
    lookAtOffset = vector3(0.0, 0.0, 0.3) + rightHandOffset,
    bone = "BONETAG_SPINE3"
}
CLOTHING_SHOP_CAMERA_OFFSETS[11] = {
    camOffset = vector3(0.0, 2.0, 0.6) + rightHandOffset,
    lookAtOffset = vector3(0.0, 0.0, 0.3) + rightHandOffset,
    bone = "BONETAG_SPINE3"
}
CLOTHING_SHOP_CAMERA_OFFSETS[100] = {
    camOffset = vector3(-0.25, 0.7, 0.9) + rightHandOffset,
    lookAtOffset = vector3(-0.25, 0.0, 0.8) + rightHandOffset,
    bone = "BONETAG_HEAD",
    maxZoomMult = 0.5
}
CLOTHING_SHOP_CAMERA_OFFSETS[101] = {
    camOffset = vector3(-0.4, 0.5, 0.8) + rightHandOffset,
    lookAtOffset = vector3(-0.4, 0.0, 0.7) + rightHandOffset,
    bone = "BONETAG_HEAD",
    maxZoomMult = 0.7
}
CLOTHING_SHOP_CAMERA_OFFSETS[102] = {
    camOffset = vector3(-0.25, 0.7, 0.9) + rightHandOffset,
    lookAtOffset = vector3(-0.25, 0.0, 0.8) + rightHandOffset,
    bone = "BONETAG_HEAD",
    maxZoomMult = 0.5
}
CLOTHING_SHOP_CAMERA_OFFSETS[106] = {
    camOffset = vector3(-1.0, 1.0, 0.1),
    lookAtOffset = vector3(0.0, 0.5, 0.0),
    bone = "BONETAG_L_HAND",
    maxZoomMult = 0.4
}
CLOTHING_SHOP_CAMERA_OFFSETS[107] = {
    camOffset = vector3(1.0, 0.6, -0.1),
    lookAtOffset = vector3(0.0, -0.7, 0.1),
    bone = "BONETAG_R_HAND",
    maxZoomMult = 0.4
}
CLOTHING_SHOP_CAMERA_OFFSETS[518] = {
    camOffset = vector3(0.0, 0.45, 0.7),
    lookAtOffset = vector3(0.2, 0.0, 0.7),
    bone = "BONETAG_HEAD",
    maxZoomMult = 0.73
}

-- Global tables (preserved for external access)
CAM_OFFSETS_CLOTHING_SHOP = CLOTHING_SHOP_CAMERA_OFFSETS
CAM_OFFSETS_PROCESSING_SHOP = {}

-- Create processing shop offsets by copying processing offsets and applying right hand offset adjustments
for componentId, offsetData in pairs(CAM_OFFSETS_PROCESSING) do
    CAM_OFFSETS_PROCESSING_SHOP[componentId] = {
        camOffset = offsetData.camOffset,
        lookAtOffset = offsetData.lookAtOffset
    }
    
    -- Apply right hand offset for components <= 102
    if componentId <= 102 then
        CAM_OFFSETS_PROCESSING_SHOP[componentId].camOffset = CAM_OFFSETS_PROCESSING_SHOP[componentId].camOffset + rightHandOffset
        CAM_OFFSETS_PROCESSING_SHOP[componentId].lookAtOffset = CAM_OFFSETS_PROCESSING_SHOP[componentId].lookAtOffset + rightHandOffset
    end
end

-- Pre-compute camera positions relative to entity for performance
function ClothingCacheOffsets(playerEntity, offsetTable)
    for componentId, offsetData in pairs(offsetTable) do
        offsetData.precomputedCamPos = GetOffsetFromEntityInWorldCoords(playerEntity, offsetData.camOffset)
        offsetData.precomputedCamLookAt = GetOffsetFromEntityInWorldCoords(playerEntity, offsetData.lookAtOffset)
    end
end

-- Initialize clothing camera system
function ClothingCamSetup(playerEntity, offsetTable, componentId)
    currentCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(currentCamera, 70.0)
    
    -- Pre-compute all camera positions for performance
    ClothingCacheOffsets(playerEntity, CAM_OFFSETS_PROCESSING)
    ClothingCacheOffsets(playerEntity, CAM_OFFSETS_CLOTHING_SHOP)
    ClothingCacheOffsets(playerEntity, CAM_OFFSETS_PROCESSING_SHOP)
    
    ClothingCamSetComponent(playerEntity, offsetTable, componentId)
    currentCameraComponent = componentId
    
    RenderScriptCams(true, false, 0, true, true)
end

-- Set camera to specific clothing component
function ClothingCamSetComponent(playerEntity, offsetTable, componentId)
    local camPos = offsetTable[componentId].precomputedCamPos
    local lookAtPos = offsetTable[componentId].precomputedCamLookAt
    
    currentCameraComponent = componentId
    ResetCamScrollZoom()
    
    SetCamCoord(currentCamera, camPos)
    PointCamAtCoord(currentCamera, lookAtPos)
end

-- Reset camera zoom and scroll to default
function ResetCamScrollZoom()
    currentZoomLevel = 0.0
    currentVerticalScroll = 0.0
end

-- Smoothly transition camera between clothing components
function ClothingCamTransitionToComponent(playerEntity, offsetTable, componentId)
    if not currentCamera then
        return
    end
    
    -- Default to component 11 if invalid component specified
    if componentId == -1 then
        componentId = 11
    end
    
    local targetOffsets = offsetTable[componentId]
    currentCameraComponent = componentId
    ResetCamScrollZoom()
    
    if not targetOffsets then
        return
    end
    
    local targetCamPos = targetOffsets.precomputedCamPos
    local targetLookAtPos = targetOffsets.precomputedCamLookAt
    
    -- Create temporary camera for smooth transition
    local newCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(newCamera, 70.0)
    SetCamCoord(newCamera, targetCamPos)
    PointCamAtCoord(newCamera, targetLookAtPos)
    
    -- Interpolate between cameras
    SetCamActiveWithInterp(newCamera, currentCamera, 300, 1, 1)
    local oldCamera = currentCamera
    
    -- Wait for interpolation to complete and cleanup
    Citizen.CreateThread(function()
        while IsCamInterpolating(oldCamera) or IsCamInterpolating(newCamera) do
            Wait(0)
        end
        DestroyCam(oldCamera)
    end)
    
    currentCamera = newCamera
end

-- Stop and cleanup camera system
function ClothingCamStop()
    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(currentCamera, false)
    currentCamera = nil
end

-- Smoothly rotate entity to target heading
function AnimateEntityRotation(targetHeading)
    local playerPed = PlayerPedId()
    local currentHeading = GetEntityHeading(playerPed)
    local headingDifference = currentHeading - targetHeading
    
    -- Normalize heading difference to [-180, 180]
    if headingDifference > 180 then
        headingDifference = headingDifference - 360
    elseif headingDifference < -180 then
        headingDifference = headingDifference + 360
    end
    
    local rotationStep = headingDifference / 10
    local newHeading = currentHeading - rotationStep
    
    -- Animate rotation over 10 frames
    for i = 1, 10 do
        Wait(0)
        SetEntityHeading(playerPed, newHeading)
        newHeading = newHeading - rotationStep
    end
end

-- Get current camera zoom level
function CamGetZoom()
    return currentZoomLevel
end

-- Set camera zoom level (0.0 to 1.0)
function CamSetZoom(playerEntity, zoomLevel)
    currentZoomLevel = math.max(0, math.min(1, zoomLevel))
    ReadjustCamZoom(currentCameraComponent)
end

-- Calculate zoom step size based on component's max zoom multiplier
function GetZoomStep(componentId)
    componentId = currentCameraComponent
    local maxZoomMult = 0.2
    
    local componentData = CAM_OFFSETS_CLOTHING_SHOP[componentId]
    if componentData and componentData.maxZoomMult then
        maxZoomMult = componentData.maxZoomMult
    end
    
    local zoomRange = (1 - maxZoomMult) * 10
    return 0.7 / zoomRange
end

-- Adjust camera position based on current zoom and scroll
function ReadjustCamZoom(componentId)
    local playerPed = PlayerPedId()
    local componentData = CAM_OFFSETS_CLOTHING_SHOP[componentId]
    local boneName = componentData.bone
    local boneIndex = GetEntityBoneIndexByName(playerPed, boneName)
    local boneWorldPos = GetWorldPositionOfEntityBone(playerPed, boneIndex)
    
    -- Get max zoom multiplier for this component
    local maxZoomMult = 0.2
    if componentData.maxZoomMult then
        maxZoomMult = componentData.maxZoomMult
    end
    
    local baseCamPos = componentData.precomputedCamPos
    local baseLookAtPos = componentData.precomputedCamLookAt
    
    -- Calculate zoom positions relative to bone
    local lookAtOffset = baseLookAtPos - boneWorldPos
    local camOffset = baseCamPos - boneWorldPos
    local zoomedCamPos = boneWorldPos + (camOffset * maxZoomMult)
    local zoomedLookAtPos = boneWorldPos + (lookAtOffset * maxZoomMult)
    
    -- Interpolate between base and zoomed positions
    local lerpedCamPos = LerpVectors(baseCamPos, zoomedCamPos, currentZoomLevel)
    local lerpedLookAtPos = LerpVectors(baseLookAtPos, zoomedLookAtPos, currentZoomLevel)
    
    -- Apply vertical scroll
    local verticalScrollOffset = vector3(0, 0, GetCamVerticalScroll())
    local finalCamPos = lerpedCamPos + verticalScrollOffset
    local finalCamLookAt = lerpedLookAtPos + verticalScrollOffset
    
    -- Enforce vertical scroll limits
    local maxScrollZ = GetMaxScrollZ()
    local minScrollZ = GetMinScrollZ()
    
    if finalCamPos.z > maxScrollZ then
        currentVerticalScroll = currentVerticalScroll + (maxScrollZ - finalCamPos.z) - 0.005
        verticalScrollOffset = vector3(0, 0, GetCamVerticalScroll())
        finalCamPos = lerpedCamPos + verticalScrollOffset
        finalCamLookAt = lerpedLookAtPos + verticalScrollOffset
    end
    
    if finalCamPos.z < minScrollZ then
        currentVerticalScroll = currentVerticalScroll + (minScrollZ - finalCamPos.z) + 0.005
        verticalScrollOffset = vector3(0, 0, GetCamVerticalScroll())
        finalCamPos = lerpedCamPos + verticalScrollOffset
        finalCamLookAt = lerpedLookAtPos + verticalScrollOffset
    end
    
    -- Adjust camera position to avoid collisions
    local adjustedCamPos = GetRaycastAdjustedFinalPos(finalCamPos, finalCamLookAt)
    
    SetCamCoord(currentCamera, adjustedCamPos)
    PointCamAtCoord(currentCamera, finalCamLookAt)
    
    return true
end

-- Check for collisions and adjust camera position
function GetRaycastAdjustedFinalPos(camPos, lookAtPos)
    local playerPed = PlayerPedId()
    
    -- Raycast slightly above and below the intended position
    local upwardRaycast = _ENV["StartExpensiveSynchronousShapeTestLosProbe"](
        lookAtPos,
        camPos + vector3(0.0, 0.0, 0.1),
        -1,
        playerPed,
        4
    )
    
    local downwardRaycast = _ENV["StartExpensiveSynchronousShapeTestLosProbe"](
        lookAtPos,
        camPos - vector3(0.0, 0.0, 0.1),
        -1,
        playerPed,
        4
    )
    
    local _, upwardHit, upwardHitPos = GetShapeTestResult(upwardRaycast)
    local _, downwardHit, downwardHitPos = GetShapeTestResult(downwardRaycast)
    
    -- Return adjusted position if collision detected
    if upwardHit == 1 then
        return upwardHitPos
    end
    if downwardHit == 1 then
        return downwardHitPos
    end
    
    return camPos
end

-- Get maximum vertical scroll position (head level)
function GetMaxScrollZ()
    local playerPed = PlayerPedId()
    local headBoneIndex = GetEntityBoneIndexByName(playerPed, "BONETAG_HEAD")
    local headBonePos = GetWorldPositionOfEntityBone(playerPed, headBoneIndex)
    return headBonePos.z + 0.1
end

-- Get minimum vertical scroll position (foot level)
function GetMinScrollZ()
    local playerPed = PlayerPedId()
    local footBoneIndex = GetEntityBoneIndexByName(playerPed, "BONETAG_R_FOOT")
    local footBonePos = GetWorldPositionOfEntityBone(playerPed, footBoneIndex)
    return footBonePos.z + 0.1
end

-- Get screen center Z coordinate for vertical scroll reference
function GetScreenCenterIshZ()
    local screenCenterCoord = GetWorldCoordFromScreenCoord(0.5, 0.5)
    return screenCenterCoord.z
end

-- Linear interpolation between two vectors
function LerpVectors(vectorA, vectorB, lerpFactor)
    local difference = vectorB - vectorA
    return vectorA + (difference * lerpFactor)
end

-- Get current vertical scroll value
function GetCamVerticalScroll()
    return currentVerticalScroll
end

-- Set vertical scroll and readjust camera
function CamSetVerticalScroll(playerEntity, scrollValue)
    currentVerticalScroll = scrollValue
    ReadjustCamZoom(currentCameraComponent)
end