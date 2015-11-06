# random string

---

https://gist.github.com/earthgecko/3089509
http://stackoverflow.com/questions/10497236/generate-random-char-in-bash

---

从 `/dev/urandom` 读取数据
用 `base64` 或者 `tr` 进行转换
靠 `dd` 或者 `head` 决定输出的长度

```
$ tr -dc '[:alnum:]' < /dev/urandom | head -c 32
$ LC_CTYPE=C tr -dc '[:alnum:]' < /dev/urandom | head -c 32 # osx
```
