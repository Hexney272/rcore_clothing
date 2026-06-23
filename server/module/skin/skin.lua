local L0_1, L1_1, L2_1
L0_1 = RegisterNetEvent
L1_1 = "rcore_clothing:requestSkinByIdentifier"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = source
  if -1 == A1_2 then
    L3_2 = GetPlayerFwIdentifier
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    A1_2 = L3_2
  end
  L3_2 = DbGetCurrentOutfit
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L4_2 = #L3_2
  if L4_2 > 0 then
    L4_2 = L3_2[1]
    L5_2 = TriggerClientEvent
    L6_2 = "rcore_clothing:responseSkinByIdentifier"
    L7_2 = L2_2
    L8_2 = A0_2
    L9_2 = {}
    L10_2 = L4_2.ped_model
    L9_2.ped_model = L10_2
    L10_2 = json
    L10_2 = L10_2.decode
    L11_2 = L4_2.outfit
    L10_2 = L10_2(L11_2)
    L9_2.skin = L10_2
    L5_2(L6_2, L7_2, L8_2, L9_2)
  else
    L4_2 = TriggerClientEvent
    L5_2 = "rcore_clothing:responseSkinByIdentifier"
    L6_2 = L2_2
    L7_2 = A0_2
    L8_2 = {}
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
end
L0_1(L1_1, L2_1)
