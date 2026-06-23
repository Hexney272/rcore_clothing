function IterateOverVariations(pedEntity, componentId, preWait, postWait, callback)
    local pedModel = GetEntityModel(pedEntity)
    model = pedModel -- Global variable preserved
    
    local actualComponentId = componentId
    
    -- Handle special component ID mappings
    if componentId == 110 or componentId == 111 then
        actualComponentId = 11  -- Torso variations
    elseif componentId == 80 or componentId == 81 then
        actualComponentId = 8   -- Undershirt variations
    end
    
    local maxDrawable = GetNumberOfPedDrawableVariations(pedEntity, actualComponentId) - 1
    local drawableStart = 0
    local drawableEnd = maxDrawable
    local midPoint = math.floor(maxDrawable / 2)
    
    -- Split drawable range based on component ID
    if componentId == 110 or componentId == 80 then
        -- First half of variations
        drawableStart = 0
        drawableEnd = midPoint
    elseif componentId == 111 or componentId == 81 then
        -- Second half of variations
        drawableStart = midPoint + 1
        drawableEnd = maxDrawable
    end
    
    for drawableId = drawableStart, drawableEnd do
        local maxTexture = GetNumberOfPedTextureVariations(pedEntity, actualComponentId, drawableId) - 1
        
        for textureId = 0, maxTexture do
            local finalTextureId = textureId
            
            -- Special handling for hair component (ID 2)
            if actualComponentId == 2 then
                finalTextureId = 0
            end
            
            local isVariationValid = IsPedComponentVariationValid(pedEntity, actualComponentId, drawableId, finalTextureId)
            local isNotGen9Exclusive = not IsPedComponentVariationGen9Exclusive(pedEntity, actualComponentId, drawableId)
            
            if isVariationValid and isNotGen9Exclusive then
                Wait(preWait)
                callback(pedModel, actualComponentId, drawableId, textureId)
                Wait(postWait)
            end
        end
    end
end

function IterateOverProps(pedEntity, propId, preWait, postWait, callback)
    local pedModel = GetEntityModel(pedEntity)
    model = pedModel -- Global variable preserved
    
    local maxDrawable = GetNumberOfPedPropDrawableVariations(pedEntity, propId) - 1
    
    for drawableId = 0, maxDrawable do
        local maxTexture = GetNumberOfPedPropTextureVariations(pedEntity, propId, drawableId) - 1
        
        for textureId = 0, maxTexture do
            Wait(preWait)
            callback(pedModel, propId, drawableId, textureId)
            Wait(postWait)
        end
    end
    
    -- Clear the prop after iteration
    ClearPedProp(pedEntity, propId)
end