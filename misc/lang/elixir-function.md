# elixir function

---

lisp1 lisp2 说的是命名空间的事情
scheme 那样函数变量都在一起的算是 lisp1
某些 lisp 实现里，函数有单独的命名空间，属于 lisp2

---

之前看过一次，不知道重点是什么，就没留意……
最近看到 elixir 匿名函数调用要加上 `.`，搜了下，又提到了这个概念。

---

https://stackoverflow.com/questions/18011784/why-are-there-two-kinds-of-functions-in-elixir/18023790#18023790

---

> def gets a new empty scope

这是比较奇葩的一点……
def 不能在 defmoudule 之外定义也挺奇葩的。

> A function always has a fixed arity.
> functions in Elixir are identified by name and arity.

只有函数名的时候，是不足以标识函数的。
所以 elixir 里匿名函数的参数个数必须都一样。

然后关于 `.` 的问题。
解释好像是说，因为变量名不足以标识出这是个函数，所以要加点来表示这个变量是个函数。
（还是感觉不对劲，是我理解不对？函数本身不是普通变量？
