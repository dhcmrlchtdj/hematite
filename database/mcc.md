# MariaDB Crash Course

-------------------------------------------------------------------------------

## 3

`SHOW DATABASES;`
`USE db_name`
`SHOW TABLES;`
`DESCRIBE tbl_name;` is alias to `SHOW COLUMNS FROM tbl_name;`

`SHOW STATUS;`
`SHOW CREATE DATABASE db_name;`
`SHOW CREATE TABLE tbl_name;`
`SHOW GRANTS;`
`SHOW ERRORS;`
`SHOW WARNINGS;`

and more `HELP SHOWS;`

-------------------------------------------------------------------------------

## 4

`SELECT col_name FROM tbl_name;`
`SELECT c1, c2 FROM tbl_name;`
`SELECT * FROM tbl_name;`

`SELECT DISTINCT col_name FROM tbl_name;`
-- distinct is applied to all columns.

`SELECT col_name FROM tbl_name LIMIT length;`
`SELECT col_name FROM tbl_name LIMIT start_position, length;`
-- mariadb count ROW from 0, just like in c.
-- if `start_position` is omitted, start from 0 by default.
`SELECT col_name FROM tbl_name LIMIT length OFFSET start_position;`
-- mariadb only.

`SELECT tbl_name.col_name FROM db_name.tbl_name;`

-------------------------------------------------------------------------------

## 5



















