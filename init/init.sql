-- =======================================================================
-- Database Initialization Script
-- =======================================================================
-- This script runs automatically when the Docker container starts
-- It creates the agency users (zachsai-read and zachsai-read-write)
-- and sets up sample tables for testing
-- =======================================================================

-- Grant admin privileges to client-admin (created via docker-compose environment vars)
GRANT ALL PRIVILEGES ON client_database.* TO 'client-admin'@'%';

-- =======================================================================
-- CREATE AGENCY USERS (AI Automations Agency Access)
-- =======================================================================

-- Read-Only User (zachsai-read)
-- Used for data analysis, reporting, and read-only automations
-- Note: Using mysql_native_password for better remote connection compatibility
CREATE USER 'zachsai-read'@'%' IDENTIFIED WITH mysql_native_password BY 'ZachsAI_ReadPass_2025';
GRANT SELECT ON client_database.* TO 'zachsai-read'@'%';

-- Read-Write User (zachsai-read-write)
-- Used for automations that need to create, update, or delete data
-- Note: Using mysql_native_password for better remote connection compatibility
CREATE USER 'zachsai-read-write'@'%' IDENTIFIED WITH mysql_native_password BY 'ZachsAI_WritePass_2025';
GRANT SELECT, INSERT, UPDATE, DELETE ON client_database.* TO 'zachsai-read-write'@'%';

-- Note: DELETE privilege is included. If you want to prevent deletions:
-- GRANT SELECT, INSERT, UPDATE ON client_database.* TO 'zachsai-read-write'@'%';

FLUSH PRIVILEGES;

-- =======================================================================
-- CREATE SAMPLE TABLES (For Testing - Customize as needed)
-- =======================================================================

USE client_database;

-- Customers table
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200),
    email VARCHAR(200),
    phone VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(200),
    quantity INT,
    price DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- =======================================================================
-- INSERT SAMPLE DATA (For Testing - Remove for production)
-- =======================================================================

-- Sample customers
INSERT INTO customers (name, email, phone) VALUES
    ('John Doe', 'john.doe@example.com', '555-0101'),
    ('Jane Smith', 'jane.smith@example.com', '555-0102'),
    ('Bob Johnson', 'bob.johnson@example.com', '555-0103');

-- Sample orders
INSERT INTO orders (customer_id, product_name, quantity, price, order_date, status) VALUES
    (1, 'T-Shirt', 2, 29.99, '2025-09-25', 'completed'),
    (1, 'Jeans', 1, 89.99, '2025-09-26', 'completed'),
    (2, 'Sneakers', 1, 129.99, '2025-09-27', 'pending'),
    (3, 'Hat', 3, 19.99, '2025-09-28', 'completed');

FLUSH PRIVILEGES;
