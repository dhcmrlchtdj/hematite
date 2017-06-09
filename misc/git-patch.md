# git patch

---

之前记录过怎么把 commit 导出成 patch

```
$ git format-patch -2 # pick 2 commit
$ git am -i /path/to/patch
```

---

另外一种场景，把文件相关的 commit 导出

```
$ git format-patch <hash> <filename>
```

从 `<hash>` 开始，`<filename>` 相关的变化都会导出。
