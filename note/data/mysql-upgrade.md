# mysql upgrade

https://stackoverflow.com/questions/49992868/mysql-errorthe-user-specified-as-a-definer-mysql-infoschemalocalhost-doe

---

```
The user specified as a definer ('mysql.infoschema'@'localhost') does not exist' when trying to dump tablespaces
```

升级到 mysql8 的时候遇到了这个问题。
平常滚习惯了，没注意，结果服务挂了。

需要 `mysql_upgrade -u root -p` 一下
