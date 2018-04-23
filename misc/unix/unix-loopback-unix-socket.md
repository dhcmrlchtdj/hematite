# unix socket vs loopback

---

https://lists.freebsd.org/pipermail/freebsd-performance/2005-February/001143.html

---

## Unix domain socket

速度更快
是个文件，可以利用 unix 的文件权限

---

## loopback

虽然是本地，但还是要走一次 TCP 协议
更通用，可移植
