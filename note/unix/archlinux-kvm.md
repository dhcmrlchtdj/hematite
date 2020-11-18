# install archlinux on kvm

---

123systems 年付 $10 的 KVM
SolusVM 的控制台
chrome 上的 VNC 插件

---

# ip

自动分配不好使，要自己手动配置

https://wiki.archlinux.org/index.php/Network_configuration#Manual_assignment
https://wiki.archlinux.org/index.php/Resolv.conf#Google

```
$ echo "nameserver 8.8.8.8" >> /etc/resolv.conf
$ ip link set <interface> up
$ ip addr add <ip>/<mask> broadcast <broadcast> dev <interface>
$ ip route add default via <gateway>
```

---

# partition

wiki 越来越不乖了……
我这种初级使用者还是喜欢 cfdisk 这种简单的……

```
$ parted /dev/sda print # 可以查看是哪种分区 MBR/GPT
```
