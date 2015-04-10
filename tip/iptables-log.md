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


