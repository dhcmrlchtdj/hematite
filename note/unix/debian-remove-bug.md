# debian

---

http://askubuntu.com/questions/573239/how-to-fix-dpkg-error-1
http://askubuntu.com/questions/249531/postgres-xc-wont-uninstall-fails-on-stopping-co-ordinators

---

```
Removing nftables (0.4-2) ...
/etc/init.d/nftables: 67: [: 3: unexpected operator
<cmdline>:1:1-13: Error: Could not process rule: Invalid argument
flush ruleset
^^^^^^^^^^^^^
<cmdline>:1:1-13: Error: Could not process rule: Invalid argument
flush ruleset
^^^^^^^^^^^^^
<cmdline>:1:1-13: Error: Could not process rule: Invalid argument
flush ruleset
^^^^^^^^^^^^^
invoke-rc.d: initscript nftables, action "stop" failed.
dpkg: error processing package nftables (--purge):
 subprocess installed pre-removal script returned error exit status 2
```

卸载时碰到上述问题。

---

反正没有在使用 nftables，修改 `/etc/init.d/nftables` 直接退出。
