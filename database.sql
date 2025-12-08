DROP DATABASE IF EXISTS projectdb;
CREATE DATABASE projectdb;
USE projectdb;

-- 1. BASE TABLE: User
CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    LoginID VARCHAR(50) UNIQUE NOT NULL, -- This maps to "username" in JSP
    Password VARCHAR(255) NOT NULL,
    Email VARCHAR(100),
    AccountCreationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. INHERITANCE LEVEL 1: Staff and EndUser
CREATE TABLE EndUser (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE Staff (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

-- 3. INHERITANCE LEVEL 2: Administrator and CustomerRep
CREATE TABLE Administrator (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES Staff(UserID) ON DELETE CASCADE
);

CREATE TABLE CustomerRep (
    UserID INT PRIMARY KEY,
    CreatorAdminID INT,
    HireDate DATE,
    FOREIGN KEY (UserID) REFERENCES Staff(UserID) ON DELETE CASCADE,
    FOREIGN KEY (CreatorAdminID) REFERENCES Administrator(UserID)
);

-- 4. DOMAIN TABLES (Categories, Auctions, etc.)
CREATE TABLE Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100),
    ParentCategoryID INT,
    FOREIGN KEY (ParentCategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE Auction (
    AuctionID INT AUTO_INCREMENT PRIMARY KEY,
    SellerID INT,
    CategoryID INT,
    WinnerID INT,
    ItemName VARCHAR(255),
    ItemDescription TEXT,
    StartTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CloseTime TIMESTAMP,
    InitialPrice DECIMAL(10, 2),
    MinPrice DECIMAL(10, 2),
    BidIncrement DECIMAL(10, 2) DEFAULT 1.00,
    Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (SellerID) REFERENCES EndUser(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (WinnerID) REFERENCES EndUser(UserID)
);

CREATE TABLE Bid (
    BidID INT AUTO_INCREMENT PRIMARY KEY,
    AuctionID INT,
    BuyerID INT,
    BidAmount DECIMAL(10, 2),
    BidTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AuctionID) REFERENCES Auction(AuctionID) ON DELETE CASCADE,
    FOREIGN KEY (BuyerID) REFERENCES EndUser(UserID)
);

CREATE TABLE AutoBid (
    UserID INT,
    AuctionID INT,
    MaxBidAmount DECIMAL(10, 2),
    PRIMARY KEY (UserID, AuctionID),
    FOREIGN KEY (UserID) REFERENCES EndUser(UserID),
    FOREIGN KEY (AuctionID) REFERENCES Auction(AuctionID) ON DELETE CASCADE
);

CREATE TABLE Alert (
    AlertID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    SearchCriteria TEXT,
    FOREIGN KEY (UserID) REFERENCES EndUser(UserID) ON DELETE CASCADE
);

-- 5. MISSING PIECE (For Q&A Checklist)
CREATE TABLE Questions (
    QuestionID INT AUTO_INCREMENT PRIMARY KEY,
    EndUserID INT,
    RepID INT,
    QuestionText TEXT,
    AnswerText TEXT,
    FOREIGN KEY (EndUserID) REFERENCES EndUser(UserID),
    FOREIGN KEY (RepID) REFERENCES CustomerRep(UserID)
);

-- ==========================================
-- DATA POPULATION
-- ==========================================

-- 1. Create the 'admin' user (Must insert into User, Staff, AND Administrator)
INSERT INTO User (LoginID, Password, Email) VALUES ('admin', 'password123', 'admin@site.com');
SET @adminID = LAST_INSERT_ID();
INSERT INTO Staff (UserID) VALUES (@adminID);
INSERT INTO Administrator (UserID) VALUES (@adminID);

-- 2. Create a 'rep1' user (User -> Staff -> CustomerRep)
INSERT INTO User (LoginID, Password, Email) VALUES ('rep1', 'password123', 'rep@site.com');
SET @repID = LAST_INSERT_ID();
INSERT INTO Staff (UserID) VALUES (@repID);
INSERT INTO CustomerRep (UserID, CreatorAdminID, HireDate) VALUES (@repID, @adminID, CURDATE());

-- 3. Create a 'buyer1' user (User -> EndUser)
INSERT INTO User (LoginID, Password, Email) VALUES ('buyer1', 'password123', 'buyer@site.com');
SET @buyerID = LAST_INSERT_ID();
INSERT INTO EndUser (UserID) VALUES (@buyerID);

-- 4. Create a 'buyer2' user (User -> EndUser)
INSERT INTO User (LoginID, Password, Email) VALUES ('buyer2', 'password123', 'buyer@site.com');
SET @buyerID = LAST_INSERT_ID();
INSERT INTO EndUser (UserID) VALUES (@buyerID);

-- 5. Create a 'buyer3' user (User -> EndUser)
INSERT INTO User (LoginID, Password, Email) VALUES ('buyer3', 'password123', 'buyer@site.com');
SET @buyerID = LAST_INSERT_ID();
INSERT INTO EndUser (UserID) VALUES (@buyerID);

-- 6. Create a dummy Category
INSERT INTO Category (CategoryName) VALUES ('Electronics');