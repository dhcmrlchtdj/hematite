# a schemer's view of monads

---

> A Schemer’s View of Monads
> Partial Draft
> Adam C. Foltzer & Daniel P. Friedman
> December 2, 2011

看文件下载地址，应该是 indiana c311 的内容
有 Daniel Friedman 的名字挂在那里
硬着头皮试一下，看能不能搞懂 monad

---

## lecture 1: state monad

---

### identity monad

---

介绍了一下 begin 和 let
怎么用 lambda 实现这个两个语义

```scheme
(begin
 (display "one")
 (display "two"))

(define my-begin (lambda (x f) (f x)))
(my-begin
  (display "one")
  (lambda (_) (display "two")))
```

```scheme
(let ([x 5]) (+ x 3))

(define my-let (lambda (x f) (f x)))
(my-let
  5
  (lambda (x) (+ x 3)))
```

---

前面的转写可以看到，my-begin 和 my-let 完全一样
提取一下，就有了一个最简单的 monad，identity monad

```scheme
(define bind-identity
  (lambda (Ma sequel)
    (sequel Ma))) ;; ==> Mb

(define unit-identity
  (lambda (a) a))
```

用 bind 和 unit 来写前面的 begin/let
看起来会是这样

```scheme
;; begin
(bind-identity
  (unit-identity (display "one"))
  (lambda (_) (unit-identity (display "two"))))

;; let
(bind-identity
  (unit-identity 5)
  (lambda (x) (unit-identity (+ x 3))))
```

关于这个 unit，不知道怎么解释

> unit-M is a function that brings a value into the world of a monad M

> bringing scheme values into the identity monad with unit-identity

---

单单只有这个 identity monad，确实没什么用，反而把 begin/let 变得更复杂了

关键在于，提供一种机制，能够修改执行顺序
作者引用 real world haskell 的说法，称之为 programmable semicolon

> provide a hook into how we evaluate expressions in sequence
> bind-M is a programmable semicolon

具体到 bind-identity
编码了一种最基础的顺序逻辑，“先做这个，再做那个”

---

### state monad

---


