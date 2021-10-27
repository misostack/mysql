# MYSQL CHEATSHEET

> Version: 8.0

## Command lines

## Datatypes

1. String
2. Numeric
3. Date and Time

- https://www.w3schools.com/MySQL/mysql_datatypes.asp

## Ref

- https://www.mysqltutorial.org/mysql-cheat-sheet.aspx
- https://www.guru99.com/sql.html
- https://www.w3schools.com/MySQL/default.asp
- https://dev.mysql.com/doc/refman/8.0/en/optimization.html
- https://www.javatpoint.com/mysql-select-database

```sql
CREATE USER 'exporter'@'localhost' IDENTIFIED BY '12345678' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';
cd monitoring
.\mysqld_exporter.exe --config.my-cnf .\.my.cnf

.\prometheus.exe --config.file .\prometheus.yml --web.listen-address="0.0.0.0:9105"
```

```yml
# config file for monitoring MySQL via mysqld_exporter on localhost
global:
  scrape_interval: 5s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 5s # Evaluate rules every 15 seconds. The default is every 1 minute.

scrape_configs:
  - job_name: "mysql-monitor"
    static_configs:
      - targets: ["localhost:9104"]
        labels:
          alias: db1
```
