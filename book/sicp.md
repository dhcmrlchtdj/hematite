# sicp

---

第一章主要讲的是对函数的组合。

印象比较深的是 递归 与 迭代。
以前看过 guido 关于为什么 python 不会支持尾递归的文章，里面提到很重要一点就是所有尾递归都能改写成迭代的形式。
实际看 sicp 中例子，能感觉到尾递归和迭代确实只是两种不同的表达形式，而且将函数改造成 迭代函数 也不比改造成 循环迭代 来得简单。
但是尾调用又不太一样，尾递归能简单改成迭代，尾调用改起来稍微麻烦些。
不过 guido 提出的反对意见也很有说服力，如果对尾调用进行优化，意味着不保存调用栈，会给调试带来麻烦。

关于递归和迭代的实现，我的理解是一次调用过程中，包含了完整环境变量。
这又让我想到了 函数式编程 和 闭包 这两个概念，可能还要加上 monad，这里不扯太远了。

---

看到 3.1，里面提到了迭代函数和循环迭代。循环迭代需要引入 赋值 这个操作。
而赋值在很多时候，会破坏纯函数的特性。

---

第三章介绍了两种组织程序的方式， 对象（object-based） 和 流（stream-processing）。

---

基于对象的方式引入了赋值的概念，这使得模块之间可以完全隔离，上层不需要知道下层的具体实现。
模块可以靠赋值改版自己的环境变量。
如果没有赋值的能力，在调用其他模块时，调用者就要传入完整的环境变量。

引入赋值的代价是函数不能再随意组合，执行结果和调用顺序是有关的。
我自己这里的表述不是非常严谨，赋值不是打破纯函数的特性（即执行结果和调用顺序无关）的充分条件。

imperative 和 functional

---

又看了下 haskell 的简单介绍，突然意识到，haskell 的延迟求值策略，其实就上 sicp 提到的 stream 模型。

---

2.1 中的结构模型：

1. 应用代码。应用层或者业务层的代码。
2. 对外 API。这层 API 不需要了解数据的实际结构，只是调用下一层 API 达到修改数据的目的。
3. 结构 API。只有组合和获取两种功能，用于将基础数据组合成复杂数据，并从复杂数据中获取基础数据。
4. 底层设施。语言层面提供的基础设施。

---

最近重看 SICP，开始做习题。
看到 2.4 了，两种不同方式表示复数。
这种代码隔离例子，解释了为什么很多地方不直接用 `(cons x y)`，而要套一层 `(define make-xx cons)`。
再想想，这个就是 interface 呀，定义接口、隐藏实现。
或者说，这个应该叫 duck type，不同的实现都提供了某个方法。
很多很基础的东西还是要多学习……

另外前面看八皇后问题的时候，感受到了简单粗暴的威力。
暴力遍历真是好方法，直接使用列表也能完成这么多的操作。
但是，还是感觉直接列表处理浪费时间空间。
这就又想到了之前接触的 transducer。
要怎么更好地把这些技巧都整合起来。

---

+ generic operations with explicit dispatch
	- 不同实现使用不同的函数名
+ data-directed style
	- 给不同实现打上标记，根据参数的标记找到对应的实现
+ message-passing-style
	- 实现封装在参数内部，调用是在参数里查找具体实现

---

```
(define (cons x y) (lambda (z) (if z x y)))
(define (car z) (z #t))
(define (cdr z) (z #f))
```

```
(define (cons x y) (lambda (m) (m x y)))
(define (car z) (z (lambda (p q) p)))
(define (cdr z) (z (lambda (p q) q)))
```

返回的不是 pair，而是函数。

---

前面说到用 data-directed 的方式将请求分发到不同实现。
当涉及到不同类型混合的调用时，可以用 coercion 的方式将某个类型转化成另一个类型。
这个过程下来，越来越接近我脑子里面向对象的相关概念。
或者说是我对两者的理解都有问题吗。

---

> assignment and mutation are equipotent:
> Each can be implemented in terms of the other.

想要实现可变数据，引入赋值操作即可。
而引入赋值操作，环境必须用可变数据来表示。

---

> any notion of time in concurrency control must be intimately tied to communication

数据同步的问题，小到两个函数调用，大到分布式计算？

---

> The truth of the matter is that, in a language in which we can deal with
> procedures as objects, there is no fundamental difference between
> "procedures" and "data", and we can choose our syntactic sugar to allow us
> to program in whatever style we choose.

+ `(wire 'get-signal)`
	- `wire` 是 procedure，`'get-signal` 是 message

+ `(get-signal wire)`
	- `get-signal` 是 procedure，`wire` 是 data

可以用语法糖来转换这两种调用方式。
`wire` 到底是数据还是函数，其实就没太多区别了。

---

3.3.5 这个，在我的现有知识里，就是双向绑定了。
更准确点，是 computed 的概念。
（不过，双向绑定本质也就是 computed 就是了，按我理解）
