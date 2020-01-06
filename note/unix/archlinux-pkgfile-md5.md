# PKGFILE md5

---

https://www.reddit.com/r/archlinux/comments/2yqgqo/how_do_you_create_md5sums_for_aur_files/
https://bbs.archlinux.org/viewtopic.php?id=63711

---

```
$ makepkg -g >> PKGFILE # 生成 md5sums
$ updpkgsums # 还可以直接更新 PKGFILE
```
