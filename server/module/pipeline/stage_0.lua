local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1
L0_1 = {}
L1_1 = "_u.ydd"
L2_1 = "_r.ydd"
L3_1 = "_uni.ytd"
L4_1 = "_whi.ytd"
L5_1 = "_bla.ytd"
L6_1 = "_chi.ytd"
L7_1 = "_lat.ytd"
L8_1 = "_ara.ytd"
L9_1 = "_bal.ytd"
L10_1 = "_jam.ytd"
L11_1 = "_kor.ytd"
L12_1 = "_ita.ytd"
L13_1 = "_pak.ytd"
L14_1 = ".ydd"
L15_1 = ".ytd"
L0_1[1] = L1_1
L0_1[2] = L2_1
L0_1[3] = L3_1
L0_1[4] = L4_1
L0_1[5] = L5_1
L0_1[6] = L6_1
L0_1[7] = L7_1
L0_1[8] = L8_1
L0_1[9] = L9_1
L0_1[10] = L10_1
L0_1[11] = L11_1
L0_1[12] = L12_1
L0_1[13] = L13_1
L0_1[14] = L14_1
L0_1[15] = L15_1
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = string
    L7_2 = L7_2.find
    L8_2 = A0_2
    L9_2 = L6_2
    L7_2, L8_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      L9_2 = string
      L9_2 = L9_2.sub
      L10_2 = A0_2
      L11_2 = 1
      L12_2 = L7_2 - 1
      return L9_2(L10_2, L11_2, L12_2)
    end
  end
  return A0_2
end
L2_1 = AddEventHandler
L3_1 = "rcore_clothing:computedClothingFiles"
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L1_2 = print
  L2_2 = "Finding clothing files to mark for reprocessing..."
  L1_2(L2_2)
  L1_2 = Wait
  L2_2 = 2000
  L1_2(L2_2)
  L1_2 = {}
  L2_2 = {}
  L3_2 = {}
  L4_2 = {}
  L5_2 = pairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = print
    L12_2 = "Marking "
    L13_2 = L9_2
    L14_2 = "/"
    L15_2 = #A0_2
    L16_2 = " for reprocessing ("
    L17_2 = L10_2
    L18_2 = ")"
    L12_2 = L12_2 .. L13_2 .. L14_2 .. L15_2 .. L16_2 .. L17_2 .. L18_2
    L11_2(L12_2)
    L11_2 = L1_1
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    L12_2 = MySQL
    L12_2 = L12_2.Sync
    L12_2 = L12_2.fetchAll
    L13_2 = [[
                SELECT rci.id, rci.decal_collection_hash
                FROM rcore_clothing_items rci
                WHERE rci.ytd_name = @ytd_name
        ]]
    L14_2 = {}
    L14_2["@ytd_name"] = L11_2
    L12_2 = L12_2(L13_2, L14_2)
    L13_2 = MySQL
    L13_2 = L13_2.Sync
    L13_2 = L13_2.fetchAll
    L14_2 = [[
                SELECT rci.id, rci.decal_collection_hash
                FROM rcore_clothing_items rci
                WHERE rci.ydd_name = @ydd_name
        ]]
    L15_2 = {}
    L15_2["@ydd_name"] = L11_2
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = pairs
    L15_2 = L12_2
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
      L20_2 = table
      L20_2 = L20_2.insert
      L21_2 = L1_2
      L22_2 = L19_2.id
      L20_2(L21_2, L22_2)
      L20_2 = L19_2.decal_collection_hash
      if L20_2 then
        L20_2 = table
        L20_2 = L20_2.insert
        L21_2 = L3_2
        L22_2 = L19_2.id
        L20_2(L21_2, L22_2)
      else
        L20_2 = table
        L20_2 = L20_2.insert
        L21_2 = L4_2
        L22_2 = L19_2.id
        L20_2(L21_2, L22_2)
      end
    end
    L14_2 = pairs
    L15_2 = L13_2
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
      L20_2 = table
      L20_2 = L20_2.insert
      L21_2 = L2_2
      L22_2 = L19_2.id
      L20_2(L21_2, L22_2)
      L20_2 = L19_2.decal_collection_hash
      if L20_2 then
        L20_2 = table
        L20_2 = L20_2.insert
        L21_2 = L3_2
        L22_2 = L19_2.id
        L20_2(L21_2, L22_2)
      else
        L20_2 = table
        L20_2 = L20_2.insert
        L21_2 = L4_2
        L22_2 = L19_2.id
        L20_2(L21_2, L22_2)
      end
    end
    L14_2 = #L1_2
    L15_2 = 300
    if not (L14_2 > L15_2) then
      L14_2 = #A0_2
      if L9_2 ~= L14_2 then
        goto lbl_163
      end
    end
    L14_2 = #L1_2
    if L14_2 > 0 then
      L14_2 = MySQL
      L14_2 = L14_2.Sync
      L14_2 = L14_2.execute
      L15_2 = [[
                    DELETE FROM rcore_clothing_item_shops
                    WHERE rcore_clothing_item_id IN (@ytdItems)
                    ]]
      L16_2 = {}
      L16_2["@ytdItems"] = L1_2
      L14_2(L15_2, L16_2)
    end
    L14_2 = #L2_2
    if L14_2 > 0 then
      L14_2 = MySQL
      L14_2 = L14_2.Sync
      L14_2 = L14_2.execute
      L15_2 = [[
                    DELETE FROM rcore_clothing_item_shops
                    WHERE rcore_clothing_item_id IN (@yddItems)
                    ]]
      L16_2 = {}
      L16_2["@yddItems"] = L2_2
      L14_2(L15_2, L16_2)
    end
    L14_2 = #L3_2
    if L14_2 > 0 then
      L14_2 = MySQL
      L14_2 = L14_2.Sync
      L14_2 = L14_2.execute
      L15_2 = [[
                    DELETE FROM rcore_clothing_items
                    WHERE id IN (@toDelete)
                ]]
      L16_2 = {}
      L16_2["@toDelete"] = L3_2
      L14_2(L15_2, L16_2)
    end
    L14_2 = #L4_2
    if L14_2 > 0 then
      L14_2 = MySQL
      L14_2 = L14_2.Sync
      L14_2 = L14_2.execute
      L15_2 = [[
                    UPDATE rcore_clothing_items
                    SET image_url=null, colors="", label="", type="", is_addon=1, ydd_name=null, ytd_name=null
                    WHERE id IN (@toUpdate)
                ]]
      L16_2 = {}
      L16_2["@toUpdate"] = L4_2
      L14_2(L15_2, L16_2)
    end
    L14_2 = {}
    L1_2 = L14_2
    L14_2 = {}
    L2_2 = L14_2
    L14_2 = {}
    L3_2 = L14_2
    L14_2 = {}
    L4_2 = L14_2
    ::lbl_163::
  end
end
L2_1(L3_1, L4_1)
