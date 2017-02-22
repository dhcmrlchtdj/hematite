# real world ocaml

---

## prologue

---

列举了一些 ocaml 的特点

- garbage collection
- first-class functions
- static type-checking
- parametric polymorphism
- immutable programming
- automatic type inference
- algebraic data types & pattern matching

如果只看到这些，感觉确实很棒啦

---

安装指南
https://github.com/realworldocaml/book/wiki/Installation-Instructions

---

## Variables and Functions

---

ocaml 默认有些奇怪
比如 `=` 可以比较整数和浮点型，但是 `+` 只能用于整数

---

可以自定义中缀表达式

```ocaml
let (|>) x f = f x ;;

let path = "/usr/bin:/usr/local/bin:/bin:/sbin";;
String.split ~on:':' path
	|> List.dedup ~compare:String.compare
	|> List.iter ~f:print_endline
;;
```

可以实现这种 pipe 的效果

---

函数定义方式
真的就是回字的四种写法了 🙄️

---

## Files, Modules, and Programs

---

```
$ ls
freq.ml

$ ocamlfind ocamlc -linkpkg -thread -package core freq.ml -o freq.byte
$ ocamlfind ocamlc -custom -linkpkg -thread -package core freq.ml -o freq.native

$ ocamlfind ocamlopt -linkpkg -thread -package core freq.ml -o freq.native

$ corebuild freq.byte
$ corebuild freq.native
```

- ocamlc 是 bytecode compiler
	- 代码跑在虚拟机上
	- 像 OCaml debugger 之类的工具，只能用于 bytecode
	- 也可以把 runtime 一起打包
- ocamlopt 是 native-code compiler
	- 可以用 gdb 调试

---

```
$ corebuild counter.inferred.mli
$ cat cat _build/counter.inferred.mli
```

- `.mli` 是接口定义
- 通常会有接口定义、类型定义、文档等
- 虽然可以用工具生成，不过通常会选择手写来保证可读性

---

- 文件名即模块名
- 模块名总是大写首字母

比如 `counter.ml` 对应的模块就是 `Counter`

- 可以在文件内嵌套模块
- `module <name> : <signature> = <implementation>`

- `open <name>` 后可以直接使用模块内的函数、变量
	- 不这么做也可以通过引用模块名来使用模块内的函数、变量
	- 直接 `open` 等于是污染当前环境
	- 尽可能少进行 `open` 操作
	- 即使要做也尽可能把作用域限制在局部

- 模块里可以 `include <name>` 来扩展生产新模块

---

