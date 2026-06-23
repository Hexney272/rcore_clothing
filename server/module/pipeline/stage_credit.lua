local L0_1, L1_1
function L0_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = StageCreditSyncHttpRequest
  L1_2 = "GET"
  L2_2 = "/account/"
  L3_2 = GetServerSecret
  L3_2 = L3_2()
  L2_2 = L2_2 .. L3_2
  L0_2 = L0_2(L1_2, L2_2)
  L1_2 = L0_2.success
  if L1_2 then
    L1_2 = L0_2.credit
    return L1_2
  else
    L1_2 = nil
    return L1_2
  end
end
GetCredit = L0_1
function L0_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = nil
  if nil ~= A2_2 then
    L4_2 = json
    L4_2 = L4_2.encode
    L5_2 = A2_2
    L4_2 = L4_2(L5_2)
    A2_2 = L4_2
  end
  L4_2 = PerformHttpRequest
  L5_2 = BACKEND_URL
  L6_2 = A1_2
  L5_2 = L5_2 .. L6_2
  function L6_2(A0_3, A1_3, A2_3, A3_3)
    local L4_3, L5_3, L6_3
    if 200 == A0_3 then
      L4_3 = json
      L4_3 = L4_3.decode
      L5_3 = A1_3
      L4_3 = L4_3(L5_3)
      A2_2 = L4_3
      L4_3 = A2_2
      L3_2 = L4_3
    else
      L4_3 = print
      L5_3 = "API error"
      L6_3 = A0_3
      L4_3(L5_3, L6_3)
      L4_3 = {}
      L4_3.success = false
      L4_3.error_type = "unknown_error"
      L3_2 = L4_3
    end
  end
  L7_2 = A0_2
  L8_2 = A2_2
  L9_2 = {}
  L9_2["Content-Type"] = "application/json"
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  while nil == L3_2 do
    L5_2 = GetGameTimer
    L5_2 = L5_2()
    L5_2 = L5_2 - L4_2
    L6_2 = 10000
    if L5_2 > L6_2 then
      L5_2 = print
      L6_2 = "API request timed out"
      L5_2(L6_2)
      L5_2 = {}
      L5_2.success = false
      L5_2.error_type = "timeout"
      L3_2 = L5_2
      break
    end
    L5_2 = Wait
    L6_2 = 100
    L5_2(L6_2)
  end
  return L3_2
end
StageCreditSyncHttpRequest = L0_1
