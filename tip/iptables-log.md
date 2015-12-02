# iptables log

---

+ https://wiki.archlinux.org/index.php/Iptables#Logging

---

```
$ iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j LOG --log-level debug # 增加日志
$ iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j DROP # 阻止 ping 请求

$ tail -f /var/log/kern.log # 查看日志
```

用上面的方法，就可以看到被阻止的包的日志。
不过有两个问题：一个是 `LOG` 和 `DROP` 的先后顺序不能乱，另外一个是性能有一些损失。

---

```
$ iptables -N logdrop # 创建一个新的 chain
$ iptables -A logdrop -j LOG --log-level debug # 进入的都打日志
$ iptables -A logdrop -j DROP # 进入的都丢掉

$ iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j logdrop # 要阻止的请求丢到新的 chain 里面

$ tail -f /var/log/kern.log # 查看日志
```

感觉和之前的方法好像没区别啊……
总之这样也可以就是了。

---

防止恶意攻击导致日志暴涨，可以限制下日志的频率

```
$ iptables -A logdrop -j LOG \
        --log-prefix "prefix:" --log-level warning \
        -m limit --limit 6/m --limit-burst 2
```
