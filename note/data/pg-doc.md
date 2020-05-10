# postgresql 12 doc

---

> Constants that are not simple numeric values usually must be surrounded by
> single quotes (')

除了数字，其他都要用单引号包起来

---

> `WHERE` selects input rows before groups and aggregates are computed,
> whereas `HAVING` selects group rows after groups and aggregates are computed.

> `WHERE` is more efficient than adding the restriction to `HAVING`.

高效是因为，在聚合前过滤，需要处理的数据就减少了

---

`OVER` 非常实用
不过 `sum(salary) OVER (ORDER BY salary)` 和 `sum(salary) OVER ()` 的差异很怪异

---

之前对 inheritance 的理解不对，以为是独立的表，原来是在一张表里。
有点 tagged union 的感觉了。

---

> `RETURNING` obtain data from modified rows while they are being manipulated.
> The `INSERT`, `UPDATE`, and `DELETE` commands all have an optional `RETURNING`
> clause that supports this.

关键是这个 modified
之前在 `insert ... on conflict do nothing returing id` 踩过坑
如果 conflict 了，因为没有修改，所以没有返回数据

---

> The default value can be an expression, which will be evaluated whenever the
> default value is inserted (not when the table is created).

create table 时的 default 语句，是插入时执行的

---

> However, two null values are never considered equal in this comparison.
> That means even in the presence of a unique constraint it is possible to store
> duplicate rows that contain a null value in at least one of the constrained
> columns.

unique 可能因为 NULL 而重复

> PostgreSQL automatically creates a unique index when a unique constraint or
> primary key is defined for a table.

unique constraint 是需求（create table 时的 unique 描述
unique index 算实现细节（可以单独 create unique index，但没必要

---

> Adding a primary key will automatically create a unique B-tree index on the
> column or group of columns listed in the primary key, and will force the
> column(s) to be marked NOT NULL.

primary key 和 unique not null 差别其实不大

---

> Both of these types can store strings up to n characters (not bytes) in length.

char/varchar 的长度，是 character 不是 byte

> character(n) is usually the slowest of the three because of its additional
> storage costs.
> In most situations text or character varying should be used instead.

推荐使用 varchar 和 text

> Values of type character are physically padded with spaces to the specified
> width n, and are stored and displayed that way.
> trailing spaces are treated as semantically insignificant and disregarded when
> comparing two values of type character.

char 会忽略前后的空格

> trailing spaces are semantically significant in character varying and text values

varchar 和 text 不会忽略空格

> The storage requirement for a short string (up to 126 bytes) is 1 byte plus
> the actual string, which includes the space padding in the case of character.
> Longer strings have 4 bytes of overhead instead of 1.

存储时需要 1byte 或者 4byte 记录长度

---

> PostgreSQL can devise query plans which can leverage multiple CPUs in order to
> answer queries faster.

PG 支持 intra-query（虽然只有部分场景

---
