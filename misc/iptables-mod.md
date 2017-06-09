# iptables

---

不知道怎么算是哪里的问题。
更新 fail2ban 的时候，发现无法插入规则。
然后就是发现 iptables 有问题

```
$ iptables -w -I INPUT -p tcp --dport 22 -j log # 失败
iptables: No chain/target/match by that name.

$ iptables -w -I INPUT -p tcp -j log # 成功
```

为什么不能指定 port 啊。
放狗……

---

https://forums-web2.gentoo.org/viewtopic-t-711809-start-0.html

```
$ lsmod | grep -E '^ip|^xt?'
iptable_filter         16384  1
ip_tables              28672  1 iptable_filter
x_tables               28672  2 ip_tables,iptable_filter
```

相比别人的输出，少了 `xt_tcpudp`，也就是说，是内核的问题？
没道理啊。

---

https://bbs.archlinux.org/viewtopic.php?id=210106

```
$ ls /lib/modules/4.6.2-1-ARCH/kernel/net/netfilter | grep tcpudp
xt_tcpudp.ko.gz
```

看了下输出，`xt_tcpudp` 之类的模块，肯定是有的。
但是，没加载吗。

---

https://bbs.archlinux.org/viewtopic.php?id=195108

```
$ cat /proc/net/ip_tables_matches
icmp
```

这是当前 iptables 使用到的模块，可以看到当前只有 icmp。
试图在 iptables 里指定端口时，这里不会更新反而报错。

```
$ modprobe -vn xt_tcpudp
modprobe: FATAL: Module xt_tcpudp not found in directory /lib/modules/4.5.4-1-ARCH
```

为什么 `modprobe` 会去找 `4.5.4-1-ARCH`……
内核更新后 `modprobe` 的路径不对了，这问题很大吧。
难道不能做个软链之类的。
所以要怎么办啊，只能重启了吗……

好吧，其实 modprobe 应该没错，`uname -r` 输出的就是 `4.5.4-1-ARCH`。
为什么 uname 没更新啊，还是只能重启了吗……

---

http://askubuntu.com/questions/547834/uname-r-returns-the-wrong-kernel-version

> uname will tell you what kernel is running, not which is installed.
> So you might have installed the new kernel, but the system would only
> be running it after a reboot.

所以，更新内核之后，还是只能重启了吧……

有时间折腾一下 kexec 试试

---

重启之后

```
$ cat /proc/net/ip_tables_matches
conntrack
conntrack
conntrack
udplite
udp
tcp
icmp

$ lsmod | grep -E '^ip|^xt?'
xt_tcpudp              16384  2
xt_conntrack           16384  2
iptable_filter         16384  1
ip_tables              28672  1 iptable_filter
x_tables               28672  4 ip_tables,xt_tcpudp,xt_conntrack,iptable_filter
```

总之
没有什么问题是一次重启解决不了的。
如果一次不行，那就两次。
