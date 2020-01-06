# trap

---

http://stackoverflow.com/questions/360201/kill-background-process-when-shell-script-exit

---

有时候希望把部分命令放到后台执行。前台的停止时，后台也一起停下。
比如 `watch` 文件时。

网上找到了 `trap` 命令，在收到结束信号时执行一些操作。

```
trap 'trap - SIGTERM && kill 0' SIGINT SIGTERM EXIT
```

---

不过还是稍显麻烦，还可以利用 `wait`

```
$ command1& command2& wait
```

这样，前台结束时，后台也会一起结束。
