# sweet.js

https://users.soe.ucsc.edu/~cormac/papers/dls14a.pdf

---

原文主要是讲 macro，不过我是冲着 lexer 去看的。
可能是没理解其价值吧，反正对这块内容稍微有点失望，反正觉得作用不大……

通常解析过程是 source -> token -> AST
我理解 macro 应该是作用于 AST 的

但作者不想构建完整的 AST，仅靠 token 又不够，所以新增了一个流程。
token -> token tree
（分歧就在这里了，作者认为构建完整的 AST 开销比较大，但我觉得无所谓……

---

实现的方式，是在碰到有二义性的 token 时，回头看之前解析好的内容。
按作者的说法，在 JS 里最多回溯 5 个 token 就足以判断当前 token 的类型。

提不起劲……
