CREATE DATABASE banking_db;

USE banking_db;

CREATE TABLE branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100) NOT NULL,
    branch_code VARCHAR(10) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL
);

INSERT INTO branches
(branch_name, branch_code, city, state)
VALUES
('SBI Patna Main','SBI001','Patna','Bihar'),
('SBI Danapur','SBI002','Patna','Bihar'),
('SBI Muzaffarpur','SBI003','Muzaffarpur','Bihar'),
('SBI Gaya','SBI004','Gaya','Bihar'),
('SBI Bhagalpur','SBI005','Bhagalpur','Bihar');

SELECT * FROM branches;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    dob DATE,
    gender ENUM('Male','Female','Other'),
    aadhar_no VARCHAR(12) UNIQUE,
    pan_no VARCHAR(10) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers
(full_name, email, phone, dob, gender, aadhar_no, pan_no)
VALUES
('Rahul Kumar','rahul@gmail.com','9876543210','2000-05-10','Male','123456789012','ABCDE1234F'),
('Priya Sharma','priya@gmail.com','9876543211','1998-08-21','Female','123456789013','ABCDE1235F'),
('Amit Singh','amit@gmail.com','9876543212','1999-11-12','Male','123456789014','ABCDE1236F'),
('Neha Verma','neha@gmail.com','9876543213','2001-03-15','Female','123456789015','ABCDE1237F'),
('Rohit Raj','rohit@gmail.com','9876543214','1997-01-25','Male','123456789016','ABCDE1238F');

SELECT * FROM customers;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    account_number BIGINT UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_type ENUM('Savings','Current') NOT NULL,
    balance DECIMAL(12,2) DEFAULT 0.00,
    status ENUM('Active','Inactive','Closed') DEFAULT 'Active',
    opened_on DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

INSERT INTO accounts
(account_number, customer_id, branch_id, account_type, balance, opened_on)
VALUES
(100000001,1,1,'Savings',25000.00,'2025-01-10'),
(100000002,2,2,'Current',85000.00,'2025-02-05'),
(100000003,3,1,'Savings',15000.00,'2025-03-12'),
(100000004,4,3,'Savings',42000.00,'2025-04-01'),
(100000005,5,5,'Current',100000.00,'2025-05-20');

SELECT * FROM accounts;

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    transaction_type ENUM('Deposit','Withdraw','Transfer') NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO transactions
(account_id, transaction_type, amount)
VALUES
(1,'Deposit',10000.00),
(1,'Withdraw',2000.00),
(2,'Deposit',15000.00),
(3,'Transfer',5000.00),
(4,'Deposit',12000.00),
(5,'Withdraw',7000.00);

SELECT * from transactions;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    designation VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

INSERT INTO employees
(full_name, designation, salary, phone, email, branch_id)
VALUES
('Rajesh Kumar','Manager',75000,'9876500001','rajesh@sbi.com',1),
('Anjali Singh','Cashier',40000,'9876500002','anjali@sbi.com',1),
('Vikas Sharma','Officer',50000,'9876500003','vikas@sbi.com',2),
('Pooja Verma','Cashier',42000,'9876500004','pooja@sbi.com',3),
('Aman Gupta','Manager',78000,'9876500005','aman@sbi.com',5);

SELECT * FROM employees;

CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    loan_type ENUM('Home','Car','Personal','Education') NOT NULL,
    loan_amount DECIMAL(12,2) NOT NULL,
    interest_rate DECIMAL(5,2),
    loan_status ENUM('Active','Closed','Pending') DEFAULT 'Pending',
    start_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO loans
(customer_id, loan_type, loan_amount, interest_rate, loan_status, start_date)
VALUES
(1,'Home',2500000.00,8.50,'Active','2025-06-01'),
(2,'Car',800000.00,9.20,'Pending','2025-07-15'),
(3,'Personal',300000.00,11.50,'Active','2025-08-10'),
(5,'Education',500000.00,7.80,'Closed','2025-03-20');

SELECT * FROM loans;

SELECT 
    customers.full_name,
    accounts.account_number,
    accounts.balance
FROM customers
INNER JOIN accounts
ON customers.customer_id = accounts.customer_id;

SELECT
    customers.full_name,
    accounts.account_number,
    accounts.balance,
    branches.branch_name,
    branches.city
FROM customers
INNER JOIN accounts
ON customers.customer_id = accounts.customer_id
INNER JOIN branches
ON accounts.branch_id = branches.branch_id;

SELECT
    branches.branch_name,
    COUNT(accounts.account_id) AS total_accounts
FROM branches
INNER JOIN accounts
ON branches.branch_id = accounts.branch_id
GROUP BY branches.branch_name;

SELECT
    branches.branch_name,
    SUM(accounts.balance) AS total_balance
FROM branches
INNER JOIN accounts
ON branches.branch_id = accounts.branch_id
GROUP BY branches.branch_name;

SELECT
    customers.full_name,
    accounts.account_number,
    accounts.balance
FROM customers
INNER JOIN accounts
ON customers.customer_id = accounts.customer_id
ORDER BY accounts.balance DESC
LIMIT 1;

SELECT
    customers.full_name,
    accounts.balance
FROM customers
INNER JOIN accounts
ON customers.customer_id = accounts.customer_id
ORDER BY accounts.balance DESC
LIMIT 3;

SELECT
    customers.full_name,
    accounts.balance
FROM customers
INNER JOIN accounts
ON customers.customer_id = accounts.customer_id
WHERE accounts.balance > 50000;

SELECT
    customers.full_name,
    loans.loan_type,
    loans.loan_amount
FROM customers
INNER JOIN loans
ON customers.customer_id = loans.customer_id
WHERE loans.loan_status = 'Active';

SELECT
    customers.full_name,
    accounts.balance,
    accounts.account_type
FROM customers
INNER JOIN accounts
ON customers.customer_id = accounts.customer_id
WHERE accounts.account_type = 'Savings'
AND accounts.balance > 20000;

SELECT * FROM accounts;

UPDATE accounts
SET balance = 30000
WHERE account_id = 1;

UPDATE employees
SET salary = 80000
WHERE employee_id = 1;

SELECT * FROM employees;

DELETE FROM transactions
WHERE transaction_id = 6;

CREATE VIEW customer_account_report AS
SELECT
    customers.full_name,
    accounts.account_number,
    accounts.balance,
    branches.branch_name,
    branches.city
FROM customers
INNER JOIN accounts
ON customers.customer_id = accounts.customer_id
INNER JOIN branches
ON accounts.branch_id = branches.branch_id;

SELECT * FROM customer_account_report;

SHOW FULL TABLES;

DELIMITER //

CREATE PROCEDURE GetCustomerBalance(IN cust_id INT)
BEGIN
    SELECT
        customers.full_name,
        accounts.account_number,
        accounts.balance
    FROM customers
    INNER JOIN accounts
    ON customers.customer_id = accounts.customer_id
    WHERE customers.customer_id = cust_id;
END //

DELIMITER ;

CALL GetCustomerBalance(1);

SELECT * FROM accounts;

DELIMITER //

CREATE TRIGGER update_balance_after_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN

    IF NEW.transaction_type = 'Deposit' THEN

        UPDATE accounts
        SET balance = balance + NEW.amount
        WHERE account_id = NEW.account_id;

    ELSEIF NEW.transaction_type = 'Withdraw' THEN

        UPDATE accounts
        SET balance = balance - NEW.amount
        WHERE account_id = NEW.account_id;

    END IF;

END //

DELIMITER ;

SELECT * FROM accounts WHERE account_id = 1;

INSERT INTO transactions
(account_id, transaction_type, amount)
VALUES
(1,'Deposit',5000);

SELECT * FROM accounts WHERE account_id = 1;

