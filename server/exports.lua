function GetSkinByIdentifier(playerIdentifier)
    local outfitData = DbGetCurrentOutfit(playerIdentifier)
    
    if #outfitData > 0 then
        local currentOutfit = outfitData[1]
        local skinData = {
            ped_model = currentOutfit.ped_model,
            skin = json.decode(currentOutfit.outfit)
        }
        
        return skinData
    else
        return {}
    end
end

exports("getSkinByIdentifier", GetSkinByIdentifier)