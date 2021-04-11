# sshguard

https://wiki.archlinux.org/index.php/Sshguard
https://wiki.gentoo.org/wiki/Sshguard

之前都用 fail2ban，但是感觉 sshguard 更简单些，主要是也没有其他服务需要保护…

---

```
THRESHOLD=10
BLOCK_TIME=60
DETECTION_TIME=86400

WHITELIST_FILE=/etc/sshguard/whitelist
BLACKLIST_FILE=60:/var/db/sshguard/blacklist.db
```
