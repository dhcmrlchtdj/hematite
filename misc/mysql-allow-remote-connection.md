# mysql connection

allow remote connect

```
$ vim my.cnf
bind-address = 0.0.0.0
```

---

https://wiki.archlinux.org/index.php/MySQL
https://stackoverflow.com/questions/1559955/host-xxx-xx-xxx-xxx-is-not-allowed-to-connect-to-this-mysql-server


```
$ # rm -rf /var/lib/mysql
$ mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql
$ systemctl start mysqld
...
[Note] A temporary password is generated for root@localhost: ??????

$ mysql -uroot -p?????

> ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';

> CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
> GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost' WITH GRANT OPTION;
> CREATE USER 'username'@'%' IDENTIFIED BY 'password';
> GRANT ALL PRIVILEGES ON *.* TO 'username'@'%' WITH GRANT OPTION;
> FLUSH PRIVILEGES;
```
