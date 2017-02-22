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


