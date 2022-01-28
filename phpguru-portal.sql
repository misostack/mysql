DROP SCHEMA IF EXISTS `phpguru-portal`;

-- CREATE SCHEMA `phpguru-portal` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `phpguru-portal`;
DROP TABLE IF EXISTS `phpguru_users`;
CREATE TABLE IF NOT EXISTS `phpguru_users`
(
  id BIGINT(20) NOT NULL AUTO_INCREMENT,
  login VARCHAR(60) NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100) NOT NULL,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  type ENUM('admin','member') NOT NULL,
  status ENUM('pending', 'active', 'inactive') NULL DEFAULT 'pending',
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  is_super_admin BOOLEAN NULL DEFAULT 0,
  PRIMARY KEY (id)
);


ALTER TABLE `phpguru_users`
ADD CONSTRAINT users_uc_email UNIQUE(email);


ALTER TABLE `phpguru_users`
ADD CONSTRAINT uc_users_login UNIQUE(login);


ALTER TABLE `phpguru_users`
ADD CONSTRAINT chk_users_is_super_admin CHECK (is_super_admin IN(0,1));

ALTER TABLE `phpguru_users`
ADD COLUMN gender CHAR(1) NOT NULL;

ALTER TABLE `phpguru_users`
ADD CONSTRAINT chk_users_gender
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
ADD CONSTRAINT chk_users_first_name
CHECK(1=1);

/* A MEMBER MUST NOT BE A SUPER ADMIN */
ALTER TABLE `phpguru_users`
ADD CONSTRAINT is_super_admin
CHECK(
  CASE
    WHEN type = 'member' AND is_super_admin = 1 THEN 0
    ELSE 1
  END = 1
);

DROP TABLE IF EXISTS `phpguru_sessions`;
CREATE TABLE IF NOT EXISTS `phpguru_sessions`
(
  id BIGINT(20) PRIMARY KEY,
  user_id BIGINT(20) NOT NULL,
  login_at DATETIME NOT NULL,
  logout_at DATETIME NULL,
  user_agent TEXT NULL
);

/* ADD FOREIGN KEY */
ALTER TABLE `phpguru_sessions`
ADD CONSTRAINT fk_users_sessions FOREIGN KEY(user_id)
REFERENCES phpguru_users(id);