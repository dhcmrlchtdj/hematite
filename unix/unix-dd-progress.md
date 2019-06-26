# dd progress

---

https://www.raspberrypi.org/documentation/installation/installing-images/mac.md

---

`dd` 的时候，如果想要查看进度的话，
可以用 `Ctrl + T` 发送一个 `SIGINFO` 给进程。

```
$ dd if=/dev/urandom of=/dev/null
# ^T
load: 1.27  cmd: dd 83572 running 0.00u 1.52s
41460+0 records in
41460+0 records out
21227520 bytes transferred in 1.535250 secs (13826752 bytes/sec)
```
