# shell redirect permission

---

```
$ echo 'a' | sudo tee -a /path/to/file
```

直接 `tee` 太危险了，还是 `tee -a` 吧。
