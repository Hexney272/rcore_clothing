local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1
L0_1 = {}
L1_1 = [[
        CREATE TABLE IF NOT EXISTS `rcore_clothing_current` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `ped_model` int(11) NOT NULL,
        `identifier` varchar(128) NOT NULL,
        `outfit` text NOT NULL,
        PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
    ]]
L2_1 = [[
        CREATE TABLE IF NOT EXISTS `rcore_clothing_items` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `ped_model` int(11) NOT NULL,
        `game_build` int(11) DEFAULT NULL,
        `name_hash` varchar(256) NOT NULL,
        `component_id` int(11) NOT NULL,
        `type` varchar(32) NOT NULL,
        `colors` varchar(64) NOT NULL,
        `drawable_id` int(11) NOT NULL,
        `texture_id` int(11) NOT NULL,
        `decal_collection_hash` int(11) DEFAULT NULL,
        `decal_name_hash` int(11) DEFAULT NULL,
        `label_gxt` varchar(64) DEFAULT NULL,
        `label` varchar(128) DEFAULT NULL,
        `price` int(11) DEFAULT NULL,
        `image_url` varchar(256) DEFAULT NULL,
        `recommended_arms` text DEFAULT NULL,
        `set_components` text DEFAULT NULL,
        `is_blacklisted` tinyint(4) NOT NULL,
        `is_soft_blacklisted` tinyint(4) DEFAULT 0,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
        `ydd_name` varchar(128) DEFAULT NULL,
        `ytd_name` varchar(128) DEFAULT NULL,
        `is_addon` tinyint(4) DEFAULT NULL,
        `is_found` tinyint(4) DEFAULT NULL,
        `custom_price` int(11) DEFAULT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `item_identifier` (`ped_model`,`component_id`,`name_hash`,`decal_collection_hash`,`decal_name_hash`),
        KEY `ped_model` (`ped_model`),
        KEY `component_id` (`component_id`),
        KEY `is_blacklisted` (`is_blacklisted`),
        KEY `rcore_clothing_items_ytd_name_index` (`ytd_name`),
        KEY `rcore_clothing_items_ydd_name_index` (`ydd_name`),
        KEY `rcore_clothing_items_ydd_name_ytd_name_index` (`ydd_name`, `ytd_name`),
        KEY `rcore_clothing_items_ydd_name_ytd_name_decal_hash_index` (`ydd_name`, `ytd_name`, `decal_collection_hash`),
        KEY `rcore_clothing_items_decal_collection_hash_index` (`decal_collection_hash`),
        KEY `rcore_clothing_items_ped_model_component_id_drawable_id_index` (`ped_model`,`component_id`,`drawable_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
    ]]
L3_1 = [[
        ALTER TABLE `rcore_clothing_current`
        ADD INDEX `identifier` (`identifier`);
    ]]
L4_1 = [[
        ALTER TABLE `rcore_clothing_items`
        ADD INDEX `ped_model_name_hash` (`ped_model`, `name_hash`);
    ]]
L5_1 = [[
        ALTER TABLE `rcore_clothing_items` ADD INDEX `rcore_items_idx_ped_model_game_build` (`ped_model`,`game_build`);
    ]]
L6_1 = [[
        ALTER TABLE `rcore_clothing_items` ADD INDEX `rcore_items_idx_ped_model_component_type` (`ped_model`,`component_id`,`type`);
    ]]
L7_1 = [[
    CREATE INDEX idx_clothing_items_ped_model_type_game_build ON rcore_clothing_items (ped_model, type, game_build);
    ]]
L8_1 = [[
        CREATE TABLE IF NOT EXISTS `rcore_clothing_item_restrictions` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `rcore_clothing_items_id` int(11) NOT NULL,
        `job` varchar(128) DEFAULT NULL,
        `job_grade` int(11) DEFAULT NULL,
        `identifier` varchar(128) DEFAULT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
        PRIMARY KEY (`id`),
        KEY `job` (`job`),
        KEY `job_grade` (`job_grade`),
        KEY `identifier` (`identifier`),
        KEY `rcore_clothing_items_id` (`rcore_clothing_items_id`),
        CONSTRAINT `rcore_clothing_item_restrictions_ibfk_2` FOREIGN KEY (`rcore_clothing_items_id`) REFERENCES `rcore_clothing_items` (`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
    ]]
L9_1 = [[
        CREATE TABLE IF NOT EXISTS `rcore_clothing_item_shops` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `rcore_clothing_item_id` int(11) NOT NULL,
        `shop_name` varchar(64) NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
        PRIMARY KEY (`id`),
        UNIQUE KEY `rcore_clothing_item_id_shop_name` (`rcore_clothing_item_id`,`shop_name`),
        KEY `rcore_clothing_item_id` (`rcore_clothing_item_id`),
        KEY `shop_name` (`shop_name`),
        CONSTRAINT `rcore_clothing_item_shops_ibfk_2` FOREIGN KEY (`rcore_clothing_item_id`) REFERENCES `rcore_clothing_items` (`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
    ]]
L10_1 = [[
        CREATE TABLE IF NOT EXISTS `rcore_clothing_outfits` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `ped_model` int(11) NOT NULL,
        `identifier` varchar(64) DEFAULT NULL,
        `shop_name` varchar(64) DEFAULT NULL,
        `name` varchar(128) DEFAULT NULL,
        `price` int(11) DEFAULT NULL,
        `outfit` text NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
        PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
    ]]
L11_1 = [[
        CREATE TABLE IF NOT EXISTS `rcore_clothing_outfit_restrictions` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `rcore_clothing_outfit_id` int(11) NOT NULL,
        `job` varchar(64) DEFAULT NULL,
        `job_grade` int(11) DEFAULT NULL,
        `identifier` varchar(128) DEFAULT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
        PRIMARY KEY (`id`),
        KEY `rcore_clothing_outfit_id` (`rcore_clothing_outfit_id`),
        CONSTRAINT `rcore_clothing_outfit_restrictions_ibfk_1` FOREIGN KEY (`rcore_clothing_outfit_id`) REFERENCES `rcore_clothing_outfits` (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
    ]]
L12_1 = [[
        CREATE TABLE IF NOT EXISTS `rcore_clothing_purchased` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `identifier` varchar(128) NOT NULL,
        `rcore_clothing_item_id` int(11) NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
        PRIMARY KEY (`id`),
        UNIQUE KEY `identifier_rcore_clothing_item_id` (`identifier`,`rcore_clothing_item_id`),
        KEY `rcore_clothing_item_id` (`rcore_clothing_item_id`),
        CONSTRAINT `rcore_clothing_purchased_ibfk_2` FOREIGN KEY (`rcore_clothing_item_id`) REFERENCES `rcore_clothing_items` (`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
    ]]
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
function L1_1()
  local L0_2, L1_2
  L0_2 = MySQL
  L0_2 = L0_2.Sync
  L0_2 = L0_2.fetchAll
  L1_2 = "SHOW TABLES LIKE 'rcore_clothing_items'"
  L0_2 = L0_2(L1_2)
  L1_2 = #L0_2
  L1_2 = L1_2 > 0
  return L1_2
end
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = {}
    L10_2 = "@id_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = "@ped_model_"
    L12_2 = L7_2
    L11_2 = L11_2 .. L12_2
    L12_2 = "@game_build_"
    L13_2 = L7_2
    L12_2 = L12_2 .. L13_2
    L13_2 = "@name_hash_"
    L14_2 = L7_2
    L13_2 = L13_2 .. L14_2
    L14_2 = "@component_id_"
    L15_2 = L7_2
    L14_2 = L14_2 .. L15_2
    L15_2 = "@type_"
    L16_2 = L7_2
    L15_2 = L15_2 .. L16_2
    L16_2 = "@colors_"
    L17_2 = L7_2
    L16_2 = L16_2 .. L17_2
    L17_2 = "@drawable_id_"
    L18_2 = L7_2
    L17_2 = L17_2 .. L18_2
    L18_2 = "@texture_id_"
    L19_2 = L7_2
    L18_2 = L18_2 .. L19_2
    L19_2 = "@decal_collection_hash_"
    L20_2 = L7_2
    L19_2 = L19_2 .. L20_2
    L20_2 = "@decal_name_hash_"
    L21_2 = L7_2
    L20_2 = L20_2 .. L21_2
    L21_2 = "@label_gxt_"
    L22_2 = L7_2
    L21_2 = L21_2 .. L22_2
    L22_2 = "@label_"
    L23_2 = L7_2
    L22_2 = L22_2 .. L23_2
    L23_2 = "@price_"
    L24_2 = L7_2
    L23_2 = L23_2 .. L24_2
    L24_2 = "@image_url_"
    L25_2 = L7_2
    L24_2 = L24_2 .. L25_2
    L25_2 = "@recommended_arms_"
    L26_2 = L7_2
    L25_2 = L25_2 .. L26_2
    L26_2 = "@set_components_"
    L27_2 = L7_2
    L26_2 = L26_2 .. L27_2
    L27_2 = "@is_blacklisted_"
    L28_2 = L7_2
    L27_2 = L27_2 .. L28_2
    L28_2 = "NOW()"
    L29_2 = "@ydd_name_"
    L30_2 = L7_2
    L29_2 = L29_2 .. L30_2
    L30_2 = "@ytd_name_"
    L31_2 = L7_2
    L30_2 = L30_2 .. L31_2
    L31_2 = "@is_addon_"
    L32_2 = L7_2
    L31_2 = L31_2 .. L32_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L9_2[3] = L12_2
    L9_2[4] = L13_2
    L9_2[5] = L14_2
    L9_2[6] = L15_2
    L9_2[7] = L16_2
    L9_2[8] = L17_2
    L9_2[9] = L18_2
    L9_2[10] = L19_2
    L9_2[11] = L20_2
    L9_2[12] = L21_2
    L9_2[13] = L22_2
    L9_2[14] = L23_2
    L9_2[15] = L24_2
    L9_2[16] = L25_2
    L9_2[17] = L26_2
    L9_2[18] = L27_2
    L9_2[19] = L28_2
    L9_2[20] = L29_2
    L9_2[21] = L30_2
    L9_2[22] = L31_2
    L10_2 = table
    L10_2 = L10_2.insert
    L11_2 = L1_2
    L12_2 = "("
    L13_2 = table
    L13_2 = L13_2.concat
    L14_2 = L9_2
    L15_2 = ", "
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = ")"
    L12_2 = L12_2 .. L13_2 .. L14_2
    L10_2(L11_2, L12_2)
    L10_2 = "@id_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[1]
    L2_2[L10_2] = L11_2
    L10_2 = "@ped_model_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[2]
    L2_2[L10_2] = L11_2
    L10_2 = "@game_build_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[3]
    L2_2[L10_2] = L11_2
    L10_2 = "@name_hash_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[4]
    L2_2[L10_2] = L11_2
    L10_2 = "@component_id_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[5]
    L2_2[L10_2] = L11_2
    L10_2 = "@type_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[6]
    L2_2[L10_2] = L11_2
    L10_2 = "@colors_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[7]
    L2_2[L10_2] = L11_2
    L10_2 = "@drawable_id_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[8]
    L2_2[L10_2] = L11_2
    L10_2 = "@texture_id_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[9]
    L2_2[L10_2] = L11_2
    L10_2 = "@decal_collection_hash_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[10]
    L2_2[L10_2] = L11_2
    L10_2 = "@decal_name_hash_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[11]
    L2_2[L10_2] = L11_2
    L10_2 = "@label_gxt_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[12]
    L2_2[L10_2] = L11_2
    L10_2 = "@label_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[13]
    L2_2[L10_2] = L11_2
    L10_2 = "@price_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[14]
    L2_2[L10_2] = L11_2
    L10_2 = "@image_url_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[15]
    L2_2[L10_2] = L11_2
    L10_2 = "@recommended_arms_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[16]
    L2_2[L10_2] = L11_2
    L10_2 = "@set_components_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[17]
    L2_2[L10_2] = L11_2
    L10_2 = "@is_blacklisted_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[18]
    L2_2[L10_2] = L11_2
    L10_2 = "@ydd_name_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[20]
    L2_2[L10_2] = L11_2
    L10_2 = "@ytd_name_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[21]
    L2_2[L10_2] = L11_2
    L10_2 = "@is_addon_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[22]
    L2_2[L10_2] = L11_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.Sync
  L3_2 = L3_2.execute
  L4_2 = [[
        INSERT INTO rcore_clothing_items (id, ped_model, game_build, name_hash, component_id, type, colors, drawable_id, texture_id, decal_collection_hash, decal_name_hash, label_gxt, label, price, image_url, recommended_arms, set_components, is_blacklisted, created_at, ydd_name, ytd_name, is_addon)
        VALUES ]]
  L5_2 = table
  L5_2 = L5_2.concat
  L6_2 = L1_2
  L7_2 = ", "
  L5_2 = L5_2(L6_2, L7_2)
  L4_2 = L4_2 .. L5_2
  L5_2 = L2_2
  L3_2(L4_2, L5_2)
end
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = {}
    L10_2 = "@id_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = "@rcore_clothing_item_id_"
    L12_2 = L7_2
    L11_2 = L11_2 .. L12_2
    L12_2 = "@shop_name_"
    L13_2 = L7_2
    L12_2 = L12_2 .. L13_2
    L13_2 = "NOW()"
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L9_2[3] = L12_2
    L9_2[4] = L13_2
    L10_2 = table
    L10_2 = L10_2.insert
    L11_2 = L1_2
    L12_2 = "("
    L13_2 = table
    L13_2 = L13_2.concat
    L14_2 = L9_2
    L15_2 = ", "
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = ")"
    L12_2 = L12_2 .. L13_2 .. L14_2
    L10_2(L11_2, L12_2)
    L10_2 = "@id_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[1]
    L2_2[L10_2] = L11_2
    L10_2 = "@rcore_clothing_item_id_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[2]
    L2_2[L10_2] = L11_2
    L10_2 = "@shop_name_"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L8_2[3]
    L2_2[L10_2] = L11_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.Sync
  L3_2 = L3_2.execute
  L4_2 = [[
        INSERT INTO rcore_clothing_item_shops (id, rcore_clothing_item_id, shop_name, created_at)
        VALUES ]]
  L5_2 = table
  L5_2 = L5_2.concat
  L6_2 = L1_2
  L7_2 = ", "
  L5_2 = L5_2(L6_2, L7_2)
  L4_2 = L4_2 .. L5_2
  L5_2 = L2_2
  L3_2(L4_2, L5_2)
end
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = MySQL
  L0_2 = L0_2.Sync
  L0_2 = L0_2.fetchAll
  L1_2 = "SHOW COLUMNS FROM rcore_clothing_items LIKE 'name_hash'"
  L0_2 = L0_2(L1_2)
  L1_2 = #L0_2
  if L1_2 > 0 then
    L1_2 = L0_2[1]
    L1_2 = L1_2.Type
    L3_2 = L1_2
    L2_2 = L1_2.match
    L4_2 = "%((%d+)%)"
    L2_2 = L2_2(L3_2, L4_2)
    L3_2 = tonumber
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if 32 == L3_2 then
      L3_2 = MySQL
      L3_2 = L3_2.Sync
      L3_2 = L3_2.execute
      L4_2 = "ALTER TABLE rcore_clothing_items MODIFY name_hash VARCHAR(256)"
      L5_2 = {}
      L3_2(L4_2, L5_2)
      L3_2 = MySQL
      L3_2 = L3_2.Sync
      L3_2 = L3_2.execute
      L4_2 = [[
                ALTER TABLE `rcore_clothing_items`
                ADD INDEX `name_hash_ped_model` (`name_hash`, `ped_model`);
            ]]
      L3_2(L4_2)
    end
  end
end
MaybeMigrateNameHashColumn = L4_1
function L4_1()
  local L0_2, L1_2
  L0_2 = MySQL
  L0_2 = L0_2.Sync
  L0_2 = L0_2.fetchAll
  L1_2 = "SHOW COLUMNS FROM `rcore_clothing_items` LIKE \"is_soft_blacklisted\""
  L0_2 = L0_2(L1_2)
  L0_2 = #L0_2
  if 0 == L0_2 then
    L0_2 = MySQL
    L0_2 = L0_2.Sync
    L0_2 = L0_2.execute
    L1_2 = [[
            ALTER TABLE `rcore_clothing_items`
                ADD `is_soft_blacklisted` tinyint(4) DEFAULT 0 AFTER `is_blacklisted`;
        ]]
    L0_2(L1_2)
  end
end
MaybeMigrateSoftBlacklist = L4_1
function L4_1()
  local L0_2, L1_2
  L0_2 = MySQL
  L0_2 = L0_2.Sync
  L0_2 = L0_2.fetchAll
  L1_2 = "SHOW COLUMNS FROM `rcore_clothing_items` LIKE \"custom_price\""
  L0_2 = L0_2(L1_2)
  L0_2 = #L0_2
  if 0 == L0_2 then
    L0_2 = MySQL
    L0_2 = L0_2.Sync
    L0_2 = L0_2.execute
    L1_2 = [[
            ALTER TABLE `rcore_clothing_items`
                ADD `custom_price` int(11) DEFAULT NULL AFTER `is_found`;
        ]]
    L0_2(L1_2)
  end
end
MaybeMigrateCustomPrice = L4_1
L4_1 = Citizen
L4_1 = L4_1.CreateThread
function L5_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = L1_1
  L0_2 = L0_2()
  if L0_2 then
    L0_2 = MaybeMigrateNameHashColumn
    L0_2()
    L0_2 = MaybeMigrateSoftBlacklist
    L0_2()
    L0_2 = MaybeMigrateCustomPrice
    L0_2()
    return
  end
  L0_2 = print
  L1_2 = "[SETUP] Creating database tables..."
  L0_2(L1_2)
  L0_2 = ipairs
  L1_2 = L0_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = MySQL
    L6_2 = L6_2.Sync
    L6_2 = L6_2.execute
    L7_2 = L5_2
    L8_2 = {}
    L6_2(L7_2, L8_2)
  end
  L0_2 = print
  L1_2 = "[SETUP] Created tables for rcore_clothing"
  L0_2(L1_2)
  L0_2 = print
  L1_2 = "[SETUP] Creating shop items..."
  L0_2(L1_2)
  L0_2 = 1
  L1_2 = 2000
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = print
    L5_2 = "[SETUP] Creating shop items from batch "
    L6_2 = L3_2
    L5_2 = L5_2 .. L6_2
    L4_2(L5_2)
    L4_2 = LoadResourceFile
    L5_2 = GetCurrentResourceName
    L5_2 = L5_2()
    L6_2 = "server/db_migration/data/items_"
    L7_2 = L3_2
    L8_2 = ".json"
    L6_2 = L6_2 .. L7_2 .. L8_2
    L4_2 = L4_2(L5_2, L6_2)
    if nil == L4_2 or "" == L4_2 then
      break
    end
    L5_2 = json
    L5_2 = L5_2.decode
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    L6_2 = L2_1
    L7_2 = L5_2
    L6_2(L7_2)
  end
  L0_2 = print
  L1_2 = "[SETUP] Creating shop assignments..."
  L0_2(L1_2)
  L0_2 = 1
  L1_2 = 2000
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = print
    L5_2 = "[SETUP] Creating shop assignments from batch "
    L6_2 = L3_2
    L5_2 = L5_2 .. L6_2
    L4_2(L5_2)
    L4_2 = LoadResourceFile
    L5_2 = GetCurrentResourceName
    L5_2 = L5_2()
    L6_2 = "server/db_migration/data/shops_"
    L7_2 = L3_2
    L8_2 = ".json"
    L6_2 = L6_2 .. L7_2 .. L8_2
    L4_2 = L4_2(L5_2, L6_2)
    if nil == L4_2 or "" == L4_2 then
      break
    end
    L5_2 = json
    L5_2 = L5_2.decode
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    L6_2 = L3_1
    L7_2 = L5_2
    L6_2(L7_2)
  end
  L0_2 = print
  L1_2 = "[SETUP] Finished inserting database data"
  L0_2(L1_2)
end
L4_1(L5_1)
