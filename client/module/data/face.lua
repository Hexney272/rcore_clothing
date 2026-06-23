function GetFaceFeaturesOptions()
    return {
        -- Nose Section
        {
            id = "face_features_nose",
            type = "paragraph",
            title = _U("char_creator.face_features.nose.title"),
            description = _U("char_creator.face_features.nose.description")
        },
        {
            isGroupStart = true,
            label = _U("face_features.nose_width"),
            faceFeatureId = 0,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.nose_width_min"),
            maxLabel = _U("char_creator.slider_labels.nose_width_max")
        },
        {
            label = _U("face_features.nose_peak_height"),
            faceFeatureId = 1,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.nose_peak_height_min"),
            maxLabel = _U("char_creator.slider_labels.nose_peak_height_max")
        },
        {
            label = _U("face_features.nose_peak_lenght"),
            faceFeatureId = 2,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.nose_peak_lenght_min"),
            maxLabel = _U("char_creator.slider_labels.nose_peak_lenght_max")
        },
        {
            label = _U("face_features.nose_bone_high"),
            faceFeatureId = 3,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.nose_bone_high_min"),
            maxLabel = _U("char_creator.slider_labels.nose_bone_high_max")
        },
        {
            label = _U("face_features.nose_peak_lowering"),
            faceFeatureId = 4,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.nose_peak_lowering_min"),
            maxLabel = _U("char_creator.slider_labels.nose_peak_lowering_max")
        },
        {
            isGroupEnd = true,
            label = _U("face_features.nose_bone_twist"),
            faceFeatureId = 5,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.nose_bone_twist_min"),
            maxLabel = _U("char_creator.slider_labels.nose_bone_twist_max")
        },
        
        -- Eyebrows Section
        {
            id = "face_features_eyebrows",
            type = "paragraph",
            title = _U("char_creator.face_features.eyebrows.title"),
            description = _U("char_creator.face_features.eyebrows.description")
        },
        {
            isGroupStart = true,
            label = _U("face_features.eyebrow_height"),
            faceFeatureId = 6,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.eyebrow_height_min"),
            maxLabel = _U("char_creator.slider_labels.eyebrow_height_max")
        },
        {
            isGroupEnd = true,
            label = _U("face_features.eyebrow_forward"),
            faceFeatureId = 7,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.eyebrow_forward_min"),
            maxLabel = _U("char_creator.slider_labels.eyebrow_forward_max")
        },
        
        -- Cheeks Section
        {
            id = "face_features_cheeks",
            type = "paragraph",
            title = _U("char_creator.face_features.cheeks.title"),
            description = _U("char_creator.face_features.cheeks.description"),
            minLabel = _U("char_creator.slider_labels.cheeks_min"),
            maxLabel = _U("char_creator.slider_labels.cheeks_max")
        },
        {
            isGroupStart = true,
            label = _U("face_features.cheeks_bone_high"),
            faceFeatureId = 8,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.cheeks_bone_high_min"),
            maxLabel = _U("char_creator.slider_labels.cheeks_bone_high_max")
        },
        {
            label = _U("face_features.cheeks_bone_width"),
            faceFeatureId = 9,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.cheeks_bone_width_min"),
            maxLabel = _U("char_creator.slider_labels.cheeks_bone_width_max")
        },
        {
            isGroupEnd = true,
            label = _U("face_features.cheeks_width"),
            faceFeatureId = 10,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.cheeks_width_min"),
            maxLabel = _U("char_creator.slider_labels.cheeks_width_max")
        },
        
        -- Jaw Section
        {
            id = "face_features_jaw",
            type = "paragraph",
            title = _U("char_creator.face_features.jaw.title"),
            description = _U("char_creator.face_features.jaw.description"),
            minLabel = _U("char_creator.slider_labels.jaw_min"),
            maxLabel = _U("char_creator.slider_labels.jaw_max")
        },
        {
            isGroupStart = true,
            label = _U("face_features.jaw_bone_width"),
            faceFeatureId = 13,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.jaw_bone_width_min"),
            maxLabel = _U("char_creator.slider_labels.jaw_bone_width_max")
        },
        {
            label = _U("face_features.jaw_bone_back_lenght"),
            faceFeatureId = 14,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.jaw_bone_back_lenght_min"),
            maxLabel = _U("char_creator.slider_labels.jaw_bone_back_lenght_max")
        },
        {
            label = _U("face_features.chimp_bone_lowering"),
            faceFeatureId = 15,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.chimp_bone_lowering_min"),
            maxLabel = _U("char_creator.slider_labels.chimp_bone_lowering_max")
        },
        {
            label = _U("face_features.chimp_bone_lenght"),
            faceFeatureId = 16,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.chimp_bone_lenght_min"),
            maxLabel = _U("char_creator.slider_labels.chimp_bone_lenght_max")
        },
        {
            label = _U("face_features.chimp_bone_width"),
            faceFeatureId = 17,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.chimp_bone_width_min"),
            maxLabel = _U("char_creator.slider_labels.chimp_bone_width_max")
        },
        {
            isGroupEnd = true,
            label = _U("face_features.chimp_hole"),
            faceFeatureId = 18,
            type = "face_feature_slider",
            min = 0.0,
            max = 1.0,
            step = 0.05,
            minLabel = _U("char_creator.slider_labels.chimp_hole_min"),
            maxLabel = _U("char_creator.slider_labels.chimp_hole_max")
        },
        
        -- Other Features Section
        {
            id = "face_features_other",
            type = "paragraph",
            title = _U("char_creator.face_features.other.title"),
            description = _U("char_creator.face_features.other.description")
        },
        {
            isGroupStart = true,
            label = _U("face_features.eyes_openning"),
            faceFeatureId = 11,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.eyes_openning_min"),
            maxLabel = _U("char_creator.slider_labels.eyes_openning_max")
        },
        {
            label = _U("face_features.lips_thickness"),
            faceFeatureId = 12,
            type = "face_feature_slider",
            min = -1.0,
            max = 1.0,
            step = 0.1,
            minLabel = _U("char_creator.slider_labels.lips_thickness_min"),
            maxLabel = _U("char_creator.slider_labels.lips_thickness_max")
        },
        {
            isGroupEnd = true,
            label = _U("face_features.neck_thickness"),
            faceFeatureId = 19,
            type = "face_feature_slider",
            min = 0.0,
            max = 1.0,
            step = 0.05,
            minLabel = _U("char_creator.slider_labels.neck_thickness_min"),
            maxLabel = _U("char_creator.slider_labels.neck_thickness_max")
        }
    }
end

function GetAvailableMalePeds()
    local malePedConfig = ConfigPeds.AvailablePeds.FormattedMale
    if not malePedConfig then
        return {
            label = "mp_m_freemode_01",
            hash = 1885233650
        }
    end
    return malePedConfig
end

function GetAvailableFemalePeds()
    local femalePedConfig = ConfigPeds.AvailablePeds.FormattedFemale
    if not femalePedConfig then
        return {
            label = "mp_f_freemode_01",
            hash = -1667301416
        }
    end
    return femalePedConfig
end

function CreateHeadOverlayCategory(overlayId, labelKey, imageFile, hasColorOptions, hasSecondaryColor)
    local category = {
        id = "headOverlay_" .. overlayId,
        type = "category",
        label = _U(labelKey),
        image = "*img/card_img/" .. imageFile .. ".webp",
        headOverlayId = overlayId,
        subtype = "head_overlay",
        items = {
            {
                type = "paragraph",
                id = "headoverlay_" .. imageFile,
                description = _U("char_creator." .. imageFile .. ".description")
            },
            {
                type = "number",
                label = _U("head_option_items.style"),
                min = -1,
                max = GetNumHeadOverlayValues(overlayId) - 1
            },
            {
                type = "size",
                label = _U("head_option_items.opacity"),
                min = 0,
                max = 10
            }
        }
    }
    
    if hasColorOptions then
        table.insert(category.items, {
            type = "color",
            label = _U("head_option_items.color"),
            min = 0,
            max = GetNumHairColors() - 1
        })
    end
    
    if hasSecondaryColor then
        table.insert(category.items, {
            type = "color_2",
            label = _U("head_option_items.highlight"),
            min = 0,
            max = GetNumMakeupColors() - 1
        })
    end
    
    return category
end

function GetHeadOptions(targetPed)
    local hairOptions = {
        {
            id = "hair",
            type = "paragraph",
            description = _U("char_creator.hair.description")
        },
        {
            type = "number",
            label = _U("head_option_items.hair_style"),
            min = 0,
            max = GetNumberOfPedDrawableVariations(targetPed, 2) - 1
        }
    }
    
    local isFreemodeModel = IsModelFreemode(GetEntityModel(targetPed))
    
    if isFreemodeModel then
        table.insert(hairOptions, {
            type = "color",
            label = _U("head_option_items.color"),
            min = 0,
            max = GetNumHairColors() - 1
        })
        table.insert(hairOptions, {
            type = "color_2",
            label = _U("head_option_items.highlight"),
            min = 0,
            max = GetNumHairColors() - 1
        })
    end
    
    local headCategories = {
        -- Ped Selection
        {
            id = "ped_select",
            type = "category",
            subtype = "ped_select",
            label = _U("charater_options.pedselect"),
            items = {
                {
                    id = "face_features_ped_select",
                    type = "paragraph",
                    description = _U("char_creator.ped_select.description")
                },
                {
                    type = "ped_select",
                    malePeds = GetAvailableMalePeds(),
                    femalePeds = GetAvailableFemalePeds()
                }
            },
            image = "*img/card_img/pedselect.webp"
        },
        
        -- Face Features
        {
            id = "face_features",
            type = "category",
            subtype = "face_features",
            label = _U("charater_options.face_features"),
            items = GetFaceFeaturesOptions(),
            image = "*img/card_img/facefeatures.webp"
        },
        
        -- Hair
        {
            id = "hair",
            type = "category",
            subtype = "hair",
            label = _U("charater_options.hair"),
            items = hairOptions,
            image = "*img/card_img/hair.webp"
        },
        
        -- Head Overlays
        CreateHeadOverlayCategory(0, "charater_options.blemish", "blemish", false, false),
        CreateHeadOverlayCategory(1, "charater_options.beard", "beard", true, false),
        CreateHeadOverlayCategory(2, "charater_options.eyebrows", "eyebrows", true, false),
        CreateHeadOverlayCategory(3, "charater_options.age", "age", false, false),
        CreateHeadOverlayCategory(4, "charater_options.makeup", "makeup", true, true),
        CreateHeadOverlayCategory(5, "charater_options.blush", "blush", true, false),
        CreateHeadOverlayCategory(6, "charater_options.complexion", "complexion", false, false),
        CreateHeadOverlayCategory(7, "charater_options.sun", "sun", false, false),
        CreateHeadOverlayCategory(8, "charater_options.lipstick", "lipstick", true, false),
        CreateHeadOverlayCategory(9, "charater_options.moles", "moles", false, false),
        CreateHeadOverlayCategory(10, "charater_options.chest", "chest", true, false),
        CreateHeadOverlayCategory(11, "charater_options.bodyb", "bodyb", false, false),
        
        -- Eye Color
        {
            id = "eye_color",
            type = "category",
            subtype = "eye_color",
            label = _U("charater_options.eye_color"),
            image = "*img/card_img/eye_color.webp",
            items = {
                {
                    type = "paragraph",
                    id = "eye_color",
                    description = _U("char_creator.eye_color.description")
                },
                {
                    type = "type_eye_color",
                    label = "",
                    options = MakeIndexedObjectSafeForFrontend(Config.AvailableEyes),
                    min = 0,
                    max = 29
                }
            }
        }
    }
    
    -- Insert model-specific head options
    if isFreemodeModel then
        table.insert(headCategories, 2, {
            id = "headblend",
            type = "category",
            subtype = "headblend",
            label = _U("charater_options.headblend"),
            items = {
                {
                    id = "face_features_headblend",
                    type = "paragraph",
                    description = _U("char_creator.headblend.description")
                },
                {
                    id = "face_features_headblend_2",
                    type = "paragraph",
                    description = _U("char_creator.headblend.description2")
                },
                {
                    type = "headblend",
                    maleIds = GetMaleHeadBlends(),
                    femaleIds = GetFemaleHeadBlends()
                }
            },
            image = "*img/card_img/headblend.webp"
        })
    else
        table.insert(headCategories, 2, {
            id = "nonfreemode_head",
            type = "category",
            subtype = "head_overlay",
            label = _U("charater_options.head"),
            items = {
                {
                    id = "headoverlay_head",
                    type = "number",
                    label = _U("ui.id_only_mode.drawable"),
                    min = 0,
                    max = GetNumberOfPedDrawableVariations(targetPed, 0) - 1
                },
                {
                    id = "headoverlay_head_texture",
                    type = "number_2",
                    label = _U("ui.id_only_mode.texture"),
                    min = 0,
                    max = GetNumberOfPedTextureVariations(targetPed, 0, GetPedDrawableVariation(targetPed, 0)) - 1
                }
            },
            image = "*img/card_img/headblend.webp"
        })
    end
    
    return headCategories
end

function GetBaseMaleHeadBlends()
    local maleHeadCount = GetPedHeadBlendNumHeads(0)
    local overlayHeadCount = GetPedHeadBlendNumHeads(2)
    local femaleHeadCount = GetPedHeadBlendNumHeads(1)
    
    local maleBlends = {}
    
    -- Add base male heads
    for i = 0, maleHeadCount - 1 do
        table.insert(maleBlends, i)
    end
    
    -- Add overlay heads
    for i = maleHeadCount + overlayHeadCount, maleHeadCount + overlayHeadCount + femaleHeadCount - 1 do
        table.insert(maleBlends, i)
    end
    
    return maleBlends
end

function GetBaseFemaleHeadBlends()
    local maleHeadCount = GetPedHeadBlendNumHeads(0)
    local overlayHeadCount = GetPedHeadBlendNumHeads(2)
    local femaleHeadCount = GetPedHeadBlendNumHeads(1)
    local extraHeadCount = GetPedHeadBlendNumHeads(3)
    
    local femaleBlends = {}
    
    -- Add female heads
    for i = maleHeadCount, maleHeadCount + overlayHeadCount - 1 do
        table.insert(femaleBlends, i)
    end
    
    -- Add extra heads
    for i = maleHeadCount + overlayHeadCount + femaleHeadCount, maleHeadCount + overlayHeadCount + femaleHeadCount + extraHeadCount - 1 do
        table.insert(femaleBlends, i)
    end
    
    return femaleBlends
end

function GetMaleHeadBlends()
    local maleBlends = GetBaseMaleHeadBlends()
    
    -- Add female blends to male options
    for _, femaleBlend in pairs(GetBaseFemaleHeadBlends()) do
        table.insert(maleBlends, femaleBlend)
    end
    
    -- Add addon heads if configured
    if Config.AddonHeadsCount then
        for i = 46, 46 + Config.AddonHeadsCount do
            table.insert(maleBlends, i)
        end
    end
    
    return maleBlends
end

function GetFemaleHeadBlends()
    local femaleBlends = GetBaseFemaleHeadBlends()
    
    -- Add male blends to female options
    for _, maleBlend in pairs(GetBaseMaleHeadBlends()) do
        table.insert(femaleBlends, maleBlend)
    end
    
    -- Add addon heads if configured
    if Config.AddonHeadsCount then
        for i = 46, 46 + Config.AddonHeadsCount do
            table.insert(femaleBlends, i)
        end
    end
    
    return femaleBlends
end