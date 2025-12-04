CREATE DATABASE IF NOT EXISTS `projectdb`; 

USE `projectdb`; 

CREATE TABLE IF NOT EXISTS `users` ( 
    `id` INT NOT NULL AUTO_INCREMENT, 
    `username` VARCHAR(50) NOT NULL, 
    `password` VARCHAR(50) NOT NULL, 
    PRIMARY KEY (`id`), 
    UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE
    );

INSERT INTO `users` (`username`, `password`) VALUES ('admin', 'password123'); 
