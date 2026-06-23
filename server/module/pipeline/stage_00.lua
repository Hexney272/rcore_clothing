local L0_1, L1_1, L2_1, L3_1, L4_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L1_2 = pairs
  L2_2 = A0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = tonumber
    L8_2 = L5_2
    L7_2 = L7_2(L8_2)
    L5_2 = L7_2
    L7_2 = nil
    L8_2 = {}
    L9_2 = L6_2.recArms
    if L9_2 then
      L9_2 = "UPDATE rcore_clothing_items SET name_hash = @newNameHash_"
      L10_2 = L5_2
      L11_2 = ", recommended_arms=@recArms_"
      L12_2 = L5_2
      L13_2 = " WHERE name_hash=@oldNameHash_"
      L14_2 = L5_2
      L15_2 = "  AND ped_model=@pedModel_"
      L16_2 = L5_2
      L9_2 = L9_2 .. L10_2 .. L11_2 .. L12_2 .. L13_2 .. L14_2 .. L15_2 .. L16_2
      L7_2 = L9_2
    else
      L9_2 = "UPDATE rcore_clothing_items SET name_hash = @newNameHash_"
      L10_2 = L5_2
      L11_2 = "  WHERE name_hash=@oldNameHash_"
      L12_2 = L5_2
      L13_2 = "  AND ped_model=@pedModel_"
      L14_2 = L5_2
      L9_2 = L9_2 .. L10_2 .. L11_2 .. L12_2 .. L13_2 .. L14_2
      L7_2 = L9_2
    end
    L9_2 = "@newNameHash_"
    L10_2 = L5_2
    L9_2 = L9_2 .. L10_2
    L10_2 = L6_2.newHash
    L8_2[L9_2] = L10_2
    L9_2 = "@oldNameHash_"
    L10_2 = L5_2
    L9_2 = L9_2 .. L10_2
    L10_2 = L6_2.oldHash
    L8_2[L9_2] = L10_2
    L9_2 = "@pedModel_"
    L10_2 = L5_2
    L9_2 = L9_2 .. L10_2
    L10_2 = L6_2.pedModel
    L8_2[L9_2] = L10_2
    L9_2 = L6_2.recArms
    if L9_2 then
      L9_2 = "@recArms_"
      L10_2 = L5_2
      L9_2 = L9_2 .. L10_2
      L10_2 = L6_2.recArms
      L8_2[L9_2] = L10_2
    end
    L9_2 = MySQL
    L9_2 = L9_2.Sync
    L9_2 = L9_2.execute
    L10_2 = L7_2
    L11_2 = L8_2
    L9_2(L10_2, L11_2)
  end
end
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = MySQL
  L1_2 = L1_2.Sync
  L1_2 = L1_2.fetchAll
  L2_2 = [[
        SELECT * FROM rcore_clothing_items WHERE name_hash NOT LIKE '%--%' AND decal_collection_hash IS NULL AND game_build <= @gameBuild ORDER BY ped_model ASC, id ASC LIMIT 50
    ]]
  L3_2 = {}
  L4_2 = GetGameBuild
  L4_2 = L4_2()
  L3_2["@gameBuild"] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = MySQL
  L2_2 = L2_2.Sync
  L2_2 = L2_2.fetchScalar
  L3_2 = "SELECT COUNT(*) FROM rcore_clothing_items WHERE name_hash NOT LIKE '%--%' AND decal_collection_hash IS NULL AND game_build <= @gameBuild"
  L4_2 = {}
  L5_2 = GetGameBuild
  L5_2 = L5_2()
  L4_2["@gameBuild"] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = #L1_2
  if L3_2 > 0 then
    L3_2 = TriggerClientEvent
    L4_2 = "rcore_clothing:stage00:processItems"
    L5_2 = A0_2
    L6_2 = L1_2
    L7_2 = L2_2
    L3_2(L4_2, L5_2, L6_2, L7_2)
  else
    L3_2 = MySQL
    L3_2 = L3_2.Sync
    L3_2 = L3_2.execute
    L4_2 = "DELETE FROM rcore_clothing_items WHERE name_hash LIKE \"%delme__%\""
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Hash migration completed"
    L3_2(L4_2)
  end
end
L2_1 = RegisterNetEvent
L3_1 = "rcore_clothing:stage00:resolveItems"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = source
  L2_2 = L0_1
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = L1_1
  L3_2 = L1_2
  L2_2(L3_2)
end
L2_1(L3_1, L4_1)
function L2_1(A0_2)
  local L1_2, L2_2
  L1_2 = L1_1
  L2_2 = A0_2
  L1_2(L2_2)
end
Stage00MigrateHashes = L2_1
