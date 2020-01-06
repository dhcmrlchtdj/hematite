# validate fstab

---

http://serverfault.com/questions/174181/how-do-you-validate-fstab-without-rebooting

---

在修改 fstab 之后，可以用 `mount` 检查配置是否正确

```
$ mount -fav
```
