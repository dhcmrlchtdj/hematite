# rsync

---

http://articles.slicehost.com/2007/10/10/rsync-exclude-files-and-folders

---

```
$ rsync -n source host:destination
$ rsync -avihP --exclude=".git/" source host:destination
```

其他可以尝试的参数有 `--stats` `-z` `--delete` 之类的
