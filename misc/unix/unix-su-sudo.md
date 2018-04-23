# login, su vs sudo

---

http://unix.stackexchange.com/questions/35338/su-vs-sudo-s-vs-sudo-i-vs-sudo-bash

---

要登录其他用户的时候，`su - <username>` 和 `sudo -iu <username>` 都是可以的。

建议使用 `sudo` 的方式

1. 不需要知道对方的密码
2. 可以通过 `/etc/sudoers` 进行灵活限制
