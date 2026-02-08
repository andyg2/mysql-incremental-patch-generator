-- Initializing temporary databases...
-- Importing schemas...
-- Generating Patch --

-- New Table: joinery_bak
CREATE TABLE IF NOT EXISTS `joinery_bak` (
  `joineryID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tenantID` int(10) unsigned NOT NULL,
  `projectID` int(10) unsigned NOT NULL,
  `quoteID` int(11) unsigned DEFAULT NULL,
  `joinery_number` varchar(50) NOT NULL,
  `status` varchar(50) DEFAULT 'Draft',
  `version` int(11) DEFAULT 1,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`joineryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- New Table: joinery_line_items_bak
CREATE TABLE IF NOT EXISTS `joinery_line_items_bak` (
  `jliID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) unsigned NOT NULL,
  `joineryID` int(11) unsigned NOT NULL,
  `phaseID` int(11) unsigned NOT NULL,
  `productID` int(11) unsigned DEFAULT NULL,
  `supplierID` int(11) unsigned DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT 0.00,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `is_labor` tinyint(1) NOT NULL DEFAULT 0,
  `hours` decimal(10,2) NOT NULL DEFAULT 0.00,
  `rate_per_hour` decimal(10,2) NOT NULL DEFAULT 0.00,
  `markup` decimal(6,2) NOT NULL DEFAULT 15.00,
  `sort_order` int(11) DEFAULT 0,
  PRIMARY KEY (`jliID`),
  KEY `idx_joinery_phase` (`phaseID`),
  KEY `idx_product` (`productID`),
  KEY `idx_tenant_joinery_phase` (`tenantID`,`joineryID`,`phaseID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- New Table: joinery_phases_bak
CREATE TABLE IF NOT EXISTS `joinery_phases_bak` (
  `phaseID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) unsigned NOT NULL,
  `joineryID` int(11) unsigned NOT NULL,
  `phase_name` varchar(255) NOT NULL,
  `markup` decimal(10,2) NOT NULL DEFAULT 0.00,
  `phase_markup` decimal(10,2) NOT NULL DEFAULT 0.00,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `hours` decimal(10,2) DEFAULT 0.00,
  `rate_per_hour` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`phaseID`),
  KEY `tenantID` (`tenantID`),
  KEY `joineryID` (`joineryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- New Table: materials__old
CREATE TABLE IF NOT EXISTS `materials__old` (
  `materialID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) unsigned NOT NULL,
  `material_name` varchar(255) NOT NULL,
  `upc` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `supplierID` int(11) unsigned DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `unit_of_measure` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`materialID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- New Table: material_price_history__old
CREATE TABLE IF NOT EXISTS `material_price_history__old` (
  `mphID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) unsigned NOT NULL,
  `materialID` int(11) unsigned NOT NULL,
  `supplierID` int(11) unsigned NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `price_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`mphID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- New Table: material_suppliers__old
CREATE TABLE IF NOT EXISTS `material_suppliers__old` (
  `materialSupplierID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) unsigned NOT NULL,
  `supplier_name` varchar(255) NOT NULL,
  `contact_name` varchar(100) DEFAULT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`materialSupplierID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- New Table: material_tags__old
CREATE TABLE IF NOT EXISTS `material_tags__old` (
  `materialTagID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) unsigned NOT NULL,
  `materialID` int(11) unsigned NOT NULL,
  `tagID` int(10) unsigned NOT NULL,
  `materialTagMasterID` int(11) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`materialTagID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- New Table: material_tag_master__old
CREATE TABLE IF NOT EXISTS `material_tag_master__old` (
  `materialTagMasterID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) unsigned NOT NULL,
  `tag_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`materialTagMasterID`),
  UNIQUE KEY `uq_mtag_tenant_name` (`tenantID`,`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- New Table: product_tags
CREATE TABLE IF NOT EXISTS `product_tags` (
  `productTagID` int(11) NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `tagID` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`productTagID`),
  UNIQUE KEY `tenant_product_tag` (`tenantID`,`productID`,`tagID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- New Table: tags
CREATE TABLE IF NOT EXISTS `tags` (
  `tagID` int(11) NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) NOT NULL,
  `tag_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`tagID`),
  UNIQUE KEY `tenantID_tag_name` (`tenantID`,`tag_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Updates for table: product_price_history
ALTER TABLE `product_price_history` ADD COLUMN `supplierID` int(11) unsigned NOT NULL    AFTER `productID`;

-- Migration check complete. --
