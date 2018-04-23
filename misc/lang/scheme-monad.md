# A Schemer's Introduction to Monads

---

http://www.ccs.neu.edu/home/dherman/research/tutorials/monads-for-schemers.txt

---

## I. Introduction.

> all side effects have one thing in common: order of evaluation matters.

> when you have side effects, they have to happen in the right order.

SICP 里讲到，赋值带来了执行顺序，也就是时间的问题。

依赖副作用来编程，要求这些副作用的顺序是确定的。

> Monads aren't the only formalism for dealing with this -- CPS and
> A-normal form do, too. But they're all related.

这个，涉及到的几个概念，只能说不明觉历了……

---

## II. Continuation-Passing Style.

```scheme
(define (begin v1 v2) v2)
```

```scheme
(define (begin cps-exp1 cps-exp2)
  (lambda (k)
    (cps-exp1 (lambda (res1)
                (cps-exp2 (lambda (res2)
                            (k res2)))))))
```

对比上下两个 begin 的定义

scheme 对参数求值顺序没有要求，所以 v1 v2 哪个先执行是没有保证的。
（当然，我们可以通过构造 lambda 等方式实现一个求值顺序固定的解释器。

但是副作用对求值顺序有要求，所以下面给出了一个 CSP 的写法来保证执行顺序。
（CSP 提到语法层来，最大的问题大概是传染性？反正实际写起来是比较不舒服的。

（这个参数 k 让人想到了 call/cc 的直接返回

---

## IV. Summary.

> two major concepts of monads
> 1. enforcing evaluation order
> 2. abstracting away accumulators

只从这两句话理解的话，是不是可以说是：
monad 通过对 accumulators 的抽象，保证了求值顺序。

> CPS is a special case of a monad

---

## III. Accumulator-Passing Style.

讲到了 rand 的例子。
这也是 SICP 中提及的东西（书还是读得不够认真啊……
（SICP 是用这个例子来展示，如何用赋值来维护局部状态，好像是


```scheme
;; rand : number -> (number x number)
(define rand
  (lambda (seed)
    (let ([ans (modulo (* seed 16807) 2147483647)])
      (cons ans ans))))
```

```scheme
;; rand : -> (number -> (number x number))
(define rand
  (lambda ()
    (lambda (seed)
      (let ([ans (modulo (* seed 16807) 2147483647)])
        (cons ans ans)))))
```

例子做了一点点改写，感觉这样看起来更清晰。

关键的地方是提炼出了一个 `T(alpha) = number -> (alpha x number)`
这样有 `rand : -> T(number)`

然后，可以把前面用 CSP 写的 begin 换个实现

```scheme
;; begin : T(alpha) T(beta) -> T(beta)
(define (begin comp1 comp2)
  (lambda (seed0)
    (let* ([res1 (comp1 seed0)]
           [val1 (car res1)]
           [seed1 (cdr res1)])
      (comp2 seed1))))
```

这个情况下，丢掉了 comp1 的结果，只使用了 seed1。

```scheme
;; pipe : T(alpha) (alpha -> T(beta)) -> T(beta)
(define (pipe comp1 build-comp2)
  (lambda (seed0)
    (let* ([res1 (comp1 seed0)]
           [val1 (car res1)]
           [seed1 (cdr res1)])
      ((build-comp2 val1) seed1))))
```

这里的 pipe 和 begin 大致相同，不过使用 seed1 来构造了 comp2。
（let* 的使用，并不会影响我们需要观察的执行顺序，只是让代码看起来更清晰。

然后，还能定义出一个 lift 操作。
（看到这里已经开始看不懂了……

```scheme
;; lift : alpha -> T(alpha)
(define (lift v)
  (lambda (seed)
    (cons v seed)))
```
