# mongodb auth

---

https://docs.mongodb.com/v2.6/core/authorization/
https://medium.com/@matteocontrini/how-to-setup-auth-in-mongodb-3-0-properly-86b60aeef7e8

---

- 在 mongodb 下开启 auth 的过程
- 为什么在说 2.6？没运维帮忙管理机器啊……

---

先创建好账号，验证下能否使用

```
$ mongo 192.168.0.5:9999/foo

> use admin
> db.createUser({ user: "ADMIN_USER", pwd: "PASSWORD", roles: [{ role: "userAdminAnyDatabase", db: "admin" }] })
> db.auth("ADMIN_USER", "PASSWORD")
> db.getUsers()

> use foo
> db.createUser({ user: "DB_USER", pwd: "PASSWORD", roles: [{ role: "dbOwner", db: "foo" }] })
> db.auth("DB_USER", "PASSWORD")
> show collections
> db.getUsers()

> exit

$ mongo --username=DB_USER --password=PASSWORD 192.168.0.5:9999/foo
```

---

开启服务端的验证

```
$ cat /etc/mongod.conf
...
security:
    #authorization: "enabled"
    keyFile: "/path/to/keyfile"
    clusterAuthMode: "keyFile"
...

$ systemctl restart mongodb.service
```

- `security.authorization` is available only for mongod
- `security.keyFile` implies `security.authorization`

开集群的话，必须上 keyFile。
