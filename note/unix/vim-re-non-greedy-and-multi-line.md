# vim non-greedy and multi-line

---

+ http://stackoverflow.com/questions/784176/multi-line-regex-support-in-vim
+ `:help non-greedy`
+ http://stackoverflow.com/questions/1305853/how-can-i-make-my-match-non-greedy-in-vim
+ `:help /\_.`

---

```
:%s/"\_.\{-}"//g
```
