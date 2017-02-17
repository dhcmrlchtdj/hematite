我想要一个什么样的语言，用来干什么

不做系统编程（c/c++/rust），不做 UI 界面（swift），不做潜入（lua）。
普通的命令小工具，编程语言特性学习，提供简单网络编程、文件处理、并发支持。

像 rust 一样基于表达式而不是语句

# module

```
import foo from "/path/to/module"
export bar = foo
```

two module in one file
module like struct

#  binding

```
let foo = "string"
let bar = 3.14
```

# comment

```
# comment
# whole line
```

出现后注释整行

# iter

```
for (let x, y z in iter) {
}
```

# loop

```
while (x < y) {
}
```

# cond

```
if (x == y) {
} else if (x > y) {
} else {
}
```

bool only

# type

string(bytes)
number(integer + float)
boolean(true / false)
nil

everything are values, no reference

# access

everything is public, no private

# async

blocked by default
await for async

