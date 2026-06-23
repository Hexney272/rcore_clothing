local L0_1, L1_1, L2_1
L0_1 = RegisterNetEvent
L1_1 = "rcore_clothing:savePersonalOutfit"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = source
  L3_2 = GetPlayerPed
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = GetEntityModel
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = GetPlayerFwIdentifier
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L6_2 = DbSavePersonalOutfit
  L7_2 = L5_2
  L8_2 = L4_2
  L9_2 = A0_2
  L10_2 = A1_2
  L6_2(L7_2, L8_2, L9_2, L10_2)
end
L0_1(L1_1, L2_1)
L0_1 = RegisterNetEvent
L1_1 = "rcore_clothing:saveShopOutfit"
function L2_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L6_2 = source
  L7_2 = GetPlayerPed
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  L8_2 = GetEntityModel
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  L9_2 = AceCan
  L10_2 = source
  L11_2 = Permissions
  L11_2 = L11_2.ADMIN_OUTFIT_EDITOR
  L9_2 = L9_2(L10_2, L11_2)
  if L9_2 then
    L9_2 = DbSaveShopOutfit
    L10_2 = L8_2
    L11_2 = A0_2
    L12_2 = A1_2
    L13_2 = A2_2
    L14_2 = A3_2
    L15_2 = A4_2
    L16_2 = A5_2
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  else
    L9_2 = print
    L10_2 = "^1Player with id "
    L11_2 = source
    L12_2 = " tried to save shop outfit without permission."
    L10_2 = L10_2 .. L11_2 .. L12_2
    L9_2(L10_2)
  end
end
L0_1(L1_1, L2_1)
L0_1 = RegisterNetEvent
L1_1 = "rcore_clothing:getPersonalOutfits"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = source
  L2_2 = GetPlayerPed
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L3_2 = GetEntityModel
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = GetPlayerFwIdentifier
  L5_2 = L1_2
  L4_2 = L4_2(L5_2)
  L5_2 = DbGetPersonalOutfits
  L6_2 = L4_2
  L7_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = TriggerClientEvent
  L7_2 = "rcore_clothing:setPersonalOutfits"
  L8_2 = L1_2
  L9_2 = A0_2
  L10_2 = L5_2
  L6_2(L7_2, L8_2, L9_2, L10_2)
end
L0_1(L1_1, L2_1)
L0_1 = RegisterNetEvent
L1_1 = "rcore_clothing:getShopOutfits"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = source
  L3_2 = GetPlayerPed
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = GetEntityModel
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = FwGetPlayerJobData
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2.name
  L7_2 = L5_2.grade
  L8_2 = AppendAces
  L9_2 = L2_2
  L10_2 = GetPlayerIdentifiers
  L11_2 = L2_2
  L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L9_2 = DbGetShopOutfits
  L10_2 = L4_2
  L11_2 = A1_2
  L12_2 = L6_2
  L13_2 = L7_2
  L14_2 = L8_2
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
  L10_2 = DbEnrichOutfitsWithRestrictions
  L11_2 = L9_2
  L10_2 = L10_2(L11_2)
  L9_2 = L10_2
  L10_2 = TriggerClientEvent
  L11_2 = "rcore_clothing:setShopOutfits"
  L12_2 = L2_2
  L13_2 = A0_2
  L14_2 = L9_2
  L10_2(L11_2, L12_2, L13_2, L14_2)
end
L0_1(L1_1, L2_1)
L0_1 = RegisterNetEvent
L1_1 = "rcore_clothing:editShopOutfit"
function L2_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L5_2 = source
  L6_2 = AceCan
  L7_2 = L5_2
  L8_2 = Permissions
  L8_2 = L8_2.ADMIN_EDIT_METADATA
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L6_2 = DbEditShopOutfit
    L7_2 = A0_2
    L8_2 = A1_2
    L9_2 = A2_2
    L10_2 = A3_2
    L11_2 = A4_2
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  else
    L6_2 = print
    L7_2 = "^1Player with id "
    L8_2 = L5_2
    L9_2 = " tried to edit shop outfit metadata without permission."
    L7_2 = L7_2 .. L8_2 .. L9_2
    L6_2(L7_2)
  end
end
L0_1(L1_1, L2_1)
