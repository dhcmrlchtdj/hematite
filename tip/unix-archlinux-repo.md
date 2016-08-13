# archlinux repo

---

https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Custom_local_repository

---

建一个 repo

```
$ repo-add -s /path/to/repo.db.tar.xz /path/to/*.pkg.tar.xz
```

---

加上 `-s` 后会自动对 repo.db.tar.xz 进行签名。
安装包则是要自己手动签名？
