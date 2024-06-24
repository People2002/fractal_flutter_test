CREATE DATABASE fractal_db;

use fractal_db;

CREATE TABLE `fractal_db`.`producto` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `unite_price` DOUBLE NOT NULL,
  `qty` INT NOT NULL,
  `total_price` DOUBLE NOT NULL,
  PRIMARY KEY (`id`));
  
  CREATE TABLE `fractal_db`.`orders` (
  `id` INT NOT NULL,
  `num_order` VARCHAR(45) NOT NULL,
  `date` VARCHAR(45) NOT NULL,
  `num_products` INT NOT NULL,
  `final_price` DOUBLE NOT NULL,
  PRIMARY KEY (`id`));
  
  CREATE TABLE `fractal_db`.`order_detail` (
  `id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `price` DOUBLE NOT NULL,
  `qty` INT NOT NULL,
  PRIMARY KEY (`id`));
  
  
  
  
