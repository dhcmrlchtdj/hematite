# milliseconds in bash

---

http://stackoverflow.com/questions/16548528/linux-command-to-get-time-in-milliseconds

---

```
$ date +%s
$ date +%s%3N
$ date +%s%N
```

`%N` 是精确到 nanoseconds
`%s%3N` 可以精确到 milliseconds

---

又要说一句，mac 的工具链，就是不如 linux 好用
