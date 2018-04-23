# type infer

---

https://www.cs.cornell.edu/courses/cs3110/2011sp/Lectures/lec26-type-inference/type-inference.htm

---

整体的流程是这样的

- source - AST - typed AST (with type variable)
- typed AST - constraints - unified
- typed AST (without type variable)

首先是源码到 AST，AST 里可能会缺失部分的 type。
缺失的 type 先用变量代替，最后得到的是一个带了类型标记的 AST。

通过遍历 AST，可以得到类型间的关系（通过比如函数、基本操作符等推到出来）。
这个关系会是一个列表。
（比如 f x = x 可以得到 Tf = Tx -> Tx，可以知道 Tf 和 Tx->Tx 可以相互替代。）

最后是通过这个关系列表，进行 unify 操作，获得新的关系列表。
