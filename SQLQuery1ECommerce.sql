CREATE DATABASE ECommerceDB;
use ECommerceDB

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    PasswordHash NVARCHAR(255),

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL
);


CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100),

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100),
    Price DECIMAL(10,2),
    Stock INT,
    CategoryID INT,

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,

    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    UserID INT,
    TotalAmount DECIMAL(10,2),

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,

    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2),

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,

    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    PaymentMethod NVARCHAR(50),
    Amount DECIMAL(10,2),

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,

    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY,
    UserID INT,
    ProductID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(255),

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,

    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Wishlist (
    WishlistID INT PRIMARY KEY IDENTITY,
    UserID INT UNIQUE,

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,

    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);


CREATE TABLE WishlistItems (
    WishlistItemID INT PRIMARY KEY IDENTITY,
    WishlistID INT,
    ProductID INT,

    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,

    FOREIGN KEY (WishlistID) REFERENCES Wishlist(WishlistID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- Users
INSERT INTO Users (Name, Email, PasswordHash)
VALUES ('Sanad', 'sanad@test.com', '123');

-- Categories
INSERT INTO Categories (Name)
VALUES ('Electronics'), ('Clothes');

-- Products
INSERT INTO Products (Name, Price, Stock, CategoryID)
VALUES 
('Laptop', 1000, 10, 1),
('T-Shirt', 20, 50, 2);

-- Orders
INSERT INTO Orders (UserID, TotalAmount)
VALUES (1, 1020);

-- OrderItems
INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price)
VALUES (1, 1, 1, 1000),
       (1, 2, 1, 20);

-- Reviews
INSERT INTO Reviews (UserID, ProductID, Rating, Comment)
VALUES (1, 1, 5, 'Excellent');

-- Update
UPDATE Products
SET Price = 900, UpdatedAt = GETDATE()
WHERE ProductID = 1;

-- Soft Delete
UPDATE Products
SET IsDeleted = 1
WHERE ProductID = 2;


SELECT o.OrderID, u.Name, o.TotalAmount
FROM Orders o
INNER JOIN Users u ON o.UserID = u.UserID
WHERE o.IsDeleted = 0;

SELECT *
FROM Products
WHERE IsDeleted = 0
ORDER BY Price ASC;

SELECT p.Name, AVG(r.Rating) AS AvgRating
FROM Products p
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.Name;


SELECT p.Name
FROM Wishlist w
INNER JOIN WishlistItems wi ON w.WishlistID = wi.WishlistID
INNER JOIN Products p ON wi.ProductID = p.ProductID
WHERE w.UserID = 1;


SELECT u.Name, SUM(o.TotalAmount) AS TotalSales
FROM Users u
INNER JOIN Orders o ON u.UserID = o.UserID
GROUP BY u.Name;


SELECT *
FROM Products
WHERE Price BETWEEN 10 AND 1000
AND IsDeleted = 0;

SELECT TOP 5 *
FROM Orders
ORDER BY CreatedAt DESC;


CREATE INDEX idx_product_price ON Products(Price);

SELECT *
FROM Products
ORDER BY Price
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


INSERT INTO Users (Name, Email, PasswordHash)
VALUES 
('Ahmad', 'ahmad@test.com', '123'),
('Lana', 'lana@test.com', '123'),
('Omar', 'omar@test.com', '123'),
('Sara', 'sara@test.com', '123'),
('Yousef', 'yousef@test.com', '123');

INSERT INTO Categories (Name)
VALUES 
('Mobiles'),
('Laptops'),
('Accessories'),
('Shoes'),
('Home');


INSERT INTO Products (Name, Price, Stock, CategoryID)
VALUES 
('iPhone 14', 1200, 15, 1),
('Samsung S22', 900, 20, 1),
('MacBook Pro', 2000, 10, 2),
('Dell Laptop', 1100, 8, 2),
('Headphones', 150, 30, 3),
('Mouse', 25, 100, 3),
('Running Shoes', 80, 50, 4),
('Sneakers', 120, 40, 4),
('Chair', 200, 12, 5),
('Table', 350, 5, 5);

INSERT INTO Orders (UserID, TotalAmount)
VALUES 
(1, 1200),
(2, 2050),
(3, 175),
(4, 350),
(5, 80);


INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price)
VALUES 
(1, 3, 1, 1200), -- Ahmad bought MacBook

(2, 1, 1, 1200),
(2, 5, 1, 150),
(2, 6, 2, 25),

(3, 5, 1, 150),
(3, 6, 1, 25),

(4, 10, 1, 350),

(5, 7, 1, 80);


INSERT INTO Payments (OrderID, PaymentMethod, Amount)
VALUES 
(1, 'Credit Card', 1200),
(2, 'PayPal', 2050),
(3, 'Cash', 175),
(4, 'Credit Card', 350),
(5, 'Cash', 80);

INSERT INTO Reviews (UserID, ProductID, Rating, Comment)
VALUES 
(1, 3, 5, 'Amazing laptop'),
(2, 1, 4, 'Very good'),
(3, 5, 5, 'Perfect sound'),
(4, 10, 3, 'Average quality'),
(5, 7, 4, 'Comfortable shoes'),
(2, 3, 5, 'Loved it'),
(3, 1, 4, 'Nice phone');

INSERT INTO Wishlist (UserID)
VALUES (1), (2), (3), (4), (5);


INSERT INTO WishlistItems (WishlistID, ProductID)
VALUES 
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(2, 7),	
(3, 8);