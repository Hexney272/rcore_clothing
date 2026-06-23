local playerBuckets = {}

-- Initialize ACE permissions on startup
Citizen.CreateThread(function()
    local permissionsValid = true
    
    for groupName, permissions in pairs(PermissionMap) do
        if not permissionsValid then
            break
        end
        
        for _, permission in pairs(permissions) do
            if not permissionsValid then
                break
            end
            
            AceAllow(groupName, permission)
            permissionsValid = AceCanGroup(groupName, permission)
            
            if not permissionsValid then
                for i = 1, 5 do
                    print(string.format("^1Ace Permissions failed! You probably forgot to add add_ace to server.cfg"))
                end
                print(string.format("^1https://documentation.rcore.cz/paid-resources/rcore_clothing/installation"))
                break
            end
        end
    end
end)

function PutPlayerIntoBucket(playerId)
    if not Config.UseBuckets then
        return
    end
    
    local currentBucket = GetPlayerRoutingBucket(playerId)
    playerBuckets[playerId] = currentBucket
    
    local bucketOffset = Config.BucketOffset or 0
    SetPlayerRoutingBucket(playerId, bucketOffset + playerId)
end

function ResetPlayerBucket(playerId)
    if not Config.UseBuckets then
        return
    end
    
    local originalBucket = playerBuckets[playerId] or 0
    SetPlayerRoutingBucket(playerId, originalBucket)
    playerBuckets[playerId] = nil
end

RegisterNetEvent("rcore_clothing:getSingleItemMetadata", function(shopId, itemNameHash, showEverything, isFree)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerModel = GetEntityModel(playerPed)
    local itemData = nil
    
    local hasEverything = Config.IdModeHasEverything
    if showEverything then
        hasEverything = true
    end
    
    if hasEverything then
        itemData = DbGetSingleItemMetadata(playerModel, itemNameHash, playerId, hasEverything)
    else
        itemData = DbGetSingleItemMetadataForShop(playerModel, itemNameHash, shopId, playerId)
    end
    
    if itemData ~= nil then
        itemData = FormatClothingItem(hasEverything, itemData, shopId)
    end
    
    if itemData and isFree then
        itemData.price = 0
    end
    
    if itemData then
        TriggerClientEvent("rcore_clothing:receiveSingleItemMetadata", playerId, itemData)
    else
        TriggerClientEvent("rcore_clothing:receiveSingleItemMetadata", playerId, {
            not_found = itemNameHash
        })
    end
end)

RegisterNetEvent("rcore_clothing:setOutfitAsCurrent", function(outfitData)
    local playerId = source
    local playerIdentifier = GetPlayerFwIdentifier(playerId)
    local playerPed = GetPlayerPed(playerId)
    local playerModel = GetEntityModel(playerPed)
    
    local existingOutfit = DbGetCurrentOutfit(playerIdentifier)
    
    if #existingOutfit > 0 then
        DbSaveCurrentOutfit(playerIdentifier, playerModel, outfitData)
    else
        DbCreateCurrentOutfit(playerIdentifier, playerModel, outfitData)
    end
end)

RegisterCommand(Config.Commands.Skin, function(playerId, args)
    local targetPlayerId = playerId
    
    if args[1] then
        local specifiedId = tonumber(args[1])
        if specifiedId and specifiedId > 0 then
            local playerName = GetPlayerName(specifiedId)
            if playerName then
                targetPlayerId = specifiedId
            else
                SendNotification(playerId, "Usage: " .. Config.Commands.Skin .. " [serverId]")
                return
            end
        else
            SendNotification(playerId, "Usage: " .. Config.Commands.Skin .. " [serverId]")
            return
        end
    end
    
    TriggerClientEvent("rcore_clothing:openSkinMenu", targetPlayerId)
end, true)

AddEventHandler("onResourceStop", function(resourceName)
    local currentResource = GetCurrentResourceName()
    if resourceName ~= currentResource then
        return
    end
    
    -- Reset all player buckets when resource stops
    for playerId, originalBucket in pairs(playerBuckets) do
        ResetPlayerBucket(playerId)
    end
end)