# tmpfs

---

https://wiki.archlinux.org/index.php/Tmpfs

---

systemctl 默认会挂载 /tmp，大小是内存的一半。
如果不够用了，可以手动改大一些。

```
$ mount -o remount,noatime,size=1G /tmp
```

---

/etc/fstab 里面没有，还是可以用下面的命令查看 /tmp 挂载时的设置

```
$ findmnt --target /tmp
```
