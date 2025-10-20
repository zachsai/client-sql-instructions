# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository provides client onboarding resources for an AI Automations Agency that needs database access. It contains SQL scripts, Docker configuration, and documentation to help clients grant secure database access for AI automation services.

## Key Components

### User Accounts
The system creates two database users for agency access:
- `zachsai-read` - Read-only user (SELECT only) for data analysis and reporting
- `zachsai-read-write` - Read-write user (SELECT, INSERT, UPDATE, DELETE) for data modification automations

### Repository Structure

```
sql-scripts/
├── mysql/create_agency_users.sql    # MySQL user setup script (for existing databases)
└── mssql/create_agency_users.sql    # MSSQL user setup script (for existing databases)

init/init.sql                         # Docker initialization script (auto-creates users + sample data)
docker-compose.yml                    # Agency-managed MySQL instance configuration
README.md                             # Comprehensive client onboarding guide
examples/                             # Connection test scripts (mysql_test.py, mssql_test.py)
```

## Docker Setup

### Starting the Docker Database
```bash
docker-compose up -d
```

This creates a MySQL 8.0 instance with:
- Container name: `gumloop_mysql`
- Port: `3306`
- Root password: `RootPassword123!@#`
- Database: `client_database`
- Client admin user: `client-admin` / `ClientPassword123!@#`
- Agency users: `zachsai-read` and `zachsai-read-write` (auto-created via init.sql)

### Stopping the Docker Database
```bash
docker-compose down
```

### Accessing the Docker Database
```bash
# As root
docker exec -it gumloop_mysql mysql -u root -p

# As client admin
docker exec -it gumloop_mysql mysql -u client-admin -p

# As agency read-only user
docker exec -it gumloop_mysql mysql -u zachsai-read -p
```

## SQL Scripts Usage

### MySQL (Existing Database)
Clients should:
1. Edit `sql-scripts/mysql/create_agency_users.sql`
2. Replace `your_database_name` with their database name
3. Change default passwords
4. Run: `mysql -u root -p < sql-scripts/mysql/create_agency_users.sql`

### MSSQL (Existing Database)
Clients should:
1. Edit `sql-scripts/mssql/create_agency_users.sql`
2. Replace `your_database_name` with their database name
3. Change default passwords
4. Execute in SSMS or Azure Data Studio

## Testing Database Access

### Python Connection Test
Test database connectivity before sending credentials to clients:

```bash
# Install dependencies
pip install sqlalchemy pymysql

# Run test script
python examples/mysql_test.py
```

Edit `examples/mysql_test.py` to configure connection details (host, port, database, username, password).

### Verifying Users and Permissions
```bash
# Inside Docker container
docker exec -it gumloop_mysql mysql -u root -pRootPassword123\!\@\#

# Or connect remotely
mysql -h hostname -P port -u zachsai-read-write -pYourPassword -e "SELECT 'Success!' AS status;"
```

```sql
-- List agency users
SELECT user, host FROM mysql.user WHERE user LIKE 'zachsai%';

-- Check permissions
SHOW GRANTS FOR 'zachsai-read'@'%';
SHOW GRANTS FOR 'zachsai-read-write'@'%';
```

### Resetting Docker Database (Troubleshooting)
If experiencing authentication issues after password changes:

```bash
# Stop and remove volumes (fresh start)
docker-compose down -v

# Start fresh (re-runs init.sql)
docker-compose up -d
```

## Security Principles

### Password Guidelines (CRITICAL)

**AVOID special characters in SQL scripts** - they cause authentication issues:
- ❌ Avoid: `!` `@` `#` `$` `` ` `` `'` `"` `\`
- ✅ Use: Letters, numbers, underscores `_`, hyphens `-`, periods `.`

**Good password**: `YourDatabase_ReadUser_2025`
**Bad password**: `YourPassword123!@#` (will fail in SQL scripts)

See TROUBLESHOOTING_PASSWORD_AUTH.md for detailed analysis of special character issues.

### Other Security Principles

- **Least Privilege**: Always start with read-only access, only grant write access when required
- **Strong Passwords**: Minimum 16 characters, mixed case, numbers, safe special characters only
- **Network Security**: Use SSL/TLS, IP whitelisting, VPN or SSH tunnels for remote access
- **Table-Level Permissions**: Grant access to specific tables when possible (not entire database)
- **mysql_native_password**: Use this authentication plugin for better remote connection compatibility

## Remote Access Methods (in order of security)

1. **VPN Access** (most secure)
2. **SSH Tunnel** (secure, no VPN needed)
3. **Cloud-Hosted with SSL** (AWS RDS, Azure SQL, Google Cloud SQL)
4. **Direct Access with IP Whitelist + SSL** (requires strong security measures)
5. **ngrok tunnel** (testing only, never production)

## Important Notes

- This repository contains client-facing documentation and setup resources
- The README.md is the primary client guide - comprehensive and self-service
- All default passwords in scripts are placeholders that MUST be changed
- Docker setup (docker-compose.yml, init.sql) is for agency-managed databases where the agency hosts the database for clients
- SQL scripts in `sql-scripts/` are for clients with existing databases
- Never commit actual client credentials or connection details to this repository
