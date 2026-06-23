-- Animation and camera state management
local animationRotation = vector3(0.0, 0.0, 0.0)
local forceStopPipeline = false
local animationActive = false
local useFreeCam = false
local currentComponentId = nil
local initialPlayerHealth = nil

-- Ped model constants
local FEMALE_PED_MODEL = 1885233650
local MALE_PED_MODEL = -1667301416

function GetAnimRot()
    return animationRotation
end

function SetAnimRot(newRotation)
    animationRotation = newRotation
end

function StopStage2Anim()
    animationActive = false
end

function Pipeline2ForceStop()
    forceStopPipeline = true
end

function SetAnim()
    animationActive = true
    
    RequestAnimDict("move_m@generic")
    while not HasAnimDictLoaded("move_m@generic") do
        Wait(100)
    end
    
    Citizen.CreateThreadNow(function()
        local playerCoords = GetEntityCoords(PlayerPedId())
        local playerRotation = GetEntityRotation(PlayerPedId())
        animationRotation = playerRotation
        
        while animationActive do
            TaskPlayAnimAdvanced(PlayerPedId(), "move_m@generic", "idle", playerCoords, animationRotation, 0.0, 0.0, 1000, 2, 0, false, false)
            
            HideHudAndRadarThisFrame()
            ThefeedHideThisFrame()
            SetRainLevel(0.0)
            SetWeatherTypePersist("EXTRASUNNY")
            SetWeatherTypeNow("EXTRASUNNY")
            SetWeatherTypeNowPersist("EXTRASUNNY")
            
            Wait(0)
        end
    end)
end

function DisplayTextOnScreen(x, y, text)
    SetTextFont(0)
    SetTextColour(255, 255, 255, 255)
    SetTextScale(1.0, 1.0)
    SetTextDropShadow()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(tostring(text))
    EndTextCommandDisplayText(x, y)
end

function Pipeline2HandleConfirmAllrightDialog(sessionId)
    local lastInputTime = GetTimeSinceLastInput()
    Wait(0)
    Wait(0)
    
    -- Wait for mouse movement to start process
    while lastInputTime < GetTimeSinceLastInput() do
        DisplayTextOnScreen(0.3, 0.4, "~g~Move your mouse to start the process")
        Wait(0)
    end
    
    local playerPed = PlayerPedId()
    
    ClothingCamSetup(playerPed, CAM_OFFSETS_PROCESSING, 11)
    BackdropSetupForPed(playerPed, {0, 255, 0, 255}, true)
    InvisibilityMakeInvisible(GetEntityModel(playerPed))
    
    -- Set default torso variation
    SetPedComponentVariation(playerPed, 11, 0, 0, 0)
    
    -- Apply appropriate default clothing based on gender
    local pedModel = GetEntityModel(playerPed)
    if pedModel == MALE_PED_MODEL then
        ApplyPedClothingItem(playerPed, {name_hash = -2029594620}, true, true)
    else
        ApplyPedClothingItem(playerPed, {name_hash = -2006797141}, true, true)
    end
    
    Wait(1000)
    
    local photoResult, errorImage = TakePhotoWithRetryAndReturnImage(sessionId)
    
    if photoResult == nil then
        print("ERROR: Could not take photo", errorImage)
        ShowInfoDialog("pipeline_failed", "Failed to take photo", "Check the URL below to see what went wrong. <br><br>If you want to contact rcore support, copy the link and send it into your ticket.", errorImage)
        
        BackdropStop()
        ClothingCamStop()
        ClearPedTasksImmediately(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
    else
        ShowPipelineConfirmDialog(photoResult)
    end
end

function OnPipeline2DialogConfirm()
    TriggerServerEvent("rcore_clothing:getDataToProcess", GetEntityModel(PlayerPedId()), 0, useFreeCam, currentComponentId)
end

function OnPipeline2DialogCancel()
    BackdropStop()
    StopStage2Anim()
    ClothingCamStop()
    ClearPedTasksImmediately(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end

function CleanupAndStop()
    ClearTimecycleModifier()
    BackdropStop()
    ClothingCamStop()
    StopStage2Anim()
    FreezeEntityPosition(PlayerPedId(), false)
end

function ProcessClothingItem(playerPed, item)
    print("Screenshotting", item.component_id, item.drawable_id, item.texture_id)
    
    InvisibilityMakeInvisible(GetEntityModel(playerPed))
    ClearPedDecorations(playerPed)
    
    -- Special handling for hair component
    if item.component_id == 2 then
        local pedModel = GetEntityModel(playerPed)
        if pedModel == MALE_PED_MODEL then
            SetPedHeadBlendData(playerPed, 31, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, true)
        else
            SetPedHeadBlendData(playerPed, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, true)
        end
        SetPedHairTint(playerPed, 8, 0)
        SetPedComponentVariation(playerPed, item.component_id, item.drawable_id, 0, 0)
    else
        ApplyPedClothingItem(playerPed, item, true, true)
    end
end

function SetupCameraForItem(playerPed, item, lastComponentId, lastDrawableId)
    if not useFreeCam then
        ClothingCamSetComponent(playerPed, CAM_OFFSETS_PROCESSING, item.component_id)
    else
        -- Only control camera if component or drawable changed
        if lastComponentId ~= item.component_id or lastDrawableId ~= item.drawable_id then
            ClothingControlFreeCam()
        end
    end
end

-- Event handlers
RegisterNetEvent("rcore_clothing:pipelineInitStage2", function(pedModel, sessionId, isFreeCam, compId)
    StopDrawingPhotosWarning()
    ResetIsStage4()
    
    useFreeCam = isFreeCam
    currentComponentId = compId
    
    print("Setting model to", pedModel)
    LoadAndSetModel(pedModel)
    print("Loaded model...")
    
    -- Position player at specific coordinates
    SetEntityCoords(PlayerPedId(), 53.91, 164.21, -114.55)
    SetEntityHeading(PlayerPedId(), 270.0)
    FreezeEntityPosition(PlayerPedId(), true)
    
    SetTimecycleModifier("rcore_clothing_tc")
    SetAnim()
    
    Wait(500)
    
    initialPlayerHealth = GetEntityHealth(PlayerPedId())
    Pipeline2HandleConfirmAllrightDialog(sessionId)
end)

RegisterNUICallback("pipeline2forceStop", function(data, callback)
    Pipeline2ForceStop()
    callback("ok")
end)

RegisterNetEvent("rcore_clothing:receiveDataToProcess", function(sessionId, itemsToProcess, statusData)
    print("Received items:" .. #itemsToProcess)
    
    -- Check for force stop or empty items
    if forceStopPipeline or #itemsToProcess <= 0 then
        CleanupAndStop()
        Wait(1000)
        
        if not forceStopPipeline then
            local currentPedModel = GetEntityModel(PlayerPedId())
            
            -- Switch to opposite gender model when done with current
            if currentPedModel == FEMALE_PED_MODEL then
                TriggerEvent("rcore_clothing:pipelineInitStage2", MALE_PED_MODEL, sessionId, useFreeCam, currentComponentId)
            else
                SetPedDefaultComponentVariation(PlayerPedId())
                ClearPedTasksImmediately(PlayerPedId())
                SetPedDefaultComponentVariation(PlayerPedId())
                TriggerServerEvent("rcore_clothing:reloadSkin")
            end
        end
        
        if not forceStopPipeline then
            ShowInfoDialog("pipeline_done", "Addon process done", "No more items to process for this ped! You can now close this window.")
        end
        
        forceStopPipeline = false
        return
    end
    
    local playerPed = PlayerPedId()
    
    -- Setup camera and backdrop
    if not useFreeCam then
        ClothingCamSetup(playerPed, CAM_OFFSETS_PROCESSING, itemsToProcess[1].component_id)
    else
        if not IsClothingFreeCamActive() then
            ClothingSetupFreeCam(playerPed, CAM_OFFSETS_PROCESSING, 11)
        end
    end
    
    BackdropSetupForPed(playerPed, {0, 255, 0, 255}, true)
    Wait(500)
    
    local initialRotation = animationRotation
    local lastProcessedId = 0
    local lastComponentId = nil
    local lastDrawableId = nil
    
    -- Perform green screen test
    InvisibilityMakeInvisible(GetEntityModel(PlayerPedId()))
    Wait(2000)
    
    local greenScreenTest, testImage = TakePhotoEmptynessTest(sessionId)
    if not greenScreenTest then
        print("Failed green screen test, some resource is probably drawing something on screen.", itemsToProcess[1].component_id)
        print("Image: " .. testImage)
        
        ShowInfoDialog("pipeline_failed_gs", "Failed to take photo", "Check the URL below to see what went wrong. If there is anything other than green screen on the photo, try to hide it. <br><br>If you want to contact rcore support, copy the link and send it into your ticket.", testImage)
        
        BackdropStop()
        StopStage2Anim()
        FreezeEntityPosition(PlayerPedId(), false)
        
        if not useFreeCam then
            ClothingCamStop()
        else
            ClothingStopFreeCam()
        end
        return
    end
    
    DisplayPipelineStatus(statusData, useFreeCam)
    
    -- Process each clothing item
    for itemIndex, item in pairs(itemsToProcess) do
        if forceStopPipeline then
            ShowNotification("Addon pipeline manually stopped. To continue later, start the step again.")
            break
        end
        
        -- Check for health damage (starvation protection)
        local healthDamage = initialPlayerHealth - GetEntityHealth(PlayerPedId())
        if healthDamage > 10 then
            HidePipelineStatus()
            print("Player took damage, stopping pipeline. You might be dying of starvation")
            
            ShowInfoDialog("pipeline_failed_hp", "Addon process stopped", "Player took damage, stopping pipeline. You might be dying of starvation.")
            
            BackdropStop()
            StopStage2Anim()
            FreezeEntityPosition(PlayerPedId(), false)
            
            if not useFreeCam then
                ClothingCamStop()
            else
                ClothingStopFreeCam()
            end
            return
        end
        
        UpdatePipelineStatus(itemIndex)
        lastProcessedId = item.id
        
        ProcessClothingItem(playerPed, item)
        SetupCameraForItem(playerPed, item, lastComponentId, lastDrawableId)
        
        if forceStopPipeline then
            break
        end
        
        ClearPedTasksImmediately(PlayerPedId())
        
        -- Special rotation handling for bags component
        if not useFreeCam and item.component_id == 5 then
            animationRotation = initialRotation + vector3(0.0, 0.0, 180.0)
        end
        
        -- Wait for busy spinner to finish
        while BusyspinnerIsOn() do
            Wait(0)
        end
        Wait(100)
        while BusyspinnerIsOn() do
            Wait(0)
        end
        
        -- Take the photo
        local resolvedItem = ResolveItemToClothingOrPropItem(PlayerPedId(), item)
        TakePhotoWithRetry(
            item.id,
            sessionId,
            GetEntityModel(playerPed),
            resolvedItem.componentId,
            resolvedItem.drawableId,
            resolvedItem.textureId,
            item.name_hash,
            resolvedItem.decalCollectionHash or 0,
            resolvedItem.decalNameHash or 0
        )
        
        lastComponentId = item.component_id
        lastDrawableId = item.drawable_id
        animationRotation = initialRotation
    end
    
    HidePipelineStatus()
    BackdropStop()
    
    if not useFreeCam then
        ClothingCamStop()
    else
        ClothingStopFreeCam()
    end
    
    -- Request next batch of items to process
    TriggerServerEvent("rcore_clothing:getDataToProcess", GetEntityModel(PlayerPedId()), lastProcessedId, useFreeCam, currentComponentId)
end)

-- Resource cleanup handler
AddEventHandler("onResourceStop", function(resourceName)
    local currentResource = GetCurrentResourceName()
    
    if resourceName == currentResource then
        ClearTimecycleModifier()
        print("Clearing ped tasks because", GetCurrentResourceName(), "is stopping")
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasksImmediately(PlayerPedId())
    end
end)