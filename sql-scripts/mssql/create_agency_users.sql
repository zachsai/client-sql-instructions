-- =======================================================================
-- Microsoft SQL Server: Create AI Automations Agency Users
-- =======================================================================
-- Run this script if you ALREADY HAVE an existing MSSQL database
-- and need to create access for our AI Automations Agency
-- =======================================================================

-- INSTRUCTIONS:
-- 1. Replace 'your_database_name' with your actual database name
-- 2. Replace passwords with strong, unique passwords (avoid special chars like !@#$)
-- 3. Open SQL Server Management Studio (SSMS) or Azure Data Studio
-- 4. Connect as an administrator (SA or admin user)
-- 5. Run this script
--
-- PASSWORD GUIDELINES:
-- ✅ Use: Letters, numbers, underscores (_), hyphens (-), periods (.)
-- ❌ Avoid: Special characters like ! @ # $ (can cause authentication issues)
-- Example: YourDatabase_ReadUser_2025

-- =======================================================================
-- CREATE SERVER-LEVEL LOGINS
-- =======================================================================

-- Read-Only Login
CREATE LOGIN [zachsai-read] WITH PASSWORD = 'CHANGE_THIS_ReadPassword_2025';

-- Read-Write Login
CREATE LOGIN [zachsai-read-write] WITH PASSWORD = 'CHANGE_THIS_WritePassword_2025';

GO

-- =======================================================================
-- SWITCH TO YOUR DATABASE
-- =======================================================================

USE your_database_name;
GO

-- =======================================================================
-- CREATE DATABASE USERS FROM LOGINS
-- =======================================================================

CREATE USER [zachsai-read] FOR LOGIN [zachsai-read];
CREATE USER [zachsai-read-write] FOR LOGIN [zachsai-read-write];

GO

-- =======================================================================
-- GRANT PERMISSIONS
-- =======================================================================

-- Option 1: Grant access to ENTIRE DATABASE (Recommended for most cases)
-- -----------------------------------------------------------------------

-- Read-Only User (can only SELECT data)
ALTER ROLE db_datareader ADD MEMBER [zachsai-read];

-- Read-Write User (can SELECT, INSERT, UPDATE, DELETE data)
ALTER ROLE db_datareader ADD MEMBER [zachsai-read-write];
ALTER ROLE db_datawriter ADD MEMBER [zachsai-read-write];

GO

-- Option 2: Grant access to SPECIFIC TABLES ONLY (Uncomment and customize if needed)
-- -----------------------------------------------------------------------------------

-- -- Read-Only User - specific tables
-- GRANT SELECT ON dbo.customers TO [zachsai-read];
-- GRANT SELECT ON dbo.orders TO [zachsai-read];
-- GRANT SELECT ON dbo.products TO [zachsai-read];
--
-- -- Read-Write User - specific tables
-- GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.customers TO [zachsai-read-write];
-- GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.orders TO [zachsai-read-write];
--
-- -- OR: Prevent DELETE operations (only allow SELECT, INSERT, UPDATE)
-- -- GRANT SELECT, INSERT, UPDATE ON dbo.customers TO [zachsai-read-write];
--
-- GO

-- =======================================================================
-- VERIFY USERS WERE CREATED
-- =======================================================================

-- List database users
SELECT name, type_desc, create_date
FROM sys.database_principals
WHERE name LIKE 'zachsai%'
ORDER BY name;

-- Check permissions for read-only user
EXECUTE AS USER = 'zachsai-read';
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
REVERT;

-- Check permissions for read-write user
EXECUTE AS USER = 'zachsai-read-write';
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
REVERT;

GO

-- =======================================================================
-- OPTIONAL: Force SSL/TLS encrypted connections
-- =======================================================================
-- In SQL Server Configuration Manager:
-- 1. Go to SQL Server Network Configuration → Protocols
-- 2. Right-click on TCP/IP → Properties
-- 3. Set "Force Encryption" to Yes
-- 4. Restart SQL Server service

-- =======================================================================
-- NEXT STEPS:
-- =======================================================================
-- 1. Send us the connection details securely (see README.md)
-- 2. Configure firewall to allow remote connections:
--    - Azure SQL: Add firewall rule with our IP address
--    - On-premise: Configure Windows Firewall to allow port 1433
-- 3. Enable SQL Server for remote connections:
--    - SQL Server Configuration Manager → SQL Server Network Configuration
--    - Enable TCP/IP protocol
--    - Restart SQL Server service
-- 4. Test the connection using the test scripts in /examples
-- =======================================================================
