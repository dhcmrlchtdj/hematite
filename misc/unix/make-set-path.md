# make set path

---

http://stackoverflow.com/questions/25506047/setting-path-within-makefile-on-mac-os-x-but-it-works-on-linux

---

```makefile
SHELL := /bin/bash
PATH := ./node_modules/.bin:$(PATH)

dist:
    browserify . > dist/bundle.js
```

osx 下面不设置 `SHELL` 的话，`PATH` 不生效。原因未知。
