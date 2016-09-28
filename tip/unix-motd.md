# motd

---

https://wiki.debian.org/motd
https://wiki.archlinux.org/index.php/Arch_boot_process#Message_of_the_day

---

motd, message of tody

rpi 在 ssh 连接上去时，会有个提示信息
以为是 issue，搜了下才知道是 motd

---

> The contents of /etc/motd are displayed by login after a successful login
> but just before it executes the login shell.

也就是说，成功登录后，之前其它操作前，会先打印 `/etc/motd` 的内容

---

> The file /etc/issue is a text file which contains a message or system
> identification to be printed before the login prompt.

issue 则是在登录之前打印的消息

---

这两个居然也有 manpage
