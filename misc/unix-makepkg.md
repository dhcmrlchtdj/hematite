# archlinux makepkg

---

http://allanmcrae.com/2015/01/replacing-makepkg-asroot/

---

```
$ mkdir -p /opt/build
$ chmod 777 /opt/build
$ echo "nobody ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
$ sudo -u nobody makepkg -sci --noconfirm
```

上面在用法上确实粗暴了些，但确实可以用。
