# dbus

---

https://wiki.archlinux.org/index.php/Systemd/User#D-Bus
https://bbs.archlinux.org/viewtopic.php?id=201543

---

上次鼓捣了很久，做了很多操作，所以某些操作生效是有效果的，我自己都不知道……
所以之前的记录是不完整的，重新梳理一次

---

核心问题，无法使用 `systemctl --user`。

```
$ systemctl --user
Failed to connect to bus: No such file or directory
```

---

首先，检查一下 `/usr/lib/systemd/systemd --user` 有没有正常启动

```
$ ps aux | grep 'systemd --user'
... /usr/lib/systemd/systemd --user
```

如果没有正常启动，可能是登录判断有问题？
反正我在 vps 遇到这个问题了。解决方式是，触发一下 login？

```
$ loginctl enable-linger username
```

---

`systemd --user` 正常启动之后，还是遇到最初的问题。
检查一下 `XDG_RUNTIME_DIR` 和 `DBUS_SESSION_BUS_ADDRESS` 这两个变量。

没有的话，就设置一下

```
$ export XDG_RUNTIME_DIR="/run/user/$UID"
$ export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
```

---

到这里，问题应该就解决了。

要添加服务的时候，在 `~/.config/systemd/user/` 下面加配置就行。
