# ssh remove known_host

---

```
$ ssh-keygen -R hostname
```

服务器地址更新的时候，会出现 `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!` 的提示，需要自己用上面的命令更新 `known_host`。
