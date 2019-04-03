# lambda cube

https://en.wikipedia.org/wiki/Lambda_cube
https://www.zhihu.com/question/29706455/answer/138665873

在看 dependent type，却突然有点知道了 lambda cube 是什么

以 simply typed lambda calculus 为基础，从不同维度扩展类型系统的能力。

比如 `let i : int = 0`，这里 `int` 是 type，`0` 是 term

对于一个类型系统

- `lambda 2` 允许 term 依赖 type，即 parametric polymorphism，比如 `let id : 'a -> 'a = fun x -> x`，这里不同的 term 可以生成不同的 type
- `lambda omega(weak?)` 允许 type 依赖 type，即 type constructor，比如 `type speed = Slow | Fast`，这里 `speed` 依赖 `Slow/Fast`
- `lambda p` 允许 type 依赖 term，即 dependent type，比如 `int arr[10]`，这里 `int[]` 依赖 `5`

这是三个正交的维度，组合成了 lambda cube

- `lambda omega` 将 parametric polymorphism 和 type constructor 组合，可以有 `type 'a option = None | Some of 'a`

剩下的都和 dependent type 相关的，目前还不太懂啊……

---

http://okmij.org/ftp/Computation/lightweight-dependent-typing.html
https://github.com/ice1000/Books/tree/master/Wow-FV-zh
https://ice1000.org/2018/11/18/SomeProspectsAboutOwO/

> dependent types are the Curry-Howard interpretation of first-order logic
> 什么是 Proof Assistant？我们一般称之为定理证明器，就是编程语言的类型系统达到一定能力后会进化而成的东西。
> 类型即命题，程序即证明(Types are propositions, pro- grams are proofs)。
> 一个编程语言在任何情况下需要程序员断言一个不可 能存在的异常的不存在，都是这门编程语言类型系统不够强 大的体现。

有一点点、朦胧的……
加了这样的定语，其实就是不懂吧。
