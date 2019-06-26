# tcpdump

---

一些简单的组合，具体的看 manpage 吧

```
$ tcpdump src host <ip>
$ tcpdump not src host <ip>
$ tcpdump dst host <ip>
$ tcpdump not src host <ip1> and not dst host <ip>

$ tcpdump not port <port>

$ tcpdump not tcp and not udp
$ tcpdump tcp
```
