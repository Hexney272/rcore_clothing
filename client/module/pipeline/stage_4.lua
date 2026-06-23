-- Stage 4 state management
local initialPlayerHealth = nil
local isStage4Active = false

-- Ped model constants
local FEMALE_PED_MODEL = 1885233650
local MALE_PED_MODEL = -1667301416

function ResetIsStage4()
    isStage4Active = false
end

function IsStage4()
    return isStage4Active
end

function CleanupStage4()
    ClearTimecycleModifier()
    BackdropStop()
    ClothingCamStop()
    StopStage2Anim()
    FreezeEntityPosition(PlayerPedId(), false)
end

function ProcessValidationItem(playerPed, item)
    print("Validating", item.component_id, item.drawable_id, item.texture_id)
    
    InvisibilityMakeInvisible(GetEntityModel(playerPed))
    ClearPedDecorations(playerPed)
    
    -- Apply the clothing item to test
    ApplyPedClothingItem(playerPed, item, true, true)
    
    -- Set camera to validation mode (component 888)
    ClothingCamSetComponent(playerPed, CAM_OFFSETS_PROCESSING, 888)
    
    ClearPedTasksImmediately(PlayerPedId())
end

function HandleBagRotation(item, initialRotation)
    -- Special rotation handling for bags component
    if item.component_id == 5 then
        SetAnimRot(initialRotation + vector3(0.0, 0.0, 180.0))
    end
end

-- Event handlers
RegisterNetEvent("rcore_clothing:pipelineInitStage4", function(pedModel, sessionId)
    StopDrawingPhotosWarning()
    isStage4Active = true
    
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

RegisterNetEvent("rcore_clothing:receiveStage4DataToProcess", function(sessionId, itemsToValidate, statusData)
    print("Received items:" .. #itemsToValidate)
    
    -- Check if processing is complete
    if #itemsToValidate <= 0 then
        CleanupStage4()
        Wait(1000)
        
        local currentPedModel = GetEntityModel(PlayerPedId())
        
        -- Switch to opposite gender model when done with current
        if currentPedModel == FEMALE_PED_MODEL then
            TriggerEvent("rcore_clothing:pipelineInitStage4", MALE_PED_MODEL, sessionId)
        else
            SetPedDefaultComponentVariation(PlayerPedId())
            ClearPedTasksImmediately(PlayerPedId())
            SetPedDefaultComponentVariation(PlayerPedId())
        end
        
        ShowInfoDialog("pipeline_done", "Addon process done", "No more items to process for this ped! You can now close this window.")
        return
    end
    
    local playerPed = PlayerPedId()
    
    -- Setup free camera for validation (component 888 is validation mode)
    ClothingSetupFreeCam(playerPed, CAM_OFFSETS_PROCESSING, 888)
    BackdropSetupForPed(playerPed, {0, 255, 0, 255}, true)
    
    Wait(500)
    
    local initialRotation = GetAnimRot()
    local lastProcessedId = 0
    local lastComponentId = nil
    local lastDrawableId = nil
    
    -- Perform green screen test
    InvisibilityMakeInvisible(GetEntityModel(PlayerPedId()))
    Wait(2000)
    
    local greenScreenTest, testImage = TakePhotoEmptynessTest(sessionId)
    if not greenScreenTest then
        print("Failed green screen test, some resource is probably drawing something on screen.", itemsToValidate[1].component_id)
        print("Image: " .. testImage)
        
        ShowInfoDialog("pipeline_failed_gs", "Failed to take photo", "Check the URL below to see what went wrong. If there is anything other than green screen on the photo, try to hide it. <br><br>If you want to contact rcore support, copy the link and send it into your ticket.", testImage)
        
        BackdropStop()
        StopStage2Anim()
        FreezeEntityPosition(PlayerPedId(), false)
        ClothingCamStop()
        return
    end
    
    -- Display pipeline status with Stage 4 flag
    DisplayPipelineStatus(statusData, false, true)
    
    -- Process each item for validation
    for itemIndex, item in pairs(itemsToValidate) do
        -- Check for health damage (starvation protection)
        local healthDamage = initialPlayerHealth - GetEntityHealth(PlayerPedId())
        if healthDamage > 10 then
            HidePipelineStatus()
            print("Player took damage, stopping pipeline. You might be dying of starvation")
            
            ShowInfoDialog("pipeline_failed_hp", "Addon process stopped", "Player took damage, stopping pipeline. You might be dying of starvation.")
            
            BackdropStop()
            StopStage2Anim()
            FreezeEntityPosition(PlayerPedId(), false)
            ClothingCamStop()
            return
        end
        
        UpdatePipelineStatus(itemIndex)
        lastProcessedId = item.id
        
        ProcessValidationItem(playerPed, item)
        HandleBagRotation(item, initialRotation)
        
        -- Wait for busy spinner to finish
        while BusyspinnerIsOn() do
            Wait(0)
        end
        Wait(100)
        while BusyspinnerIsOn() do
            Wait(0)
        end
        
        -- Resolve item and test if it's visible/valid
        local resolvedItem = ResolveItemToClothingOrPropItem(PlayerPedId(), item)
        local visibilityTest, _ = TakePhotoEmptynessTest(sessionId)
        
        -- If item is NOT visible (green screen test passes), it means the item is broken/invisible
        if visibilityTest then
            TriggerServerEvent("rcore_clothing:stage4SoftBlacklist", item.id)
        end
        
        lastComponentId = item.component_id
        lastDrawableId = item.drawable_id
        SetAnimRot(initialRotation)
    end
    
    HidePipelineStatus()
    BackdropStop()
    ClothingCamStop()
    
    -- Request next batch of items to validate
    TriggerServerEvent("rcore_clothing:getStage4DataToProcess", GetEntityModel(PlayerPedId()), lastProcessedId)
end)

function OnPipeline4DialogConfirm()
    TriggerServerEvent("rcore_clothing:getStage4DataToProcess", GetEntityModel(PlayerPedId()))
end