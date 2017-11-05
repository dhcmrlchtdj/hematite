# ocaml show

---

https://github.com/ocaml-ppx/ppx_deriving

---

之前自己定义类型的时候就感觉经常写 `to_string` 好麻烦。
果然是有工具来干这种事情的。

---

```ocaml
type tree =
    | Leaf of int
    | Node of tree list
[@@deriving show]
```

比如上面的代码，最终生成的会是

```ocaml
type tree = Leaf of int | Node of tree list
val pp_tree : Format.formatter -> tree -> unit
val show_tree : tree -> string
```

后续代码里就可以直接使用 `show_tree` 了。
