======================
 MariaDB Crash Course
======================

basic
======

.. code-block:: sql

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

-------------------------------------------------------------------------------

limit
======

.. code-block:: sql

    SELECT col_name FROM tbl_name;
    SELECT c1, c2 FROM tbl_name;
    SELECT * FROM tbl_name;

    SELECT DISTINCT col_name FROM tbl_name;

**caution**: distinct is applied to **all** columns.

.. code-block:: sql

    SELECT col_name FROM tbl_name LIMIT length;
    SELECT col_name FROM tbl_name LIMIT start_position, length;

    -- mariadb count ROW from 0, just like in c.
    -- if `start_position` is omitted, start from 0 by default.

    SELECT col_name FROM tbl_name LIMIT length OFFSET start_position;
    -- mariadb only.

    SELECT tbl_name.col_name FROM db_name.tbl_name;

-------------------------------------------------------------------------------

order by
=========

.. code-block:: sql

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

-------------------------------------------------------------------------------

where
======

.. code-block:: sql

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

-------------------------------------------------------------------------------

in
===

.. code-block:: sql

    SELECT col_name FROM tbl_name WHERE expr [op expr];

op can be :code:`AND` or :code:`OR`.

**caution**: use :code:`()` to combine expressions.
ops are short circuit operator.

+ :code:`IN`
+ :code:`NOT IN`
+ :code:`NOT BETWEEN`
+ :code:`NOT EXISTS`

-------------------------------------------------------------------------------

like
=====

.. code-block:: sql

    SELECT col_name FROM tbl_name WHERE col_name LIKE pattern;

+ :code:`%`, like :code:`.*` in regex. it will not match :code:`NULL`.
+ :code:`_`, like :code:`.` in regex.

-------------------------------------------------------------------------------

regexp
=======

.. code-block:: sql

    SELECT col_name FROM tbl_name WHERE col_name REGEXP pattern;

**caution**: :code:`LIKE` match whole string.
:code:`REGEXP` search pattern within string.
(add :code:`^$` to work as :code:`LIKE`.)

**caution**: :code:`REGEXP` is not case-sensitive by default.
use :code:`REGEXP BINARY` to force case-sensitive mode.

.. code-block:: sql

    SELECT col_name FROM tbl_name WHERE col_name REGEXP BINARY expr;

use :code:``\\`` to escape. :code:``\\\`` matched :code:``\``.

-------------------------------------------------------------------------------

as
===

use :code:`AS` rename column and table.

.. code-block:: sql

    SELECT col_name AS new_name FROM tbl_name;
    SELECT col_name FROM tbl_name AS new_name;

-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------

function
=========

+ :code:`AVG(column)`, :code:`NULL` will be ignore.
+ :code:`COUNT(column)`, :code:`NULL` will be ignore if column is not :code:`*`.
+ :code:`MAX(column)`, :code:`NULL` will be ignore.
+ :code:`MIN(column)`, :code:`NULL` will be ignore.
+ :code:`SUM(column)`, :code:`NULL` will be ignore.

column can be :code:`DISTINCT col_name`.

-------------------------------------------------------------------------------

group by
=========

compare the two sql:

.. code-block:: sql

    SELECT col_name, COUNT(*) FROM tbl_name WHERE col_name='blahblah';
    SELECT col_name, COUNT(*) FROM tbl_name GROUP BY col_name;

**caution**: if :code:`GROUP BY` meet :code:`NULL`, :code:`NULL` will return as a group.

.. code-block:: sql

    SELECT col_name, COUNT(*) FROM tbl_name GROUP BY col_name WITH ROLLUP;

:code:`WITH ROLLUP` will list all rows in a group.

.. code-block:: sql

    SELECT col_name, COUNT(*) FROM tbl_name GROUP BY col_name HAVING expr;

:code:`HAVING` work as :code:`WHERE`, but apply to group.


**caution**: order of a :code:`SELECT` clause is

.. code-block:: sql

    SELECT . FROM . [WHERE .] [GROUP BY . [HAVING .]] [ORDER BY .] [LIMIT .]

-------------------------------------------------------------------------------

subquery
=========

.. code-block:: sql

    SELECT col_name FROM tbl_name WHERE col IN (SELECT clause);
    SELECT col_name, (SELECT clause) FROM tbl_name;

-------------------------------------------------------------------------------

on
===

:code:`ON` is same as :code:`WHERE`.

-------------------------------------------------------------------------------

join
=====

**caution**: it is not case-sensitive while use :code:`AS` to alias table.

self join
----------

.. code-block:: sql

    WHERE expr AND expr

inner join
-----------

.. code-block:: sql

    FROM t1 INNER JOIN t2
    FROM t1, t2

outer join
-----------

.. code-block:: sql

    FROM t1 LEFT OUTER JOIN t2
    FROM t1 RIGHT OUTER JOIN t2
    -- is same as
    FROM t2 LEFT OUTER JOIN t1


inner join is intersection of t1 and t2.

outer join is whole t1, plus intersection part of t2.

-------------------------------------------------------------------------------

union
======

.. code-block:: sql

    SELECT col_name FROM tbl_name WHERE expr_1
    UNION
    SELECT col_name FROM tbl_name WHERE expr_2;

+ can union many select clause at the same time.
+ each select clause must have same columns. order can be different.

**caution**: :code:`UNION` remove duplicate row by default.
:code:`UNION ALL` do not eliminate duplicates.

**caution**: :code:`ORDER BY` after last select clause will be apply to all result.

-------------------------------------------------------------------------------

full text search
=================

.. code-block:: sql

    CREATE TABLE example (
        note TEXT NOT NULL,
        FILLTEXT (note)
    ) ENGINE=Maria;


**caution**: don't enable FULLTEXT while import data to new table.
it will take some times to do it. you can enable FULLTEXT after data imported.

.. code-block:: sql

    SELECT col_name FROM tbl_name WHERE MATCH(note) AGAINST('pattern');

use :code:`MATCH()` to specify colums to be searched.
use :code:`AGAINST()` to specify the search expression to be used.

-------------------------------------------------------------------------------

insert
=======

.. code-block:: sql

    INSERT INTO tbl_name (col_name) VALUES (value);
    INSERT INTO tbl_name (col_name) VALUES (val1), (val2), (val3);

use :code:`LOW_PRIORITY` to set priority for
:code:`INSERT`, :code:`UPDATE`, :code:`DELETE`.

.. code-block:: sql

    INSERT LOW_PRIORITY INSERT

insert query result.

.. code-block:: sql

    INSERT INTO tbl_name (col_name) SELECT column FROM other_table;

**caution**: mariadb use postion but not colums' name to insert value.

-------------------------------------------------------------------------------

update and delete
==================

update
-------

.. code-block:: sql

    UPDATE tbl_name SET col_name = 'blahblah' WHERE expr;

**caution**: don't forget :code:`WHERE` clause.
without :code:`WHERE`, it will update every row in table.

use subquery in update clause.

.. code-block:: sql

    UPDATE tbl_name SET col_name = (SELECT clause) WHERE expr;

use :code:`IGNORE` to ignore error.

.. code-block:: sql

    UPDATE IGNORE tbl_name SET col_name = 'blahblah' WHERE expr;

delete
-------

.. code-block:: sql

    DELETE FROM tbl_name WHERE expr;

**caution**: don't forget :code:`WHERE` clause,
or it will delete all rows in table.
use :code:`TRUNCATE TABLE` clause to delete data in table, it is more quickly.

+ don't omit :code:`WHERE` clause.
+ use primary key in :code:`WHERE` clause.
+ there is **no** undo, be careful.

-------------------------------------------------------------------------------

create and manipulate table
============================

.. code-block:: sql

   create table


