# pg sort order

https://dba.stackexchange.com/questions/94887/what-is-the-impact-of-lc-ctype-on-a-postgresql-database/94972#94972
https://www.postgresql.org/docs/current/locale.html
https://simply.name/pg-lc-collate.html

---

在 heroku 上发现 pg 的 order by 输出不符合预期，调查了一下

---

场景描述

```
CREATE TABLE urls (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    url TEXT NOT NULL UNIQUE
);

INSERT INTO urls(url) VALUES ('http://a'),('https://'),('http://z');

SELECT * FROM urls ORDER BY url;
```

上面 select 的预期输出应该是 `http://a , http://z, https://`
但在 heroku 上的输出是 `http://a, https://, http://z`

反复测试后发现，应该是 `://` 在排序时被忽略了，但直接 `select 'http://s' = 'https://'` 又不成立，搞不懂

为了得到预期输出，需要加上 collate，变成 `SELECT * FROM urls ORDER BY url COLLATE "C"`

---

> If you want the system to behave as if it had no locale support, use the special locale name C, or equivalently POSIX.
> The drawback of using locales other than C or POSIX in PostgreSQL is its performance impact.

其实没有特殊的需求，collate 用 C 应该是最符合预期的，直接比价 byte。

---

`show all` 可以看到 heroku 上的 lc_collate 是 `en_US.UTF-8`

`SELECT name, setting FROM pg_settings WHERE category ~ 'Locale'` 可以查到更多相关配置

虽然在 mac 上测不出来，但是在 linux 下可以观察到和 PG 相同的行为（或者说，本来就是 PG 在 linux 上的行为

```
$ echo 'http://a\nhttp://z\nhttp://s\nhttps://' > a

$ export LC_COLLATE="en_US.UTF-8"
$ cat a | sort
http://a
http://s
https://
http://z

$ export LC_COLLATE="C"
$ cat a | sort
http://a
http://s
http://z
https://
```

所以，`LC_COLLATE="en_US.UTF-8"` 到底是怎么回事…
