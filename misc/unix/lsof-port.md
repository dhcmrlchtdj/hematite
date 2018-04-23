# lsof port

---

查看谁在使用端口

```
$ lsof -i :8000
```

---

`-s p:s` 可以进行状态的筛选

```
p = TCP | UDP
s = Unbound | Idle
s = LISTEN | ESTABLISHED | IDLE | CLOSED | ...
```

```
$ lsof -i :80 -s TCP:LISTEN
```

---

只需要进程 id 的时候，可以加上 `-t`

```
$ lsof -i :80 -s TCP:LISTEN -t
```
