"""
MySQL Connection Test Script
=============================
Use this script to verify your MySQL database connection works correctly
before sending credentials to the AI Automations Agency.

Requirements:
    pip install sqlalchemy pymysql

Usage:
    1. Update the configuration variables below
    2. Run: python mysql_test.py
"""

from sqlalchemy import create_engine, text
import urllib.parse

# ============================================
# CONFIGURATION - Update these values
# ============================================

HOST = "your-database-host.com"  # e.g., "db.example.com" or "12.34.56.78"
PORT = "3306"                     # Default MySQL port
DATABASE = "your_database_name"   # Your database name
USERNAME = "zachsai-read"         # Test with read-only user first
PASSWORD = "YOUR_PASSWORD_HERE"   # The password you created

# ============================================
# Create Connection
# ============================================

# URL-encode the password to handle special characters
encoded_password = urllib.parse.quote_plus(PASSWORD)

# Build connection string
connection_string = f"mysql+pymysql://{USERNAME}:{encoded_password}@{HOST}:{PORT}/{DATABASE}"

print("=" * 60)
print("MySQL Connection Test")
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
        result = connection.execute(text("SELECT DATABASE(), USER(), VERSION()"))
        for row in result:
            print(f"Connected to database: {row[0]}")
            print(f"Connected as user: {row[1]}")
            print(f"MySQL version: {row[2]}")

        # Test read access - count tables
        print("\n" + "=" * 60)
        print("Testing READ access...")
        print("=" * 60)

        result = connection.execute(text("""
            SELECT COUNT(*) as table_count
            FROM information_schema.tables
            WHERE table_schema = DATABASE()
        """))

        for row in result:
            print(f"✅ Can access {row.table_count} tables in this database")

        # List tables (if any)
        result = connection.execute(text("""
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = DATABASE()
            LIMIT 10
        """))

        tables = [row.table_name for row in result]
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
    print("2. Check that the user can connect from your current IP address")
    print("3. Verify firewall allows connections on port 3306")
    print("4. Ensure MySQL is configured to accept remote connections")
    print("5. Check if SSL/TLS is required (add ?ssl_disabled=true for testing)")
    print("\nSee README.md Troubleshooting section for more help.")
