# tmpfs

---

https://www.kernel.org/doc/Documentation/filesystems/tmpfs.txt
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

---

偶然发现文档

> Tmpfs is a file system which keeps all files in virtual memory.

> Everything in tmpfs is temporary in the sense that no files will be
> created on your hard drive.

tmpfs 其实是映射在内存里的，这也就是为什么 arch 下面默认大小为内存的一般吧。
