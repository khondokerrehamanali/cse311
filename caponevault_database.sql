-- ============================================================
-- CSE311L: Database Systems
-- CaponeVault Database — Group 7 (Database Implementation)
-- ============================================================
-- HOW TO IMPORT:
--   1. Open XAMPP → Start Apache + MySQL
--   2. Go to http://localhost/phpmyadmin
--   3. Click the "Import" tab at the top
--   4. Choose this file and click "Go"
-- ============================================================

-- ============================================================
-- STEP 1: Create and select the database
-- ============================================================
CREATE DATABASE IF NOT EXISTS CaponeVault;
USE CaponeVault;

-- ============================================================
-- STEP 2: Drop existing tables (child tables first)
-- ============================================================
DROP TABLE IF EXISTS Alerts;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Investigations;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Customers;

-- ============================================================
-- TABLE 1: Customers
-- ============================================================
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    national_id VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE 2: Accounts (OWNS: one customer → many accounts)
-- ============================================================
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    account_type VARCHAR(20) NOT NULL,
    balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    opened_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- ============================================================
-- TABLE 3: Transactions
-- ============================================================
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    related_account_id INT,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_date DATETIME NOT NULL,
    channel VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Completed',
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (related_account_id) REFERENCES Accounts(account_id)
);

-- ============================================================
-- TABLE 4: Investigations (HAS_CASES: one customer → many cases)
-- ============================================================
CREATE TABLE Investigations (
    investigation_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    assigned_investigator VARCHAR(100) NOT NULL,
    case_title VARCHAR(150) NOT NULL,
    case_description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'Open',
    risk_level VARCHAR(20) NOT NULL,
    opened_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- ============================================================
-- TABLE 5: Alerts
-- ============================================================
CREATE TABLE Alerts (
    alert_id INT PRIMARY KEY,
    transaction_id INT NOT NULL,
    investigation_id INT NOT NULL,
    alert_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'New',
    generated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id),
    FOREIGN KEY (investigation_id) REFERENCES Investigations(investigation_id)
);

-- ============================================================
--                  SAMPLE DATA
-- ============================================================

-- Customers (10 customers)
INSERT INTO Customers VALUES
(1,  'Rahim Uddin Ahmed',   '1985-03-14', '1985612345678', 'rahim.ahmed@gmail.com',     '01711-000001', '2022-01-10 09:00:00'),
(2,  'Nusrat Jahan',        '1992-07-22', '1992734567891', 'nusrat.jahan@yahoo.com',    '01711-000002', '2022-02-14 10:30:00'),
(3,  'Tanvir Hossain',      '1988-11-05', '1988845678912', 'tanvir.hossain@gmail.com',  '01711-000003', '2021-11-03 11:45:00'),
(4,  'Farhana Akter',       '1995-02-18', '1995956789123', 'farhana.akter@outlook.com', '01711-000004', '2023-05-20 12:10:00'),
(5,  'Mahmudul Hasan Khan', '1979-09-30', '1979067891234', 'mahmudul.khan@gmail.com',   '01711-000005', '2020-08-17 09:20:00'),
(6,  'Sadia Islam',         '1990-12-01', '1990178912345', 'sadia.islam@yahoo.com',     '01711-000006', '2023-09-09 14:00:00'),
(7,  'Imran Chowdhury',     '1983-06-27', '1983289123456', 'imran.c@gmail.com',         '01711-000007', '2021-06-25 10:15:00'),
(8,  'Ayesha Siddika',      '1998-04-09', '1998391234567', 'ayesha.s@outlook.com',      '01711-000008', '2024-02-02 13:40:00'),
(9,  'Rafiq Mia',           '1975-08-12', '1975412345678', 'rafiq.mia@gmail.com',       '01711-000009', '2019-12-12 09:50:00'),
(10, 'Tasnim Rahman',       '2000-01-25', '2000523456789', 'tasnim.r@yahoo.com',        '01711-000010', '2024-04-18 16:25:00');

-- Accounts (14 accounts)
INSERT INTO Accounts VALUES
(1,  1,  '1001000001', 'Savings',  250000.00,  'Active', '2022-01-10 09:30:00'),
(2,  1,  '1001000002', 'Current',  480000.00,  'Active', '2022-03-05 10:00:00'),
(3,  2,  '1001000003', 'Savings',  120000.00,  'Active', '2022-02-14 11:00:00'),
(4,  3,  '1001000004', 'Current',  1100000.00, 'Active', '2021-11-03 12:00:00'),
(5,  3,  '1001000005', 'Savings',  75000.00,   'Active', '2022-01-20 15:30:00'),
(6,  4,  '1001000006', 'Savings',  60000.00,   'Active', '2023-05-20 12:40:00'),
(7,  5,  '1001000007', 'Current',  1500000.00, 'Active', '2020-08-17 09:45:00'),
(8,  6,  '1001000008', 'Savings',  38000.00,   'Active', '2023-09-09 14:20:00'),
(9,  7,  '1001000009', 'Current',  450000.00,  'Frozen', '2021-06-25 10:30:00'),
(10, 7,  '1001000010', 'Savings',  1160000.00, 'Active', '2021-07-10 11:15:00'),
(11, 8,  '1001000011', 'Savings',  15000.00,   'Active', '2024-02-02 14:00:00'),
(12, 9,  '1001000012', 'Current',  640000.00,  'Active', '2019-12-12 10:10:00'),
(13, 10, '1001000013', 'Savings',  20000.00,   'Active', '2024-04-18 16:45:00'),
(14, 5,  '1001000014', 'Savings',  0.00,       'Closed', '2020-09-01 10:00:00');

-- Transactions (27 transactions)
-- ── Everyday activity ───────────────────────────────────────
INSERT INTO Transactions VALUES
(1,  1,  NULL, 'Deposit',    85000.00,   '2026-09-01 10:05:00', 'Branch',     'Completed'),
(2,  1,  3,    'Transfer',   15000.00,   '2026-09-03 14:20:00', 'Mobile App', 'Completed'),
(3,  2,  NULL, 'Withdrawal', 20000.00,   '2026-09-04 11:00:00', 'ATM',        'Completed'),
(4,  3,  NULL, 'Deposit',    40000.00,   '2026-09-05 09:40:00', 'Branch',     'Completed'),
(5,  6,  8,    'Transfer',   5000.00,    '2026-09-06 18:30:00', 'Mobile App', 'Completed'),
(6,  8,  NULL, 'Withdrawal', 10000.00,   '2026-09-07 13:10:00', 'ATM',        'Completed');

-- ── Structuring pattern: deposits just under 1,000,000 ─────
INSERT INTO Transactions VALUES
(7,  4,  NULL, 'Deposit',    950000.00,  '2026-09-10 10:15:00', 'Branch',     'Completed'),
(8,  4,  NULL, 'Deposit',    980000.00,  '2026-09-11 10:40:00', 'Branch',     'Completed'),
(9,  4,  NULL, 'Deposit',    970000.00,  '2026-09-12 11:05:00', 'Branch',     'Completed');

-- ── Layering pattern: large inflow forwarded within hours ──
INSERT INTO Transactions VALUES
(10, 4,  9,    'Transfer',   1800000.00, '2026-09-14 14:30:00', 'Online',     'Completed'),
(11, 9,  12,   'Transfer',   900000.00,  '2026-09-14 15:45:00', 'Online',     'Completed'),
(12, 9,  10,   'Transfer',   850000.00,  '2026-09-14 16:10:00', 'Online',     'Completed');

-- ── Dormant account suddenly active ─────────────────────────
INSERT INTO Transactions VALUES
(13, 12, 13,   'Transfer',   500000.00,  '2026-09-15 09:30:00', 'Mobile App', 'Completed'),
(14, 13, NULL, 'Withdrawal', 480000.00,  '2026-09-15 12:00:00', 'Branch',     'Completed');

-- ── Large cash withdrawal and a failed transfer ─────────────
INSERT INTO Transactions VALUES
(15, 7,  NULL, 'Withdrawal', 800000.00,  '2026-09-18 10:30:00', 'Branch',     'Completed'),
(16, 7,  14,   'Transfer',   410000.00,  '2026-09-20 15:00:00', 'Online',     'Failed');

-- ── More regular activity ───────────────────────────────────
INSERT INTO Transactions VALUES
(17, 5,  4,    'Transfer',   30000.00,   '2026-09-21 17:45:00', 'Mobile App', 'Completed'),
(18, 11, NULL, 'Deposit',    12000.00,   '2026-09-22 10:20:00', 'Branch',     'Completed'),
(19, 2,  7,    'Transfer',   200000.00,  '2026-09-23 11:55:00', 'Online',     'Completed');

-- ── Activity around the frozen account ──────────────────────
INSERT INTO Transactions VALUES
(20, 12, 9,    'Transfer',   300000.00,  '2026-09-24 09:10:00', 'Online',     'Pending'),
(21, 10, 12,   'Transfer',   700000.00,  '2026-09-25 13:25:00', 'Online',     'Completed'),
(22, 3,  1,    'Transfer',   5000.00,    '2026-09-26 19:05:00', 'Mobile App', 'Completed'),
(23, 8,  NULL, 'Withdrawal', 8000.00,    '2026-09-27 12:35:00', 'ATM',        'Completed'),
(24, 1,  2,    'Transfer',   100000.00,  '2026-10-01 10:50:00', 'Online',     'Completed'),
(25, 6,  NULL, 'Deposit',    25000.00,   '2026-10-02 11:30:00', 'Branch',     'Completed'),
(26, 12, NULL, 'Withdrawal', 600000.00,  '2026-10-03 14:15:00', 'Branch',     'Completed'),
(27, 9,  NULL, 'Withdrawal', 1000000.00, '2026-10-04 10:00:00', 'Branch',     'Failed');

-- Investigations (6 cases)
INSERT INTO Investigations VALUES
(1, 3,  'Mizanur Rahman',  'Suspected Structuring - Branch Cash Deposits',
    'Three branch cash deposits just below the 1,000,000 BDT reporting threshold within 72 hours, followed by a large online transfer.',
    'Under Review', 'High',     '2026-09-13 09:00:00'),
(2, 7,  'Sharmin Sultana', 'Rapid Fund Movement (Layering)',
    'Account received 1,800,000 BDT and forwarded almost all of it to two other accounts within two hours. Account frozen pending review.',
    'Open',         'Critical', '2026-09-15 09:00:00'),
(3, 10, 'Mizanur Rahman',  'Dormant Account Sudden Activity',
    'Account with no activity since opening received 500,000 BDT and was almost fully withdrawn in cash on the same day.',
    'Under Review', 'Medium',   '2026-09-16 10:30:00'),
(4, 5,  'Nadia Karim',     'Large Cash Withdrawal Review',
    'One-off branch cash withdrawal of 800,000 BDT and a failed transfer to a closed account. Customer provided documents; no further concern.',
    'Closed',       'Low',      '2026-09-19 11:00:00'),
(5, 9,  'Sharmin Sultana', 'Inbound Transfers Linked to Flagged Accounts',
    'Account received funds from accounts linked to the layering case and made a large cash withdrawal soon after.',
    'Open',         'High',     '2026-09-25 15:00:00'),
(6, 1,  'Nadia Karim',     'Routine Velocity Check',
    'Routine review after an internal transfer between two of his own accounts triggered a velocity rule. Activity matched the customer profile.',
    'Closed',       'Low',      '2026-10-02 09:30:00');

-- Alerts (16 alerts)
INSERT INTO Alerts VALUES
(1,  7,  1, 'Structuring',              'Medium',   'Cash deposit of 950,000 BDT just below the reporting threshold.',               'Reviewed',  '2026-09-10 10:30:00'),
(2,  8,  1, 'Structuring',              'High',     'Second near-threshold cash deposit within 24 hours.',                           'Reviewed',  '2026-09-11 11:00:00'),
(3,  9,  1, 'Structuring',              'High',     'Third near-threshold cash deposit in 72 hours; pattern matches structuring.',   'Escalated', '2026-09-12 11:30:00'),
(4,  10, 2, 'Large Transfer',           'High',     'Transfer of 1,800,000 BDT to an account with no prior history with the sender.', 'Escalated', '2026-09-14 14:35:00'),
(5,  11, 2, 'Rapid Movement',           'Critical', 'Funds forwarded about one hour after receipt (900,000 BDT).',                   'Escalated', '2026-09-14 15:50:00'),
(6,  12, 2, 'Rapid Movement',           'Critical', 'Second onward transfer (850,000 BDT) the same afternoon; layering suspected.',  'Escalated', '2026-09-14 16:15:00'),
(7,  13, 3, 'Dormant Account Activity', 'Medium',   'First-ever activity on an account open for more than two years.',               'Reviewed',  '2026-09-15 09:35:00'),
(8,  14, 3, 'Large Cash Withdrawal',    'High',     'About 96 percent of a freshly received balance withdrawn in cash same day.',   'Reviewed',  '2026-09-15 12:05:00'),
(9,  15, 4, 'Large Cash Withdrawal',    'Low',      'Cash withdrawal of 800,000 BDT is above the customer usual monthly volume.',   'Closed',    '2026-09-18 10:35:00'),
(10, 16, 4, 'Closed Account Attempt',   'Low',      'Attempted transfer to an account that was already closed.',                    'Closed',    '2026-09-20 15:05:00'),
(11, 21, 5, 'Related Account Activity', 'High',     '700,000 BDT received from an account owned by a customer under investigation.', 'Reviewed',  '2026-09-25 13:30:00'),
(12, 20, 2, 'Frozen Account Attempt',   'High',     'Transfer to a frozen account initiated and left pending.',                     'New',       '2026-09-24 09:15:00'),
(13, 26, 5, 'Large Cash Withdrawal',    'Medium',   'Cash withdrawal of 600,000 BDT shortly after receiving funds from a flagged source.', 'New', '2026-10-03 14:20:00'),
(14, 27, 2, 'Frozen Account Attempt',   'High',     'Withdrawal of 1,000,000 BDT attempted from a frozen account; blocked.',        'New',       '2026-10-04 10:05:00'),
(15, 24, 6, 'Velocity Check',           'Low',      'Internal transfer between own accounts exceeded the velocity rule.',           'Closed',    '2026-10-01 10:55:00'),
(16, 11, 2, 'Large Transfer',           'High',     'Transfer of 900,000 BDT out of a high-risk account.',                          'Reviewed',  '2026-09-14 15:55:00');



