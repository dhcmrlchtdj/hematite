# bbr

---

首先加载 BBR 模块

```
$ cat /proc/sys/net/ipv4/tcp_available_congestion_control
cubic reno

$ sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = cubic reno

$ modprobe tcp_bbr

$ sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = bbr cubic reno
```

然后启用 BBR

```
$ sysctl net.ipv4.tcp_congestion_control
net.ipv4.tcp_congestion_control = cubic

$ sysctl net.ipv4.tcp_congestion_control=bbr

$ sysctl net.ipv4.tcp_congestion_control
net.ipv4.tcp_congestion_control = bbr
```

最后可以把 BBR 设置加入 sysctl.d

```
$ echo "net.ipv4.tcp_congestion_control = bbr" | tee -a /etc/sysctl.d/66-bbr.conf
```

---

搜了下，很多人都说可以加上另一个设置

```
$ sysctl net.core.default_qdisc
net.core.default_qdisc = fq_codel

$ sysctl net.core.default_qdisc=fq
```

https://www.bufferbloat.net/projects/codel/wiki/

然后搜到上面这个

> For servers with tcp-heavy workloads, particularly at 10GigE speeds ...
> net.core.default_qdisc = fq_codel - best general purpose qdisc
> net.core.default_qdisc = fq - for fat servers, fq_codel for routers.

大概是说，超过 10GigE 才应该选择 fq？
