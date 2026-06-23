local L0_1, L1_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = {}
  L2_2 = AceCan
  L3_2 = A0_2
  L4_2 = Permissions
  L4_2 = L4_2.USE_ADMIN_MODE
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.canUseAdminMode = L2_2
  L2_2 = AceCan
  L3_2 = A0_2
  L4_2 = Permissions
  L4_2 = L4_2.ADMIN_STOCK_MANAGEMENT
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.canUseStockManagement = L2_2
  L2_2 = AceCan
  L3_2 = A0_2
  L4_2 = Permissions
  L4_2 = L4_2.ADMIN_EDIT_METADATA
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.canEditMetadata = L2_2
  L2_2 = AceCan
  L3_2 = A0_2
  L4_2 = Permissions
  L4_2 = L4_2.ADMIN_EDIT_ARMS
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.canEditArms = L2_2
  L2_2 = AceCan
  L3_2 = A0_2
  L4_2 = Permissions
  L4_2 = L4_2.ADMIN_OUTFIT_EDITOR
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.canUseOutfitEditor = L2_2
  L2_2 = AceCan
  L3_2 = A0_2
  L4_2 = Permissions
  L4_2 = L4_2.ADMIN_IMAGE_DEBUG
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.canUseImageDebug = L2_2
  L2_2 = AceCan
  L3_2 = A0_2
  L4_2 = Permissions
  L4_2 = L4_2.TOGGLE_ID_ONLY_MODE
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.canToggleIdOnlyMode = L2_2
  return L1_2
end
GetPlayerPermissions = L0_1
