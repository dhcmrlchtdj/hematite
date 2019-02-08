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

- 关于 REPL
    - 暴露 compiler linker interpreter 接口，实现易用的交互

---

## abstract machine

---

## value and memory

---

## compiler

---

## runtime
