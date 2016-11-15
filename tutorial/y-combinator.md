# y combinator

---

http://matt.might.net/articles/implementation-of-recursive-fixed-point-y-combinator-in-javascript-for-memoization/
https://yinwang0.wordpress.com/2012/04/09/reinvent-y/
http://okmij.org/ftp/Computation/fixed-point-combinators.html
http://sighingnow.github.io/%E7%BC%96%E7%A8%8B%E8%AF%AD%E8%A8%80/y_combinator.html
http://stackoverflow.com/questions/13591970/does-python-optimize-tail-recursion

---

> it is possible to express a "recursive" function like factorial without using recursion or iteration.
> the recursive function is computed as the "fixed point" of a non-recursive function.

> Y combinator is a non-recursive function that computes fixed points

不用 recursion 和 iteration，只用不动点的概念来完成递归的功能

---

先从函数入手理解

不动点的定义为 `x=F(x)`

假设 `F(x) = x^2 - 2`，则 `x = F(x) = x^2 - 2`，可以很容易解出 `x={-1, 2}`
即不动点为 -1 和 2

不过我们真正要研究的不是变量 x，而是函数 f
即 `f = F(f)`
`Y combinator` 是用来寻找不动点 f 的方法
（令 f = Y(F)，则 Y(F) = F(Y(F))，这个 Y 就叫 Y combinator

---

高阶函数，以函数为参数
高阶函数的不动点是个函数

可以按照下列步骤来消除递归调用
1. 找到一个高阶函数，这个高阶函数的不动点是我们的递归函数
2. 找到这个高阶函数不使用递归的不动点

---

。。。
感觉烧脑子

```
我们定义不动点为 Y(F) = F(Y(F))

现有一函数 Y
Y = λf.(λx.f(x x))(λx.f(x x))
则
Yg = (λx.g(x x))(λx.g(x x))			# 定义
	= g((λx.g(x x)) (λx.g(x x)))	# 右边代入左边，x=(λx.g(x x))
	= g(Yg)							# 括号内根据定义替换
即
Yg = gYg
满足我们对不动点的定义

这个
Y = λf.(λx.f(x x))(λx.f(x x))
就是 curry 找到的 Y combinator
```

开头说 y combinator 可以不用递归迭代，其实是说反了
应该是一开始 lambda 演算没有递归，所以要借助 y combinator 这种东西实现递归

---

```
;; call-by-value Y combinator
(define Y
  (lambda (f)
    ((lambda (u) (u u))
     (lambda (x) (f (lambda (t) ((x x) t)))))))

;; call-by-name Y
(define Y-n
  (lambda (f)
    ((lambda (x) (f (x x)))
     (lambda (x) (f (x x))))))
```

---

U combinator

U = λf.f(f)

`(define U (lambda (f) (f f)))`
