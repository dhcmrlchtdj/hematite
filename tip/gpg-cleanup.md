# gpg cleanup

---

https://www.phildev.net/pgp/gpg_moving_keys.html

---

虽然不建议这么做？
但是测试用的，还是想要删除掉

```
$ gpg --list-keys
$ gpg --delete-secret-and-public-keys <keyid>
```

---

导出

```
$ gpg --export-secret-keys -a <keyid> > private_key.asc
$ gpg --export -a <keyid> > public_key.asc
```

导入

```
$ gpg --import private_key.asc
$ gpg --import public_key.asc
$ gpg --edit-key <keyid>
> trust
```
