-- =======================================================================
-- MySQL: Create AI Automations Agency Users
-- =======================================================================
-- Run this script if you ALREADY HAVE an existing MySQL database
-- and need to create access for our AI Automations Agency
-- =======================================================================

-- INSTRUCTIONS:
-- 1. Replace 'your_database_name' with your actual database name
-- 2. Replace passwords with strong, unique passwords (avoid special chars like !@#$)
-- 3. Connect to MySQL as an administrator (root or admin user)
-- 4. Run this script: mysql -u root -p < create_agency_users.sql
--
-- PASSWORD GUIDELINES:
-- ✅ Use: Letters, numbers, underscores (_), hyphens (-), periods (.)
-- ❌ Avoid: Special characters like ! @ # $ (can cause authentication issues)
-- Example: YourDatabase_ReadUser_2025

-- =======================================================================
-- CREATE READ-ONLY USER (zachsai-read)
-- =======================================================================
-- This user can only SELECT (read) data
-- Use this for most automations (reporting, analysis, etc.)
-- Using mysql_native_password for better remote connection compatibility

CREATE USER 'zachsai-read'@'%' IDENTIFIED WITH mysql_native_password BY 'CHANGE_THIS_ReadPassword_2025';

-- Grant SELECT access to entire database
GRANT SELECT ON your_database_name.* TO 'zachsai-read'@'%';

-- OR: Grant SELECT access to specific tables only (uncomment and customize):
-- GRANT SELECT ON your_database_name.customers TO 'zachsai-read'@'%';
-- GRANT SELECT ON your_database_name.orders TO 'zachsai-read'@'%';
-- GRANT SELECT ON your_database_name.products TO 'zachsai-read'@'%';

-- =======================================================================
-- CREATE READ-WRITE USER (zachsai-read-write)
-- =======================================================================
-- This user can SELECT, INSERT, UPDATE, and DELETE data
-- Only use this when automations need to modify data
-- Using mysql_native_password for better remote connection compatibility

CREATE USER 'zachsai-read-write'@'%' IDENTIFIED WITH mysql_native_password BY 'CHANGE_THIS_WritePassword_2025';

-- Grant read and write access to entire database
GRANT SELECT, INSERT, UPDATE, DELETE ON your_database_name.* TO 'zachsai-read-write'@'%';

-- OR: Grant access to specific tables only (uncomment and customize):
-- GRANT SELECT, INSERT, UPDATE, DELETE ON your_database_name.customers TO 'zachsai-read-write'@'%';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON your_database_name.orders TO 'zachsai-read-write'@'%';

-- OR: Prevent DELETE operations (only allow SELECT, INSERT, UPDATE):
-- GRANT SELECT, INSERT, UPDATE ON your_database_name.* TO 'zachsai-read-write'@'%';

-- =======================================================================
-- APPLY CHANGES
-- =======================================================================

FLUSH PRIVILEGES;

-- =======================================================================
-- VERIFY USERS WERE CREATED
-- =======================================================================

-- List users
SELECT user, host FROM mysql.user WHERE user LIKE 'zachsai%';

-- Check read-only user permissions
SHOW GRANTS FOR 'zachsai-read'@'%';

-- Check read-write user permissions
SHOW GRANTS FOR 'zachsai-read-write'@'%';

-- =======================================================================
-- OPTIONAL: Require SSL/TLS for secure connections
-- =======================================================================
-- Uncomment these lines to require encrypted connections:

-- ALTER USER 'zachsai-read'@'%' REQUIRE SSL;
-- ALTER USER 'zachsai-read-write'@'%' REQUIRE SSL;
-- FLUSH PRIVILEGES;

-- =======================================================================
-- NEXT STEPS:
-- =======================================================================
-- 1. Send us the connection details securely (see README.md)
-- 2. Set up remote access (VPN, SSH tunnel, or cloud firewall rules)
-- 3. Test the connection using the test scripts in /examples
-- =======================================================================
