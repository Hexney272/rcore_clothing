function GetForcedComponents(pedEntity, apparelVariant)
    local forcedComponentCount = GetShopPedApparelForcedComponentCount(apparelVariant)
    local armsComponentId = 3
    local torsoComponentId = 10
    local forcedComponents = {}
    
    for componentIndex = 0, forcedComponentCount - 1 do
        local nameHash, drawableId, componentId = GetForcedComponent(apparelVariant, componentIndex)
        local finalDrawableId = nil
        local finalTextureId = nil
        
        if componentId == armsComponentId then
            -- Handle arms component (3)
            if nameHash == 0 or nameHash == 1849449579 then
                finalDrawableId = drawableId
                finalTextureId = 0
            else
                local shopComponent = GetShopPedComponent(nameHash)
                if shopComponent.Drawable then
                    componentId = shopComponent.ComponentType
                    finalDrawableId = shopComponent.Drawable
                    finalTextureId = shopComponent.Texture
                    shouldShortSleep = true -- Global variable preserved
                else
                    finalDrawableId = drawableId
                    finalTextureId = 0
                end
            end
            
            local isValidVariation = IsPedComponentVariationValid(pedEntity, componentId, finalDrawableId, finalTextureId)
            if isValidVariation then
                table.insert(forcedComponents, {
                    nameHash = nameHash,
                    componentId = componentId,
                    drawableId = finalDrawableId,
                    textureId = finalTextureId
                })
            end
            
        elseif componentId == torsoComponentId then
            -- Handle torso component (10)
            if nameHash ~= 0 and nameHash ~= 1849449579 then
                local shopComponent = GetShopPedComponent(nameHash)
                if shopComponent and shopComponent.Drawable > 0 then
                    local isValidVariation = IsPedComponentVariationValid(
                        pedEntity,
                        shopComponent.ComponentType,
                        shopComponent.Drawable,
                        shopComponent.Texture
                    )
                    
                    if isValidVariation then
                        table.insert(forcedComponents, {
                            nameHash = nameHash,
                            componentId = shopComponent.ComponentType,
                            drawableId = shopComponent.Drawable,
                            textureId = shopComponent.Texture
                        })
                    end
                end
            end
            
        else
            -- Handle other components
            if nameHash ~= 0 and nameHash ~= 1849449579 then
                local shopComponent = GetShopPedComponent(nameHash)
                if shopComponent and shopComponent.Drawable > 0 then
                    local isValidVariation = IsPedComponentVariationValid(
                        pedEntity,
                        shopComponent.ComponentType,
                        shopComponent.Drawable,
                        shopComponent.Texture
                    )
                    
                    if isValidVariation then
                        table.insert(forcedComponents, {
                            nameHash = nameHash,
                            componentId = shopComponent.ComponentType,
                            drawableId = shopComponent.Drawable,
                            textureId = shopComponent.Texture
                        })
                    end
                end
            end
        end
    end
    
    return forcedComponents
end