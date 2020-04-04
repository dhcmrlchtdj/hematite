# Use The Index, Luke

https://use-the-index-luke.com/

---

## Concatenated Keys

> Note that the column order of a concatenated index has great impact on its usability so it must be chosen carefully.
> The most important consideration when defining a concatenated index is how to choose the column order so it can be used as often as possible.

> The database does not use the index because it cannot use single columns from a concatenated index arbitrarily.

> That means that a two-column index does not support searching on the second column alone;
> We can take advantage of the fact that the first index column is always usable for searching.

有 `INDEX(a, b, c)`，就不需要 `INDEX(a)` 和 `INDEX(a,b)` 了。
但不能代替 `INDEX(b)`

---

## Bind Variables

> Not using bind parameters is like recompiling a program every time.

> When using bind parameters, the optimizer has no concrete values available to determine their frequency.
> It then just assumes an equal distribution and always gets the same row count estimates and cost values.
> In the end, it will always select the same execution plan.

> you should always use bind parameters except for values that shall influence the execution plan.

---

## Greater, Less and BETWEEN

> Rule of thumb: index for equality first—then for ranges.

## Indexing SQL LIKE Filters

> Only the part before the first wild card serves as an access predicate.
> Avoid LIKE expressions with leading wildcards (e.g., '%TERM').

索引可以处理部分 LIKE 语句。
比如 `LIKE 'WIN%D'` 可以通过 `>= 'WIN'` 且 `<= 'WIO'` 缩小查找范围。

> Most databases just assume that there is no leading wild card when optimizing a LIKE condition with bind parameter
> PostgreSQL assumes there is a leading wild card when using bind parameters for a LIKE expression

这个 LIKE 优化，在处理变量的时候，根据数据库不同会有不同处理方式。

---

## Date Types

> It is a perfectly valid and correct statement but it cannot properly make use of an index on SALE_DATE

`WHERE TRUNC(sale_date) = TRUNC(sysdate - INTERVAL '1' DAY)` 加索引 `TRUNC(sale_date)`
`WHERE DATE_FORMAT(sale_date, "%Y-%M") = DATE_FORMAT(now(), "%Y-%M")` 改成 `WHERE sale_date BETWEEN quarter_begin(?) AND quarter_end(?)`
`WHERE TO_CHAR(sale_date, 'YYYY-MM-DD') = '1970-01-01'` 改成 `WHERE sale_date = TO_DATE('1970-01-01', 'YYYY-MM-DD')`

## Smart Logic

> databases are optimized for dynamic SQL—so use it if you need it.

> The most reliable method for arriving at the best execution plan is to avoid unnecessary filters in the SQL statement.

---

## Sorting and Grouping

> SQL queries with an order by clause do not need to sort the result explicitly
> if the relevant index already delivers the rows in the required order.
> That means the same index that is used for the where clause must also cover the order by clause.

> When using mixed ASC and DESC modifiers in the order by clause,
> you must define the index likewise in order to use it for a pipelined order by.

> SQL databases use two entirely different group by algorithms.
> the hash algorithm (buffer the aggregated result)
> the sort/group algorithm (materializes the complete input set)
>  the hash algorithm needs less memory

---

## Selecting Top-N Rows

> The database can only optimize a query for a partial result if it knows this from the beginning.

> For efficient execution, the ranking must be done with a pipelined order by.
> a pipelined top-N query does not depend on the table size

## Fetching The Next Page

> main advantage of offset method is that it is very easy to handle
> This has two disadvantages:
> (1) the pages drift when inserting new sales because the numbering is always done from scratch;
> (2) the response time increases when browsing further back.

> The seek method avoids both problems because it uses the values of the previous page as a delimiter.
> You not only have to phrase the where clause very carefully—you also cannot fetch arbitrary pages.

## Window-Functions

> Window functions offer yet another way to implement pagination in SQL

用 `ROW_NUMBER` 实现

---

## Insert

> To optimize insert performance, it is very important to keep the number of indexes small.

## Delete

> the delete statement works like a select that is followed by an extra step to delete the identified rows.

> PostgreSQL's delete performance therefore does not depend on the number of indexes on the table.
> The physical deletion of the table row and the related index maintenance is carried out only during the VACUUM process.
