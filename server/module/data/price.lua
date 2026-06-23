local L0_1, L1_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = pairs
  L2_2 = Config
  L2_2 = L2_2.PriceSeed
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.componentId
    if L7_2 == A0_2 then
      L7_2 = L6_2.type
      if "other" == L7_2 then
        L7_2 = L6_2.price
        return L7_2
      end
    end
  end
  L1_2 = pairs
  L2_2 = Config
  L2_2 = L2_2.PriceSeed
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.componentId
    if L7_2 == A0_2 then
      L7_2 = L6_2.price
      return L7_2
    end
  end
  L1_2 = 5
  return L1_2
end
GetDefaultOtherPrice = L0_1
