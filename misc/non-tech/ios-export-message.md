# ios export message

https://www.zhihu.com/question/21184025
https://stackoverflow.com/questions/75675/how-do-i-dump-the-data-of-some-sqlite3-tables

---

- 在 mac 上用 itunes 备份手机
- 找到 `~/Library/Application Support/MobileSync/Backup/XXXX/3d/3d0dXXXX`
- 一个 sqlite 数据库，短信都在里面

```
.mode csv
.headers on
.out sms
select text from message where is_from_me=0;
```
