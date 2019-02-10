# ZINC

http://caml.inria.fr/pub/papers/xleroy-zinc.pdf

---

## design

- 关于 module
    - 只有 module 能同时满足 separate compilation 和 strong static type
    - compiler linker interpreter 三个过程，之前都没留意 link

- 关于多参函数
    - 支持多参数，函数调用更高效
    - 但是 partial application 意味着可以 partial evaluation，减少计算
    - 作者最终选择不支持多参数 no n-ary function

- 关于运行
    - 可以编译到 machine code / high-level language / bytecode
    - （时代局限性啊，现在肯定会考虑一下 LLVM IR

- 关于 REPL
    - 暴露 compiler linker interpreter 接口，实现易用的交互

---

## abstract machine

- 主要是讲一个不同于 SECD 的 abstract machine
- 具体实现的寄存器，包括 `acc / env / arg / return`

---

## value and memory

- sum-of-product
- three-class data types
    - atomic, predefined types: integer, float-point number, character, string, arbirary-precision integer
    - predefined type constructor: function (closure), vector, dynamic
    - concrete type (用户自定义的类型)
- memory
    - unboxed object 只有 integer
    - boxed object 的 header 由 `size(22bit), GC flag(2bit), tag(8bit)` 组成
        - 还分 structured / unstructured
- value
    - `int/char` 都是 31bit 的（还有 1bit 用于标记这是 unboxed object）
    - `int/char` 等其他类型，都是 unstructured 的
    - `float-point number` 使用 boxed object，主要是为了实现 IEEE 标准

还是有一些概念不太懂

---

## compiler

- 编译过程，AST 到 lambda (tree) 到 bytecode (linear list)
- parsing / type inference / lambda compiler / bytecode compiler

---

> 多练多看，重要的东西总是会重复出现

比如这节出现 pattern match 展开、Brujin indexes。

---

## runtime
