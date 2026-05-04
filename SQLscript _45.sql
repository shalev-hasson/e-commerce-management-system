SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema TAUFashion_45
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS TAUFashion_45 DEFAULT CHARACTER SET utf8 ;
USE TAUFashion_45 ;

-- -----------------------------------------------------
-- Table TAUFashion_45.Users
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TAUFashion_45.Users (
  Mail VARCHAR(45) NOT NULL,
  Username VARCHAR(45) NOT NULL,
  BirthDate date NOT NULL,
  UPassword VARCHAR(45) NOT NULL,
  Gender enum('Male', 'Female') NOT NULL,
  Faculty VARCHAR(45) NOT NULL,
  IsManager enum('Yes', 'No') NOT NULL,
  PRIMARY KEY (Mail))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table TAUFashion_45.Garment
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TAUFashion_45.Garment (
  CatalogNum INT NOT NULL,
  GName VARCHAR(45) NOT NULL,
  Quantity INT NOT NULL,
  Price INT NOT NULL,
  Imagepath VARCHAR(300) NOT NULL,
  Campaign TINYINT(1) NOT NULL DEFAULT 0,  
  PRIMARY KEY (CatalogNum))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table TAUFashion_45.Updates
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TAUFashion_45.Updates (
  Mail VARCHAR(45) NOT NULL,
  CatalogNum INT NOT NULL,
  AddQuantity INT NOT NULL,
  UpdateDate datetime NOT NULL,
  PRIMARY KEY (Mail, CatalogNum, UpdateDate),
  CONSTRAINT FK_Updates_Users
    FOREIGN KEY (Mail)
    REFERENCES TAUFashion_45.Users (Mail)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Updates_Garment
    FOREIGN KEY (CatalogNum)
    REFERENCES TAUFashion_45.Garment (CatalogNum)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table TAUFashion_45.Transaction
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TAUFashion_45.Transaction (
  OrderNum INT NOT NULL,
  OrderQuantity INT NOT NULL,
  ODate DATETIME NOT NULL,
  Mail VARCHAR(45) NOT NULL,
  CatalogNum INT NOT NULL,
  PRIMARY KEY (OrderNum, Mail, CatalogNum),
  CONSTRAINT FK_Transaction_Users
    FOREIGN KEY (Mail)
    REFERENCES TAUFashion_45.Users (Mail)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_Transaction_Garment
    FOREIGN KEY (CatalogNum)
    REFERENCES TAUFashion_45.Garment (CatalogNum)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

 -- Populating Users table
INSERT INTO TAUFashion_45.Users (Mail, Username, BirthDate, UPassword, Gender, Faculty, IsManager) VALUES
('user1@mail.com', 'User1', '2003-07-14', 'password1', 'Male', 'Engineering', 'No'),
('user2@mail.com', 'User2', '2001-03-22', 'password2', 'Female', 'Medicine', 'Yes'),
('user3@mail.com', 'User3', '2002-01-05', 'password3', 'Male', 'Law', 'No'),
('user4@mail.com', 'User4', '2000-11-30', 'password4', 'Female', 'Business', 'No'),
('user5@mail.com', 'User5', '2004-08-09', 'password5', 'Male', 'Design', 'No'),
('user6@mail.com', 'User6', '1998-12-17', 'password6', 'Female', 'Computer Science', 'Yes'),
('user7@mail.com', 'User7', '2003-05-26', 'password7', 'Male', 'Physics', 'No'),
('user8@mail.com', 'User8', '1980-07-31', 'password8', 'Female', 'Math', 'No'),
('user9@mail.com', 'User9', '2002-10-19', 'password9', 'Male', 'Biology', 'No'),
('user10@mail.com', 'User10','1997-02-28', 'password10', 'Female', 'Chemistry', 'Yes');

-- Populating Garment table
INSERT INTO TAUFashion_45.Garment (CatalogNum, GName, Quantity, Price, Imagepath, Campaign) VALUES
(1001, 'YSL TShirt', 50, 499, "images/Tshirtboys.jpg", 0),
(1002, 'Mugler Jeans', 30, 1200, "images/mugler.jpg", 1),
(1003, 'Burberry Coat', 20,15000, "images/burberrycoat.jpg", 0),
(1004, 'YSL Dress', 15, 2100, "images/ysldress.jpg", 1),
(1010, 'Bottega Veneta', 100, 2000, "images/bottegabag.jpg", 1),
(1005, 'Balenciaga Shoes', 40, 3450, "images/unnamed.jpg", 0),
(1007, 'Ralph Luarent sweater', 35, 600, "images/Ralphswboys.jpg", 0),
(1008, 'Verace Tshirt', 18, 550, "images/versaceboy.jpg", 0),
(1006, 'POLO Hat', 25, 299, "images/Ralphhat.jpg", 0),
(1009, 'Balenciaga Sunglasses', 22, 1300, "images/Balenciagasunglasses.jpg", 1),
(1011, 'Kelly Hand Bag', 100, 12000, "images/Kellybag.jpg", 0),
(1012, 'Ralph Luarent sweater', 100, 599, "images/Raplphboys.jpg", 0);

-- Populating Updates table
INSERT INTO TAUFashion_45.Updates (Mail, CatalogNum, AddQuantity,UpdateDate) VALUES
('user2@mail.com', 1001,  5, '2024-03-11 10:23:00'),
('user2@mail.com', 1002,  3, '2024-06-22 14:45:00'),
('user6@mail.com', 1003,  7, '2024-02-17 09:10:15'),
('user6@mail.com', 1004,  2, '2024-10-05 16:30:00'),
('user10@mail.com', 1005, 4, '2024-11-13 20:15:00'),
('user2@mail.com', 1006,  6, '2024-07-09 01:05:00'),
('user6@mail.com', 1007,  8, '2024-03-30 05:45:00'),
('user10@mail.com', 1008, 3, '2024-09-21 11:59:00'),
('user2@mail.com', 1009,  9, '2024-12-25 23:59:59'),
('user10@mail.com',1010, 10,'2024-06-01 08:03:33');

-- Populating Transaction table
INSERT INTO TAUFashion_45.Transaction (OrderNum, OrderQuantity,ODate, Mail, CatalogNum) VALUES
(1, 2,  '2025-01-12 10:30:00', 'user1@mail.com', 1001),
(2, 1,  '2025-01-12 11:00:00', 'user2@mail.com', 1002),
(3, 3,  '2025-01-12 12:00:00', 'user3@mail.com', 1003),
(4, 1,  '2025-01-12 13:30:00', 'user4@mail.com', 1004),
(5, 4,  '2025-01-12 14:15:00', 'user5@mail.com', 1005),
(6, 2,  '2025-01-12 15:45:00', 'user6@mail.com', 1005),
(7, 5,  '2025-01-12 16:00:00', 'user7@mail.com', 1007),
(8, 3,  '2025-01-12 17:10:00', 'user8@mail.com', 1008),
(9, 2,  '2025-01-12 18:20:00', 'user9@mail.com', 1009),
(9, 3,  '2025-01-12 18:20:00', 'user9@mail.com', 1007);

