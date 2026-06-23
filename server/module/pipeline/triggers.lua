local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1
L0_1 = nil
L1_1 = nil
function L2_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
GetRecalibrationInProgress = L2_1
function L2_1()
  local L0_2, L1_2
  L0_2 = L1_1
  return L0_2
end
GetPhotosInProgress = L2_1
L2_1 = false
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_enable_dangerous_commands"
function L5_1(A0_2)
  local L1_2, L2_2, L3_2
  if 0 ~= A0_2 then
    L1_2 = SendNotification
    L2_2 = A0_2
    L3_2 = "This command must be ran from server console (like txAdmin)"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = true
  L2_1 = L1_2
  L1_2 = print
  L2_2 = "[PIPELINE] Dangerous commands enabled!"
  L1_2(L2_2)
  L1_2 = Wait
  L2_2 = 3600000
  L1_2(L2_2)
  L1_2 = false
  L2_1 = L1_2
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_detect_replace_clothing"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if 0 ~= A0_2 then
    L2_2 = SendNotification
    L3_2 = A0_2
    L4_2 = "This command must be ran from server console (like txAdmin)"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L2_1
  if not L2_2 then
    L2_2 = print
    L3_2 = "This command can unintentionally change your data in unexpected ways."
    L2_2(L3_2)
    L2_2 = print
    L3_2 = "Check our documentation to see what this command does and how to enable it."
    L2_2(L3_2)
    return
  end
  L2_2 = print
  L3_2 = "[PIPELINE] Detecting replace clothes"
  L2_2(L3_2)
  L2_2 = TriggerEvent
  L3_2 = "rcore_clothing:getClothingFiles"
  L2_2(L3_2)
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_migrate_hashes"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if 0 ~= A0_2 then
    L2_2 = SendNotification
    L3_2 = A0_2
    L4_2 = "This command must be ran from server console (like txAdmin)"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L2_1
  if not L2_2 then
    L2_2 = print
    L3_2 = "This command can unintentionally change your data in unexpected ways."
    L2_2(L3_2)
    L2_2 = print
    L3_2 = "Check our documentation to see what this command does and how to enable it."
    L2_2(L3_2)
    return
  end
  L2_2 = A1_2[1]
  if not L2_2 then
    L3_2 = print
    L4_2 = "Usage: rcore_clothing_migrate_hashes <serverId>"
    L3_2(L4_2)
    return
  end
  L3_2 = tonumber
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L2_2 = L3_2
  if L2_2 > 0 then
    L3_2 = GetPlayerPing
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 > 0 then
      L3_2 = Stage00MigrateHashes
      L4_2 = L2_2
      L3_2(L4_2)
  end
  else
    L3_2 = print
    L4_2 = "Invalid serverId"
    L3_2(L4_2)
  end
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_recalibrate"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if 0 ~= A0_2 then
    L2_2 = SendNotification
    L3_2 = A0_2
    L4_2 = "This command must be ran from server console (like txAdmin)"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L2_1
  if not L2_2 then
    L2_2 = print
    L3_2 = "This command can unintentionally change your data in unexpected ways."
    L2_2(L3_2)
    L2_2 = print
    L3_2 = "Check our documentation to see what this command does and how to enable it."
    L2_2(L3_2)
    return
  end
  L2_2 = A1_2[1]
  if not L2_2 then
    L3_2 = print
    L4_2 = "Usage: rcore_clothing_recalibrate <serverId>"
    L3_2(L4_2)
    return
  end
  L3_2 = IsAnyItemPendingMigration
  L3_2 = L3_2()
  if L3_2 then
    L3_2 = print
    L4_2 = "Before recalibrating, please run /rcore_clothing_migrate_hashes <serverId>"
    L3_2(L4_2)
    return
  end
  L3_2 = tonumber
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L2_2 = L3_2
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "number" ~= L3_2 then
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    return
  end
  if L2_2 > 0 then
    L3_2 = GetPlayerPing
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 > 0 then
      L3_2 = PipelineDeletePrepare
      L3_2()
      L0_1 = L2_2
      L3_2 = print
      L4_2 = "[PIPELINE] Running re-calibration to find new clothes"
      L3_2(L4_2)
      L3_2 = TriggerClientEvent
      L4_2 = "rcore_clothing:pipelineInitStage1"
      L5_2 = L2_2
      L3_2(L4_2, L5_2)
  end
  else
    L3_2 = print
    L4_2 = "Invalid serverId"
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Invalid serverId"
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Invalid serverId"
    L3_2(L4_2)
  end
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_check_not_found"
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if 0 ~= A0_2 then
    L1_2 = SendNotification
    L2_2 = A0_2
    L3_2 = "This command must be ran from server console (like txAdmin)"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = PipelineDeleteGetCount
  L1_2 = L1_2()
  L2_2 = print
  L3_2 = "WARNING: Make sure you ran the re-calibration process recently"
  L2_2(L3_2)
  L2_2 = print
  L3_2 = "Number of clothing items registered, but not found: "
  L4_2 = L1_2
  L2_2(L3_2, L4_2)
  L2_2 = print
  L3_2 = "If you want to delete these not-found clothing items, run /rcore_clothing_delete_not_found"
  L2_2(L3_2)
  L2_2 = print
  L3_2 = "We recommend you to make a database backup before running that command."
  L2_2(L3_2)
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_delete_not_found"
function L5_1(A0_2)
  local L1_2, L2_2, L3_2
  if 0 ~= A0_2 then
    L1_2 = SendNotification
    L2_2 = A0_2
    L3_2 = "This command must be ran from server console (like txAdmin)"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = L2_1
  if not L1_2 then
    L1_2 = print
    L2_2 = "This command can unintentionally change your data in unexpected ways."
    L1_2(L2_2)
    L1_2 = print
    L2_2 = "Check our documentation to see what this command does and how to enable it."
    L1_2(L2_2)
    return
  end
  L1_2 = PipelineDeleteForReal
  L1_2()
  L1_2 = print
  L2_2 = "[PIPELINE] Deleted all clothing items that were not found"
  L1_2(L2_2)
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_photos"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if 0 ~= A0_2 then
    L2_2 = SendNotification
    L3_2 = A0_2
    L4_2 = "This command must be ran from server console (like txAdmin)"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L2_1
  if not L2_2 then
    L2_2 = print
    L3_2 = "This command can unintentionally change your data in unexpected ways."
    L2_2(L3_2)
    L2_2 = print
    L3_2 = "Check our documentation to see what this command does and how to enable it."
    L2_2(L3_2)
    return
  end
  L2_2 = A1_2[1]
  if not L2_2 then
    L3_2 = print
    L4_2 = "Usage: rcore_clothing_photos <serverId>"
    L3_2(L4_2)
    return
  end
  L3_2 = tonumber
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L2_2 = L3_2
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "number" ~= L3_2 then
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    return
  end
  L3_2 = nil
  L4_2 = A1_2[2]
  if L4_2 then
    L4_2 = tonumber
    L5_2 = A1_2[2]
    L4_2 = L4_2(L5_2)
    if L4_2 > 0 then
      L4_2 = tonumber
      L5_2 = A1_2[2]
      L4_2 = L4_2(L5_2)
      L3_2 = L4_2
    end
  end
  if L2_2 > 0 then
    L4_2 = GetPlayerPing
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    if L4_2 > 0 then
      L1_1 = L2_2
      L4_2 = print
      L5_2 = "[PIPELINE] Running screenshot pipeline"
      L4_2(L5_2)
      L4_2 = StartInitStage2
      L5_2 = L2_2
      L6_2 = false
      L7_2 = L3_2
      L4_2(L5_2, L6_2, L7_2)
  end
  else
    L4_2 = print
    L5_2 = "Invalid serverId"
    L4_2(L5_2)
    L4_2 = print
    L5_2 = "Invalid serverId"
    L4_2(L5_2)
    L4_2 = print
    L5_2 = "Invalid serverId"
    L4_2(L5_2)
  end
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_photos_manual"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if 0 ~= A0_2 then
    L2_2 = SendNotification
    L3_2 = A0_2
    L4_2 = "This command must be ran from server console (like txAdmin)"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L2_1
  if not L2_2 then
    L2_2 = print
    L3_2 = "This command can unintentionally change your data in unexpected ways."
    L2_2(L3_2)
    L2_2 = print
    L3_2 = "Check our documentation to see what this command does and how to enable it."
    L2_2(L3_2)
    return
  end
  L2_2 = A1_2[1]
  if not L2_2 then
    L3_2 = print
    L4_2 = "Usage: rcore_clothing_photos_manual <serverId>"
    L3_2(L4_2)
    return
  end
  L3_2 = tonumber
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L2_2 = L3_2
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "number" ~= L3_2 then
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    return
  end
  L3_2 = nil
  L4_2 = A1_2[2]
  if L4_2 then
    L4_2 = tonumber
    L5_2 = A1_2[2]
    L4_2 = L4_2(L5_2)
    if L4_2 > 0 then
      L4_2 = tonumber
      L5_2 = A1_2[2]
      L4_2 = L4_2(L5_2)
      L3_2 = L4_2
    end
  end
  if L2_2 > 0 then
    L4_2 = GetPlayerPing
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    if L4_2 > 0 then
      L1_1 = L2_2
      L4_2 = print
      L5_2 = "[PIPELINE] Running screenshot pipeline"
      L4_2(L5_2)
      L4_2 = StartInitStage2
      L5_2 = L2_2
      L6_2 = true
      L7_2 = L3_2
      L4_2(L5_2, L6_2, L7_2)
  end
  else
    L4_2 = print
    L5_2 = "Invalid serverId"
    L4_2(L5_2)
    L4_2 = print
    L5_2 = "Invalid serverId"
    L4_2(L5_2)
    L4_2 = print
    L5_2 = "Invalid serverId"
    L4_2(L5_2)
  end
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_soft_blacklist_invisible"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if 0 ~= A0_2 then
    L2_2 = SendNotification
    L3_2 = A0_2
    L4_2 = "This command must be ran from server console (like txAdmin)"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L2_1
  if not L2_2 then
    L2_2 = print
    L3_2 = "This command can unintentionally change your data in unexpected ways."
    L2_2(L3_2)
    L2_2 = print
    L3_2 = "Check our documentation to see what this command does and how to enable it."
    L2_2(L3_2)
    return
  end
  L2_2 = A1_2[1]
  if not L2_2 then
    L3_2 = print
    L4_2 = "Usage: rcore_clothing_soft_blacklist_invisible <serverId>"
    L3_2(L4_2)
    return
  end
  L3_2 = tonumber
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L2_2 = L3_2
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "number" ~= L3_2 then
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    L3_2 = print
    L4_2 = "Server ID must be a number."
    L3_2(L4_2)
    return
  end
  L3_2 = nil
  L4_2 = A1_2[2]
  if L4_2 then
    L4_2 = tonumber
    L5_2 = A1_2[2]
    L4_2 = L4_2(L5_2)
    if L4_2 > 0 then
      L4_2 = tonumber
      L5_2 = A1_2[2]
      L4_2 = L4_2(L5_2)
      L3_2 = L4_2
    end
  end
  if L2_2 > 0 then
    L4_2 = GetPlayerPing
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    if L4_2 > 0 then
      L1_1 = L2_2
      L4_2 = print
      L5_2 = "[PIPELINE] Running screenshot pipeline"
      L4_2(L5_2)
      L4_2 = StartInitStage4
      L5_2 = L2_2
      L6_2 = false
      L7_2 = L3_2
      L4_2(L5_2, L6_2, L7_2)
  end
  else
    L4_2 = print
    L5_2 = "Invalid serverId"
    L4_2(L5_2)
    L4_2 = print
    L5_2 = "Invalid serverId"
    L4_2(L5_2)
    L4_2 = print
    L5_2 = "Invalid serverId"
    L4_2(L5_2)
  end
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_credit"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if 0 ~= A0_2 then
    L2_2 = SendNotification
    L3_2 = A0_2
    L4_2 = "This command must be ran from server console (like txAdmin)"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = GetCredit
  L2_2 = L2_2()
  L3_2 = print
  L4_2 = "RCore AI Credit: "
  L5_2 = L2_2
  L4_2 = L4_2 .. L5_2
  L3_2(L4_2)
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_credit_claim"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if 0 ~= A0_2 then
    L2_2 = SendNotification
    L3_2 = A0_2
    L4_2 = "This command must be ran from server console (like txAdmin)"
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L2_1
  if not L2_2 then
    L2_2 = print
    L3_2 = "This command can unintentionally change your data in unexpected ways."
    L2_2(L3_2)
    L2_2 = print
    L3_2 = "Check our documentation to see what this command does and how to enable it."
    L2_2(L3_2)
    return
  end
  L2_2 = A1_2[1]
  if not L2_2 then
    L2_2 = print
    L3_2 = "Usage: rcore_clothing_credit_claim <tebex transaction ID>"
    L2_2(L3_2)
    return
  end
  L2_2 = A1_2[1]
  transactionId = L2_2
  L2_2 = StageCreditSyncHttpRequest
  L3_2 = "POST"
  L4_2 = "/account"
  L5_2 = {}
  L6_2 = GetServerSecret
  L6_2 = L6_2()
  L5_2.apiKey = L6_2
  L6_2 = transactionId
  L5_2.transactionId = L6_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2.success
  if L3_2 then
    L3_2 = print
    L4_2 = "Successfuly claimed "
    L5_2 = L2_2.credit_gained
    L6_2 = " RCore AI Credit"
    L4_2 = L4_2 .. L5_2 .. L6_2
    L3_2(L4_2)
  else
    L3_2 = L2_2.error_type
    if "already_claimed" == L3_2 then
      L3_2 = print
      L4_2 = "Credit for transaction ID "
      L5_2 = transactionId
      L6_2 = " was already claimed"
      L4_2 = L4_2 .. L5_2 .. L6_2
      L3_2(L4_2)
    else
      L3_2 = print
      L4_2 = "Failed to claim credit for transaction "
      L5_2 = transactionId
      L4_2 = L4_2 .. L5_2
      L3_2(L4_2)
    end
  end
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_ai"
function L5_1(A0_2)
  local L1_2, L2_2, L3_2
  if 0 ~= A0_2 then
    L1_2 = SendNotification
    L2_2 = A0_2
    L3_2 = "This command must be ran from server console (like txAdmin)"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = L2_1
  if not L1_2 then
    L1_2 = print
    L2_2 = "This command can unintentionally change your data in unexpected ways."
    L1_2(L2_2)
    L1_2 = print
    L2_2 = "Check our documentation to see what this command does and how to enable it."
    L1_2(L2_2)
    return
  end
  L1_2 = Pipeline3StartAIWorker
  L1_2()
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterCommand
L4_1 = "rcore_clothing_reapply_pricing_policy"
function L5_1(A0_2)
  local L1_2, L2_2, L3_2
  if 0 ~= A0_2 then
    L1_2 = SendNotification
    L2_2 = A0_2
    L3_2 = "This command must be ran from server console (like txAdmin)"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = L2_1
  if not L1_2 then
    L1_2 = print
    L2_2 = "This command can unintentionally change your data in unexpected ways."
    L1_2(L2_2)
    L1_2 = print
    L2_2 = "Check our documentation to see what this command does and how to enable it."
    L1_2(L2_2)
    return
  end
  L1_2 = print
  L2_2 = "[pipeline] Re-assigning prices according to pre-defined pricing policy"
  L1_2(L2_2)
  L1_2 = Stage4ResetPrices
  L1_2()
end
L6_1 = true
L3_1(L4_1, L5_1, L6_1)
