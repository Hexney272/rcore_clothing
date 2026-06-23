function CopyShopCategoryWithoutItems(categoryData)
    local copiedCategory = {}
    
    for key, value in pairs(categoryData) do
        if key ~= "items" then
            copiedCategory[key] = value
        end
    end
    
    return copiedCategory
end

function FilterShopStructure(shopStructure, availableItemsMap)
    if not availableItemsMap then
        return shopStructure
    end
    
    local filteredShop = {}
    
    for categoryIndex, categoryData in pairs(shopStructure) do
        local filteredItems = {}
        
        -- Filter items based on availability map
        for itemIndex, itemData in pairs(categoryData.items) do
            local itemId = itemData.id
            if availableItemsMap[itemId] then
                table.insert(filteredItems, itemData)
            end
        end
        
        -- Only include categories that have available items
        if #filteredItems > 0 then
            local filteredCategory = CopyShopCategoryWithoutItems(categoryData)
            filteredCategory.items = filteredItems
            table.insert(filteredShop, filteredCategory)
        end
    end
    
    return filteredShop
end