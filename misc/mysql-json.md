# mysql JSON

---

https://dev.mysql.com/doc/refman/5.7/en/json.html
https://dev.mysql.com/doc/refman/5.7/en/json-functions.html
https://hub.docker.com/_/mysql/

---

```
$ docker pull mysql
$ docker run \
    -p 3306:3306 \
    --name mysql-json \
    # -v /my/custom:/etc/mysql/conf.d \
    -e MYSQL_ROOT_PASSWORD=password \
    -d mysql:latest

$ docker exec -it mysql-json bash
$ docker logs mysql-json

$ docker rm mysql-json

$ mysql -h $(docker-machine ip <machine>) -u root -p


$ docker exec mysql-json sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```

---

JSON 本质还是字符串，但这个字符串要符合 JSON 要求。
感觉提供的 JSON 表达能力不强啊。

---

https://stackoverflow.com/questions/15534977/mysql-cannot-add-foreign-key-constraint

建索引出错的时候，可以执行 `SHOW ENGINE INNODB STATUS;`。
输出的 `LATEST FOREIGN KEY ERROR` 里有详细的错误信息。

---

```
$ docker exec mysql-json sh -c 'exec mysqldump --compact --skip-extended-insert -uUSER -pPASSWORD test <table1> <table2>'
```
