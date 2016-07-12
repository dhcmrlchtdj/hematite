# systemd user

---

https://wiki.archlinux.org/index.php/Systemd#Targets_table

---

简单部署一点代码，用 systemd 还是非常方便的，基础的访问日志都不需要自己处理。

拿之前的短链接服务做例子

```
[Unit]
Description=shortener.js

[Service]
Type=simple
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
