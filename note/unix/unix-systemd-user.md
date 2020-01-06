# systemd user

---

https://wiki.archlinux.org/index.php/Systemd#Targets_table
http://unix.stackexchange.com/questions/251211/why-doesnt-my-systemd-user-unit-start-at-boot

---

简单部署一点代码，用 systemd 还是非常方便的，基础的访问日志都不需要自己处理。

拿之前的短链接服务做例子

```
[Unit]
Description=shortener.js

[Service]
Type=simple
Restart=on-failure
User=nobody
WorkingDirectory=/path/to/shortener.js
EnvironmentFile=/path/to/shortener.js/deploy/env
ExecStart=/usr/bin/node /path/to/shortener.js/api/index.js

[Install]
WantedBy=multi-user.target
```

---

如果只是用户自己的服务，可以用 `systemctl --user` 来管理，用 `journalctl --user-unit` 来看日志。
但是用户权限下，无法切换到 `nobody` 这个用户，所以还是要全局维护。

---

更新一下
之前的写法碰到了一个问题。开机后，用户服务不会自动启动。
看 SO，应该是 `WantedBy` 的问题。

查当前的 `default.target`

```
$ systemctl get-default
graphical.target
$ systemctl --user get-default
default.target
```

查可选的 target

```
$ systemctl list-units --type=target
$ systemctl --user list-units --type=target
```

因为当前不是 `multi-user.target`，所以服务一直没启动……
把 service 文件最后换成 `default.target` 就可以了
