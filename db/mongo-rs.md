# mongo replication

---

https://docs.mongodb.com/v2.6/core/replication-introduction/

---

```
> rs.status()
"stateStr" : "(not reachable/healthy)"

$ mongod -f /opt/local/mongodb/conf/mongodb.conf
$ mongod -f /opt/local/moncfg/etc/moncfg.conf
$ mongos -f /opt/local/mongos/etc/mongos.conf

> rs.status()
"stateStr" : "RECOVERING"
```

---

```
SECONDARY
> use admin
> db.shutdownServer()
server should be down...


PRIMARY
> rs.config()
> rs.remove("<secondary host>")

SECONDARY
$ rm -rfv <mongo-db-path>
$ mongod -f /opt/local/mongodb/conf/mongodb.conf
$ mongod -f /opt/local/moncfg/etc/moncfg.conf
$ mongos -f /opt/local/mongos/etc/mongos.conf


PRIMARY
> rs.add("<secondary host>")
> rs.config()
```
