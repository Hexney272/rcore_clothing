-- Request tracking system
local requestIdCounter = 0
local pendingRequests = {}

-- Timeout constant
local REQUEST_TIMEOUT_MS = 2000

function GetSkinByIdentifier(skinIdentifier)
    -- Generate unique request ID
    requestIdCounter = requestIdCounter + 1
    local requestId = requestIdCounter
    
    -- Send request to server
    TriggerServerEvent("rcore_clothing:requestSkinByIdentifier", requestId, skinIdentifier)
    
    -- Wait for response with timeout
    local startTime = GetGameTimer()
    
    while true do
        local responseData = pendingRequests[requestId]
        if responseData then
            break
        end
        
        local elapsedTime = GetGameTimer() - startTime
        if elapsedTime >= REQUEST_TIMEOUT_MS then
            break
        end
        
        Wait(0)
    end
    
    -- Get response and cleanup
    local skinData = pendingRequests[requestId]
    pendingRequests[requestId] = nil
    
    return skinData
end

-- Event handler for server responses
RegisterNetEvent("rcore_clothing:responseSkinByIdentifier", function(requestId, skinData)
    pendingRequests[requestId] = skinData
end)