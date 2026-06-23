local L0_1, L1_1
function L0_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = pairs
  L1_2 = Config
  L1_2 = L1_2.PriceSeed
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = print
    L7_2 = "Resetting price for"
    L8_2 = L5_2.type
    L9_2 = L5_2.componentId
    L10_2 = L5_2.price
    L6_2(L7_2, L8_2, L9_2, L10_2)
    L6_2 = MySQL
    L6_2 = L6_2.Sync
    L6_2 = L6_2.execute
    L7_2 = [[
            UPDATE rcore_clothing_items SET price=@price WHERE component_id=@compId AND `type`=@type;
        ]]
    L8_2 = {}
    L9_2 = L5_2.price
    L8_2["@price"] = L9_2
    L9_2 = L5_2.componentId
    L8_2["@compId"] = L9_2
    L9_2 = L5_2.type
    L8_2["@type"] = L9_2
    L6_2(L7_2, L8_2)
  end
end
Stage4ResetPrices = L0_1
