local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1
L0_1 = {}
L1_1 = 2
L2_1 = 3
L3_1 = 4
L4_1 = 5
L5_1 = 6
L6_1 = 8
L7_1 = 9
L8_1 = 11
L9_1 = 100
L10_1 = 101
L11_1 = 102
L12_1 = 106
L13_1 = 107
L0_1[1] = L1_1
L0_1[2] = L2_1
L0_1[3] = L3_1
L0_1[4] = L4_1
L0_1[5] = L5_1
L0_1[6] = L6_1
L0_1[7] = L7_1
L0_1[8] = L8_1
L0_1[9] = L9_1
L0_1[10] = L10_1
L0_1[11] = L11_1
L0_1[12] = L12_1
L0_1[13] = L13_1
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = 1
  L2_2 = L0_1
  L2_2 = #L2_2
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = L0_1
    L5_2 = L5_2[L4_2]
    if L5_2 == A0_2 then
      L5_2 = true
      return L5_2
    end
  end
  L1_2 = false
  return L1_2
end
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = SetPlayerRoutingBucket
  L4_2 = A0_2
  L5_2 = A0_2
  L3_2(L4_2, L5_2)
  L3_2 = GetResourceState
  L4_2 = "rcore_clothing_for_photos"
  L3_2 = L3_2(L4_2)
  if "started" ~= L3_2 then
    L3_2 = print
    L4_2 = "^1[ERROR]^7 rcore_clothing_for_photos is required for taking photos"
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "^1[ERROR]^7 please start it and restart your game"
    L3_2(L4_2)
    return
  end
  L3_2 = TriggerEvent
  L4_2 = "rcore_clothing:getHeads"
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
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
      L1_3 = A2_2
      if L1_3 then
        L1_3 = L1_1
        L2_3 = A2_2
        L1_3 = L1_3(L2_3)
        if not L1_3 then
          L1_3 = print
          L2_3 = "^1[ERROR]^7 Invalid component id. Valid components:"
          L3_3 = table
          L3_3 = L3_3.concat
          L4_3 = L0_1
          L5_3 = ", "
          L3_3, L4_3, L5_3, L6_3, L7_3 = L3_3(L4_3, L5_3)
          L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
          return
        end
      end
      L1_3 = TriggerClientEvent
      L2_3 = "rcore_clothing:pipelineInitStage2"
      L3_3 = A0_2
      L4_3 = 1885233650
      L5_3 = GetServerSecret
      L5_3 = L5_3()
      L6_3 = A1_2
      L7_3 = A2_2
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
    end
  end
  L3_2(L4_2, L5_2)
end
StartInitStage2 = L2_1
L2_1 = RegisterNetEvent
L3_1 = "rcore_clothing:getDataToProcess"
function L4_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = source
  L5_2 = DbGetDataForStage2
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L9_2 = A3_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L7_2 = TriggerClientEvent
  L8_2 = "rcore_clothing:receiveDataToProcess"
  L9_2 = L4_2
  L10_2 = GetServerSecret
  L10_2 = L10_2()
  L11_2 = L5_2
  L12_2 = L6_2
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
end
L2_1(L3_1, L4_1)
L2_1 = RegisterNetEvent
L3_1 = "rcore_clothing:stage2SaveResult"
function L4_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = source
  L4_2 = GetPhotosInProgress
  L4_2 = L4_2()
  if not L4_2 then
    L4_2 = SendNotification
    L5_2 = L3_2
    L6_2 = "Taking pictures is not in progress or it is performed by someone else"
    L4_2(L5_2, L6_2)
    return
  end
  L4_2 = table
  L4_2 = L4_2.concat
  L5_2 = A2_2
  L6_2 = ","
  L4_2 = L4_2(L5_2, L6_2)
  A2_2 = L4_2
  L4_2 = DbGetItemById
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2.colors
  if nil ~= L5_2 then
    L5_2 = L4_2.colors
    if "" ~= L5_2 then
      L5_2 = print
      L6_2 = "Preserving db color!"
      L7_2 = A0_2
      L5_2(L6_2, L7_2)
      A2_2 = L4_2.colors
    end
  end
  L5_2 = DbStage2SaveResult
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L5_2(L6_2, L7_2, L8_2)
end
L2_1(L3_1, L4_1)
L2_1 = RegisterNetEvent
L3_1 = "rcore_clothing:stage2CouldNotProcess"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = source
  L2_2 = GetPhotosInProgress
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = SendNotification
    L3_2 = L1_2
    L4_2 = "Taking pictures is not in progress or it is performed by someone else"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = DbMarkAsImageless
  L3_2 = A0_2
  L2_2(L3_2)
end
L2_1(L3_1, L4_1)
