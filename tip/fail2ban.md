# fail2ban

---

https://wiki.archlinux.org/index.php/Fail2ban
http://serverfault.com/questions/384230/fail2ban-unblock-ipaddress

---

安装好 `fail2ban` 之后，配置规则，具体还是看 `man jail.conf`。

```
# jail.d/ssh-iptables.conf
[ssh-iptables]
enabled  = true
logpath  = /var/log/auth.log
filter   = sshd
findtime = 86400
maxretry = 5
action   = iptables[name=F2B-SSH, port=ssh, protocol=tcp]
bantime  = 36000
```

`filter` 和 `action` 都是用自带的，暂时没去研究怎么写。
注意下 `port=ssh` 更换成使用的端口。

---

重启 `fail2ban` 之后，检查下 `iptables -nL` 的输出是否正确。
