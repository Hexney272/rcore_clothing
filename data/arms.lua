local L0_1, L1_1
function L0_1()
  local L0_2, L1_2, L2_2
  L0_2 = GetShopPed
  L0_2 = L0_2()
  if not L0_2 then
    L0_2 = PlayerPedId
    L0_2 = L0_2()
  end
  L1_2 = GetEntityModel
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if 1885233650 == L1_2 then
    L2_2 = MALE_ARMS
    return L2_2
  elseif -1667301416 == L1_2 then
    L2_2 = FEMALE_ARMS
    return L2_2
  end
  L2_2 = {}
  return L2_2
end
DataGetArms = L0_1
function L0_1()
  local L0_2, L1_2, L2_2
  L0_2 = GetShopPed
  L0_2 = L0_2()
  if not L0_2 then
    L0_2 = PlayerPedId
    L0_2 = L0_2()
  end
  L1_2 = GetEntityModel
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if 1885233650 == L1_2 then
    L2_2 = MALE_ARM_CONFIG
    return L2_2
  elseif -1667301416 == L1_2 then
    L2_2 = FEMALE_ARM_CONFIG
    return L2_2
  end
  L2_2 = {}
  return L2_2
end
DataGetArmConfig = L0_1
function L0_1()
  local L0_2, L1_2, L2_2
  L0_2 = GetShopPed
  L0_2 = L0_2()
  if not L0_2 then
    L0_2 = PlayerPedId
    L0_2 = L0_2()
  end
  L1_2 = GetEntityModel
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if 1885233650 == L1_2 then
    L2_2 = MALE_ARM_CONFIG_IGNORE
    return L2_2
  elseif -1667301416 == L1_2 then
    L2_2 = FEMALE_ARM_CONFIG_IGNORE
    return L2_2
  end
  L2_2 = {}
  return L2_2
end
DataGetArmConfigIgnore = L0_1
function L0_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = GetShopPed
  L0_2 = L0_2()
  if not L0_2 then
    L0_2 = PlayerPedId
    L0_2 = L0_2()
  end
  L1_2 = GetEntityModel
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if 1885233650 == L1_2 then
    L2_2 = {}
    L3_2 = MALE_71_GAP_START
    L2_2.start = L3_2
    L3_2 = MALE_71_GAP_LENGTH
    L2_2.length = L3_2
    return L2_2
  elseif -1667301416 == L1_2 then
    L2_2 = {}
    L3_2 = FEMALE_71_GAP_START
    L2_2.start = L3_2
    L3_2 = FEMALE_71_GAP_LENGTH
    L2_2.length = L3_2
    return L2_2
  end
  L2_2 = {}
  return L2_2
end
DataGetGapData = L0_1
