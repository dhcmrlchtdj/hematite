# git ignore partial

+ include
+ attribute
+ filter

---

+ http://stackoverflow.com/questions/2316677/can-git-automatically-switch-between-spaces-and-tabs
+ http://git-scm.com/book/ch8-2.html

---

## 忽略 npmrc 里登录信息的例子

```
$ # triggered on checkout
$ git config filter.npmrc.smudge "cat"
$ # triggered on add
$ git config filter.npmrc.clean "sed '/\/\//d'"
$ echo "npmrc filter=npmrc" >> .gitattributes
```
---

## 忽略 source map 的例子

```
[filter "ignoreSourceMap"]
    smudge = "sed '/^[/][/*]# sourceMappingURL=/d'"
    clean = "sed '/^[/][/*]# sourceMappingURL=/d'"
```
