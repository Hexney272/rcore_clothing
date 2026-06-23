local L0_1, L1_1, L2_1, L3_1, L4_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = A0_2.collectionName
  L2_2 = "--"
  L3_2 = A0_2.componentId
  L4_2 = "--"
  L5_2 = A0_2.collectionIndex
  L6_2 = "--"
  L7_2 = A0_2.textureId
  L1_2 = L1_2 .. L2_2 .. L3_2 .. L4_2 .. L5_2 .. L6_2 .. L7_2
  return L1_2
end
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L1_2 = {}
  L2_2 = nil
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L0_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    L10_2 = table
    L10_2 = L10_2.insert
    L11_2 = L1_2
    L12_2 = tostring
    L13_2 = L9_2
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L12_2(L13_2)
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    if nil == L2_2 then
      L2_2 = L8_2.pedModel
    else
      L10_2 = L8_2.pedModel
      if L2_2 ~= L10_2 then
        L10_2 = print
        L11_2 = "Multiple ped models in one batch, not supported"
        L10_2(L11_2)
        L10_2 = {}
        return L10_2
      end
    end
  end
  L3_2 = {}
  L4_2 = #L1_2
  if L4_2 > 0 then
    L4_2 = DbCollectorGetByPedModelAndHashes
    L5_2 = L2_2
    L6_2 = L1_2
    L4_2 = L4_2(L5_2, L6_2)
    L5_2 = pairs
    L6_2 = A0_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L11_2 = L0_1
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      L12_2 = tostring
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      L11_2 = L12_2
      L12_2 = false
      L13_2 = pairs
      L14_2 = L4_2
      L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
      for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
        L19_2 = L18_2.name_hash
        if L19_2 == L11_2 then
          L19_2 = L10_2.decalCollectionHash
          if nil ~= L19_2 then
            L19_2 = L10_2.decalNameHash
            if nil ~= L19_2 then
              L19_2 = L18_2.decal_collection_hash
              L20_2 = L10_2.decalCollectionHash
              if L19_2 == L20_2 then
                L19_2 = L18_2.decal_name_hash
                L20_2 = L10_2.decalNameHash
                if L19_2 == L20_2 then
                  L12_2 = true
                  break
                end
              end
          end
          else
            L12_2 = true
            break
          end
        end
      end
      if not L12_2 then
        L13_2 = table
        L13_2 = L13_2.insert
        L14_2 = L3_2
        L15_2 = L10_2
        L13_2(L14_2, L15_2)
      end
    end
    return L3_2
  else
    L4_2 = {}
    return L4_2
  end
end
Stage1FilterOutKnownItems = L1_1
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = {}
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = table
    L8_2 = L8_2.insert
    L9_2 = L1_2
    L10_2 = L0_1
    L11_2 = L7_2
    L10_2, L11_2 = L10_2(L11_2)
    L8_2(L9_2, L10_2, L11_2)
  end
  L2_2 = #L1_2
  if L2_2 > 0 then
    L2_2 = DbCollectorMarkAsFound
    L3_2 = L1_2
    L2_2(L3_2)
  end
end
function L2_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = MySQL
  L0_2 = L0_2.Sync
  L0_2 = L0_2.fetchScalar
  L1_2 = "SELECT COUNT(*) FROM rcore_clothing_items WHERE name_hash NOT LIKE '%--%' AND decal_collection_hash IS NULL AND game_build <= @gameBuild"
  L2_2 = {}
  L3_2 = GetGameBuild
  L3_2 = L3_2()
  L2_2["@gameBuild"] = L3_2
  L0_2 = L0_2(L1_2, L2_2)
  L1_2 = L0_2 > 0
  return L1_2
end
IsAnyItemPendingMigration = L2_1
L2_1 = RegisterNetEvent
L3_1 = "rcore_clothing:sendClothingMappingData"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = source
  L2_2 = GetRecalibrationInProgress
  L2_2 = L2_2()
  if L2_2 ~= L1_2 then
    L2_2 = SendNotification
    L3_2 = L1_2
    L4_2 = "Recalibration is not in progress or it is performed by someone else"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L1_1
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = #A0_2
  L3_2 = Stage1FilterOutKnownItems
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  L3_2 = print
  L4_2 = "[calibration] Received items: "
  L5_2 = L2_2
  L6_2 = ", Relevant items:"
  L7_2 = #A0_2
  L4_2 = L4_2 .. L5_2 .. L6_2 .. L7_2
  L3_2(L4_2)
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L0_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    L8_2.nameHash = L9_2
    L9_2 = DbCollectorInsertItem
    L10_2 = L8_2.nameHash
    L11_2 = L8_2.componentId
    L12_2 = L8_2.drawableId
    L13_2 = L8_2.textureId
    L14_2 = L8_2.pedModel
    L15_2 = L8_2.decalCollectionHash
    L16_2 = L8_2.decalNameHash
    L17_2 = L8_2.labelGxt
    L18_2 = L8_2.label
    L19_2 = L8_2.price
    L20_2 = L8_2.recommendedArms
    L21_2 = L8_2.setComponents
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  end
  L3_2 = print
  L4_2 = "[calibration] Done"
  L3_2(L4_2)
end
L2_1(L3_1, L4_1)
L2_1 = RegisterNetEvent
L3_1 = "rcore_clothing:sendPropMappingData"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = source
  L2_2 = GetRecalibrationInProgress
  L2_2 = L2_2()
  if L2_2 ~= L1_2 then
    L2_2 = SendNotification
    L3_2 = L1_2
    L4_2 = "Recalibration is not in progress or it is performed by someone else"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L1_1
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = #A0_2
  L3_2 = Stage1FilterOutKnownItems
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  L3_2 = print
  L4_2 = "[calibration] Received items: "
  L5_2 = L2_2
  L6_2 = ", Relevant items:"
  L7_2 = #A0_2
  L4_2 = L4_2 .. L5_2 .. L6_2 .. L7_2
  L3_2(L4_2)
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L0_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    L8_2.nameHash = L9_2
    L9_2 = DbCollectorInsertItem
    L10_2 = L8_2.nameHash
    L11_2 = L8_2.componentId
    L12_2 = L8_2.drawableId
    L13_2 = L8_2.textureId
    L14_2 = L8_2.pedModel
    L15_2 = nil
    L16_2 = nil
    L17_2 = L8_2.labelGxt
    L18_2 = L8_2.label
    L19_2 = L8_2.price
    L20_2 = nil
    L21_2 = nil
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  end
  L3_2 = print
  L4_2 = "[calibration] Done"
  L3_2(L4_2)
end
L2_1(L3_1, L4_1)
