-- Head photo generation system for character variations
-- Note: This system appears to be disabled (early return statement)

Citizen.CreateThread(function()
    -- Early exit - system is currently disabled
    local isSystemEnabled = false
    if not isSystemEnabled then
        return
    end
    
    -- Get available head blend variations
    local maleHeadBlends = GetMaleHeadBlends()
    local femaleHeadBlends = GetFemaleHeadBlends()
    
    -- Combine all head blend variations
    local allHeadBlends = {}
    
    -- Add female head blends
    for _, headBlend in pairs(femaleHeadBlends) do
        table.insert(allHeadBlends, headBlend)
    end
    
    -- Add male head blends
    for _, headBlend in pairs(maleHeadBlends) do
        table.insert(allHeadBlends, headBlend)
    end
    
    -- Setup character model and environment
    local maleModelHash = 1885233650
    LoadAndSetModel(maleModelHash)
    InvisibilityMakeInvisible(maleModelHash)
    
    Wait(100)
    SetAnim()
    Wait(2000)
    
    local playerPed = PlayerPedId()
    
    -- Setup camera for head photography
    ClothingCamSetup(playerPed, CAM_OFFSETS_PROCESSING, 999)
    
    -- Setup green screen backdrop for clean photo capture
    local greenScreenColor = {0, 255, 0, 255}  -- RGBA green
    BackdropSetupForPed(playerPed, greenScreenColor, true)
    
    -- Generate photos for all head blend combinations
    for _, headBlendId in pairs(allHeadBlends) do
        -- Iterate through all skin tone variations (0-44)
        for skinToneId = 0, 44 do
            local currentHeadBlend = headBlendId
            local currentSkinTone = skinToneId
            
            Wait(100)
            
            -- Apply head blend configuration
            SetPedHeadBlendData(
                playerPed,
                currentHeadBlend,     -- skinFirst (main head blend)
                0,                    -- skinSecond
                0,                    -- skinThird
                currentSkinTone,      -- faceFirst (skin tone)
                0,                    -- faceSecond
                0,                    -- faceThird
                0.0,                  -- skinMix
                0.0,                  -- faceMix
                0.0,                  -- thirdMix
                false                 -- isParent
            )
            
            Wait(200)
            
            -- Capture and upload photo
            TakeHeadPhoto(maleModelHash, currentHeadBlend, currentSkinTone)
            
            Wait(400)
        end
    end
end)

-- Capture head photo and upload to server
function TakeHeadPhoto(modelHash, headBlendId, skinToneId)
    local isUploadComplete = false
    local uploadSuccess = false
    
    -- Construct upload URL with parameters
    local uploadUrl = "http://localhost:8080/upload-head/" .. 
                     modelHash .. "/" .. 
                     headBlendId .. "/" .. 
                     skinToneId
    
    print("screening", uploadUrl)
    
    -- Take screenshot and upload using screenshot-basic export
    exports["screenshot-basic"]:requestScreenshotUpload(
        uploadUrl,
        "files[]",
        {encoding = "png"},
        function(responseData)
            local response = json.decode(responseData)
            uploadSuccess = response.success
            isUploadComplete = true
        end
    )
    
    -- Wait for upload completion
    while not isUploadComplete do
        Wait(0)
    end
    
    return uploadSuccess
end