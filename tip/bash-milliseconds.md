# milliseconds in bash

---

http://stackoverflow.com/questions/16548528/linux-command-to-get-time-in-milliseconds
http://unix.stackexchange.com/questions/12068/how-to-measure-time-of-program-execution-and-store-that-inside-a-variable

---

```
$ date +%s
$ date +%s%3N
$ date +%s%N
```

`%N` 是精确到 nanoseconds
`%s%3N` 可以精确到 milliseconds

---

又要说一句，mac 的工具链，就是不如 linux 好用

---

会来搞这个主要是想要得到 source 耗费的时长
搞完发现，直接 `time` 也是可以的……

```
$ time (source ~/.nvm/nvm.sh)
$ time (source ~/.zshrc)
```

但是去掉括号就不行了。
实质是开了个 subshell 吗。
