function TakePhoto(itemId, sessionId, pedModel, componentId, drawableId, textureId, nameHash, decalCollectionHash, decalNameHash)
    local uploadComplete = false
    local uploadSuccess = false
    
    -- Build upload URL with all parameters
    local uploadUrl = BACKEND_URL .. "/upload/" .. sessionId .. "/" .. pedModel .. "/" .. componentId .. "/" .. drawableId .. "/" .. textureId .. "/" .. nameHash .. "/" .. decalCollectionHash .. "/" .. decalNameHash
    
    exports["screenshot-basic"]:requestScreenshotUpload(uploadUrl, "files[]", {encoding = "png"}, function(response)
        local responseData = json.decode(response)
        uploadSuccess = responseData.success
        uploadComplete = true
        
        if uploadSuccess then
            TriggerServerEvent("rcore_clothing:stage2SaveResult", itemId, responseData.url, responseData.colors)
        end
    end)
    
    -- Wait for upload to complete
    while not uploadComplete do
        Wait(0)
    end
    
    return uploadSuccess
end

function TakePhotoWithRetry(itemId, sessionId, pedModel, componentId, drawableId, textureId, nameHash, decalCollectionHash, decalNameHash)
    local maxRetries = 3
    local success = false
    
    repeat
        local photoResult = TakePhoto(itemId, sessionId, pedModel, componentId, drawableId, textureId, nameHash, decalCollectionHash, decalNameHash)
        
        if photoResult then
            success = true
            break
        else
            maxRetries = maxRetries - 1
            
            if maxRetries < 2 then
                print("No clothing item is visible on screen, it is ok - don't panic ;).", drawableId, textureId, "retries left:", maxRetries)
                ShowPipelineStatusIsInvisible()
            end
            
            Wait(100)
        end
    until photoResult or maxRetries <= 0
    
    -- If all retries failed, notify server
    if not success then
        TriggerServerEvent("rcore_clothing:stage2CouldNotProcess", itemId)
    end
end

function TakePhotoWithRetryAndReturnImage(sessionId)
    local uploadComplete = false
    local uploadSuccess = false
    local successUrl = nil
    local failureUrl = nil
    
    local uploadUrl = BACKEND_URL .. "/upload-test/" .. sessionId
    
    exports["screenshot-basic"]:requestScreenshotUpload(uploadUrl, "files[]", {encoding = "png"}, function(response)
        local responseData = json.decode(response)
        uploadSuccess = responseData.success
        uploadComplete = true
        
        if uploadSuccess then
            successUrl = responseData.url
        else
            failureUrl = responseData.failUrl
        end
    end)
    
    -- Wait for upload to complete
    while not uploadComplete do
        Wait(0)
    end
    
    return successUrl, failureUrl
end

function TakePhotoEmptynessTest(sessionId)
    local uploadComplete = false
    local uploadSuccess = false
    local imageUrl = nil
    
    local uploadUrl = BACKEND_URL .. "/upload-test/" .. sessionId .. "?emptytest=1"
    
    exports["screenshot-basic"]:requestScreenshotUpload(uploadUrl, "files[]", {encoding = "png"}, function(response)
        local responseData = json.decode(response)
        uploadSuccess = responseData.success
        uploadComplete = true
        imageUrl = responseData.url
    end)
    
    -- Wait for upload to complete
    while not uploadComplete do
        Wait(0)
    end
    
    return uploadSuccess, imageUrl
end