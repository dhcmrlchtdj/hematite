# pg array / cte

---

https://tapoueh.org/blog/2018/04/postgresql-data-types-arrays/
https://www.postgresql.org/docs/current/arrays.html
https://www.postgresql.org/docs/current/functions-array.html
https://www.postgresql.org/docs/current/functions-comparisons.html
https://www.postgresql.org/docs/current/gin.html

---

> looping over arrays elements really is inefficient, so learn to use unnest()
> instead, and filter elements with a where clause.

`SELECT id FROM unnest(ARRAY[1,2]) as temp_table(id)`

可以把 array 转换成列，然后和其他 table 进行 join 操作

`CREATE INDEX ON table USING gin (hashtags);`

索引 array 可以用 gin

---

https://tapoueh.org/blog/2018/01/exporting-a-hierarchy-in-json-with-recursive-queries/
https://www.postgresql.org/docs/current/queries-with.html

---

我觉得 CTE 是最复杂的 SQL 之一，union 的部分比较绕

```sql
CREATE TABLE dndclasses (
    id         SERIAL PRIMARY KEY,
    parent_id  INT REFERENCES dndclasses(id),
    name       TEXT
);

-- step 1
SELECT id, name, '{}'::int[] AS parents, 0 AS level
FROM dndclasses
WHERE parent_id IS NULL;

-- step 2
WITH RECURSIVE
dndclasses_from_parents AS (
    SELECT id, name, '{}'::int[] AS parents, 0 AS level
    FROM dndclasses
    WHERE parent_id IS NULL

    UNION ALL

    -- `||` means concatenation
    SELECT c.id, c.name, p.parents || c.parent_id, p.level + 1
    FROM dndclasses_from_parents p
    JOIN dndclasses c ON c.parent_id = p.id
    WHERE NOT c.id = ANY(p.parents)
)
SELECT name, id, parents, level
FROM dndclasses_from_parents;
```
