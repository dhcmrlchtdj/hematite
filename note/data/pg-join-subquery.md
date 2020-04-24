#postgresql

https://www.percona.com/blog/2020/04/16/sql-optimizations-in-postgresql-in-vs-exists-vs-any-all-vs-join/

> PostgreSQL is smart enough to produce the same execution plan for all four options

有点震惊，这样都能分析出来吗

> So the IN clause works great if the sub-plan selects a fewer number of rows.
> The same happens even if the subquery returns a few hundred rows.

数据量不大的时候，用 subquery 也能获得很好的性能
什么叫数据量大不呢，大概百来行。具体还是看 explain 输出吧
需要注意的是，数据可能会随时间增加。这么看还是 join 稳妥

> Avoid thinking from “How to break the logic” into subqueries.
> Never assume that the query is performing well with a small amount of data in the table.
> Use an EXPLAIN plan to understand what is going on in the background.
> In general, EXISTS and direct JOIN of tables often results in good results
> It is worth investing time in rewriting queries for better optimization.

作者其实也更推荐 join
