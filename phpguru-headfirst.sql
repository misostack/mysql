DROP SCHEMA IF EXISTS `phpguru-headfirst`;
CREATE SCHEMA `phpguru-headfirst` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `phpguru-headfirst`;
DROP TABLE IF EXISTS `phpguru_users`;
CREATE TABLE IF NOT EXISTS `phpguru_users`
(
  id BIGINT(20) NOT NULL AUTO_INCREMENT,
  login VARCHAR(60) NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100) NOT NULL,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  type TINYINT(255) NOT NULL,
  status TINYINT(255) NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  is_super_admin BOOLEAN NULL DEFAULT 0,
  PRIMARY KEY (id)
);