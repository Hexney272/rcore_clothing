local L0_1, L1_1, L2_1
L0_1 = {}
L0_1[8] = true
L0_1[10] = true
function L1_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2
  if not A5_2 or 0 == A5_2 then
    L6_2 = 0
    return L6_2
  end
  L6_2 = L0_1
  L6_2 = L6_2[A2_2]
  if L6_2 then
    A1_2 = "uniprice"
  end
  L6_2 = Config
  L6_2 = L6_2.ShopMultiplier
  L6_2 = L6_2[A1_2]
  if not L6_2 then
    A1_2 = "default"
  end
  L6_2 = Config
  L6_2 = L6_2.GlobalPriceMultiplier
  L6_2 = A5_2 * L6_2
  L7_2 = Config
  L7_2 = L7_2.ShopMultiplier
  L7_2 = L7_2[A1_2]
  L6_2 = L6_2 * L7_2
  L7_2 = GetRandomDeterministicMultiplier
  L8_2 = A2_2 * A3_2
  L7_2 = L7_2(L8_2)
  L8_2 = tonumber
  L9_2 = math
  L9_2 = L9_2.floor
  L10_2 = L6_2 * L7_2
  L9_2, L10_2 = L9_2(L10_2)
  L8_2 = L8_2(L9_2, L10_2)
  L6_2 = L8_2
  if L6_2 < 1 then
    L6_2 = 1
  end
  L8_2 = 200
  if L6_2 > L8_2 then
    L8_2 = tonumber
    L9_2 = math
    L9_2 = L9_2.floor
    L10_2 = L6_2 / 10
    L9_2, L10_2 = L9_2(L10_2)
    L8_2 = L8_2(L9_2, L10_2)
    L6_2 = L8_2 * 10
  elseif L6_2 > 50 then
    L8_2 = tonumber
    L9_2 = math
    L9_2 = L9_2.floor
    L10_2 = L6_2 / 5
    L9_2, L10_2 = L9_2(L10_2)
    L8_2 = L8_2(L9_2, L10_2)
    L6_2 = L8_2 * 5
  end
  return L6_2
end
CalculateItemPrice = L1_1
function L1_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2
  function L2_2()
    local L0_3, L1_3
    L0_3 = L1_2
    L1_3 = L1_2
    L1_3 = L1_3 << 13
    L0_3 = L0_3 ~ L1_3
    L1_2 = L0_3
    L0_3 = L1_2
    L1_3 = L1_2
    L1_3 = L1_3 >> 17
    L0_3 = L0_3 ~ L1_3
    L1_2 = L0_3
    L0_3 = L1_2
    L1_3 = L1_2
    L1_3 = L1_3 << 5
    L0_3 = L0_3 ~ L1_3
    L1_2 = L0_3
    L0_3 = L1_2
    return L0_3
  end
  next = L2_2
  L2_2 = next
  return L2_2
end
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L1_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L2_2 = L2_2()
  L2_2 = L2_2 / 4294967295
  L2_2 = L2_2 * 100000
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L3_2 = L2_2 - L3_2
  L4_2 = L3_2 * 0.4
  L4_2 = 1 + L4_2
  L4_2 = L4_2 - 0.2
  return L4_2
end
GetRandomDeterministicMultiplier = L2_1
