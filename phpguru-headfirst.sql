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

ALTER TABLE `phpguru_users`
ADD CONSTRAINT UC_User_Email UNIQUE(email);

ALTER TABLE `phpguru_users`
ADD CONSTRAINT UC_User_Login UNIQUE(login);

SHOW INDEX FROM `phpguru_users`;

ALTER TABLE `phpguru_users`
ADD CONSTRAINT CKH_User_IsSuperAdmin CHECK (is_super_admin IN(0,1));

SHOW COLUMNS FROM `phpguru_users`;

SHOW CREATE TABLE `phpguru_users`;

ALTER TABLE `phpguru_users`
ADD COLUMN gender CHAR(1) NOT NULL;

ALTER TABLE `phpguru_users`
ADD CONSTRAINT users_chk_gender
CHECK(
  CASE
    WHEN gender = 'M' THEN 1
    WHEN gender = 'm' THEN 1
    WHEN gender = 'F' THEN 1
    WHEN gender = 'f' THEN 1
    ELSE 0
  END = 1
);

ALTER TABLE `phpguru_users`
ADD CONSTRAINT users_chk_first_name
CHECK(1=1);

SELECT
       CONSTRAINT_NAME,
       TABLE_SCHEMA,
       TABLE_NAME
       FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
       WHERE TABLE_NAME = 'phpguru_users'
       AND CONSTRAINT_SCHEMA = 'phpguru-headfirst'
       AND  CONSTRAINT_TYPE = 'CHECK';