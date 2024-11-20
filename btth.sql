CREATE DATABASE salesDB;

CREATE TABLE customers (
	customerID INT PRIMARY KEY AUTO_INCREMENT,
    firsrName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE products (
	productID INT PRIMARY KEY AUTO_INCREMENT,
    productName VARCHAR(100) NOT NULL,
    price DECIMAL(10,2)
);

CREATE TABLE orders (
	orderID INT PRIMARY KEY AUTO_INCREMENT,
    customerID INT,
    FOREIGN KEY(customerID) REFERENCES customers(customerID),
    orderDate DATE NOT NULL,
    totalAmount DECIMAL(10,2) NOT NULL
);

CREATE TABLE promotions (
	promotionID INT PRIMARY KEY AUTO_INCREMENT,
    promotionName VARCHAR(100) NOT NULL,
    discountPercentage DECIMAL(5,2)
);

CREATE TABLE sales (
	saleID INT PRIMARY KEY AUTO_INCREMENT,
    orderID INT,
    FOREIGN KEY(orderID) REFERENCES orders(orderID),
    saleDate DATE NOT NULL,
    saleAmount DECIMAL(10,2) NOT NULL
);

INSERT INTO customers (customerID, firsrName, lastName, email) VALUES
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com'),
(4, 'Bob', 'Brown', 'bob.brown@example.com');

INSERT INTO products (productID, productName, price) VALUES
(1, 'Product A', 100.00),
(2, 'Product B', 150.50),
(3, 'Product C', 200.00),
(4, 'Product D', 50.75);

INSERT INTO orders (orderID, customerID, orderDate, totalAmount) VALUES
(1, 1, '2024-07-01', 250.00),
(2, 1, '2024-07-15', 300.00),
(3, 2, '2024-07-05', 150.50),
(4, 3, '2024-08-01', 500.00),
(5, 4, '2024-07-12', 100.00);

INSERT INTO sales (saleID, orderID, saleDate, saleAmount) VALUES
(1, 1, '2024-07-01', 250.00),
(2, 2, '2024-07-15', 300.00),
(3, 3, '2024-07-05', 150.50),
(4, 4, '2024-08-01', 500.00),
(5, 5, '2024-07-12', 100.00);

INSERT INTO promotions (promotionID, promotionName, discountPercentage) VALUES
(1, 'Summer Sale', 10.00),
(2, 'Winter Discount', 15.00);

DELIMITER $$

CREATE PROCEDURE CalculateMonthlyRevenueAndApplyPromotion(
    IN monthYear VARCHAR(7), 
    IN revenueThreshold DECIMAL(10, 2) 
)
BEGIN
    DECLARE startDate DATE;
    DECLARE endDate DATE;

    SET startDate = STR_TO_DATE(CONCAT(monthYear, '-01'), '%Y-%m-%d');
    SET endDate = LAST_DAY(startDate);

    INSERT INTO promotions (promotionName, discountPercentage)
    SELECT 
        CONCAT('Promotion for Customer ', o.customerID, ' in ', monthYear) AS promotionName,
        10.00 
    FROM orders o
    JOIN sales s ON o.orderID = s.orderID
    WHERE s.saleDate BETWEEN startDate AND endDate
    GROUP BY o.customerID
    HAVING SUM(s.saleAmount) > revenueThreshold;

END$$

DELIMITER ;

CALL CalculateMonthlyRevenueAndApplyPromotion('2024-07', 200);

SELECT * FROM promotions;