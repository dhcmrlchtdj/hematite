# grep history

---

http://stackoverflow.com/questions/2928584/how-to-grep-search-committed-code-in-the-git-history

---

```
$ git grep <regexp> $(git rev-list --all)
```

查已经删除了的代码，还是很好用的。
