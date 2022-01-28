USE `jsguru-typeorm`;
/* ALLOW DROP TABLE THAT HAVE BEEN REFERENCED BY ANOTHER TABLE */
SET foreign_key_checks = 0;

DROP TABLE IF EXISTS `customer_sources`;
CREATE TABLE customer_sources(
	id BIGINT AUTO_INCREMENT,
    name VARCHAR(80) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY(id)
);

ALTER TABLE customer_sources
ADD CONSTRAINT uc_name UNIQUE(name);

DROP TABLE IF EXISTS `customers`;
CREATE TABLE customers(
	id BIGINT AUTO_INCREMENT,
    fullname VARCHAR(60) NOT NULL,
    dob DATE, /* date of birth */
    gender ENUM('female','male','unknown'),
    company VARCHAR(60),
    position VARCHAR(60),
    phone_number VARCHAR(20),
    email VARCHAR(80) NOT NULL,
    address VARCHAR(120),
    city VARCHAR(60),
    notes VARCHAR(255),
    source_id BIGINT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,    
    PRIMARY KEY(id)
);

ALTER TABLE customers
ADD CONSTRAINT customers_chk_dob
CHECK (
	CASE
		WHEN dob BETWEEN "1930-01-01" AND "2030-12-31" THEN 1
		ELSE 0
    END = 1
);

ALTER TABLE customers
ADD CONSTRAINT uc_email UNIQUE(email);

ALTER TABLE customers
ADD FOREIGN KEY(source_id) REFERENCES customer_sources(id)
ON UPDATE SET NULL
ON DELETE SET NULL;

SET foreign_key_checks = 1;

DROP TABLE IF EXISTS `events`;
CREATE TABLE events(
	id BIGINT AUTO_INCREMENT,
    name VARCHAR(80) NOT NULL,
    event_date DATE NOT NULL,
    image VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS `email_templates`;
CREATE TABLE email_templates(
	id BIGINT AUTO_INCREMENT,
    name VARCHAR(80) NOT NULL,
    template_id BIGINT NOT NULL, /* eg: 3530164 */
    variables TINYTEXT NOT NULL, /* json stringify this content */
    description VARCHAR(120) NOT NULL,
    PRIMARY KEY(id)
);


