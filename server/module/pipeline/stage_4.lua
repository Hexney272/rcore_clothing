local L0_1, L1_1, L2_1, L3_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = SetPlayerRoutingBucket
  L2_2 = A0_2
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
  L1_2 = GetResourceState
  L2_2 = "rcore_clothing_for_photos"
  L1_2 = L1_2(L2_2)
  if "started" ~= L1_2 then
    L1_2 = print
    L2_2 = "^1[ERROR]^7 rcore_clothing_for_photos is required for taking photos"
    L1_2(L2_2)
    L1_2 = print
    L2_2 = "^1[ERROR]^7 please start it and restart your game"
    L1_2(L2_2)
    return
  end
  L1_2 = TriggerEvent
  L2_2 = "rcore_clothing:getHeads"
  function L3_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = #A0_3
    if L1_3 > 0 then
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6 THIS IS NOT AN ERROR IN RCORE_CLOTHING"
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6 Please read carefully."
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6"
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6 You have some replaced heads in your server that will"
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6 prevent the script from making your head invisible while taking photos"
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6 Please rename the following files (for example add _ at the start of the file name)"
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6 restart your server and try to take photos again."
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6 Once all photo steps are done, rename the files back"
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6 and disable/do not start rcore_clothing_for_photos resource"
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^1[READ_THIS]^6 Files that need renaming:"
      L1_3(L2_3)
      L1_3 = tprint
      L2_3 = A0_3
      L1_3(L2_3)
    else
      L1_3 = TriggerClientEvent
      L2_3 = "rcore_clothing:pipelineInitStage4"
      L3_3 = A0_2
      L4_3 = 1885233650
      L5_3 = GetServerSecret
      L5_3 = L5_3()
      L1_3(L2_3, L3_3, L4_3, L5_3)
    end
  end
  L1_2(L2_2, L3_2)
end
StartInitStage4 = L0_1
L0_1 = 0
L1_1 = RegisterNetEvent
L2_1 = "rcore_clothing:getStage4DataToProcess"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = source
  if not A1_2 then
    A1_2 = L0_1
  end
  L3_2 = DbGetDataForStage4
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2)
  L0_1 = A1_2
  L5_2 = TriggerClientEvent
  L6_2 = "rcore_clothing:receiveStage4DataToProcess"
  L7_2 = L2_2
  L8_2 = GetServerSecret
  L8_2 = L8_2()
  L9_2 = L3_2
  L10_2 = L4_2
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
end
L1_1(L2_1, L3_1)
L1_1 = RegisterNetEvent
L2_1 = "rcore_clothing:stage4SoftBlacklist"
function L3_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = MySQL
  L1_2 = L1_2.Sync
  L1_2 = L1_2.execute
  L2_2 = "UPDATE rcore_clothing_items SET is_soft_blacklisted=1 WHERE id = @id"
  L3_2 = {}
  L3_2["@id"] = A0_2
  L1_2(L2_2, L3_2)
end
L1_1(L2_1, L3_1)
