local L0_1, L1_1
function L0_1()
  local L0_2, L1_2
  L0_2 = MySQL
  L0_2 = L0_2.Sync
  L0_2 = L0_2.fetchScalar
  L1_2 = "SELECT COUNT(*) FROM rcore_clothing_items WHERE is_found <> 1"
  return L0_2(L1_2)
end
PipelineDeleteGetCount = L0_1
function L0_1()
  local L0_2, L1_2
  L0_2 = MySQL
  L0_2 = L0_2.Sync
  L0_2 = L0_2.execute
  L1_2 = "DELETE FROM rcore_clothing_items WHERE is_found <> 1"
  L0_2(L1_2)
end
PipelineDeleteForReal = L0_1
function L0_1()
  local L0_2, L1_2
  L0_2 = MySQL
  L0_2 = L0_2.Sync
  L0_2 = L0_2.execute
  L1_2 = "UPDATE rcore_clothing_items SET is_found=0"
  L0_2(L1_2)
  L0_2 = MySQL
  L0_2 = L0_2.Sync
  L0_2 = L0_2.execute
  L1_2 = "UPDATE rcore_clothing_items SET is_found=1 where component_id in (3, 10)"
  L0_2(L1_2)
end
PipelineDeletePrepare = L0_1
