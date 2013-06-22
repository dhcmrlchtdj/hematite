======================
 MariaDB Crash Course
======================

basic
======

.. code:: sql

    SHOW DATABASES;
    USE db_name
    SHOW TABLES;
    DESCRIBE tbl_name;
    SHOW COLUMNS FROM tbl_name;

    SHOW STATUS;
    SHOW CREATE DATABASE db_name;
    SHOW CREATE TABLE tbl_name;
    SHOW GRANTS;
    SHOW ERRORS;
    SHOW WARNINGS;

and more :code:`HELP SHOWS;`


limit
======

.. code:: sql

    SELECT col_name FROM tbl_name;
    SELECT c1, c2 FROM tbl_name;
    SELECT * FROM tbl_name;

    SELECT DISTINCT col_name FROM tbl_name;

**caution**: distinct is applied to **all** columns.

.. code:: sql

    SELECT col_name FROM tbl_name LIMIT length;
    SELECT col_name FROM tbl_name LIMIT start_position, length;

    -- mariadb count ROW from 0, just like in c.
    -- if `start_position` is omitted, start from 0 by default.

    SELECT col_name FROM tbl_name LIMIT length OFFSET start_position;
    -- mariadb only.

    SELECT tbl_name.col_name FROM db_name.tbl_name;


order by
=========

.. code:: sql

    SELECT col_name FROM tbl_name ORDER BY col_name;
    SELECT c1, c2 FROM tbl_name ORDER BY c1, c2;

    SELECT c1, c2, c3, c4 FROM tbl_name ORDER BY 3, 1;
    -- is shortcut for
    SELECT c1, c2, c3, c4 FROM tbl_name ORDER BY c3, c1;


    SELECT col_name FROM tbl_name ORDER BY col_name DESC;
    SELECT c1, c2 FROM tbl_name ORDER BY c2 DESC, c1;

+ DESC is applied to **one** column.
+ AES is default.

**caution**: the postion of :code:`ORDER BY` and :code:`LIMIT``.


where
======

.. code:: sql

    SELECT col_name FROM tbl_name WHERE expr;


+ :code:`=`
+ :code:`<>` or :code:`!=`
+ :code:`<`
+ :code:`<=`
+ :code:`>`
+ :code:`>=`
+ :code:`BETWEEN val1 AND val2`
+ :code:`IS NULL`

use :code:`IS NULL` to detect :code:`NULL`.
any other operators applied to :code:`NULL` just return :code:`NULL`.


in
===

.. code:: sql

    SELECT col_name FROM tbl_name WHERE expr [op expr];

op can be :code:`AND` or :code:`OR`.

**caution**: use :code:`()` to combine expressions.
ops are short circuit operator.

+ :code:`IN`
+ :code:`NOT IN`
+ :code:`NOT BETWEEN`
+ :code:`NOT EXISTS`


like
=====

.. code:: sql

    SELECT col_name FROM tbl_name WHERE col_name LIKE pattern;

+ :code:`%`, like :code:`.*` in regex. it will not match :code:`NULL`.
+ :code:`_`, like :code:`.` in regex.


regexp
=======

.. code:: sql

    SELECT col_name FROM tbl_name WHERE col_name REGEXP pattern;

**caution**: :code:`LIKE` match whole string.
:code:`REGEXP` search pattern within string.
(add :code:`^$` to work as :code:`LIKE`.)

**caution**: :code:`REGEXP` is case-insensitive by default.
use :code:`REGEXP BINARY` to force case-sensitive mode.

.. code:: sql

    SELECT col_name FROM tbl_name WHERE col_name REGEXP BINARY expr;

use :code:``\\`` to escape. :code:``\\\`` matched :code:``\``.


as
===

use :code:`AS` rename column and table.

.. code:: sql

    SELECT col_name AS new_name FROM tbl_name;
    SELECT col_name FROM tbl_name AS new_name;


function
=========

text
-----

+ :code:`Left(text, length)`
+ :code:`Right(text, length)`

+ :code:`Length(text)`

+ :code:`SubString(text, start_position[, length])`
+ :code:`Locate(pattern, text)`

+ :code:`Upper(text)`
+ :code:`Lower(text)`

+ :code:`LTrim(text)`
+ :code:`RTrim(text)`

+ :code:`Soundex(text)`

date and time
--------------

+ :code:`CurDate()`
+ :code:`CurTime()`
+ :code:`Now()`

+ :code:`DateDiff(date, date)`

+ :code:`Date(datetime)`
+ :code:`Time(datetime)`
+ :code:`Year(date)`
+ :code:`Month(date)`
+ :code:`Day(date)`
+ :code:`Hour(time)`
+ :code:`Minute(time)`
+ :code:`Second(time)`

+ :code:`DayOfWeek(datetime)`

+ :code:`AddDate(date, date)`
+ :code:`AddTime(time, time)`
+ :code:`Date_Add()`

+ :code:`Date_Format(datetime, format)`


numeric
--------

+ :code:`Pi()`
+ :code:`Rand([seek])`

+ :code:`Abs(n)`
+ :code:`Sqrt(n)`
+ :code:`Exp(n)`
+ :code:`Mod(n,n)`

+ :code:`Cos(n)`
+ :code:`Sin(n)`
+ :code:`Tan(n)`


function
=========

+ :code:`AVG(column)`, :code:`NULL` will be ignore.
+ :code:`COUNT(column)`, :code:`NULL` will be ignore if column is not :code:`*`.
+ :code:`MAX(column)`, :code:`NULL` will be ignore.
+ :code:`MIN(column)`, :code:`NULL` will be ignore.
+ :code:`SUM(column)`, :code:`NULL` will be ignore.

column can be :code:`DISTINCT col_name`.


group by
=========

compare the two sql:

.. code:: sql

    SELECT col_name, COUNT(*) FROM tbl_name WHERE col_name='blahblah';
    SELECT col_name, COUNT(*) FROM tbl_name GROUP BY col_name;

**caution**: if :code:`GROUP BY` meet :code:`NULL`, :code:`NULL` will return as a group.

.. code:: sql

    SELECT col_name, COUNT(*) FROM tbl_name GROUP BY col_name WITH ROLLUP;

:code:`WITH ROLLUP` will list all rows in a group.

.. code:: sql

    SELECT col_name, COUNT(*) FROM tbl_name GROUP BY col_name HAVING expr;

:code:`HAVING` work as :code:`WHERE`, but apply to group.


**caution**: order of a :code:`SELECT` clause is

.. code:: sql

    SELECT . FROM . [WHERE .] [GROUP BY . [HAVING .]] [ORDER BY .] [LIMIT .]


subquery
=========

.. code:: sql

    SELECT col_name FROM tbl_name WHERE col IN (SELECT clause);
    SELECT col_name, (SELECT clause) FROM tbl_name;


on
===

:code:`ON` is same as :code:`WHERE`.


join
=====

**caution**: it is case-insensitive while use :code:`AS` to alias table.

self join
----------

.. code:: sql

    WHERE expr AND expr

inner join
-----------

.. code:: sql

    FROM t1 INNER JOIN t2
    FROM t1, t2

outer join
-----------

.. code:: sql

    FROM t1 LEFT OUTER JOIN t2
    FROM t1 RIGHT OUTER JOIN t2
    -- is same as
    FROM t2 LEFT OUTER JOIN t1


inner join is intersection of t1 and t2.

outer join is whole t1, plus intersection part of t2.


union
======

.. code:: sql

    SELECT col_name FROM tbl_name WHERE expr_1
    UNION
    SELECT col_name FROM tbl_name WHERE expr_2;

+ can union many select clause at the same time.
+ each select clause must have same columns. order can be different.

**caution**: :code:`UNION` remove duplicate row by default.
:code:`UNION ALL` do not eliminate duplicates.

**caution**: :code:`ORDER BY` after last select clause will be apply to all result.


full text search
=================

.. code:: sql

    CREATE TABLE example (
        note TEXT NOT NULL,
        FILLTEXT (note)
    ) ENGINE=Maria;


**caution**: don't enable FULLTEXT while import data to new table.
it will take some times to do it. you can enable FULLTEXT after data imported.

.. code:: sql

    SELECT col_name FROM tbl_name WHERE MATCH(note) AGAINST('pattern');

use :code:`MATCH()` to specify colums to be searched.
use :code:`AGAINST()` to specify the search expression to be used.


insert
=======

.. code:: sql

    INSERT INTO tbl_name (col_name) VALUES (value);
    INSERT INTO tbl_name (col_name) VALUES (val1), (val2), (val3);

use :code:`LOW_PRIORITY` to set priority for
:code:`INSERT`, :code:`UPDATE`, :code:`DELETE`.

.. code:: sql

    INSERT LOW_PRIORITY INTO

insert data by query.

.. code:: sql

    INSERT INTO tbl_name (col_name) SELECT other_col FROM other_table;

**caution**: mariadb use postion but not name of colums in insert clause.


update and delete
==================

update
-------

.. code:: sql

    UPDATE tbl_name SET col_name = 'blahblah' WHERE expr;

**caution**: don't forget :code:`WHERE` clause.
without :code:`WHERE`, it will update every row in table.

use subquery in update clause.

.. code:: sql

    UPDATE tbl_name SET col_name = (SELECT clause) WHERE expr;

use :code:`IGNORE` to ignore error.

.. code:: sql

    UPDATE IGNORE tbl_name SET col_name = 'blahblah' WHERE expr;

delete
-------

.. code:: sql

    DELETE FROM tbl_name WHERE expr;

**caution**: don't forget :code:`WHERE` clause,
or it will delete all rows in table.
use :code:`TRUNCATE TABLE` clause to delete data in table, it is more quickly.

+ don't omit :code:`WHERE` clause.
+ use primary key in :code:`WHERE` clause.
+ there is **no** undo, be careful.


create and manipulate table
============================

create
-------

.. code:: sql

   CREATE TABLE tbl_name (
        key_example INT NOT NULL AUTO_INCREMENT,
        default_example INT NOT NULL DEFAULT 0,
        PRIMARY KEY (key_example)
   ) ENGINE=InnoDB;


:code:`SELECT last_insert_id()` return the last :code:`AUTO_INCREMENT` value.

it is not allowed to use functions in :code:`DEFAULT`.
only constants are supported.

**caution**: can't set foreign key between tables use different engine.


alter
------

**caution**: don't alter table contain data.

.. code:: sql

   ALTER TABLE tbl_name ADD col_define;
   ALTER TABLE tbl_name DROP COLUMN col_name;

   -- add foreign key
   ALTER TABLE tbl1 ADD CONSTRAINT fk_tbl1_tbl2
   FOREIGN KEY (col1) REDERENCES tbl2 (col2);


delete
-------

.. code:: sql

   DROP TABLE tbl_name;


rename
-------

.. code:: sql

    RENAME TABLE old_tbl_name TO new_tbl_name [, old2 TO new2];


view
=====

view is virtual table.
it doesn't contain any data but SQL query.
view can be used at any where table be used.

view cann't be indexed, nor have trigger or set associated.

.. code:: sql

   CREATE VIEW view_name AS
   SELECT col_name FROM tbl_name WHERE expr;

:code:`WHERE` clause while query a view will be combined with
:code:`WHERE` clause while create view.

view is a wrap to original tables.

.. code:: sql

   DROP VIEW view_name;
   -- there is no alter clause for view.
   -- just DROP and re CREATE, or REPLACE
   CREATE OR REPLACE view_name AS SELECT col_name FROM tbl_name WHERE expr;


stored procrdures
==================

stored procrdures collected statements for use.


create simple procedure
------------------------

.. code:: sql

   CREATE PROCEDURE proc_name()
   BEGIN
        SELECT col_name FROM tbl_name;
   END;

create procedure in cli, delimiter should be change temporary.
otherwise it conflict with delimiter of select clause.

.. code:: sql

   DELIMITER //
   CREATE PROCEDURE proc_name()
   BEGIN
        SELECT clause;
   END//
   DELIMITER ;

use this procedure by :code:`CALL proc_name();`.
it will return the columns be selected.


get data by variable
---------------------

if a procedure has many select clause, use variable to store result.

.. code:: sql

   CREATE PROCEDURE proc_with_var (
        OUT var_1 INT,
        OUT var_2 INT
   )
   BEGIN
        SELECT col_name INTO var_1 FROM tbl_name;
        SELECT col_name INTO var_2 FROM tbl_name;
   END;

use this procedure by

.. code:: sql

   CALL proc_with_var(@v1, @v2);
   SELECT @v1, @v2;

**caution**: variable must begin with :code:`@`


where clause in procedure
------------------------------

pass variable to procedure to filter data.

.. code:: sql

   CREATE PROCEDURE proc_name (
        IN v1 INT,
        OUT v2 INT
   )
   BEGIN
        SELECT col_name FROM tbl_name
        WHERE condition = v1
        INTO v2;
   END;

   -- then use this procedure

   CALL proc_name("blahblah", @result);
   SELECT @result;


logic in procedure
-------------------

.. code:: sql

   CREATE PROCEDURE proc (
        IN v1 BOOLEAN,
        OUT v2 INT
   ) COMMENT 'blahblah'
   BEGIN
        -- declare variable, initial by 0
        DECLARE v3 INT DEFAULT 0;

        -- ELSEIF and ELSE are supported
        IF v1 THEN
            SELECT col_name FROM tbl_name INTO v3;
        ENDIF;

        SELECT v3 INTO v2;
   END;

   CALL proc(true, @result);
   SELECT @result;


the statements in procedure can query by
:code:`SHOW CREATE PROCEDURE proc_name;`.

the :code:`COMMENT` will show in :code:`SHOW PROCEDURE STATUS;`.
and this command will show all procedures.
query only one procedure use :code:`SHOW PROCEDURE STATUS LIKE 'proc_name';`.


drop procedure
---------------

.. code:: sql

   DROP PROCEDURE proc_name;
   DROP PROCEDURE IF EXISTS proc_name;


cursor
=======

mariadb support cursor in stored procedure and functions only.

.. code:: sql

   CREATE PROCEDURE cursor_example()
   BEGIN
        -- declare variable must before other statements
        DECLARE var INT;

        -- create cursor
        DECLARE cur_name CURSOR
        FOR
        SELECT col_name FROM tbl_name;

        -- open cursor
        OPEN cur_name;

        -- fetch data
        FETCH cur_name INTO var;

        -- close cursor
        CLOSE cur_name;
   END;


trigger
========

a trigger is a group of statements that
is automatically executed when event occur.

**caution**: trigger are supported on table only, not view or temporary table.

.. code:: sql

   CREATE TRIGGER trigger_name
   AFTER INSERT
   ON tbl_name FOR EACH ROW
   BEGIN
        -- statements here
   END;

   -- event can be
   -- BEFORE or AFTER
   -- INSERT, UPDATE, DELETE

   DROP TRIGGER trigger_name;

**caution**: a trigger can be associated with only one event on one table.

**caution**: if a :code:`BRFORE` trigger fail,
the request(:code:`INSERT`, :code:`UPDATE`, :code:`DELETE`) will not execute.
and if request fail, :code:`AFTER` trigger will not execute.

trigger cann't be manipulate, just drop it and recreate.


within :code:`INSERT` trigger, there is a virtual table named :code:`NEW`.
it contains the row to be insert.

within :code:`DELETE` trigger, virtual table :code:`OLD` contains
the rows be deleted. it is read only.

within :code:`UPDATE`, :code:`NEW` contain new value,
:code:`OLD` contain old value.

**caution**: it is not supported to :code:`CALL` procedures in trigger.


transaction
============

.. code:: sql

   START TRANSACTION;
   -- some statements
   ROLLBACK;

   START TRANSACTION;
   -- some statements
   COMMIT;

:code:`ROLLBACK` work with :code:`INSERT`, :code:`UPDATE`, :code:`DELETE`,
but not :code:`CREATE` or :code:`DROP`.

set savepoint

.. code:: sql

   START TRANSACTION;
   SAVEPONIT point_name;
   -- some statements
   ROLLBACK TO point_name;

   -- SAVEPONIT will auto release after ROLLBACK or COMMIT
   -- and can be release by
   RELEASE SAVEPOINT point_name;

mariadb auto commit statements,
and can disable by :code:`SET AUTOCOMMIT=0;`.
then :code:`COMMIT` is required for every statements.


charset
========

.. code:: sql

   -- output all supported character sets
   SHOW CHARACTER SET;
   -- all supported collations
   -- %_cs => case sensitive
   -- %_ci => case insensitive
   SHOW COLLATION;

   -- character set and collation of server
   -- that can be overwrited by database, table, even column
   SHOW VARIABLES LIKE "character%";
   SHOW VARIABLES LIKE "collation%";

   -- set character set on create table
   CREATE TABLE tbl_name (
        col_name TEXT CHARACTER SET utf8 COLLATE utf8_general_ci
   )
   DEFAULT CHARACTER SET utf8
   COLLATE utf8_general_ci;

   -- COLLATE in SELECT clause
   SELECT * FROM tbl_name ORDER BY col_name COLLATE utf8_general_ci;
   -- also work with GROUP BY, HAVING, function, aliase and so on.


user
=====

.. code:: sql

   -- query users
   USE mysql;
   SELECT user FROM user;

   -- create user
   CREATE USER user_name IDENTIFIED BY "plain password";
   CREATE USER user_name IDENTIFIED BY PASSWORD "hashed password";
   -- it is not recommand to create user by
   -- insert row into user table or GRANT statement

   -- rename and delete
   RENAME USER old_name TO new_name;
   DROP USER user_name;

   -- change password
   SET PASSWORD FOR username = Password("new plain password");
   SET PASSWORD = Password("new plain password") -- for self


.. code:: sql

   -- query privilege
   SHOW GRANTS FOR user_name;
   -- GRANT USAGE ON *.* TO 'user_name'@'%'
   -- means no permission to do anything

   -- set privilege
   GRANT SELECT, INSERT ON db_name.tbl_name TO user_name;
   REVOKE SELECT ON db_name.tbl_name FROM user_name;


part of privileges

+ :code:`ALL`, all except :code:`GRANT OPTION`.
+ :code:`GRANT OPTION`, use of :code:`GRANT` and :code:`REVOKE`.
+ :code:`CREATE USER`,
  include :code:`CREATE USER`, :code:`DROP USER`,
  :code:`RENAME USER`, :code:`REVOKE ALL PRIVILEGE`.
+ :code:`CREATE`
+ :code:`CREATE TEMPORARY TABLES`
+ :code:`CREATE VIEW`
+ :code:`INDEX`, use of :code:`CREATE INDEX` and :code:`DROP INDEX`.
+ :code:`ALTER`
+ :code:`DROP`
+ :code:`INSERT`
+ :code:`SELECT`
+ :code:`UPDATE`
+ :code:`DELETE`
+ :code:`EXECUTE`, use of :code:`CALL`.
+ :code:`SHOW DATABASES`
+ :code:`SHOW VIEW`


maintenance
============

.. code:: sql

   ANALYZE TABLE tbl_name;
   CHECK TABLE tbl_name;


performance
============

+ use :code:`EXPLAIN` to analyze a `SELECT` statement.
+ stored procedure is quicker than individual statements.
+ not use :code:`SELECT *`.
+ when import data
  - turn off :code:`autocommit`.
  - drop index, re-create them after import has completed.
  - use :code:`ALTER TABLE` to temporary :code:`DISABLE KEYS`.
+ create index on columns that be used in where or order.
+ use :code:`UNION` instead of :code:`OR`.
+ :code:`FULLTEXT` is faster than :code:`LIKE`.


data type
==========

string
-------

+ ENUM
+ SET
+ CHAR
+ VARCHAR
+ TEXT
+ TINYTEXT
+ LONGTEXT
+ MEDIUMTEXT


numeric
--------

+ BIT
+ BOOLEAN(BOOL)
+ INT(INTEGER)
+ TINYINT
+ SMALLINT
+ MEDIUMINT
+ BIGINT
+ DECIMAL(DEC)
+ FLOAT
+ DOUBLE
+ REAL


datetime
---------

+ TIMESTAMP
+ DATETIME
+ DATE
+ TIME
+ YEAR


binary
-------

+ BLOB
+ TINYBLOB
+ MEDIUMBLOB
+ LONGBLOB
