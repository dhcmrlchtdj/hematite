# make oneshell

https://www.gnu.org/software/make/manual/html_node/One-Shell.html

---

有的时候，想进二级目录做点操作，`cd` 起来确实麻烦。
搜了下，原来有 `oneshell` 这种高端玩法。

```
SHELL := /bin/bash

.ONESHELL:
foo:
	cd ./dir
	pwd
```

---

苹果自带了 GNU Make 3.81，而 ONESHELL 是 3.82 加入的新功能
😂
