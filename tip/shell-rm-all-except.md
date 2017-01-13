# remove all except

---

http://stackoverflow.com/questions/4325216/rm-all-files-except-some

---

```
$ # find [path] -type f -not -name 'EXPR' -print0 | xargs -0 rm --
$ find . -type f -not -name '*txt' -print0 | xargs -0 rm --
```
