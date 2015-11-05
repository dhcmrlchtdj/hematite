# sed multi command

---

http://unix.stackexchange.com/questions/13711/differences-between-sed-on-mac-osx-and-other-standard-sed
https://gist.github.com/pvdb/777954

---

```
$ make -nprR | sed -ne '/^$/{n' -e '/^[^#.]/{s/:.*//' -e 'p' -e '}' -e '}'
$ make -nprR | sed -ne '/^$/{n; /^[^#.]/{ s/:.*//; p;};}'
$ make -nprR | sed -n '/^$/{n; /^[^#.]/{s/:.*//; p}}'
```

第一种写法太麻烦，直接排除。

需要兼容 bsd sed 的时候，必须用第二种写法，每个指令后面都必须有 `;`
GNU sed 会更精简些
