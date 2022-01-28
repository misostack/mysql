SELECT
       CONSTRAINT_NAME,
       TABLE_SCHEMA,
       TABLE_NAME,
       CONSTRAINT_TYPE
       FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
       WHERE TABLE_NAME = 'phpguru_users';

SHOW INDEX FROM `phpguru_users`;
SHOW COLUMNS FROM `phpguru_users`;
SHOW CREATE TABLE `phpguru_users`;
SHOW TABLES;
USE `phpguru-headfirst`;
SELECT
  TABLE_NAME AS `Table`,
  TABLE_SCHEMA,
  ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024) AS `Size (MB)`
FROM
  information_schema.TABLES
WHERE TABLE_SCHEMA = 'phpguru-headfirst'
ORDER BY
  (DATA_LENGTH + INDEX_LENGTH)
DESC;