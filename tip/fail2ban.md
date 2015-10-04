# fail2ban

---

https://wiki.archlinux.org/index.php/Fail2ban
http://serverfault.com/questions/384230/fail2ban-unblock-ipaddress

---

安装好 `fail2ban` 之后，配置规则，具体还是看 `man jail.conf`。

```
# jail.d/sshd.conf
[sshd]
enabled  = true
logpath  = /var/log/auth.log
filter   = sshd
findtime = 86400
maxretry = 5
action   = iptables[name=SSHD, port=ssh, protocol=tcp]
bantime  = 36000
```

`filter` 和 `action` 基本都有现成的。
注意下把 `port=ssh` 更换成使用的端口。

---

重启 `fail2ban` 后规则就生效了。
可以执行 `fail2ban-client status` 看下当前的配置是否生效了。
可以看下 `iptables -nL` 的输出是否符合预期。

---

`action` 有 `iptables` 基本就够用了。
`filter` 如果没有现成的，可以自己写一个，定义好匹配的正则就可以了。

```
# filter.d/nginx.conf
[Definition]

failregex = ^<HOST> - - \[[\]]+\] "\x05\x01\x00" 400 172 "-" "0"$
```
