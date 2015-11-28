# sed space

---

https://www.gnu.org/software/sed/manual/html_node/Execution-Cycle.html
http://coolshell.cn/articles/9104.html

---

sed 的 `pattern space` 和 `hold space` 一直傻傻分不清楚。
manpage 里也没有对相关概念进行解释。

---

sed 在执行的时候

1. 读取一行输入，去掉 `\n`，放到 `pattern space` 里
2. 执行指定的命令
3. 通常，清空本次的 `pattern space`，开始下一行的处理

---

换种说法

`pattern space` 是当前正在处理的那行数据

比如很常用的
`s` 是对 `pattern space` 进行替换
`p` 是打印 `pattern space`
`d` 是删除 `pattern space`

---

`hold pattern` 需要主动调用 `h/H/g/G/x` 命令去写入，也不会自动清空

---

要类比的话，`hold space` 是全局变量，`pattern space` 是循环变量
