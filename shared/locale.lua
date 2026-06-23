local L0_1, L1_1
L0_1 = Locales
if not L0_1 then
  L0_1 = {}
end
Locales = L0_1
function L0_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = Config
  if L1_2 then
    L1_2 = Config
    L1_2 = L1_2.Locale
    if L1_2 then
      goto lbl_11
    end
  end
  L1_2 = "not_found_config"
  do return L1_2 end
  ::lbl_11::
  L1_2 = Locales
  L2_2 = Config
  L2_2 = L2_2.Locale
  L1_2 = L1_2[L2_2]
  if not L1_2 then
    L1_2 = "not_found_locale"
    return L1_2
  end
  L1_2 = {}
  L2_2 = string
  L2_2 = L2_2.gmatch
  L3_2 = A0_2
  L4_2 = "([^%.]+)"
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = table
    L7_2 = L7_2.insert
    L8_2 = L1_2
    L9_2 = L6_2
    L7_2(L8_2, L9_2)
  end
  L2_2 = Locales
  L3_2 = Config
  L3_2 = L3_2.Locale
  L2_2 = L2_2[L3_2]
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L2_2[L8_2]
    if L9_2 then
      L2_2 = L2_2[L8_2]
    else
      return A0_2
    end
  end
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = string
    L3_2 = L3_2.format
    L4_2 = L2_2
    L5_2, L6_2, L7_2, L8_2, L9_2 = ...
    return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  else
    L3_2 = "invalid_locale_structure"
    return L3_2
  end
end
_U = L0_1
