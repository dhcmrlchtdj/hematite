# how to debug tail call

---

我自己最初的想法，尾递归保留一个调用栈，不同函数的尾调用全部保留。
不过这样连相互递归都解决不了，好像确实没什么用。

---

https://webkit.org/blog/6240/ecmascript-6-proper-tail-calls-in-webkit/

- keep around a shadow stack that will display a finite number, currently 128, tail deleted frames
- ShadowChicken uses a logging mechanism for constructing its shadow stack.
    - prologue 调用函数
    - tail 调用尾调用函数
    - throw 抛出异常
- To construct the shadow stack, ShadowChicken takes two inputs:
    - machine stack
    - sequence of prologue/tai/throw packet

不保留完整的 stack frame，只在 logging 记录调用情况。
需要输出 stack 的时候，从 logging 读取记录，构造完整的调用栈。
