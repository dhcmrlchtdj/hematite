# screen permission

---

http://serverfault.com/questions/116775/sudo-as-different-user-and-running-screen

---

```
$ sudo -iu user2

$ screen
Cannot open your terminal '/dev/pts/0' - please check.

$ ll /dev/pts
crw--w---- 1 user1   tty  136, 0 Aug  3 21:55 0
c--------- 1 root    root   5, 2 Dec  9  2015 ptmx
```

切换用户之后，发现 `screen` 无法正常启动。
查了下，权限确实不对。

---

```
$ script /dev/null
Script started, file is /dev/null

$ ll /dev/pts
crw--w---- 1 user1   tty  136, 0 Aug  3 21:57 0
crw--w---- 1 user2   tty  136, 1 Aug  3 21:57 1
c--------- 1 root    root   5, 2 Dec  9  2015 ptmx

$ screen
```

网上搜到的方案，执行一下 `script`，然后就能正常使用 screen 了。
看了下 man 文档，还是没太搞懂 script 到底做啥的。
