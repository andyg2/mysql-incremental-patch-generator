-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 08, 2026 at 09:19 AM
-- Server version: 10.6.22-MariaDB-ubu2004
-- PHP Version: 8.2.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `abc_projects`
--

-- --------------------------------------------------------

--
-- Table structure for table `attachments`
--

CREATE TABLE `attachments` (
  `attachmentID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `parent_entityID` int(11) UNSIGNED NOT NULL,
  `parent_entity_type` varchar(50) NOT NULL,
  `file_name_original` varchar(255) NOT NULL,
  `file_name_stored` varchar(255) NOT NULL,
  `file_path` varchar(512) NOT NULL,
  `file_type_mime` varchar(100) DEFAULT NULL,
  `file_size_bytes` int(15) UNSIGNED DEFAULT NULL,
  `description` text DEFAULT NULL,
  `uploaded_by` int(11) UNSIGNED DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `auditID` bigint(20) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `userID` int(11) UNSIGNED DEFAULT NULL,
  `action_type` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entityID` int(11) UNSIGNED DEFAULT NULL,
  `details_before` text DEFAULT NULL,
  `details_after` text DEFAULT NULL,
  `details_diff` text DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `call_notes`
--

CREATE TABLE `call_notes` (
  `callNoteID` int(11) NOT NULL,
  `tenantID` int(11) NOT NULL,
  `invoiceID` int(11) NOT NULL,
  `note_content` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `company_details`
--

CREATE TABLE `company_details` (
  `companyID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `logo_filename` varchar(255) DEFAULT NULL,
  `address_street` varchar(255) DEFAULT NULL,
  `address_city` varchar(100) DEFAULT NULL,
  `address_state` varchar(100) DEFAULT NULL,
  `address_zip` varchar(20) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `language` varchar(10) DEFAULT 'en-US',
  `date_format` varchar(20) DEFAULT 'YYYY-MM-DD',
  `currency_symbol` varchar(5) DEFAULT '$'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `invoiceID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `projectID` int(11) UNSIGNED NOT NULL,
  `quoteID` int(11) UNSIGNED NOT NULL COMMENT 'Source quote that was approved',
  `invoice_number` varchar(50) NOT NULL,
  `version` int(11) UNSIGNED NOT NULL DEFAULT 1,
  `revision_notes` text DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Draft',
  `issue_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `terms` varchar(100) DEFAULT 'Net 30 Days',
  `paid_date` date DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT 0.00,
  `original_percentage` decimal(5,2) DEFAULT 0.00,
  `original_quote_total` decimal(10,2) DEFAULT 0.00,
  `tax_amount` decimal(10,2) DEFAULT 0.00,
  `discount_amount` decimal(10,2) DEFAULT 0.00,
  `created_by` int(11) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_line_items`
--

CREATE TABLE `invoice_line_items` (
  `iliID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `invoiceID` int(11) UNSIGNED NOT NULL,
  `phaseID` int(11) DEFAULT NULL,
  `quote_phaseID` int(11) UNSIGNED DEFAULT NULL,
  `productID` int(11) UNSIGNED DEFAULT NULL,
  `description` text NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `markup` float(5,2) NOT NULL DEFAULT 15.00,
  `markup_percent` float(5,2) DEFAULT 0.00,
  `unit_of_measure` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `sort_order` int(11) UNSIGNED DEFAULT 0,
  `supplierID` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_phases`
--

CREATE TABLE `invoice_phases` (
  `phaseID` int(11) NOT NULL,
  `tenantID` int(11) NOT NULL,
  `invoiceID` int(11) NOT NULL,
  `phase_name` varchar(255) NOT NULL,
  `sort_order` int(11) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_quotes`
--

CREATE TABLE `invoice_quotes` (
  `iqID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `invoiceID` int(11) UNSIGNED NOT NULL,
  `quoteID` int(11) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_statuses`
--

CREATE TABLE `invoice_statuses` (
  `statusID` int(11) NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `status_name` varchar(50) NOT NULL,
  `sequence` int(3) NOT NULL,
  `is_active` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `joinery`
--

CREATE TABLE `joinery` (
  `joineryID` int(10) UNSIGNED NOT NULL,
  `tenantID` int(10) UNSIGNED NOT NULL,
  `projectID` int(10) UNSIGNED NOT NULL,
  `quoteID` int(11) UNSIGNED DEFAULT NULL,
  `joinery_number` varchar(50) NOT NULL,
  `status` varchar(50) DEFAULT 'Draft',
  `version` int(11) DEFAULT 1,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `joinery_line_items`
--

CREATE TABLE `joinery_line_items` (
  `jliID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `joineryID` int(11) UNSIGNED NOT NULL,
  `phaseID` int(11) UNSIGNED NOT NULL,
  `description` varchar(255) NOT NULL,
  `hours` decimal(10,2) NOT NULL DEFAULT 0.00,
  `rate_per_hour` decimal(10,2) NOT NULL DEFAULT 0.00,
  `markup` decimal(6,2) NOT NULL DEFAULT 15.00,
  `sort_order` int(11) DEFAULT 0,
  `productID` int(11) NOT NULL DEFAULT 0,
  `supplierID` int(11) DEFAULT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT 0.00,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `is_labor` tinyint(1) NOT NULL DEFAULT 1,
  `quoteID` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `joinery_phases`
--

CREATE TABLE `joinery_phases` (
  `phaseID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `joineryID` int(11) UNSIGNED NOT NULL,
  `phase_name` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Phase notes/comments'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `paymentID` int(11) NOT NULL,
  `tenantID` int(11) NOT NULL,
  `invoiceID` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `reference` varchar(100) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `po`
--

CREATE TABLE `po` (
  `poID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `projectID` int(11) UNSIGNED NOT NULL,
  `supplierID` int(11) UNSIGNED DEFAULT NULL,
  `po_number` varchar(50) NOT NULL,
  `order_date` date NOT NULL,
  `expected_delivery_date` date DEFAULT NULL,
  `actual_delivery_date` date DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Draft',
  `shipping_address` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `po_line_items`
--

CREATE TABLE `po_line_items` (
  `poliID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `poID` int(11) UNSIGNED NOT NULL,
  `productID` int(11) UNSIGNED DEFAULT NULL,
  `qliID` int(11) UNSIGNED DEFAULT NULL,
  `description` text NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `unit_of_measure` varchar(50) DEFAULT NULL,
  `received_quantity` decimal(10,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `is_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `po_payments`
--

CREATE TABLE `po_payments` (
  `popID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `poID` int(11) UNSIGNED NOT NULL,
  `payment_date` date NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `payment_method` varchar(100) DEFAULT NULL,
  `reference_number` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `recorded_by` int(11) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `po_statuses`
--

CREATE TABLE `po_statuses` (
  `statusID` int(11) NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `status_name` varchar(50) NOT NULL,
  `sequence` int(3) NOT NULL,
  `is_active` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `productID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `upc` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `unit_of_measure` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) UNSIGNED NOT NULL DEFAULT 1,
  `supplierID` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_price_history`
--

CREATE TABLE `product_price_history` (
  `pphID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `productID` int(11) UNSIGNED NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `price_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `projectID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `client_name` varchar(255) NOT NULL,
  `site_address` text DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `statusID` int(11) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_default_phases`
--

CREATE TABLE `project_default_phases` (
  `defaultPhaseID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) NOT NULL,
  `projectID` int(11) UNSIGNED NOT NULL,
  `phaseID` int(11) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_phases`
--

CREATE TABLE `project_phases` (
  `projectPhaseID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `template_name` varchar(255) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_phase_line_items`
--

CREATE TABLE `project_phase_line_items` (
  `templateItemID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `projectPhaseID` int(11) UNSIGNED NOT NULL,
  `templatePhaseID` int(11) UNSIGNED DEFAULT NULL,
  `productID` int(11) UNSIGNED DEFAULT NULL,
  `description` text NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `unit_of_measure` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `supplierID` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_phase_phases`
--

CREATE TABLE `project_phase_phases` (
  `templatePhaseID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `projectPhaseID` int(11) UNSIGNED NOT NULL,
  `phase_name` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_phase_template_items`
--

CREATE TABLE `project_phase_template_items` (
  `templateItemID` int(11) NOT NULL,
  `tenantID` int(11) NOT NULL,
  `projectPhaseID` int(11) NOT NULL COMMENT 'Links to the template header',
  `templatePhaseID` int(11) NOT NULL COMMENT 'Links to the specific phase',
  `productID` int(11) NOT NULL COMMENT 'Links to the product',
  `default_quantity` decimal(10,2) NOT NULL DEFAULT 1.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_specifications`
--

CREATE TABLE `project_specifications` (
  `psID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `projectID` int(11) UNSIGNED NOT NULL,
  `tsID` int(11) UNSIGNED DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `materials` text DEFAULT NULL,
  `labor_notes` text DEFAULT NULL,
  `measurements` text DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_statuses`
--

CREATE TABLE `project_statuses` (
  `statusID` int(11) NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `status_name` varchar(50) NOT NULL,
  `status_class` varchar(20) NOT NULL,
  `sequence` int(3) NOT NULL,
  `is_active` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quotes`
--

CREATE TABLE `quotes` (
  `quoteID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `projectID` int(11) UNSIGNED NOT NULL,
  `quote_number` varchar(50) NOT NULL,
  `version` int(11) UNSIGNED NOT NULL DEFAULT 1,
  `revision_notes` text DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Draft',
  `approval_token` varchar(255) DEFAULT NULL,
  `markup_percentage` decimal(5,2) DEFAULT NULL,
  `discount_percentage` decimal(5,2) DEFAULT NULL,
  `valid_until_date` date DEFAULT NULL,
  `sent_date` date DEFAULT NULL,
  `sent_to_client_at` datetime DEFAULT NULL,
  `approved_date` date DEFAULT NULL,
  `client_decision_at` datetime DEFAULT NULL,
  `created_by` int(11) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quote_line_items`
--

CREATE TABLE `quote_line_items` (
  `qliID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `quoteID` int(11) UNSIGNED NOT NULL,
  `phaseID` int(11) UNSIGNED DEFAULT NULL,
  `productID` int(11) UNSIGNED DEFAULT NULL,
  `supplierID` int(11) DEFAULT NULL,
  `description` text NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `markup` float(5,2) NOT NULL DEFAULT 15.00,
  `unit_of_measure` varchar(50) DEFAULT NULL,
  `is_pc_sum` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `sort_order` int(11) UNSIGNED DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quote_phases`
--

CREATE TABLE `quote_phases` (
  `phaseID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `quoteID` int(11) UNSIGNED NOT NULL,
  `phase_name` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Phase notes/comments'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quote_statuses`
--

CREATE TABLE `quote_statuses` (
  `statusID` int(11) NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `status_name` varchar(50) NOT NULL,
  `sequence` int(3) NOT NULL,
  `is_active` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receiving_log`
--

CREATE TABLE `receiving_log` (
  `logID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `poID` int(11) UNSIGNED NOT NULL,
  `poliID` int(11) UNSIGNED NOT NULL,
  `quantity_received` decimal(10,2) NOT NULL,
  `received_by_userID` int(11) UNSIGNED DEFAULT NULL,
  `received_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receiving_photos`
--

CREATE TABLE `receiving_photos` (
  `photoID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `logID` int(11) UNSIGNED NOT NULL,
  `file_name_stored` varchar(255) NOT NULL,
  `file_path` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `roleID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `role_description` text NOT NULL,
  `is_active` int(1) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplierID` int(11) NOT NULL,
  `tenantID` int(11) NOT NULL,
  `supplier_name` varchar(255) NOT NULL,
  `contact_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tenants`
--

CREATE TABLE `tenants` (
  `tenantID` int(11) UNSIGNED NOT NULL,
  `tenant_name` varchar(30) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `onboarding_complete` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `is_active` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `roleID` int(3) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `invitation_token` varchar(255) DEFAULT NULL,
  `invitation_expires_at` datetime DEFAULT NULL,
  `full_name` varchar(255) NOT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_verified` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `variations`
--

CREATE TABLE `variations` (
  `variationID` int(11) UNSIGNED NOT NULL,
  `tenantID` int(11) UNSIGNED NOT NULL,
  `projectID` int(11) UNSIGNED NOT NULL,
  `original_quoteID` int(11) UNSIGNED DEFAULT NULL,
  `variation_number` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `reason_for_change` text DEFAULT NULL,
  `cost_impact` decimal(10,2) NOT NULL,
  `approval_status` varchar(50) NOT NULL DEFAULT 'Pending',
  `requested_by` varchar(255) DEFAULT NULL,
  `date_requested` date DEFAULT NULL,
  `date_approved_rejected` date DEFAULT NULL,
  `created_by` int(11) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attachments`
--
ALTER TABLE `attachments`
  ADD PRIMARY KEY (`attachmentID`),
  ADD KEY `idx_attachments_parent_entity` (`parent_entity_type`,`parent_entityID`),
  ADD KEY `idx_attachments_uploaded_by` (`uploaded_by`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`auditID`),
  ADD KEY `idx_audit_logs_userID` (`userID`),
  ADD KEY `idx_audit_logs_entity` (`entity_type`,`entityID`),
  ADD KEY `idx_audit_logs_action_type` (`action_type`),
  ADD KEY `idx_audit_logs_created_at` (`created_at`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `call_notes`
--
ALTER TABLE `call_notes`
  ADD PRIMARY KEY (`callNoteID`),
  ADD UNIQUE KEY `unique_invoice_note` (`tenantID`,`invoiceID`),
  ADD KEY `idx_tenant_invoice` (`tenantID`,`invoiceID`);

--
-- Indexes for table `company_details`
--
ALTER TABLE `company_details`
  ADD PRIMARY KEY (`companyID`),
  ADD UNIQUE KEY `tenantID` (`tenantID`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`invoiceID`),
  ADD KEY `idx_projectID` (`projectID`),
  ADD KEY `idx_quoteID` (`quoteID`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `invoice_line_items`
--
ALTER TABLE `invoice_line_items`
  ADD PRIMARY KEY (`iliID`),
  ADD KEY `idx_invoiceID` (`invoiceID`),
  ADD KEY `idx_productID` (`productID`),
  ADD KEY `idx_quote_phaseID` (`quote_phaseID`),
  ADD KEY `tenantID` (`tenantID`),
  ADD KEY `idx_phase` (`phaseID`);

--
-- Indexes for table `invoice_phases`
--
ALTER TABLE `invoice_phases`
  ADD PRIMARY KEY (`phaseID`),
  ADD KEY `idx_tenant_invoice` (`tenantID`,`invoiceID`);

--
-- Indexes for table `invoice_quotes`
--
ALTER TABLE `invoice_quotes`
  ADD PRIMARY KEY (`iqID`),
  ADD KEY `idx_tenant_invoice` (`tenantID`,`invoiceID`),
  ADD KEY `idx_quote` (`quoteID`);

--
-- Indexes for table `invoice_statuses`
--
ALTER TABLE `invoice_statuses`
  ADD PRIMARY KEY (`statusID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `joinery`
--
ALTER TABLE `joinery`
  ADD PRIMARY KEY (`joineryID`);

--
-- Indexes for table `joinery_line_items`
--
ALTER TABLE `joinery_line_items`
  ADD PRIMARY KEY (`jliID`),
  ADD KEY `idx_joinery_phase` (`phaseID`),
  ADD KEY `idx_tenant_joinery_phase` (`tenantID`,`joineryID`,`phaseID`);

--
-- Indexes for table `joinery_phases`
--
ALTER TABLE `joinery_phases`
  ADD PRIMARY KEY (`phaseID`),
  ADD KEY `tenantID` (`tenantID`),
  ADD KEY `joineryID` (`joineryID`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`paymentID`),
  ADD KEY `tenantID` (`tenantID`),
  ADD KEY `invoiceID` (`invoiceID`),
  ADD KEY `payment_date` (`payment_date`);

--
-- Indexes for table `po`
--
ALTER TABLE `po`
  ADD PRIMARY KEY (`poID`),
  ADD UNIQUE KEY `idx_purchase_orders_po_number_unique` (`po_number`),
  ADD KEY `idx_purchase_orders_projectID` (`projectID`),
  ADD KEY `idx_purchase_orders_status` (`status`),
  ADD KEY `idx_purchase_orders_created_by` (`created_by`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `po_line_items`
--
ALTER TABLE `po_line_items`
  ADD PRIMARY KEY (`poliID`),
  ADD KEY `idx_po_line_items_poID` (`poID`),
  ADD KEY `idx_po_line_items_productID` (`productID`),
  ADD KEY `idx_po_line_items_qliID` (`qliID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `po_payments`
--
ALTER TABLE `po_payments`
  ADD PRIMARY KEY (`popID`),
  ADD KEY `idx_po_payments_poID` (`poID`),
  ADD KEY `idx_po_payments_recorded_by` (`recorded_by`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `po_statuses`
--
ALTER TABLE `po_statuses`
  ADD PRIMARY KEY (`statusID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`productID`),
  ADD UNIQUE KEY `idx_products_upc_unique` (`upc`),
  ADD KEY `idx_products_product_name` (`product_name`(250)),
  ADD KEY `tenantID` (`tenantID`),
  ADD KEY `idx_supplier` (`supplierID`);

--
-- Indexes for table `product_price_history`
--
ALTER TABLE `product_price_history`
  ADD PRIMARY KEY (`pphID`),
  ADD KEY `idx_product_price_history_productID` (`productID`),
  ADD KEY `idx_product_price_history_price_date` (`price_date`),
  ADD KEY `idx_product_price_history_prod_supp_date` (`productID`,`price_date`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`projectID`),
  ADD KEY `idx_projects_created_by` (`created_by`),
  ADD KEY `idx_projects_status` (`statusID`),
  ADD KEY `idx_projects_client_name` (`client_name`(250)),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `project_default_phases`
--
ALTER TABLE `project_default_phases`
  ADD PRIMARY KEY (`defaultPhaseID`),
  ADD KEY `projectID` (`projectID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `project_phases`
--
ALTER TABLE `project_phases`
  ADD PRIMARY KEY (`projectPhaseID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `project_phase_line_items`
--
ALTER TABLE `project_phase_line_items`
  ADD PRIMARY KEY (`templateItemID`),
  ADD KEY `projectPhaseID` (`projectPhaseID`),
  ADD KEY `templatePhaseID` (`templatePhaseID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `project_phase_phases`
--
ALTER TABLE `project_phase_phases`
  ADD PRIMARY KEY (`templatePhaseID`),
  ADD KEY `projectPhaseID` (`projectPhaseID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `project_phase_template_items`
--
ALTER TABLE `project_phase_template_items`
  ADD PRIMARY KEY (`templateItemID`),
  ADD KEY `idx_template_phase` (`templatePhaseID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `project_specifications`
--
ALTER TABLE `project_specifications`
  ADD PRIMARY KEY (`psID`),
  ADD KEY `idx_project_specifications_projectID` (`projectID`),
  ADD KEY `idx_project_specifications_tsID` (`tsID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `project_statuses`
--
ALTER TABLE `project_statuses`
  ADD PRIMARY KEY (`statusID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `quotes`
--
ALTER TABLE `quotes`
  ADD PRIMARY KEY (`quoteID`),
  ADD UNIQUE KEY `idx_quotes_quote_number_unique` (`quote_number`),
  ADD KEY `idx_quotes_projectID` (`projectID`),
  ADD KEY `idx_quotes_status` (`status`),
  ADD KEY `idx_quotes_created_by` (`created_by`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `quote_line_items`
--
ALTER TABLE `quote_line_items`
  ADD PRIMARY KEY (`qliID`),
  ADD KEY `idx_quote_line_items_quoteID` (`quoteID`),
  ADD KEY `idx_quote_line_items_productID` (`productID`),
  ADD KEY `tenantID` (`tenantID`),
  ADD KEY `phaseID_idx` (`phaseID`);

--
-- Indexes for table `quote_phases`
--
ALTER TABLE `quote_phases`
  ADD PRIMARY KEY (`phaseID`),
  ADD KEY `quoteID_idx` (`quoteID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `quote_statuses`
--
ALTER TABLE `quote_statuses`
  ADD PRIMARY KEY (`statusID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `receiving_log`
--
ALTER TABLE `receiving_log`
  ADD PRIMARY KEY (`logID`),
  ADD KEY `poID` (`poID`),
  ADD KEY `poliID` (`poliID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `receiving_photos`
--
ALTER TABLE `receiving_photos`
  ADD PRIMARY KEY (`photoID`),
  ADD KEY `logID` (`logID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`roleID`),
  ADD KEY `tenantID` (`tenantID`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplierID`),
  ADD KEY `tenantID` (`tenantID`),
  ADD KEY `supplier_name` (`supplier_name`),
  ADD KEY `is_active` (`is_active`);

--
-- Indexes for table `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`tenantID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `idx_users_email_unique` (`email`) USING HASH,
  ADD KEY `tenantID` (`tenantID`),
  ADD KEY `tenantID_2` (`tenantID`),
  ADD KEY `roleID` (`roleID`);

--
-- Indexes for table `variations`
--
ALTER TABLE `variations`
  ADD PRIMARY KEY (`variationID`),
  ADD UNIQUE KEY `idx_variations_variation_number_unique` (`variation_number`),
  ADD KEY `idx_variations_projectID` (`projectID`),
  ADD KEY `idx_variations_original_quoteID` (`original_quoteID`),
  ADD KEY `idx_variations_approval_status` (`approval_status`),
  ADD KEY `idx_variations_created_by` (`created_by`),
  ADD KEY `tenantID` (`tenantID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attachments`
--
ALTER TABLE `attachments`
  MODIFY `attachmentID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `auditID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `call_notes`
--
ALTER TABLE `call_notes`
  MODIFY `callNoteID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `company_details`
--
ALTER TABLE `company_details`
  MODIFY `companyID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `invoiceID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_line_items`
--
ALTER TABLE `invoice_line_items`
  MODIFY `iliID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_phases`
--
ALTER TABLE `invoice_phases`
  MODIFY `phaseID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_quotes`
--
ALTER TABLE `invoice_quotes`
  MODIFY `iqID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_statuses`
--
ALTER TABLE `invoice_statuses`
  MODIFY `statusID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `joinery`
--
ALTER TABLE `joinery`
  MODIFY `joineryID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `joinery_line_items`
--
ALTER TABLE `joinery_line_items`
  MODIFY `jliID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `joinery_phases`
--
ALTER TABLE `joinery_phases`
  MODIFY `phaseID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `paymentID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `po`
--
ALTER TABLE `po`
  MODIFY `poID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `po_line_items`
--
ALTER TABLE `po_line_items`
  MODIFY `poliID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `po_payments`
--
ALTER TABLE `po_payments`
  MODIFY `popID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `po_statuses`
--
ALTER TABLE `po_statuses`
  MODIFY `statusID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `productID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_price_history`
--
ALTER TABLE `product_price_history`
  MODIFY `pphID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `projectID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_default_phases`
--
ALTER TABLE `project_default_phases`
  MODIFY `defaultPhaseID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_phases`
--
ALTER TABLE `project_phases`
  MODIFY `projectPhaseID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_phase_line_items`
--
ALTER TABLE `project_phase_line_items`
  MODIFY `templateItemID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_phase_phases`
--
ALTER TABLE `project_phase_phases`
  MODIFY `templatePhaseID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_phase_template_items`
--
ALTER TABLE `project_phase_template_items`
  MODIFY `templateItemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_specifications`
--
ALTER TABLE `project_specifications`
  MODIFY `psID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_statuses`
--
ALTER TABLE `project_statuses`
  MODIFY `statusID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quotes`
--
ALTER TABLE `quotes`
  MODIFY `quoteID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quote_line_items`
--
ALTER TABLE `quote_line_items`
  MODIFY `qliID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quote_phases`
--
ALTER TABLE `quote_phases`
  MODIFY `phaseID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quote_statuses`
--
ALTER TABLE `quote_statuses`
  MODIFY `statusID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `receiving_log`
--
ALTER TABLE `receiving_log`
  MODIFY `logID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `receiving_photos`
--
ALTER TABLE `receiving_photos`
  MODIFY `photoID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `roleID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplierID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `tenantID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `variations`
--
ALTER TABLE `variations`
  MODIFY `variationID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
