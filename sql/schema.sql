-- =============================================================
--   College Lost and Found Portal - MySQL Database Schema
--   Run this script once to initialize the database.
--   Compatible with MySQL 8.0+
-- =============================================================

-- Create and select the database
CREATE DATABASE IF NOT EXISTS college_lost_found
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE college_lost_found;

-- =============================================================
-- TABLE: admins
-- Stores admin credentials (separate from regular users)
-- =============================================================
CREATE TABLE IF NOT EXISTS admins (
    admin_id       INT           AUTO_INCREMENT PRIMARY KEY,
    username       VARCHAR(50)   NOT NULL UNIQUE,
    password_hash  VARCHAR(255)  NOT NULL,
    email          VARCHAR(100)  NOT NULL,
    full_name      VARCHAR(100)  NOT NULL,
    created_at     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =============================================================
-- TABLE: users
-- Stores student / staff account information
-- =============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id        INT           AUTO_INCREMENT PRIMARY KEY,
    usn            VARCHAR(20)   NOT NULL UNIQUE COMMENT 'University Seat Number / Roll Number',
    full_name      VARCHAR(100)  NOT NULL,
    email          VARCHAR(100)  NOT NULL UNIQUE,
    phone          VARCHAR(15),
    department     VARCHAR(50),
    password_hash  VARCHAR(255)  NOT NULL,
    is_active      TINYINT(1)    DEFAULT 1,
    created_at     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_usn  (usn),
    INDEX idx_email (email)
) ENGINE=InnoDB;

-- =============================================================
-- TABLE: lost_items
-- Records reported lost items submitted by users
-- =============================================================
CREATE TABLE IF NOT EXISTS lost_items (
    item_id       INT           AUTO_INCREMENT PRIMARY KEY,
    user_id       INT           NOT NULL,
    item_name     VARCHAR(100)  NOT NULL,
    category      VARCHAR(50)   NOT NULL,
    description   TEXT,
    date_lost     DATE          NOT NULL,
    location      VARCHAR(200)  NOT NULL,
    image_path    VARCHAR(300),
    contact_info  VARCHAR(200)  NOT NULL,
    status        ENUM('Active','Recovered','Closed') DEFAULT 'Active',
    is_approved   TINYINT(1)    DEFAULT 1  COMMENT '0 = pending admin approval',
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_status   (status),
    INDEX idx_category (category),
    INDEX idx_date_lost (date_lost)
) ENGINE=InnoDB;

-- =============================================================
-- TABLE: found_items
-- Records found items submitted by users
-- =============================================================
CREATE TABLE IF NOT EXISTS found_items (
    item_id       INT           AUTO_INCREMENT PRIMARY KEY,
    user_id       INT           NOT NULL,
    item_name     VARCHAR(100)  NOT NULL,
    category      VARCHAR(50)   NOT NULL,
    description   TEXT,
    date_found    DATE          NOT NULL,
    location      VARCHAR(200)  NOT NULL,
    image_path    VARCHAR(300),
    contact_info  VARCHAR(200)  NOT NULL,
    status        ENUM('Available','Claimed','Closed') DEFAULT 'Available',
    is_approved   TINYINT(1)    DEFAULT 1  COMMENT '0 = pending admin approval',
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_status   (status),
    INDEX idx_category (category),
    INDEX idx_date_found (date_found)
) ENGINE=InnoDB;

-- =============================================================
-- TABLE: claim_requests
-- Users claim ownership of a found item
-- =============================================================
CREATE TABLE IF NOT EXISTS claim_requests (
    claim_id          INT           AUTO_INCREMENT PRIMARY KEY,
    found_item_id     INT           NOT NULL,
    claimant_user_id  INT           NOT NULL,
    proof_description TEXT          NOT NULL  COMMENT 'Claimant describes identifying features',
    status            ENUM('Pending','Approved','Rejected') DEFAULT 'Pending',
    admin_note        VARCHAR(500)  COMMENT 'Note from admin or item finder when resolving',
    created_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (found_item_id)    REFERENCES found_items(item_id) ON DELETE CASCADE,
    FOREIGN KEY (claimant_user_id) REFERENCES users(user_id)       ON DELETE CASCADE,
    INDEX idx_status         (status),
    INDEX idx_found_item_id  (found_item_id),
    UNIQUE KEY uq_claim (found_item_id, claimant_user_id)  -- one claim per user per item
) ENGINE=InnoDB;

-- =============================================================
-- SEED DATA: Default Admin Account
-- Password: admin@123  (BCrypt hashed)
-- Change immediately after first login!
-- =============================================================
INSERT INTO admins (username, password_hash, email, full_name)
VALUES (
    'admin',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'admin@college.edu',
    'System Administrator'
);

-- =============================================================
-- SEED DATA: Sample Students (password: student@123)
-- =============================================================
INSERT INTO users (usn, full_name, email, phone, department, password_hash) VALUES
('1RV20CS001', 'Arjun Sharma',   'arjun.sharma@student.edu',   '9876543210', 'Computer Science', '$2a$10$sQ3.WD5zLgKYnbGjRHQtNuqSwVmfMGVB5wqxO3gEFpL2sTYQ.RWLS'),
('1RV20EC045', 'Priya Patel',    'priya.patel@student.edu',    '9845123456', 'Electronics',       '$2a$10$sQ3.WD5zLgKYnbGjRHQtNuqSwVmfMGVB5wqxO3gEFpL2sTYQ.RWLS'),
('1RV20ME012', 'Rahul Nair',     'rahul.nair@student.edu',     '9901234567', 'Mechanical',        '$2a$10$sQ3.WD5zLgKYnbGjRHQtNuqSwVmfMGVB5wqxO3gEFpL2sTYQ.RWLS');

-- =============================================================
-- SEED DATA: Sample Lost Items
-- =============================================================
INSERT INTO lost_items (user_id, item_name, category, description, date_lost, location, contact_info, status) VALUES
(1, 'Blue Water Bottle',      'Accessories', 'Steel blue water bottle with my name engraved - Arjun', '2024-01-15', 'Cafeteria',          '9876543210', 'Active'),
(2, 'Scientific Calculator',  'Electronics', 'Casio FX-991ES Plus, black cover with sticker',          '2024-01-18', 'Lab Block 2, Room 204', '9845123456', 'Active'),
(3, 'Student ID Card',        'Documents',   'ID card for Rahul Nair, 1RV20ME012',                     '2024-01-20', 'Main Gate',          '9901234567', 'Recovered'),
(1, 'Laptop Charger',         'Electronics', 'Dell 65W charger, black, barrel connector',              '2024-01-22', 'Library Reading Hall','9876543210', 'Active');

-- =============================================================
-- SEED DATA: Sample Found Items
-- =============================================================
INSERT INTO found_items (user_id, item_name, category, description, date_found, location, contact_info, status) VALUES
(2, 'Black Wallet',           'Accessories', 'Black leather wallet with student ID inside',            '2024-01-16', 'Parking Lot Block A', '9845123456', 'Available'),
(3, 'Umbrella',               'Accessories', 'Purple umbrella, found near main entrance',              '2024-01-19', 'Main Entrance',       '9901234567', 'Available'),
(1, 'Notebook - Data Structures', 'Stationery', 'Red notebook with DS notes, found in CS lab',        '2024-01-21', 'CS Lab 3',            '9876543210', 'Claimed');

-- =============================================================
-- SEED DATA: Sample Claim Request
-- =============================================================
INSERT INTO claim_requests (found_item_id, claimant_user_id, proof_description, status) VALUES
(3, 1, 'The notebook has my name on the first page - Arjun Sharma, and contains my handwritten notes from the Data Structures class with Professor Mehta.', 'Approved');

-- Update found item status for the approved claim
UPDATE found_items SET status = 'Claimed' WHERE item_id = 3;
