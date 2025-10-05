# Database Access Setup Guide

## Welcome!

This guide will help you grant our **AI Automations Agency** secure access to your database so we can deliver powerful automation solutions.

---

## 📋 Quick Start: Choose Your Scenario

### I already have a database running →
**[Go to Section: Existing Database Setup](#existing-database-setup)**

### I don't have a database yet →
**[Choose who will manage it](#new-database-setup)**
- **You manage it** → [Self-Managed Database Setup](#option-1-you-manage-the-database)
- **We manage it for you** → [Agency-Managed Database Setup](#option-2-we-manage-the-database-for-you)

---

## Table of Contents

1. [What We Need](#what-we-need)
2. [Existing Database Setup](#existing-database-setup) ⭐ Most common
3. [New Database Setup](#new-database-setup)
4. [Remote Access Configuration](#remote-access-configuration)
5. [Security Best Practices](#security-best-practices)
6. [What to Send Us](#what-to-send-us)
7. [Troubleshooting](#troubleshooting)

---

## What We Need

To build automations for your business, we need two database user accounts:

| User Account | Purpose | Permissions |
|--------------|---------|-------------|
| **`zachsai-read`** | Data analysis, reporting, dashboards | Read-only (SELECT) |
| **`zachsai-read-write`** | Automations that create/update data | Read + Write (SELECT, INSERT, UPDATE, DELETE) |

**Why two accounts?**
- **Security**: Most automations only need to *read* your data
- **Safety**: Read-only account can't accidentally modify or delete data
- **Compliance**: Separate accounts provide better audit trails

---

## Existing Database Setup

**Choose this if**: You already have MySQL, MSSQL, PostgreSQL, or another database running.

### Step 1: Identify Your Database Type

- MySQL / MariaDB → [MySQL Instructions](#mysql-existing-database)
- Microsoft SQL Server → [MSSQL Instructions](#mssql-existing-database)
- PostgreSQL → Contact us for PostgreSQL-specific instructions
- Other → Contact us

---

### MySQL (Existing Database)

#### Connect to Your Database

Connect as an administrator:
```bash
mysql -u root -p
# Or use your database admin GUI (MySQL Workbench, phpMyAdmin, etc.)
```

#### Run the Setup Script

We've created a ready-to-use script for you:

**Option A: Download and run our script**
1. Download: [`sql-scripts/mysql/create_agency_users.sql`](sql-scripts/mysql/create_agency_users.sql)
2. Edit the file:
   - Replace `your_database_name` with your actual database name
   - Replace `CHANGE_THIS_PASSWORD_123!@#` with a strong password (read-only user)
   - Replace `CHANGE_THIS_PASSWORD_456!@#` with a strong password (read-write user)
3. Run it:
   ```bash
   mysql -u root -p your_database_name < create_agency_users.sql
   ```

**Option B: Copy and paste manually**

```sql
-- Create read-only user
CREATE USER 'zachsai-read'@'%' IDENTIFIED BY 'YOUR_STRONG_PASSWORD_HERE';
GRANT SELECT ON your_database_name.* TO 'zachsai-read'@'%';

-- Create read-write user
CREATE USER 'zachsai-read-write'@'%' IDENTIFIED BY 'YOUR_STRONG_PASSWORD_HERE';
GRANT SELECT, INSERT, UPDATE, DELETE ON your_database_name.* TO 'zachsai-read-write'@'%';

FLUSH PRIVILEGES;
```

#### For Specific Tables Only (Optional)

If you only want us to access certain tables:

```sql
-- Read-only user - specific tables
GRANT SELECT ON your_database_name.customers TO 'zachsai-read'@'%';
GRANT SELECT ON your_database_name.orders TO 'zachsai-read'@'%';
GRANT SELECT ON your_database_name.products TO 'zachsai-read'@'%';

-- Read-write user - specific tables
GRANT SELECT, INSERT, UPDATE, DELETE ON your_database_name.orders TO 'zachsai-read-write'@'%';

FLUSH PRIVILEGES;
```

#### Verify Users Were Created

```sql
-- Check users exist
SELECT user, host FROM mysql.user WHERE user LIKE 'zachsai%';

-- Check permissions
SHOW GRANTS FOR 'zachsai-read'@'%';
SHOW GRANTS FOR 'zachsai-read-write'@'%';
```

✅ **Done!** Now continue to [Remote Access Configuration](#remote-access-configuration)

---

### MSSQL (Existing Database)

#### Connect to Your Database

Open **SQL Server Management Studio (SSMS)** or **Azure Data Studio** and connect as an administrator.

#### Run the Setup Script

We've created a ready-to-use script for you:

**Option A: Download and run our script**
1. Download: [`sql-scripts/mssql/create_agency_users.sql`](sql-scripts/mssql/create_agency_users.sql)
2. Edit the file:
   - Replace `your_database_name` with your actual database name
   - Replace passwords with strong passwords
3. Open in SSMS/Azure Data Studio and execute

**Option B: Copy and paste manually**

```sql
-- Create server-level logins
CREATE LOGIN [zachsai-read] WITH PASSWORD = 'YOUR_STRONG_PASSWORD_HERE';
CREATE LOGIN [zachsai-read-write] WITH PASSWORD = 'YOUR_STRONG_PASSWORD_HERE';
GO

-- Switch to your database
USE your_database_name;
GO

-- Create database users
CREATE USER [zachsai-read] FOR LOGIN [zachsai-read];
CREATE USER [zachsai-read-write] FOR LOGIN [zachsai-read-write];
GO

-- Grant permissions (entire database)
ALTER ROLE db_datareader ADD MEMBER [zachsai-read];
ALTER ROLE db_datareader ADD MEMBER [zachsai-read-write];
ALTER ROLE db_datawriter ADD MEMBER [zachsai-read-write];
GO
```

#### For Specific Tables Only (Optional)

```sql
-- Grant access to specific tables
GRANT SELECT ON dbo.customers TO [zachsai-read];
GRANT SELECT ON dbo.orders TO [zachsai-read];

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.orders TO [zachsai-read-write];
GO
```

#### Verify Users Were Created

```sql
SELECT name, type_desc FROM sys.database_principals
WHERE name LIKE 'zachsai%';
```

✅ **Done!** Now continue to [Remote Access Configuration](#remote-access-configuration)

---

## New Database Setup

**Choose this if**: You don't have a database yet and need to set one up.

### Important Decision: Who Will Manage the Database?

#### Option 1: You Manage the Database

**Best for**: Organizations with IT staff, specific compliance requirements, or existing infrastructure

**Recommended Approach**:
- **Cloud-hosted** (Easiest): AWS RDS, Azure SQL Database, Google Cloud SQL
- **On-premise**: Install MySQL/MSSQL on your server

**Steps**:
1. Set up your database using your preferred method
2. Follow the [Existing Database Setup](#existing-database-setup) instructions above
3. Configure [Remote Access](#remote-access-configuration)

---

#### Option 2: We Manage the Database For You

**Best for**: Small businesses, startups, quick projects, or if you don't have database expertise

**What this means**:
- We set up and host the database for you
- You get full admin access (`client-admin` account)
- We create our agency accounts (`zachsai-read` and `zachsai-read-write`)
- We handle backups, updates, and maintenance

**How it works**:
1. **Contact us** to discuss your needs (data volume, performance requirements, etc.)
2. We'll set up a database instance for you
3. We'll provide you with:
   - Connection details (hostname, port, database name)
   - Your admin credentials (`client-admin` username and password)
   - Access to backups and monitoring

**Pricing**: Contact us for pricing based on your requirements.

---

## Remote Access Configuration

Our automation platform needs to connect to your database remotely. Choose the option that works best for your setup:

### ✅ Option 1: Cloud-Hosted Database (Recommended)

**Best for**: AWS RDS, Azure SQL, Google Cloud SQL, or other managed databases

**Steps**:
1. **Configure firewall rules** to allow connections from our automation platform
2. **Enable SSL/TLS** connections (usually enabled by default)
3. **Whitelist our IP addresses** (we'll provide these)

**Example (AWS RDS)**:
- Go to your RDS instance → Security Groups
- Add inbound rule: Type = MySQL (or MSSQL), Source = [our IP address]

**Example (Azure SQL)**:
- Go to SQL Database → Firewalls and virtual networks
- Add client IP → Enter our IP address

✅ **Pros**: Secure, managed, SSL built-in, highly available

---

### ✅ Option 2: VPN Access

**Best for**: Maximum security, on-premise databases

**Steps**:
1. Set up VPN credentials for our automation platform
2. Provide VPN configuration file
3. Share internal database hostname and port

✅ **Pros**: Most secure, database stays completely private

---

### ✅ Option 3: SSH Tunnel

**Best for**: Secure access without VPN complexity

**Steps**:
1. Set up SSH access to a jump server/bastion host
2. Provide SSH credentials (username + password or private key)
3. Database accessible via localhost from the SSH server

✅ **Pros**: Encrypted, no VPN needed, relatively simple

---

### ⚠️ Option 4: Direct Access with IP Whitelist

**Best for**: Quick setup, but requires security measures

**Requirements**:
1. **Configure firewall** to allow port 3306 (MySQL) or 1433 (MSSQL)
2. **Whitelist only our IP addresses** (we'll provide)
3. **Require SSL/TLS connections** (critical!)
4. **Use strong passwords** (20+ characters)

**MySQL - Require SSL**:
```sql
ALTER USER 'zachsai-read'@'%' REQUIRE SSL;
ALTER USER 'zachsai-read-write'@'%' REQUIRE SSL;
FLUSH PRIVILEGES;
```

**MSSQL - Force Encryption**:
- SQL Server Configuration Manager → Protocols → Force Encryption: Yes

⚠️ **Warning**: Only use with proper security (SSL, strong passwords, IP whitelist)

---

### 🧪 Option 5: Temporary Tunnel (Testing ONLY)

**For initial testing only - NOT for production**

Use ngrok to create a temporary tunnel:

```bash
# Install ngrok
brew install ngrok/ngrok/ngrok

# Sign up at ngrok.com and get your auth token
ngrok config add-authtoken YOUR_TOKEN

# Create tunnel
ngrok tcp 3306  # For MySQL
ngrok tcp 1433  # For MSSQL
```

**Send us**: The ngrok URL (e.g., `tcp://0.tcp.us-cal-1.ngrok.io:12181`)

⚠️ **Warning**:
- Exposes database to internet - use ONLY for testing
- Kill tunnel when done: `pkill ngrok`
- Change passwords after testing
- Never use in production

---

## What to Send Us

Once setup is complete, securely send us:

### ✅ Required Information

**Connection Details**:
- [ ] Database Type: MySQL / MSSQL / PostgreSQL / Other
- [ ] Hostname: `_____________________`
- [ ] Port: `_____________________`
- [ ] Database Name: `_____________________`

**User Credentials**:
- [ ] **Read-Only User**: `zachsai-read`
  - Password: `_____________________`
- [ ] **Read-Write User**: `zachsai-read-write` (if needed)
  - Password: `_____________________`

**Security**:
- [ ] SSL/TLS Required? Yes / No
- [ ] SSL Certificate (if using custom CA): _____

**Access Scope**:
- [ ] Full database access
- [ ] OR Specific tables only (list): `___________________`

### ✅ Optional Information

- [ ] VPN configuration (if applicable)
- [ ] SSH tunnel details (if applicable)
- [ ] IP whitelist requirements
- [ ] Timezone of database server
- [ ] Any rate limiting or query restrictions

---

### 🔒 How to Send Credentials Securely

**❌ DO NOT send passwords via plain text email!**

**✅ Secure options**:

1. **Password Manager** (Recommended)
   - Use 1Password, LastPass, or Bitwarden shared vault
   - Invite us to a shared folder

2. **One-Time Secret**
   - Use [OneTimeSecret.com](https://onetimesecret.com)
   - Send us the one-time link (self-destructs after viewing)

3. **Encrypted Email**
   - Request our PGP public key
   - Encrypt credentials before sending

4. **Secure Portal**
   - Use your company's secure file sharing system

---

## Security Best Practices

### ✅ Password Requirements

**Strong passwords**:
- Minimum 16 characters (20+ recommended)
- Mix of uppercase, lowercase, numbers, special characters
- No dictionary words, company names, or dates
- Use a password manager to generate them

### ✅ Principle of Least Privilege

**Start minimal**:
1. Grant read-only access (`zachsai-read`) by default
2. Only grant read-write when automation requires it
3. Grant access to specific tables when possible (not entire database)
4. Revoke access when automation is no longer needed

### ✅ Network Security

**Best practices**:
- SSL/TLS encryption for all connections
- IP whitelisting to our platform only
- VPN or SSH tunnel when possible
- Enable database audit logging
- Regular security reviews

### ❌ Avoid

- Exposing database to entire internet (0.0.0.0/0)
- Unencrypted connections
- Weak or default passwords
- Using root/SA accounts for automations

---

## Troubleshooting

### ❌ Connection Refused / Timeout

**Check**:
1. Firewall allows connections on database port (3306 or 1433)
2. Database configured to accept remote connections
3. Correct hostname and port
4. Test: `telnet your-hostname.com 3306`

**MySQL - Enable remote connections**:
```bash
# Edit /etc/mysql/mysql.conf.d/mysqld.cnf
bind-address = 0.0.0.0

# Restart MySQL
sudo systemctl restart mysql
```

---

### ❌ Authentication Failed

**Check**:
1. Username and password are exactly correct
2. User allowed to connect from `'%'` (anywhere), not just `'localhost'`
3. Account not locked or expired

**MySQL - Verify user host**:
```sql
SELECT user, host FROM mysql.user WHERE user = 'zachsai-read';
-- Should show '%' not 'localhost'
```

---

### ❌ Access Denied to Tables

**Check**:
1. GRANT statements executed correctly
2. Permissions flushed (MySQL: `FLUSH PRIVILEGES`)
3. User connected to correct database

**MySQL - Check permissions**:
```sql
SHOW GRANTS FOR 'zachsai-read'@'%';
```

**MSSQL - Check permissions**:
```sql
EXECUTE AS USER = 'zachsai-read';
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
REVERT;
```

---

### ❌ SSL/TLS Errors

**Temporary workaround for testing** (disable SSL to isolate issue):

**MySQL**:
```python
# Add ?ssl_disabled=true to connection string
mysql+pymysql://user:pass@host:3306/db?ssl_disabled=true
```

**MSSQL**:
```python
# Add TrustServerCertificate=yes
mssql+pyodbc://user:pass@host:1433/db?TrustServerCertificate=yes
```

Once connected, properly configure SSL rather than leaving it disabled.

---

## Support

Need help? Here's how to get assistance:

1. **Review this guide** - Check the Troubleshooting section above
2. **Check database error logs** - Error messages provide important clues
3. **Test locally first** - Verify users work from localhost before testing remotely
4. **Contact us** with:
   - Database type and version (e.g., "MySQL 8.0", "SQL Server 2022")
   - Exact error message (copy/paste full text)
   - Steps you've already tried
   - Connection method (VPN, SSH, direct, etc.)

---

## Repository Structure

```
.
├── README.md                              # This guide (for clients)
├── sql-scripts/                           # Ready-to-use SQL scripts
│   ├── mysql/
│   │   └── create_agency_users.sql        # MySQL user setup
│   └── mssql/
│       └── create_agency_users.sql        # MSSQL user setup
├── examples/                              # Test scripts
│   ├── mysql_test.py                      # MySQL connection test
│   └── mssql_test.py                      # MSSQL connection test
├── docker-compose.yml                     # For agency-managed databases
└── init/init.sql                          # For agency-managed databases
```

---

## Frequently Asked Questions

**Q: Can you access our entire database?**
A: Only what you grant us access to. You can restrict us to specific tables/columns.

**Q: Can the read-only account modify our data?**
A: No. The `zachsai-read` account can only SELECT (read) data, never INSERT, UPDATE, or DELETE.

**Q: What if we need to revoke access?**
A: Simply drop the users:
```sql
-- MySQL
DROP USER 'zachsai-read'@'%';
DROP USER 'zachsai-read-write'@'%';

-- MSSQL
DROP USER [zachsai-read];
DROP USER [zachsai-read-write];
DROP LOGIN [zachsai-read];
DROP LOGIN [zachsai-read-write];
```

**Q: Can we monitor what queries you run?**
A: Yes! Enable audit logging on your database to track all queries.

**Q: Do we need both users?**
A: At minimum, you need `zachsai-read`. Only create `zachsai-read-write` if your automation requires data modification.

**Q: What if we use a different database (PostgreSQL, MongoDB, etc.)?**
A: Contact us! We support most major databases. We'll provide custom instructions.

---

**Questions?** Contact us at your AI Automations Agency

**Last Updated**: October 2025 | **Version**: 1.0
