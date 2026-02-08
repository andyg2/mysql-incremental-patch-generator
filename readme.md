# MySQL Incremental Migration Patch Generator

A standalone PHP utility that compares two MySQL schema exports and generates a non-destructive, incremental SQL patch. It is designed for developers who need to push database updates to multiple client environments without altering existing data or fields.

## 🚀 Overview

This tool solves the problem of manual database synchronization. By importing a "before" and "after" schema into temporary databases, it uses MySQL's own `INFORMATION_SCHEMA` to identify exactly what has changed, generating a precise SQL script to bring the old database up to date.

## ✨ Key Features

- **Additive Only:** Generates `CREATE TABLE` and `ADD COLUMN` statements. It will never rename, modify, or drop existing columns.
- **PDO Powered:** Uses standard PHP Data Objects for database interactions, making it compatible with any modern PHP environment.
- **Order Preservation:** Uses `ORDINAL_POSITION` to place new columns using the `AFTER` or `FIRST` clause, ensuring the client's schema matches your development environment exactly.
- **Smart Sanitization:** Automatically strips `USE` and `CREATE DATABASE` commands from your SQL exports so the migration remains scoped to the correct target.
- **Cross-Platform:** Automatically detects the MySQL CLI path for both Windows (XAMPP default) and Linux environments.

## 📋 Prerequisites

- **PHP 8.0+**
- **PDO MySQL Extension**
- **MySQL Command Line Tool:** The `mysql` binary must be in your system path (or XAMPP bin folder).
- **Database Permissions:** The provided DB user must have `CREATE` and `DROP` database privileges.

## 🛠️ Setup

1. Open `migrate.php` and update the `DB_HOST`, `DB_USER`, and `DB_PASS` constants.
2. Ensure you have two files in the same directory:
    -   `old_schema.sql`: Your current client/production structure.
    -   `new_schema.sql`: Your updated development structure.
    *Note: These files should be structure-only (no data).*

## 📖 Usage

Run the script from your terminal:

```bash
php migrate.php > patch.sql
```

Review the `patch.sql` file. It will look like this:

```sql
-- New Table: logs
CREATE TABLE IF NOT EXISTS `logs` ( ... );

-- Updates for table: users
ALTER TABLE `users` ADD COLUMN `last_login` datetime NULL AFTER `password`;
ALTER TABLE `users` ADD COLUMN `is_active` tinyint(1) NOT NULL DEFAULT '1' AFTER `last_login`;
```

## ⚙️ How It Works

1. **Isolation:** Creates two temporary databases to act as a workspace.
2. **Safe Import:** Sanitizes the input SQL files and imports them into the temporary databases via the MySQL CLI.
3. **Schema Querying:** 
    -   Identifies tables that exist in the "new" schema but not the "old".
    -   Identifies columns that exist in the "new" schema but not the "old".
4. **Generation:** Constructs valid `ALTER` statements including types, nullability, default values, and comments.
5. **Cleanup:** Automatically drops the temporary databases upon completion.

## 📄 License

This project is open-source. Feel free to modify it for your internal deployment pipelines.
