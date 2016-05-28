# tmpfs

---

https://wiki.archlinux.org/index.php/Tmpfs

---

systemctl 默认会挂载 /tmp，大小是内存的一半。
如果不够用了，可以手动改大一些。

```
$ mount -o remount,noatime,size=1G /tmp
```
