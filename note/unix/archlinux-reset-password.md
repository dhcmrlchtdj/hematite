# reset password

https://wiki.archlinux.org/index.php/Reset_lost_root_password

---

```
$ mount /dev/sda1 /mnt
$ passwd --root /mnt <user_name>
```

VPS 的密码忘记了，还好厂商支持 VNC 方式启动 live CD，救了回来
