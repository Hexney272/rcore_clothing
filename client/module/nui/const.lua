-- UI Sound configuration table
-- Maps UI actions to their corresponding sound effects and soundsets
local UI_SOUND_EFFECTS = {}

-- Navigation sounds
UI_SOUND_EFFECTS.NAV_UP_DOWN = {
    name = "NAV_UP_DOWN",
    soundset = "HUD_FRONTEND_DEFAULT_SOUNDSET"
}

UI_SOUND_EFFECTS.BACK = {
    name = "BACK",
    soundset = "HUD_FRONTEND_DEFAULT_SOUNDSET"
}

UI_SOUND_EFFECTS.SELECT = {
    name = "SELECT",
    soundset = "HUD_FRONTEND_DEFAULT_SOUNDSET"
}

-- Purchase/transaction sounds
UI_SOUND_EFFECTS.PURCHASE = {
    name = "PURCHASE",
    soundset = "HUD_LIQUOR_STORE_SOUNDSET"
}

UI_SOUND_EFFECTS.PURCHASE_FAIL = {
    name = "OTHER_TEXT",
    soundset = "HUD_AWARDS"
}

-- Interface control sounds
UI_SOUND_EFFECTS.QUIT = {
    name = "QUIT",
    soundset = "HUD_FRONTEND_DEFAULT_SOUNDSET"
}

UI_SOUND_EFFECTS.QUIT_UI = {
    name = "QUIT",
    soundset = "HUD_FRONTEND_DEFAULT_SOUNDSET"
}

-- Shopping cart sounds
UI_SOUND_EFFECTS.CLEAR_CART = {
    name = "Whoosh_1s_L_to_R",
    soundset = "MP_LOBBY_SOUNDS"
}

UI_SOUND_EFFECTS.REMOVE_FROM_CART = {
    name = "Shard_Disappear",
    soundset = "GTAO_Boss_Goons_FM_Shard_Sounds"
}

-- Interaction sounds
UI_SOUND_EFFECTS.SLIDER_CHANGE = {
    name = "Pin_Centred",
    soundset = "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"
}

-- Item preview sounds
UI_SOUND_EFFECTS.PREVIEW_ITEM_1 = {
    name = "Reset_Prop_Position",
    soundset = "DLC_Dmod_Prop_Editor_Sounds"
}

UI_SOUND_EFFECTS.PREVIEW_ITEM_FESTIVE = {
    name = "FestiveGift",
    soundset = "Feed_Message_Sounds"
}

-- Global table (preserved for external access)
SOUNDS_BY_TYPE = UI_SOUND_EFFECTS