-- Initializing temporary databases...
-- Importing schemas...
-- Generating Patch --

-- Updates for table: joinery_line_items
ALTER TABLE `joinery_line_items` ADD COLUMN `notes` text NOT NULL    AFTER `quoteID`;
-- Updates for table: quote_phases
ALTER TABLE `quote_phases` ADD COLUMN `phase_notes` text NULL DEFAULT 'NULL'   AFTER `created_at`;
ALTER TABLE `quote_phases` ADD COLUMN `dropbox_files` text NULL DEFAULT 'NULL'   AFTER `phase_notes`;

-- Migration check complete. --
