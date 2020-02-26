# restart systemd

- https://stackoverflow.com/questions/31055194/how-can-i-configure-a-systemd-service-to-restart-periodically/50332245#50332245
- https://www.freedesktop.org/software/systemd/man/systemd.service.html#RuntimeMaxSec=

定期重启任务

```
[Service]
Restart=always
RuntimeMaxSec=3600
```
