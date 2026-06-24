-- rcore_clothing interakció — real_markers alapú rendszer
-- A real_markers script exportjait használja a markerek megjelenítéséhez

local markersRegistered = false

local function openShop(shop)
    if not shop.config then
        shop.config = {}
    end

    if not shop.config.modifiers then
        shop.config.modifiers = {}
    end

    if Config.EveryShopHasEverything then
        shop.config.modifiers[SHOP_MODIFIERS.HAS_EVERYTHING] = true
    end

    if Config.IdModeHasEverything then
        shop.config.modifiers[SHOP_MODIFIERS.ID_MODE_HAS_EVERYTHING] = true
    end

    SetPedInShopHeading(shop.pos)
    RequestOpenClothingShopUI(shop.type, shop.config)
end

local function openJobChangingRoom(room)
    room.config = {
        structure = SHOP_CONFIG_ALIAS.CLOTHING.structure,
        modifiers = {
            [SHOP_MODIFIERS.IS_EVERYTHING_FREE] = true,
            [SHOP_MODIFIERS.JOB_CHANGING_ROOM] = true,
        }
    }

    if Config.JobChangingRoomActsAsPersonalChangingRoom then
        room.config.modifiers[SHOP_MODIFIERS.CHANGING_ROOM] = true
    end

    SetPedInShopHeading(room.pos)
    RequestOpenClothingShopUI(room.type, room.config)
end

function SetPedInShopHeading(coords)
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    SetEntityHeading(ped, coords.w)
end

function StartRenderingMarkers()
    -- real_markers kezeli a renderelést, nem kell külön
end

function StopRenderingMarkers()
    -- real_markers kezeli a renderelést, nem kell külön
end

-- Interakciós event handler-ek
RegisterNetEvent('rcore_clothing:marker:openShop', function(markerId, args)
    local shopIndex = args and args.shopIndex
    if not shopIndex then return end
    local shop = Config.ClothingShops[shopIndex]
    if shop then
        openShop(shop)
    end
end)

RegisterNetEvent('rcore_clothing:marker:openJobRoom', function(markerId, args)
    local roomIndex = args and args.roomIndex
    if not roomIndex then return end
    local room = Config.JobChangingRooms[roomIndex]
    if room then
        openJobChangingRoom(room)
    end
end)

RegisterNetEvent('rcore_clothing:marker:openChangingRoom', function(markerId, args)
    local roomIndex = args and args.roomIndex
    if not roomIndex then return end
    local room = Config.ChangingRooms[roomIndex]
    if room then
        SetPedInShopHeading(room.pos)
        TriggerEvent('rcore_clothing:openChangingRoom')
    end
end)

-- Markerek regisztrálása a real_markers rendszerbe
CreateThread(function()
    -- Várjuk meg, hogy a real_markers elinduljon
    local timeout = 0
    while GetResourceState('real_markers') ~= 'started' and timeout < 10 do
        Wait(1000)
        timeout = timeout + 1
    end

    if GetResourceState('real_markers') ~= 'started' then
        print("^1[rcore_clothing] real_markers resource nincs elindítva! A markerek nem fognak megjelenni.^7")
        return
    end

    Wait(500)

    -- Ruhaboltok regisztrálása
    for index, shop in ipairs(Config.ClothingShops) do
        local style = 'clothing'
        local title = 'Ruhabolt'
        local icon = 'clothing'

        if shop.type == 'barber' then
            title = 'Borbély'
            icon = 'scissors'
        elseif shop.type == 'tattoo' or shop.type == 'tattoos' then
            title = 'Tetoválás'
        end

        local helpText = '~INPUT_CONTEXT~ ' .. title
        local markerData = {
            style = style,
            coords = vec3(shop.pos.x, shop.pos.y, shop.pos.z),
            title = title,
            helpText = helpText,
            icon = icon,
            useImage = true,
            imageScale = 2.5,
            zOffset = 0.85,
            event = 'rcore_clothing:marker:openShop',
            args = { shopIndex = index },
        }

        -- Job-restricted shop esetén visibility beállítás
        if shop.jobs and #shop.jobs > 0 then
            local jobPerms = {}
            for _, job in ipairs(shop.jobs) do
                jobPerms[job] = 0
            end
            markerData.visibility = { jobs = jobPerms }
        end

        exports['real_markers']:RegisterImageMarker('rcore_shop_' .. index, markerData)
    end

    -- Munkahelyi öltözők regisztrálása
    for index, room in ipairs(Config.JobChangingRooms) do
        local title = room.label or _U("interact.job_changing_room")
        local helpText = '~INPUT_CONTEXT~ ' .. title

        local jobPerms = {}
        if room.jobs then
            for _, job in ipairs(room.jobs) do
                jobPerms[job] = 0
            end
        end

        exports['real_markers']:RegisterImageMarker('rcore_jobroom_' .. index, {
            style = 'clothing',
            coords = vec3(room.pos.x, room.pos.y, room.pos.z),
            title = title,
            helpText = helpText,
            icon = 'clothing',
            useImage = true,
            imageScale = 2.5,
            zOffset = 0.85,
            event = 'rcore_clothing:marker:openJobRoom',
            args = { roomIndex = index },
            visibility = { jobs = jobPerms },
        })
    end

    -- Öltözők regisztrálása
    for index, room in ipairs(Config.ChangingRooms) do
        local title = _U("interact.changing_room")
        local helpText = '~INPUT_CONTEXT~ ' .. title

        exports['real_markers']:RegisterImageMarker('rcore_changing_' .. index, {
            style = 'clothing',
            coords = vec3(room.pos.x, room.pos.y, room.pos.z),
            title = 'Öltöző',
            helpText = helpText,
            icon = 'clothing',
            useImage = true,
            imageScale = 2.5,
            zOffset = 0.85,
            event = 'rcore_clothing:marker:openChangingRoom',
            args = { roomIndex = index },
        })
    end

    markersRegistered = true
    print("^2[rcore_clothing] Markerek sikeresen regisztrálva a real_markers rendszerbe (" .. #Config.ClothingShops .. " bolt, " .. #Config.JobChangingRooms .. " munkahelyi öltöző, " .. #Config.ChangingRooms .. " öltöző)^7")
end)

-- Takarítás resource stop-nál
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if not markersRegistered then return end
    if GetResourceState('real_markers') ~= 'started' then return end

    for index, _ in ipairs(Config.ClothingShops) do
        exports['real_markers']:RemoveCustomMarker('rcore_shop_' .. index)
    end
    for index, _ in ipairs(Config.JobChangingRooms) do
        exports['real_markers']:RemoveCustomMarker('rcore_jobroom_' .. index)
    end
    for index, _ in ipairs(Config.ChangingRooms) do
        exports['real_markers']:RemoveCustomMarker('rcore_changing_' .. index)
    end
end)
