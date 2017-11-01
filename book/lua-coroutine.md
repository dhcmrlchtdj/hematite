# Revisiting coroutines

---

https://dl.acm.org/citation.cfm?id=1462167
https://dl.acm.org/authorize.cfm?key=155562

---

lua 作者的 coroutine 分析

> full asymmetric coroutines have an expressive power equivalent to one-shot
> continuations and one-shot delimited continuations.

---

coroutine 的属性/分类

- asymmetric vs symmetric
    - yield to invoker 和 yield to scheduler 的区别
    - asymmetri control sequencing is much simpler to manage and understand
    - asymmetric coroutines are more easily managed and can support more
        succinct implementations of user-defined constructs
- first-class vs constrained
    - first-class coroutines can be freely manipulated by the programmer
        and invoked at any place
- stackful vs stackless
    - stackful mechanism allow coroutines to suspend execution from within
        nested functions

作者将 first-class & stackful 的称为 full coroutine。
asymmetric / symmetric 只影响使用体验，不影响 coroutine 的能力。

---


