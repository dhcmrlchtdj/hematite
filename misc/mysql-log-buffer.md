# mysql innodb log buffer

---

http://dba.stackexchange.com/questions/12611/is-it-safe-to-use-innodb-flush-log-at-trx-commit-2

看其他人吹水，也能遇到一些奇怪的知识……

---

安全第一就

```
[mysqld]
innodb_flush_log_at_trx_commit=1
sync_binlog=1
```

如果能接受意外时丢失 1s 的数据，
可以把 `innodb_flush_log_at_trx_commit` 改成 0 或 2
