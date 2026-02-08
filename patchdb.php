<?php

/**
 * MySQL Incremental Migration Patch Generator (PDO Version)
 * 
 * Usage: 
 * 1. Place old_schema.sql and new_schema.sql in the folder.
 * 2. Run: php migrate.php > patch.sql
 */

// --- CONFIGURATION ---
// Replace these with your actual credentials or environment variables
define('DB_HOST', '127.0.0.1');
define('DB_USER', 'root');
define('DB_PASS', '');


// These are just temporary databases they will be created and destroyed
$dbOldName  = 'temp_migration_old';
$dbNewName  = 'temp_migration_new';

$oldSqlFile = 'old_schema.sql';
$newSqlFile = 'new_schema.sql';

$mysql_path_linux = '/usr/bin/mysql';
$mysql_path_windows = 'C:\xampp\mysql\bin\mysql.exe';


// OS-specific MySQL CLI path
if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
  define('MYSQL_PATH', $mysql_path_windows);
} else {
  define('MYSQL_PATH', $mysql_path_linux);
}

try {
  // 1. Establish PDO Connection
  $dsn = "mysql:host=" . DB_HOST . ";charset=utf8mb4";
  $pdo = new PDO($dsn, DB_USER, DB_PASS, [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  ]);

  echo "-- Initializing temporary databases...\n";
  $pdo->exec("DROP DATABASE IF EXISTS `$dbOldName` text;");
  $pdo->exec("CREATE DATABASE `$dbOldName`;");
  $pdo->exec("DROP DATABASE IF EXISTS `$dbNewName`;");
  $pdo->exec("CREATE DATABASE `$dbNewName`;");

  /**
   * Prepares a SQL file by stripping USE and CREATE DATABASE statements
   * and imports it into the target temp database via CLI.
   */
  function safeImport($db, $file) {
    if (!file_exists($file)) {
      throw new Exception("Source file not found: $file");
    }

    $content = file_get_contents($file);

    // Remove 'USE `db`;', 'CREATE DATABASE...', and prefixes like `mydb`.`mytable`
    $content = preg_replace('/^USE `.*`;/m', '', $content);
    $content = preg_replace('/^CREATE DATABASE .*;/m', '', $content);
    $content = preg_replace('/CREATE TABLE `.*`\.`/i', 'CREATE TABLE `', $content);

    $tempFile = $file . '.tmp';
    file_put_contents($tempFile, $content);

    $command = sprintf(
      '%s -h %s -u %s %s %s < %s',
      escapeshellarg(MYSQL_PATH),
      escapeshellarg(DB_HOST),
      escapeshellarg(DB_USER),
      (DB_PASS ? '-p' . escapeshellarg(DB_PASS) : ''),
      escapeshellarg($db),
      escapeshellarg($tempFile)
    );

    shell_exec($command);
    unlink($tempFile);
  }

  echo "-- Importing schemas...\n";
  safeImport($dbOldName, $oldSqlFile);
  safeImport($dbNewName, $newSqlFile);

  echo "-- Generating Patch --\n\n";

  // 2. FIND NEW TABLES
  $newTablesQuery = "
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_SCHEMA = '$dbNewName' 
        AND TABLE_NAME NOT IN (
            SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '$dbOldName'
        )";

  foreach ($pdo->query($newTablesQuery) as $row) {
    $tableName = $row['TABLE_NAME'];
    $stmt = $pdo->query("SHOW CREATE TABLE `$dbNewName`.`$tableName` text;");
    $res = $stmt->fetch();

    echo "-- New Table: $tableName\n";
    $createSql = str_replace("CREATE TABLE `", "CREATE TABLE IF NOT EXISTS `", $res['Create Table']);
    echo $createSql . ";\n\n";
  }

  // 3. FIND NEW COLUMNS
  $newColumnsQuery = "
        SELECT 
            new.TABLE_NAME, 
            new.COLUMN_NAME, 
            new.COLUMN_TYPE, 
            new.IS_NULLABLE, 
            new.COLUMN_DEFAULT, 
            new.EXTRA, 
            new.COLUMN_COMMENT,
            (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
             WHERE TABLE_SCHEMA = '$dbNewName' 
             AND TABLE_NAME = new.TABLE_NAME 
             AND ORDINAL_POSITION = new.ORDINAL_POSITION - 1) as PREVIOUS_COLUMN
        FROM INFORMATION_SCHEMA.COLUMNS new
        LEFT JOIN INFORMATION_SCHEMA.COLUMNS old ON 
            old.TABLE_SCHEMA = '$dbOldName' AND 
            old.TABLE_NAME = new.TABLE_NAME AND 
            old.COLUMN_NAME = new.COLUMN_NAME
        WHERE new.TABLE_SCHEMA = '$dbNewName'
        AND old.COLUMN_NAME IS NULL
        AND new.TABLE_NAME IN (
            SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '$dbOldName'
        )
        ORDER BY new.TABLE_NAME, new.ORDINAL_POSITION";

  $currentTable = '';
  foreach ($pdo->query($newColumnsQuery) as $col) {
    if ($currentTable !== $col['TABLE_NAME']) {
      $currentTable = $col['TABLE_NAME'];
      echo "-- Updates for table: $currentTable\n";
    }

    $nullSql = ($col['IS_NULLABLE'] === 'YES') ? 'NULL' : 'NOT NULL';

    $defaultSql = '';
    if ($col['COLUMN_DEFAULT'] !== null) {
      $defaultSql = (strtoupper($col['COLUMN_DEFAULT']) == 'CURRENT_TIMESTAMP')
        ? "DEFAULT CURRENT_TIMESTAMP"
        : "DEFAULT '" . addslashes($col['COLUMN_DEFAULT']) . "'";
    } elseif ($col['IS_NULLABLE'] === 'YES') {
      $defaultSql = "DEFAULT NULL";
    }

    $extraSql   = $col['EXTRA'];
    $commentSql = $col['COLUMN_COMMENT'] ? "COMMENT '" . addslashes($col['COLUMN_COMMENT']) . "'" : "";
    $afterSql   = $col['PREVIOUS_COLUMN'] ? "AFTER `{$col['PREVIOUS_COLUMN']}`" : "FIRST";

    printf(
      "ALTER TABLE `%s` ADD COLUMN `%s` %s %s %s %s %s %s;\n",
      $col['TABLE_NAME'],
      $col['COLUMN_NAME'],
      $col['COLUMN_TYPE'],
      $nullSql,
      $defaultSql,
      $extraSql,
      $commentSql,
      $afterSql
    );
  }

  // 4. CLEANUP
  $pdo->exec("DROP DATABASE `$dbOldName`;");
  $pdo->exec("DROP DATABASE `$dbNewName`;");
  echo "\n-- Migration check complete. --\n";
} catch (Exception $e) {
  die("Error: " . $e->getMessage());
}
