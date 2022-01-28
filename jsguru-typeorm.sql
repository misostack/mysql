USE `jsguru-typeorm`;
/* ALLOW DROP TABLE THAT HAVE BEEN REFERENCED BY ANOTHER TABLE */
SET foreign_key_checks = 0;

DROP TABLE IF EXISTS `customer_sources`;
CREATE TABLE customer_sources(
	id BIGINT AUTO_INCREMENT,
    name VARCHAR(80) NOT NULL,
    description VARCHAR(255),
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,        
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

DROP TABLE IF EXISTS `events`;
CREATE TABLE events(
	id BIGINT AUTO_INCREMENT,
    name VARCHAR(80) NOT NULL,
    event_date DATE NOT NULL,
    image VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,        
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS `email_templates`;
CREATE TABLE email_templates(
	id BIGINT AUTO_INCREMENT,
    name VARCHAR(80) NOT NULL,
    template_id BIGINT NOT NULL, /* eg: 3530164 */
    variables TINYTEXT NOT NULL, /* json stringify this content */
    description VARCHAR(120) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,        
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS `email_campaigns`;
CREATE TABLE email_campaigns(
	id BIGINT AUTO_INCREMENT,
    name VARCHAR(120) NOT NULL,
    target TEXT,
    event_id BIGINT NULL,
    email_template_id BIGINT NULL, /* eg: 3530164 */
    description VARCHAR(120) NOT NULL,
    sent BIGINT NOT NULL DEFAULT 0,
    opened BIGINT NOT NULL DEFAULT 0,
    clicked BIGINT NOT NULL DEFAULT 0,
    replied BIGINT NOT NULL DEFAULT 0,
    status ENUM('pending','inprogress','pause','cancel','done') NOT NULL DEFAULT 'pending',
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,        
    PRIMARY KEY(id)
);

ALTER TABLE email_campaigns
ADD FOREIGN KEY(email_template_id) REFERENCES email_templates(id)
ON UPDATE SET NULL
ON DELETE SET NULL;

ALTER TABLE email_campaigns
ADD FOREIGN KEY(event_id) REFERENCES events(id)
ON UPDATE SET NULL
ON DELETE SET NULL;

DROP TABLE IF EXISTS `email_campaign_contacts`;
CREATE TABLE email_campaign_contacts(
	id BIGINT AUTO_INCREMENT,
    email_campaign_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL, 
    PRIMARY KEY(id)
);

ALTER TABLE email_campaign_contacts
ADD FOREIGN KEY(email_campaign_id) REFERENCES email_campaigns(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE email_campaign_contacts
ADD FOREIGN KEY(customer_id) REFERENCES customers(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

DROP TABLE IF EXISTS `email_queue`;
CREATE TABLE email_queue(
	id BIGINT AUTO_INCREMENT,
    email_campaign_id BIGINT NOT NULL,
    email_campaign_contact_id BIGINT NOT NULL,
    status ENUM('pending', 'locked', 'queued', 'failed', 'done') NOT NULL DEFAULT 'pending',
    mail_service_message_id BIGINT NULL DEFAULT 0,
    mail_service_message_status VARCHAR(20) NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,    
    PRIMARY KEY(id)
);

ALTER TABLE email_queue
ADD CONSTRAINT uc_email_campaign_email_campaign_contact UNIQUE(email_campaign_id, email_campaign_contact_id);

ALTER TABLE email_queue
ADD FOREIGN KEY(email_campaign_id) REFERENCES email_campaigns(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE email_queue
ADD FOREIGN KEY(email_campaign_contact_id) REFERENCES email_campaign_contacts(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

/*  ENABLE CHECK CONSTAINTS */
SET foreign_key_checks = 1;

