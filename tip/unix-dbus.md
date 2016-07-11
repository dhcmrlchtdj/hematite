# dbus

---

https://wiki.archlinux.org/index.php/Systemd/User#D-Bus
https://bbs.archlinux.org/viewtopic.php?id=201543

---

最近想要用 systemd 跑 node 服务，才发现 dbus 不太对劲。
会出现连接不上 dbus 的情况。
但目测 systemd 又启动了。

```
$ systemctl --user
Failed to connect to bus: No such file or directory

$ ps aux | grep 'systemd --user'
... /usr/lib/systemd/systemd --user
```

搜了一下，不知道为什么 `XDG_RUNTIME_DIR` 之类的变量没设置。

```
$ export XDG_RUNTIME_DIR="/run/user/$UID"
$ export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
$ systemctl --user
```

---

要添加服务的时候，在 `~/.config/systemd/user/` 下面加配置就行
