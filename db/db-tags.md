# tags schema

---

http://tagging.pui.ch/post/37027745720/tags-database-schemas
http://tagging.pui.ch/post/37027745995/tags-with-mysql-fulltext

---

最近要开发一个系统，分类可能会变得会比较复杂，所以考虑用 tag 来做。
交集并集差集都是必要的。

感觉直接用 `item_id, tag_id` 这种关系表，查询起来会比较复杂。

---

## MySQLicious

- `id, item, tags`
- 直接存储 tag 数组
- 数据库支持数组的话，直接这样确实挺好的
- 不支持数组的话，用 LIKE 查询总觉得不太好，直接存储字符串也会有长度限制
- 作者写了另一篇，配合全文检索来实现

```sql
SELECT * FROM delicious WHERE MATCH (tags) AGAINST ('+search +webservice -search' IN BOOLEAN MODE)
```

## Scuttle

- `id, item`, `id, item_id, tag`
- 两者分开存储
- 查询起来需要用 `group by`，下面是个 `bookmark + webservice - semweb` 的例子

```sql
SELECT b. *
FROM scBookmarks b, scCategories c
WHERE b.bId = c.bId
AND (c.category IN ('bookmark', 'webservice'))
AND b.bId NOT IN (SELECT b.bId FROM scBookmarks b, scCategories c WHERE b.bId = c.bId AND c.category = 'semweb')
GROUP BY b.bId
HAVING COUNT( b.bId ) =2
```

## Toxi
- `id, item`, `id, tag`, `item_id, tag_id`
- 感觉就是逐步 normalized 了，查询上没有变得更方便啊

```sql
SELECT b.*
FROM tagmap bt, bookmark b, tag t
WHERE bt.tag_id = t.tag_id
AND (t.name IN ('bookmark', 'webservice', 'semweb'))
AND b.id = bt.bookmark_id
GROUP BY b.id
HAVING COUNT( b.id )=3
```

---

都是渣渣。
还是 postgresql 直接支持数组好。
