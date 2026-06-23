local tattooCache = {}
local isCacheReady = false

function PrecomputeTattooCache(dlcIndex)
    if not tattooCache[dlcIndex] then
        tattooCache[dlcIndex] = {}
    end
    
    local totalTattoos = GetNumTattooShopDlcItems(dlcIndex)
    local operationCounter = 500  -- Performance throttling counter
    
    for tattooIndex = 0, totalTattoos do
        local tattooData = MyGetTattooShopDlcItemData(dlcIndex, tattooIndex)
        tattooCache[dlcIndex][tattooData.NameHash] = tattooData
        
        -- Throttle operations to prevent frame drops
        operationCounter = operationCounter - 1
        if operationCounter < 0 then
            operationCounter = 500
            Wait(0)
        end
    end
    
    isCacheReady = true
end

function IsTattooCacheReady()
    return isCacheReady
end

function GetDecalVariations(dlcIndex, targetPed, apparelVariant)
    ClearPedDecorations(targetPed)
    
    local componentCount = GetShopPedApparelVariantComponentCount(apparelVariant)
    local validDecorations = {}
    
    if componentCount > 0 then
        for componentIndex = 0, componentCount - 1 do
            local componentHash, _, componentType = GetVariantComponent(apparelVariant, componentIndex)
            
            -- Check if component is a decoration (type 10)
            if componentType == 10 then
                local tattooData = tattooCache[dlcIndex] and tattooCache[dlcIndex][componentHash]
                
                if tattooData then
                    -- Apply decoration temporarily to test validity
                    SetPedDecoration(
                        targetPed,
                        tattooData.CollectionHash,
                        tattooData.NameHash
                    )
                    
                    Wait(100)
                    
                    -- Check if decoration was successfully applied
                    local currentDecorations = GetPedDecorations(targetPed)
                    if #currentDecorations > 0 then
                        table.insert(validDecorations, {
                            CollectionHash = tattooData.CollectionHash,
                            DecorationNameHash = tattooData.NameHash,
                            Price = ResolvePrice(tattooData.Price),
                            Label = tattooData.Label
                        })
                    end
                    
                    -- Clear decoration after testing
                    ClearPedDecorations(targetPed)
                end
            end
        end
    end
    
    return validDecorations
end