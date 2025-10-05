"""
Microsoft SQL Server Connection Test Script
============================================
Use this script to verify your MSSQL database connection works correctly
before sending credentials to the AI Automations Agency.

Requirements:
    pip install sqlalchemy pyodbc

    You also need the ODBC Driver for SQL Server:
    - macOS: brew install msodbcsql17
    - Windows: Download from Microsoft
    - Linux: Follow Microsoft's installation guide

Usage:
    1. Update the configuration variables below
    2. Run: python mssql_test.py
"""

from sqlalchemy import create_engine, text
import urllib.parse

# ============================================
# CONFIGURATION - Update these values
# ============================================

HOST = "your-database-host.com"  # e.g., "db.example.com" or "12.34.56.78"
PORT = "1433"                     # Default MSSQL port
DATABASE = "your_database_name"   # Your database name
USERNAME = "zachsai-read"         # Test with read-only user first
PASSWORD = "YOUR_PASSWORD_HERE"   # The password you created

# ============================================
# Create Connection
# ============================================

# URL-encode the password to handle special characters
encoded_password = urllib.parse.quote_plus(PASSWORD)
encoded_username = urllib.parse.quote_plus(USERNAME)

# Build connection string
# Using ODBC Driver 17 (adjust if you have a different version)
connection_string = (
    f"mssql+pyodbc://{encoded_username}:{encoded_password}@{HOST}:{PORT}/{DATABASE}"
    f"?driver=ODBC+Driver+17+for+SQL+Server"
    f"&TrustServerCertificate=yes"  # For testing; use proper SSL in production
)

print("=" * 60)
print("Microsoft SQL Server Connection Test")
print("=" * 60)
print(f"Host: {HOST}:{PORT}")
print(f"Database: {DATABASE}")
print(f"Username: {USERNAME}")
print("=" * 60)

try:
    # Create database engine
    engine = create_engine(connection_string, echo=False)

    # Test connection
    with engine.connect() as connection:
        print("\n✅ CONNECTION SUCCESSFUL!\n")

        # Get database info
        result = connection.execute(text("SELECT DB_NAME(), SYSTEM_USER, @@VERSION"))
        for row in result:
            print(f"Connected to database: {row[0]}")
            print(f"Connected as user: {row[1]}")
            print(f"SQL Server version: {row[2][:50]}...")  # Truncate version string

        # Test read access - count tables
        print("\n" + "=" * 60)
        print("Testing READ access...")
        print("=" * 60)

        result = connection.execute(text("""
            SELECT COUNT(*) as table_count
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE = 'BASE TABLE'
        """))

        for row in result:
            print(f"✅ Can access {row.table_count} tables in this database")

        # List tables (if any)
        result = connection.execute(text("""
            SELECT TOP 10 TABLE_NAME
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE = 'BASE TABLE'
            ORDER BY TABLE_NAME
        """))

        tables = [row.TABLE_NAME for row in result]
        if tables:
            print(f"\nFirst 10 tables:")
            for table in tables:
                print(f"  - {table}")

        # Test simple query (if tables exist)
        if tables:
            first_table = tables[0]
            try:
                result = connection.execute(text(f"SELECT COUNT(*) as row_count FROM {first_table}"))
                for row in result:
                    print(f"\n✅ Can query table '{first_table}': {row.row_count} rows")
            except Exception as e:
                print(f"\n⚠️  Cannot query table '{first_table}': {e}")

        # Check user permissions
        print("\n" + "=" * 60)
        print("Checking permissions...")
        print("=" * 60)

        result = connection.execute(text("""
            SELECT
                dp.class_desc,
                dp.permission_name,
                dp.state_desc
            FROM sys.database_permissions dp
            JOIN sys.database_principals u ON dp.grantee_principal_id = u.principal_id
            WHERE u.name = USER_NAME()
        """))

        permissions = list(result)
        if permissions:
            print(f"Found {len(permissions)} permissions:")
            for perm in permissions[:5]:  # Show first 5
                print(f"  - {perm.permission_name} ({perm.state_desc})")
        else:
            print("No specific permissions found (may be using role-based permissions)")

        print("\n" + "=" * 60)
        print("✅ ALL TESTS PASSED!")
        print("=" * 60)
        print("\nYour database connection is working correctly.")
        print("You can now send these credentials to the agency.")

except Exception as e:
    print(f"\n❌ CONNECTION FAILED!\n")
    print(f"Error: {e}\n")
    print("Troubleshooting:")
    print("1. Verify HOST, PORT, DATABASE, USERNAME, and PASSWORD are correct")
    print("2. Check that ODBC Driver 17 for SQL Server is installed")
    print("3. Verify firewall allows connections on port 1433")
    print("4. Ensure SQL Server is configured to accept remote connections")
    print("   - SQL Server Configuration Manager → Protocols → TCP/IP: Enabled")
    print("5. Check if Windows Firewall allows port 1433 (on-premise only)")
    print("6. For Azure SQL, verify firewall rules allow your IP address")
    print("\nSee README.md Troubleshooting section for more help.")
