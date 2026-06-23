local L0_1, L1_1
function L0_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  while true do
    L0_2 = DbCountUntypedItem
    L0_2 = L0_2()
    if L0_2 <= 0 then
      L1_2 = print
      L2_2 = "[PIPELINE] No items to process. Stopping AI worker."
      L1_2(L2_2)
      return
    end
    L1_2 = print
    L2_2 = "Processing clothing items with RCore AI. Remaining:"
    L3_2 = L0_2
    L1_2(L2_2, L3_2)
    L1_2 = DbGetUntypedItems
    L2_2 = 10
    L1_2 = L1_2(L2_2)
    L2_2 = {}
    L3_2 = pairs
    L4_2 = L1_2
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = Citizen
      L9_2 = L9_2.CreateThread
      function L10_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
        L0_3 = Stage3HandleItem
        L1_3 = L8_2
        L0_3, L1_3 = L0_3(L1_3)
        L2_3 = table
        L2_3 = L2_3.insert
        L3_3 = L2_2
        L4_3 = {}
        L4_3.success = L0_3
        L4_3.msg = L1_3
        L2_3(L3_3, L4_3)
        if L0_3 then
          L2_3 = print
          L3_3 = "[#"
          L4_3 = L7_2
          L5_3 = "/SUCCESS]"
          L3_3 = L3_3 .. L4_3 .. L5_3
          L4_3 = L1_3
          L2_3(L3_3, L4_3)
        else
          L2_3 = print
          L3_3 = "[#"
          L4_3 = L7_2
          L5_3 = "/FAILED]"
          L3_3 = L3_3 .. L4_3 .. L5_3
          L4_3 = L1_3
          L2_3(L3_3, L4_3)
        end
      end
      L9_2(L10_2)
    end
    while true do
      L3_2 = #L2_2
      L4_2 = #L1_2
      if not (L3_2 < L4_2) then
        break
      end
      L3_2 = Wait
      L4_2 = 0
      L3_2(L4_2)
    end
    L3_2 = 0
    L4_2 = 0
    L5_2 = ipairs
    L6_2 = L2_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L11_2 = L10_2.success
      if L11_2 then
        L3_2 = L3_2 + 1
      else
        L4_2 = L4_2 + 1
      end
    end
    if L3_2 < L4_2 or L4_2 > 3 then
      L5_2 = print
      L6_2 = "Too many failures, stopping AI worker."
      L5_2(L6_2)
      return
    end
    L5_2 = Wait
    L6_2 = 100
    L5_2(L6_2)
  end
end
Pipeline3StartAIWorker = L0_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = A0_2.component_id
  if 8 == L1_2 then
    L1_2 = Stage3SyncItem
    L2_2 = A0_2
    L3_2 = "other"
    L4_2 = ""
    L5_2 = A0_2.colors
    L1_2(L2_2, L3_2, L4_2, L5_2)
  else
    L1_2 = A0_2.component_id
    if 102 == L1_2 then
      L1_2 = Stage3SyncItem
      L2_2 = A0_2
      L3_2 = "earring"
      L4_2 = ""
      L5_2 = A0_2.colors
      L1_2(L2_2, L3_2, L4_2, L5_2)
    else
      L1_2 = Stage3SyncHttpRequest
      L2_2 = A0_2.component_id
      L3_2 = A0_2.image_url
      L1_2 = L1_2(L2_2, L3_2)
      L2_2 = L1_2.error_type
      if "no_credit" == L2_2 then
        L2_2 = false
        L3_2 = "You do not have RCore AI Credit to perform automated clothing recognition. Stopping for now."
        return L2_2, L3_2
      end
      L2_2 = L1_2.error_type
      if "timeout" == L2_2 then
        L2_2 = false
        L3_2 = "API request timed out, stopping for now. Try restaring the resource later"
        return L2_2, L3_2
      end
      L2_2 = L1_2.error_type
      if "unknown_error" == L2_2 then
        L2_2 = false
        L3_2 = "API request failed with unknown error, stopping for now. Try restaring the resource later"
        return L2_2, L3_2
      end
      L2_2 = L1_2.error_type
      if "bad_request" == L2_2 then
        L2_2 = false
        L3_2 = "Bad request sent to API, stopping for now. Please contact support"
        return L2_2, L3_2
      end
      L2_2 = L1_2.error_type
      if "unprocessable_content" == L2_2 then
        L2_2 = Stage3SyncItem
        L3_2 = A0_2
        L4_2 = "other"
        L5_2 = ""
        L6_2 = A0_2.colors
        L2_2(L3_2, L4_2, L5_2, L6_2)
      else
        L2_2 = L1_2.error_type
        if "unprocessable_content_2" == L2_2 then
          L2_2 = Stage3SyncItem
          L3_2 = A0_2
          L4_2 = "other"
          L5_2 = ""
          L6_2 = A0_2.colors
          L2_2(L3_2, L4_2, L5_2, L6_2)
        else
          L2_2 = L1_2.success
          if not L2_2 then
            L2_2 = false
            L3_2 = "API request failed with unknown error, stopping for now. Try restaring the resource later"
            return L2_2, L3_2
          end
          L2_2 = L1_2.colors
          if not L2_2 then
            L2_2 = {}
            L1_2.colors = L2_2
          end
          L2_2 = L1_2.type
          if not L2_2 then
            L1_2.type = "other"
          end
          L2_2 = Stage3SyncItem
          L3_2 = A0_2
          L4_2 = L1_2.type
          L5_2 = L1_2.name
          L6_2 = table
          L6_2 = L6_2.concat
          L7_2 = L1_2.colors
          L8_2 = ","
          L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L6_2(L7_2, L8_2)
          L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
          L2_2 = true
          L3_2 = "Processed "
          L4_2 = A0_2.ped_model
          L5_2 = ", "
          L6_2 = A0_2.name_hash
          L7_2 = ", "
          L8_2 = A0_2.component_id
          L9_2 = ", "
          L10_2 = A0_2.drawable_id
          L11_2 = ", "
          L12_2 = A0_2.texture_id
          L3_2 = L3_2 .. L4_2 .. L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2 .. L10_2 .. L11_2 .. L12_2
          return L2_2, L3_2
        end
      end
    end
  end
  L1_2 = true
  return L1_2
end
Stage3HandleItem = L0_1
function L0_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = A0_2.label
  if not L4_2 or "" == L4_2 or "NULL" == L4_2 then
    L4_2 = A2_2
  end
  L5_2 = ResolveColorMatch
  L6_2 = A0_2.colors
  L7_2 = A3_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = DbSyncItem
  L7_2 = A0_2.id
  L8_2 = L4_2
  L9_2 = A1_2
  L10_2 = L5_2
  L6_2(L7_2, L8_2, L9_2, L10_2)
end
Stage3SyncItem = L0_1
function L0_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  if nil == A0_2 or "" == A0_2 then
    return A1_2
  end
  L2_2 = mysplit
  L3_2 = A0_2
  L4_2 = ","
  L2_2 = L2_2(L3_2, L4_2)
  splitColors = L2_2
  L2_2 = mysplit
  L3_2 = A1_2
  L4_2 = ","
  L2_2 = L2_2(L3_2, L4_2)
  splitAiColors = L2_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = splitColors
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = ipairs
    L10_2 = splitAiColors
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      if L8_2 == L14_2 or "camo" == L14_2 then
        L15_2 = table
        L15_2 = L15_2.insert
        L16_2 = L2_2
        L17_2 = L8_2
        L15_2(L16_2, L17_2)
      end
    end
  end
  L3_2 = #L2_2
  if 0 == L3_2 then
    L3_2 = splitAiColors
    L3_2 = #L3_2
    if L3_2 > 0 then
      return A1_2
    end
    return A0_2
  end
  L3_2 = table
  L3_2 = L3_2.concat
  L4_2 = L2_2
  L5_2 = ","
  return L3_2(L4_2, L5_2)
end
ResolveColorMatch = L0_1
function L0_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if nil == A1_2 then
    A1_2 = "%s"
  end
  L2_2 = {}
  L3_2 = string
  L3_2 = L3_2.gmatch
  L4_2 = A0_2
  L5_2 = "([^"
  L6_2 = A1_2
  L7_2 = "]+)"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2)
  for L7_2 in L3_2, L4_2, L5_2, L6_2 do
    L8_2 = table
    L8_2 = L8_2.insert
    L9_2 = L2_2
    L10_2 = L7_2
    L8_2(L9_2, L10_2)
  end
  return L2_2
end
mysplit = L0_1
function L0_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = nil
  L3_2 = PerformHttpRequest
  L4_2 = BACKEND_URL
  L5_2 = "/process-ai"
  L4_2 = L4_2 .. L5_2
  function L5_2(A0_3, A1_3, A2_3, A3_3)
    local L4_3, L5_3, L6_3
    if 200 == A0_3 then
      L4_3 = json
      L4_3 = L4_3.decode
      L5_3 = A1_3
      L4_3 = L4_3(L5_3)
      data = L4_3
      L4_3 = data
      L2_2 = L4_3
    else
      L4_3 = print
      L5_3 = "API error"
      L6_3 = A0_3
      L4_3(L5_3, L6_3)
      L4_3 = {}
      L4_3.success = false
      L4_3.error_type = "unknown_error"
      L2_2 = L4_3
    end
  end
  L6_2 = "POST"
  L7_2 = json
  L7_2 = L7_2.encode
  L8_2 = {}
  L9_2 = GetServerSecret
  L9_2 = L9_2()
  L8_2.apiKey = L9_2
  L8_2.componentId = A0_2
  L8_2.url = A1_2
  L7_2 = L7_2(L8_2)
  L8_2 = {}
  L8_2["Content-Type"] = "application/json"
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  while nil == L2_2 do
    L4_2 = GetGameTimer
    L4_2 = L4_2()
    L4_2 = L4_2 - L3_2
    L5_2 = 10000
    if L4_2 > L5_2 then
      L4_2 = print
      L5_2 = "API request timed out"
      L4_2(L5_2)
      L4_2 = {}
      L4_2.success = false
      L4_2.error_type = "timeout"
      L2_2 = L4_2
      break
    end
    L4_2 = Wait
    L5_2 = 100
    L4_2(L5_2)
  end
  return L2_2
end
Stage3SyncHttpRequest = L0_1
function L0_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if not A1_2 then
    A1_2 = 0
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = pairs
    L3_2 = A0_2
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = string
      L8_2 = L8_2.rep
      L9_2 = "  "
      L10_2 = A1_2
      L8_2 = L8_2(L9_2, L10_2)
      L9_2 = L6_2
      L10_2 = ": "
      L8_2 = L8_2 .. L9_2 .. L10_2
      formatting = L8_2
      L8_2 = type
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if "table" == L8_2 then
        L8_2 = print
        L9_2 = formatting
        L8_2(L9_2)
        L8_2 = tprint
        L9_2 = L7_2
        L10_2 = A1_2 + 1
        L8_2(L9_2, L10_2)
      else
        L8_2 = type
        L9_2 = L7_2
        L8_2 = L8_2(L9_2)
        if "boolean" == L8_2 then
          L8_2 = print
          L9_2 = formatting
          L10_2 = tostring
          L11_2 = L7_2
          L10_2 = L10_2(L11_2)
          L9_2 = L9_2 .. L10_2
          L8_2(L9_2)
        else
          L8_2 = print
          L9_2 = formatting
          L10_2 = L7_2
          L9_2 = L9_2 .. L10_2
          L8_2(L9_2)
        end
      end
    end
  else
    L2_2 = print
    L3_2 = A0_2
    L2_2(L3_2)
  end
end
tprint = L0_1
