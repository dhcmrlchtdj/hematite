# interpreter

---

http://www.yinwang.org/blog-cn/2012/08/01/interpreter

---

> 思考题：可能有些人看过 lambda calculus，这些人可能知道 (let ([x e1]) e2) 其实
> 等价于一个函数调用：((lambda (x) e2) e1)。现在问题来了，我们在讨论函数和调用
> 的时候，很深入的讨论了关于 lexical scoping 和 dynamic scoping 的差别。既然
> let 绑定等价于一个函数定义和调用，为什么之前我们讨论对绑定的时候，没有讨论过
> lexical scoping 和 dynamic scoping 的问题，也没有制造过闭包呢？

---

个人想法

函数在定义的时候，只有 `(lambda (x) e)`，执行的环境是未知的，
所以需要用闭包携带作用域。

而变量的绑定，是 `((lambda (x) e2) e1)`，在定义的后立刻执行了，环境是确定的。

---

模式匹配确实能在很大程度上简化代码呀……
