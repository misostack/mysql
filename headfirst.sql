DROP SCHEMA IF EXISTS `headfirst`;
CREATE SCHEMA `headfirst` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `headfirst`;

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
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  is_super_admin BOOLEAN NULL DEFAULT 0,
  PRIMARY KEY (id)
);

ALTER TABLE `phpguru_users`
ADD CONSTRAINT users_uc_email UNIQUE(email);

ALTER TABLE `phpguru_users`
ADD CONSTRAINT uc_users_login UNIQUE(login);

CREATE INDEX ix_phpguru_users_first_name_last_name ON phpguru_users (first_name, last_name);
DROP INDEX ix_phpguru_users_first_name_last_name_status ON phpguru_users;


DROP TABLE IF EXISTS shorturl_hash;
CREATE TABLE shorturl_hash (
    id serial primary key,
    short int unsigned NOT null default 0,
    url text not null
) ;
DELIMITER //
CREATE TRIGGER shorturl_hash_ins BEFORE INSERT ON shorturl_hash FOR EACH ROW BEGIN
	SET NEW.short=crc32(NEW.url);
END;
//

CREATE TRIGGER shorturl_hash_upd BEFORE UPDATE ON shorturl_hash FOR EACH ROW BEGIN
	SET NEW.short=crc32(NEW.url);
END;
//
DELIMITER ;

INSERT INTO shorturl_hash (url) VALUES('http://jsguru.net');
CREATE INDEX ix_shorturl_hash_short ON shorturl_hash (short);

EXPLAIN SELECT * FROM headfirst.shorturl_hash where short = CRC32("http://jsguru.net") and url = "http://jsguru.net";
