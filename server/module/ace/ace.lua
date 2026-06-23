local L0_1, L1_1, L2_1, L3_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = string
  L1_2 = L1_2.find
  L2_2 = A0_2
  L3_2 = "command."
  L1_2 = L1_2(L2_2, L3_2)
  L1_2 = 1 == L1_2
  if L1_2 then
    return A0_2
  end
  L2_2 = string
  L2_2 = L2_2.format
  L3_2 = "%s_%s"
  L4_2 = GetCurrentResourceName
  L4_2 = L4_2()
  L5_2 = A0_2
  return L2_2(L3_2, L4_2, L5_2)
end
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = "ace_"
  L2_2 = string
  L2_2 = L2_2.gsub
  L3_2 = A0_2
  L4_2 = "[^%w]"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2 = L1_2 .. L2_2
  return L1_2
end
L2_1 = Citizen
L2_1 = L2_1.CreateThread
function L3_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = Config
  L0_2 = L0_2.ClothingAceRestrictionOptions
  if L0_2 then
    L0_2 = ipairs
    L1_2 = Config
    L1_2 = L1_2.ClothingAceRestrictionOptions
    L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
    for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
      L6_2 = L1_1
      L7_2 = L5_2
      L6_2 = L6_2(L7_2)
      L7_2 = AceAllow
      L8_2 = L5_2
      L9_2 = L6_2
      L7_2(L8_2, L9_2)
    end
  end
end
L2_1(L3_1)
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = ExecuteCommand
  L3_2 = string
  L3_2 = L3_2.format
  L4_2 = "add_principal %s %s"
  L5_2 = A0_2
  L6_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2)
end
AceAddPrincipal = L2_1
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = ExecuteCommand
  L3_2 = string
  L3_2 = L3_2.format
  L4_2 = "remove_principal %s %s"
  L5_2 = A0_2
  L6_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2)
end
AceRemovePrincipal = L2_1
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = ExecuteCommand
  L3_2 = string
  L3_2 = L3_2.format
  L4_2 = "add_ace %s %s allow"
  L5_2 = A0_2
  L6_2 = L0_1
  L7_2 = A1_2
  L6_2, L7_2 = L6_2(L7_2)
  L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
end
AceAllow = L2_1
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = ExecuteCommand
  L3_2 = string
  L3_2 = L3_2.format
  L4_2 = "add_ace %s %s deny"
  L5_2 = A0_2
  L6_2 = L0_1
  L7_2 = A1_2
  L6_2, L7_2 = L6_2(L7_2)
  L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
end
AceDeny = L2_1
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = IsPlayerAceAllowed
  L3_2 = A0_2
  L4_2 = L0_1
  L5_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2)
  return L2_2(L3_2, L4_2, L5_2)
end
AceCan = L2_1
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = IsPrincipalAceAllowed
  L3_2 = A0_2
  L4_2 = L0_1
  L5_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2)
  return L2_2(L3_2, L4_2, L5_2)
end
AceCanGroup = L2_1
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = {}
  L2_2 = pairs
  L3_2 = Config
  L3_2 = L3_2.ClothingAceRestrictionOptions
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L1_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    L9_2 = AceCan
    L10_2 = A0_2
    L11_2 = L8_2
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L9_2 = table
      L9_2 = L9_2.insert
      L10_2 = L1_2
      L11_2 = "ace:"
      L12_2 = L7_2
      L11_2 = L11_2 .. L12_2
      L9_2(L10_2, L11_2)
      L9_2 = table
      L9_2 = L9_2.insert
      L10_2 = L1_2
      L11_2 = L7_2
      L9_2(L10_2, L11_2)
    end
  end
  return L1_2
end
AcesToIdentifiers = L2_1
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = AcesToIdentifiers
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = pairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = table
    L9_2 = L9_2.insert
    L10_2 = A1_2
    L11_2 = L8_2
    L9_2(L10_2, L11_2)
  end
  return A1_2
end
AppendAces = L2_1
