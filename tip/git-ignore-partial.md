# git ignore partial

+ include
+ attribute
+ filter

---

+ http://stackoverflow.com/questions/2316677/can-git-automatically-switch-between-spaces-and-tabs
+ http://git-scm.com/book/ch8-2.html

---

```
$ # triggered on checkout
$ git config filter.npmrc.smudge "cat"
$ # triggered on add
$ git config filter.npmrc.clean "sed '/\\/\\//d'"
$ echo "npmrc filter=npmrc" >> .gitattributes
```
