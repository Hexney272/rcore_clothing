-- Global state variables (preserved for cross-file compatibility)
local isFreeCamActive = false
local freeCamObject = nil
local pendingCameraPosition = nil
local pendingCameraRotation = nil
local isControlThreadActive = false

-- Initialize free camera with specific position and rotation
function SetupFreeCameraPosition(camera, playerPed, offsetTable, componentId)
    ClothingCacheOffsets(playerPed, offsetTable)
    
    local camPosition = offsetTable[componentId].precomputedCamPos
    local lookAtPosition = offsetTable[componentId].precomputedCamLookAt
    
    SetCamCoord(camera, camPosition)
    SetCamRot(camera, vector3(-8.0, 0.0, 90.0))
end

-- Check if control is pressed (handles both normal and disabled controls)
function IsControlActive(controlId)
    local isPressed = IsControlPressed(0, controlId)
    if not isPressed then
        isPressed = IsDisabledControlPressed(0, controlId)
    end
    return isPressed
end

-- Get control input value (combines normal and disabled control values)
function GetControlValue(controlId)
    local normalValue = GetControlNormal(0, controlId)
    local disabledValue = GetDisabledControlNormal(0, controlId)
    return normalValue + disabledValue
end

-- Handle free camera movement and controls
function HandleFreeCameraControls(camera, movementSpeed, mouseSpeed)
    DisableAllControlActions(0)
    
    local frameTime = GetFrameTime()
    local slowModeMultiplier = 0.2
    local fastModeMultiplier = 0.8
    
    local horizontalSpeed = frameTime * movementSpeed
    local verticalSpeed = frameTime * movementSpeed * fastModeMultiplier
    
    -- Mouse look input
    local mouseX = GetControlValue(1) * frameTime * mouseSpeed
    local mouseY = GetControlValue(2) * frameTime * mouseSpeed
    
    -- Camera settings
    SetCamNearClip(camera, 0.0)
    SetCamNearDof(camera, 0.0)
    
    -- Get current camera rotation and apply mouse input
    local currentRotation = GetCamRot(camera, 2)
    SetCamRot(camera, 
        math.max(-70.0, math.min(70.0, currentRotation.x - mouseY)),
        0.0,
        currentRotation.z - mouseX,
        2
    )
    
    -- Get camera matrix for movement calculations
    local rightVector, forwardVector, upVector, position = GetCamMatrix(camera)
    
    -- Apply slow mode if shift is held
    if IsControlActive(21) then  -- Left Shift
        horizontalSpeed = horizontalSpeed * slowModeMultiplier
        verticalSpeed = verticalSpeed * slowModeMultiplier
    end
    
    -- Forward movement (W key or controller)
    if IsControlActive(32) or IsControlActive(87) then
        local forwardMovement = forwardVector * horizontalSpeed
        position = vector3(
            position.x + forwardMovement.x,
            position.y + forwardMovement.y,
            position.z + forwardMovement.z
        )
    end
    
    -- Backward movement (S key or controller)
    if IsControlActive(33) or IsControlActive(88) then
        local backwardMovement = forwardVector * horizontalSpeed
        position = vector3(
            position.x - backwardMovement.x,
            position.y - backwardMovement.y,
            position.z - backwardMovement.z
        )
    end
    
    -- Left movement (A key or controller)
    if IsControlActive(34) or IsControlActive(89) then
        local leftMovement = rightVector * verticalSpeed
        position = vector3(
            position.x - leftMovement.x,
            position.y - leftMovement.y,
            position.z - leftMovement.z
        )
    end
    
    -- Right movement (D key or controller)
    if IsControlActive(35) or IsControlActive(90) then
        local rightMovement = rightVector * verticalSpeed
        position = vector3(
            position.x + rightMovement.x,
            position.y + rightMovement.y,
            position.z + rightMovement.z
        )
    end
    
    -- Apply pending camera position/rotation if set (from preset loading)
    if pendingCameraPosition then
        SetCamCoord(camera, pendingCameraPosition.x, pendingCameraPosition.y, pendingCameraPosition.z)
        SetCamRot(camera, pendingCameraRotation.x, pendingCameraRotation.y, pendingCameraRotation.z, 2)
        pendingCameraPosition = nil
        pendingCameraRotation = nil
    else
        SetCamCoord(camera, position.x, position.y, position.z)
    end
end

-- Display text on screen with right alignment
function DisplayRightAlignedText(x, y, text)
    SetTextFont(0)
    SetTextColour(255, 255, 255, 255)
    SetTextScale(0.5, 0.5)
    SetTextDropShadow()
    SetTextRightJustify(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(tostring(text))
    EndTextCommandDisplayText(x, y)
end

-- Start free camera system
function ClothingSetupFreeCam(playerEntity, offsetTable, componentId)
    local playerPed = PlayerPedId()
    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    
    SetCamFov(camera, 50.0)
    SetupFreeCameraPosition(camera, playerPed, offsetTable, componentId)
    
    RenderScriptCams(true, false, false, 0, 0)
    
    isFreeCamActive = true
    freeCamObject = camera
end

-- Main control loop for free camera
function ClothingControlFreeCam()
    local movementSpeed = 1
    local mouseSpeed = 400
    isControlThreadActive = true
    
    while isFreeCamActive do
        Wait(0)
        
        -- Display control instructions
        DisplayRightAlignedText(0.1, 0.37, "[WSAD | MOUSE] Move")
        DisplayRightAlignedText(0.1, 0.4, "[SPACE] Take picture")
        DisplayRightAlignedText(0.1, 0.43, "[SHIFT] Hold for slow cam")
        DisplayRightAlignedText(0.1, 0.46, "[/rcp_save name] Save preset")
        DisplayRightAlignedText(0.1, 0.49, "[/rcp_load name] Load preset")
        DisplayRightAlignedText(0.1, 0.52, "[/rcp_list] List saved presets")
        DisplayRightAlignedText(0.1, 0.55, "[/rcp_stop] Stop freecam")
        
        HandleFreeCameraControls(freeCamObject, movementSpeed, mouseSpeed)
        
        -- Check for Y key to take picture (control 353)
        if IsDisabledControlPressed(0, 353) then
            isControlThreadActive = false
            return
        end
    end
end

-- Stop free camera system
function ClothingStopFreeCam()
    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(freeCamObject, false)
    freeCamObject = nil
    isFreeCamActive = false
    isControlThreadActive = false
end

-- Check if free camera is currently active
function IsClothingFreeCamActive()
    return freeCamObject ~= nil
end

-- Check if free camera control thread is running
function IsClothingFreeCamControlled()
    return isControlThreadActive
end

-- Command: Save camera preset
RegisterCommand("rcp_save", function(source, args)
    if not isFreeCamActive then
        return
    end
    
    if #args < 1 then
        return
    end
    
    local presetName = args[1]
    local currentCamera = GetRenderingCam()
    local cameraPosition = GetCamCoord(currentCamera)
    local cameraRotation = GetCamRot(currentCamera, 2)
    
    -- Load existing presets from storage
    local presetsJson = GetResourceKvpString("rcp_presets")
    local presets = json.decode(presetsJson)
    if not presets then
        presets = {}
    end
    
    -- Save new preset
    presets[presetName] = {
        pos = cameraPosition,
        rot = cameraRotation
    }
    
    SetResourceKvp("rcp_presets", json.encode(presets))
end)

-- Command: Stop free camera
RegisterCommand("rcp_stop", function(source, args)
    if not isFreeCamActive then
        return
    end
    
    Pipeline2ForceStop()  -- ⚠️ External function - purpose unclear
    ClothingStopFreeCam()
end)

-- Command: Load camera preset
RegisterCommand("rcp_load", function(source, args)
    if not isFreeCamActive then
        return
    end
    
    if #args < 1 then
        return
    end
    
    local presetName = args[1]
    
    -- Load presets from storage
    local presetsJson = GetResourceKvpString("rcp_presets")
    local presets = json.decode(presetsJson)
    if not presets then
        presets = {}
    end
    
    local preset = presets[presetName]
    if not preset then
        return
    end
    
    local currentCamera = GetRenderingCam()
    
    -- Set pending position/rotation to be applied in next frame
    pendingCameraPosition = preset.pos
    pendingCameraRotation = preset.rot
end)

-- Command: List all saved presets
RegisterCommand("rcp_list", function(source, args)
    if not isFreeCamActive then
        return
    end
    
    -- Load presets from storage
    local presetsJson = GetResourceKvpString("rcp_presets")
    local presets = json.decode(presetsJson)
    if not presets then
        presets = {}
    end
    
    local presetNames = ""
    print("Camera presets:")
    
    for presetName, presetData in pairs(presets) do
        print("-", presetName)
        presetNames = presetNames .. presetName .. ", "
    end
    
    -- Display in chat
    TriggerEvent("chat:addMessage", {
        color = {239, 199, 80},
        multiline = true,
        args = {"camera presets", presetNames}
    })
end)

-- Command: Clear all presets
RegisterCommand("rcp_clearall", function(source, args)
    if not isFreeCamActive then
        return
    end
    
    SetResourceKvp("rcp_presets", "{}")
end)