# MariaDB Crash Course

-------------------------------------------------------------------------------

## 3. basic

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

## 4. limit

`SELECT col_name FROM tbl_name;`
`SELECT c1, c2 FROM tbl_name;`
`SELECT * FROM tbl_name;`

`SELECT DISTINCT col_name FROM tbl_name;`

**caution**: distinct is applied to **all** columns.

`SELECT col_name FROM tbl_name LIMIT length;`
`SELECT col_name FROM tbl_name LIMIT start_position, length;`
-- mariadb count ROW from 0, just like in c.
-- if `start_position` is omitted, start from 0 by default.
`SELECT col_name FROM tbl_name LIMIT length OFFSET start_position;`
-- mariadb only.

`SELECT tbl_name.col_name FROM db_name.tbl_name;`

-------------------------------------------------------------------------------

## 5. order by

`SELECT col_name FROM tbl_name ORDER BY col_name;`
`SELECT c1, c2 FROM tbl_name ORDER BY c1, c2;`

`SELECT c1, c2, c3, c4 FROM tbl_name ORDER BY 3, 1;`
is shortcut for
`SELECT c1, c2, c3, c4 FROM tbl_name ORDER BY c3, c1;`


`SELECT col_name FROM tbl_name ORDER BY col_name DESC;`
`SELECT c1, c2 FROM tbl_name ORDER BY c2 DESC, c1;`
-- DESC is applied to **one** column.
-- AES is default.

**caution**: the postion of `ORDER BY` and `LIMIT`.

-------------------------------------------------------------------------------

## 6. where

`SELECT col_name FROM tbl_name WHERE expr;`

+ `=`
+ `<>`, `!=`
+ `<`
+ `<=`
+ `>`
+ `>=`
+ `BETWEEN val1 AND val2`
+ `IS NULL`

use `IS NULL` to detect `NULL`.
any other operators applied to `NULL` just return `NULL`.

-------------------------------------------------------------------------------

## 7. in


`SELECT col_name FROM tbl_name WHERE expr [op expr];`

op can be `AND` or `OR`.

**caution**: use `()` to combine expressions.
there ops are short circuit operator.

+ `IN`
+ `NOT IN`
+ `NOT BETWEEN`
+ `NOT EXISTS`

-------------------------------------------------------------------------------

## 8. like

`SELECT col_name FROM tbl_name WHERE col_name LIKE pattern;`

+ `%`, like `.*` in regex. it will not match `NULL`.
+ `_`, like `.` in regex.

-------------------------------------------------------------------------------

## 9. regexp

`SELECT col_name FROM tbl_name WHERE col_name REGEXP pattern;`

**caution**: `LIKE` match whole string.
`REGEXP` search pattern within string. (add `^$` to work as `LIKE`.)

**caution**: `REGEXP` is not case-sensitive by default.
use `REGEXP BINARY` to force case-sensitive mode.
`SELECT col_name FROM tbl_name WHERE col_name REGEXP BINARY expr;`

use `\\` to escape.`\\\` matched '\'.

-------------------------------------------------------------------------------

## 10. concat

use `Concat()` to concat values (columns or other literal).

use `Trim()`, `LTrim()`, `RTrim()` to remove space.

use `AS` rename column.

`SELECT col_name AS new_name FROM tbl_name;`

-------------------------------------------------------------------------------

## 11. function

### text

+ `Left(text, length)`
+ `Right(text, length)`

+ `Length(text)`

+ `SubString(text, start_position[, length])`
+ `Locate(pattern, text)`

+ `Upper(text)`
+ `Lower(text)`

+ `LTrim(text)`
+ `RTrim(text)`

+ `Soundex(text)`


### date and time

+ `CurDate()`
+ `CurTime()`
+ `Now()`

+ `DateDiff(date, date)`

+ `Date(datetime)`
+ `Time(datetime)`
+ `Year(date)`
+ `Month(date)`
+ `Day(date)`
+ `Hour(time)`
+ `Minute(time)`
+ `Second(time)`

+ `DayOfWeek(datetime)`

+ `AddDate(date, date)`
+ `AddTime(time, time)`
+ `Date_Add()`

+ `Date_Format(datetime, format)`


### numeric

+ `Pi()`
+ `Rand([seek])`

+ `Abs(n)`
+ `Sqrt(n)`
+ `Exp(n)`
+ `Mod(n,n)`

+ `Cos(n)`
+ `Sin(n)`
+ `Tan(n)`

-------------------------------------------------------------------------------

## 12. function

+ `AVG(column)`, `NULL` will be ignore.
+ `COUNT(column)`, `NULL` will be ignore if column is not `*`.
+ `MAX(column)`, `NULL` will be ignore.
+ `MIN(column)`, `NULL` will be ignore.
+ `SUM(column)`, `NULL` will be ignore.

column can be `DISTINCT col_name`.

-------------------------------------------------------------------------------

## 13. group by

compare the two sql:

+ `SELECT col_name, COUNT(*) FROM tbl_name WHERE col_name='blahblah';`
+ `SELECT col_name, COUNT(*) FROM tbl_name GROUP BY col_name;`

**caution**: if `GROUP BY` meet `NULL`, `NULL` will return as a group.

+ `SELECT col_name, COUNT(*) FROM tbl_name GROUP BY col_name WITH ROLLUP;`

`WITH ROLLUP` will list all rows in a group.

+ `SELECT col_name, COUNT(*) FROM tbl_name GROUP BY col_name HAVING expr;`

`HAVING` work as `WHERE`, but apply to group.


**caution**: order of a `SELECT` clause is
    `SELECT . FROM . [WHERE .] [GROUP BY . [HAVING .]] [ORDER BY .] [LIMIT .]`

-------------------------------------------------------------------------------

## 14. subquery

`SELECT col_name FROM tbl_name WHERE col IN (SELECT clause)`;
`SELECT col_name, (SELECT clause) FROM tbl_name;`

-------------------------------------------------------------------------------

## 15. on

`ON` is same as `WHERE`.

-------------------------------------------------------------------------------

## 16. join

**caution**: it is not case-sensitive while use `AS` to alias table.

+ self join
    `WHERE expr AND expr`

+ inner join
    `FROM t1 INNER JOIN t2`
    `FROM t1, t2`

+ outer join
    `FROM t1 LEFT OUTER JOIN t2`
    `FROM t1 RIGHT OUTER JOIN t2` is same as `FROM t2 LEFT OUTER JOIN t1`

inner join is intersection of t1 and t2.

outer join is whole t1, plus intersection part of t2.

-------------------------------------------------------------------------------

## 17. union

```
SELECT col_name FROM tbl_name WHERE expr_1
UNION
SELECT col_name FROM tbl_name WHERE expr_2;
```

+ can union many select clause at the same time.
+ each select clause must have same columns. order can be different.

**caution**: `UNION` remove duplicate row by default.
    `UNION ALL` do not eliminate duplicates.

**caution**: `ORDER BY` after last select clause will be apply to all result.

-------------------------------------------------------------------------------

## 18. full text search

```
CREATE TABLE example (
    note TEXT NOT NULL,
    FILLTEXT (note)
) ENGINE=Maria;
```

**caution**: don't enable FULLTEXT while import data to new table.
    it will take some times to do it.
    you can enable FULLTEXT after data imported.

```
SELECT col_name FROM tbl_name WHERE
MATCH(note) AGAINST('pattern');
```

use `MATCH()` to specify colums to be searched.
use `AGAINST()` to specify the search expression to be used.

-------------------------------------------------------------------------------






