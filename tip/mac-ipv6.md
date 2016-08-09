# mac ipv6

---

```
$ # 查看帮助
$ networksetup -help
...

$ # 设备列表
$ networksetup -listnetworkserviceorder
(1) USB Ethernet
(Hardware Port: USB Ethernet, Device: en4)

(2) Wi-Fi
(Hardware Port: Wi-Fi, Device: en0)

(3) Bluetooth PAN
(Hardware Port: Bluetooth PAN, Device: en3)

(4) Thunderbolt Bridge
(Hardware Port: Thunderbolt Bridge, Device: bridge0)

$ # 禁用／开启 ipv6
$ networksetup -setv6off 'Wi-Fi'
$ networksetup -setv6automatic 'Wi-Fi'
```

根本没有 ipv6 支持，直接都关掉
