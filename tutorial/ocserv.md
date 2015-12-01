# ocserv

---

## install

```
$ yaourt -S ocserv
```

`PKGBUILD` 里面配置文件路径有错，需要手动改一下

---

## ip forward

```
$ echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.d/30-ipforward.conf
$ sysctl --system # load conf
```

## nat

```
$ iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
# $ iptables -t nat -A POSTROUTING -j SNAT --to-source <server ip> -o <nic>
$ iptables -t nat -A POSTROUTING -j MASQUERADE -o <nic>
$ iptables-save | tee -a /etc/iptables/iptables.rules
$ # systemctl start iptables
$ # systemctl enable iptables
```

`iptables.service` 停用的时候会把 iptables 清空
会导致 fail2ban 等其他服务的配置丢失，比较坑

---

## cert


