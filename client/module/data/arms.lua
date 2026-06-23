function GetAvailableGloves(baseArmsHash)
    local armConfig = DataGetArmConfig()
    local availableGloves = armConfig[baseArmsHash]
    
    if not availableGloves then
        return {}
    end
    
    return armConfig[baseArmsHash]
end

function IsBaseArms(armsHash)
    local baseArmsData = DataGetArms()
    
    for _, baseArms in ipairs(baseArmsData) do
        if baseArms == armsHash then
            return true
        end
    end
    
    return false
end

function GetBaseArmsFromHash(armsHash)
    if type(armsHash) ~= "string" then
        print("ERROR: armsHash must be a string because some arms dont have a hash")
    end
    
    local armConfigData = DataGetArmConfig()
    
    for baseArmsHash, glovesList in pairs(armConfigData) do
        for gloveIndex, gloveHash in ipairs(glovesList) do
            if gloveHash == armsHash then
                return gloveIndex, baseArmsHash
            end
        end
    end
    
    return nil
end

function GetGloveIndex(glovesList, targetArmsHash)
    for index, gloveHash in ipairs(glovesList) do
        if gloveHash == targetArmsHash then
            return index, baseArms
        end
    end
    
    return nil
end

function IsDefaultArmsForModel(baseArmsHash)
    local currentPed = GetShopPed()
    if not currentPed then
        currentPed = PlayerPedId()
    end
    
    local pedModel = GetEntityModel(currentPed)
    
    -- Male model (mp_m_freemode_01)
    if pedModel == 1885233650 then
        return baseArmsHash == "nondlcgta5--3--4--0"
    -- Female model (mp_f_freemode_01)
    elseif pedModel == -1667301416 then
        return baseArmsHash == "nondlcgta5--3--11--0" or baseArmsHash == "nondlcgta5--3--3--0"
    end
    
    return false
end

function GetEquivalentGlovesFromHash(sourceArmsHash, targetBaseArmsHash)
    local sourceIndex, sourceBaseArmsHash = GetBaseArmsFromHash(sourceArmsHash)
    local sourceGloves = GetAvailableGloves(sourceBaseArmsHash)
    
    -- Filter out unique items if this is default arms for the model
    if IsDefaultArmsForModel(sourceBaseArmsHash) then
        sourceGloves = FilterOutUniques(sourceGloves)
    end
    
    local sourceGloveIndex = GetGloveIndex(sourceGloves, sourceArmsHash)
    local targetGloves = GetAvailableGloves(targetBaseArmsHash)
    
    -- Filter out unique items if this is default arms for the model
    if IsDefaultArmsForModel(targetBaseArmsHash) then
        targetGloves = FilterOutUniques(targetGloves)
    end
    
    -- If source glove not found, return first target glove
    if sourceGloveIndex == nil then
        return targetGloves[1]
    end
    
    local targetGlovesCount = #targetGloves
    local sourceGlovesCount = #sourceGloves
    
    -- If target doesn't have standard glove counts (61 or 71), return first
    if targetGlovesCount ~= 61 and targetGlovesCount ~= 71 then
        return targetGloves[1]
    end
    
    -- If source doesn't have standard glove counts (61 or 71), return first
    if sourceGlovesCount ~= 61 and sourceGlovesCount ~= 71 then
        return targetGloves[1]
    end
    
    -- If both have same count, direct mapping
    if targetGlovesCount == sourceGlovesCount then
        return targetGloves[sourceGloveIndex]
    end
    
    -- Handle gap mapping between different glove set sizes
    local gapData = DataGetGapData()
    
    -- Converting from 61 to 71 gloves
    if sourceGlovesCount == 61 and targetGlovesCount == 71 then
        if sourceGloveIndex > gapData.start then
            local adjustedIndex = sourceGloveIndex + gapData.length
            return targetGloves[adjustedIndex]
        end
        return targetGloves[sourceGloveIndex]
    end
    
    -- Converting from 71 to 61 gloves
    if sourceGlovesCount == 71 and targetGlovesCount == 61 then
        if sourceGloveIndex > gapData.start then
            local gapEnd = gapData.start + gapData.length
            if sourceGloveIndex < gapEnd then
                -- Index falls in gap, return first glove
                return targetGloves[1]
            end
            -- Index after gap, subtract gap length
            local adjustedIndex = sourceGloveIndex - gapData.length
            return targetGloves[adjustedIndex]
        else
            return targetGloves[sourceGloveIndex]
        end
    end
    
    -- Fallback to first glove
    return targetGloves[1]
end

function FilterOutUniques(glovesList)
    local filteredGloves = {}
    local ignoreData = DataGetArmConfigIgnore()
    
    for _, gloveHash in ipairs(glovesList) do
        if not ignoreData[gloveHash] then
            table.insert(filteredGloves, gloveHash)
        end
    end
    
    return filteredGloves
end