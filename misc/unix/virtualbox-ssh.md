# virtualbox ssh

---

https://www.ulyaoth.net/resources/tutorial-ssh-into-a-virtualbox-linux-guest-from-your-host.35/

---

之前刷 rpi 的 tf 卡时，玩了一次，这次备份旧硬盘，又玩了一次。

主要时 mac 上挂载 linux 下面的硬盘比较麻烦，还不如直接 virtualbox 虚拟机里搞。

---

设置起来，很简单 `Settings -> Network -> Adapter 2 -> Host-only Adapter -> vboxnet0`

Adapter 1 是 NAT，不管。
Adapter 2 里加上一个 Host-only Adapter。

---

在 virtualbox 里面，直接 dhcp 拿地址就可以了

```
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
	link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
	inet 192.168.99.101/24 brd 192.168.99.255 scope global enp0s8
		valid_lft forever preferred_lft forever
```

在 macOS 上面，可以查到 vboxnet0 的地址

```
vboxnet0: flags=0000<UP,BROADCAST,RUNNING,PROMISC,SIMPLEX,MULTICAST> mtu 1500
	ether 00:00:00:00:00:00
	inet 192.168.99.1 netmask 0xffffff00 broadcast 192.168.99.255
```

---

在 virtualbox 里开启 sshd，就能连上了
