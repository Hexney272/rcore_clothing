-- Global state variable (preserved for cross-file compatibility)
local isImageDebuggingActive = false

-- Check if image debugging is currently active
function GetIsImageDebugging()
    return isImageDebuggingActive
end

-- Alternative function name for checking debug state (preserved for compatibility)
function IsDebuggingImages()
    return isImageDebuggingActive
end

-- Start image debugging mode
function StartImageDebug()
    -- Set backdrop to bright green for debugging visibility
    BackdropForceColor({0, 255, 0, 255})
    
    -- Make the player model invisible for clean screenshots
    local playerPed = PlayerPedId()
    local playerModel = GetEntityModel(playerPed)
    InvisibilityMakeInvisible(playerModel)
    
    isImageDebuggingActive = true
end

-- Stop image debugging mode and reset everything
function StopImageDebug()
    ResetBackdropColor()
    isImageDebuggingActive = false
    ResetEverything()
end