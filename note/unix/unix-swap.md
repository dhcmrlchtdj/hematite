# swap file

---

https://wiki.archlinux.org/index.php/Swap#Swap_file

---

1G 内存的 VPS，一开始没留 swap 分区
结果编译 gentoo prefix 的时候内存爆炸了

看了下 wiki，搞了下 swap file

就实际情况来看，swap 不需要多大，512M ~ 1G 完全够用了

---

添加

```
$ fallocate -l 512M /swapfile
$ chmod 600 /swapfile
$ mkswap /swapfile
$ swapon /swapfile
$ echo '/swapfile none swap defaults 0 0' >> /etc/fstab
```

删除

```
$ swapoff -a
$ rm -f /swapfile
$ sed -i.bak '/swap/d' /etc/fstab
```

另外，wiki 里提了一个 systemd-swap，不知道具体啥用处。

> Uncomment the lines containing swapf in the swap file section
> of /etc/systemd-swap.conf. Start/enable the systemd-swap service.
