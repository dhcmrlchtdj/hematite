# the little schemer

---

## perface

---

> Most collections of data, and hence most programs, are recursive.

> Recursion is the act of defining an object or solving a problem in terms of
> itself.

关于递归

---

> We believe that programming languages are the best way to convey the concept
> of recursion.

> Perhaps the best programming language for teaching recursion is Scheme.

> there is a direct correspondence between the structure of Scheme programs
> and the data those programs manipulate.

> writing programs recursively in Scheme is essentially simple pattern
> recognition.

关于 scheme

---

> The goal of this book is to teach the rader to think recursively.

> not introduce you to the practical world of programming,
> but a mastery of the concepts in these books provides a start toward
> understanding the nature of computation.

关于本书（及下一本

---

> Second, we want to provide you with a little distraction.

> We know how frustrating the subject matter can be, and a little
> distraction will help you keep your sanity.

关于书里经常出现食物这件事

---

## 1. toys

---

基础概念

- atom
- list
- null, empty list
- car / cdr / cons
- null?
- atom?, (and (not pair?) (not null?))
- eq?

---

### the law of car
the primitive `car` is defined only for non-empty lists.

### the law of cdr
the primitive `cdr` is defined only for non-empty lists.
the cdr of any non-empty list is always another list.

### the law of cons
the primitive `cons` takes two arguments.
the second argument to cons must be a list.
the result is a list.

### the law of null?
the primitive `null?` is defined only for lists.

### the law of eq?
the primitive `eq?` takes two arguments.
each must be a non-numric atom.

---

## 2. do it, do it again, and again, and again...

---

开始讲递归

- lat?, list of atom
- member?

---

### the first commandment (preliminary)
always ask `null?` as the first question in expressing any function.

---

## 3. cons the magnificent

---

还是比较基础的内容

- rember, remove a member
- firsts
- insertR / insertL / subst / subst2
- multirember / multiintertR / multiintertL

---

### the second commandment
use `cons` to build lists.

### the third commandment
when building a list, describe the first typical element,
and then `cons` it onto the natural recursion.

### the fourth commandment (preliminary)
always change at least one argument while recurring.
it must be changed to be closer to termination.
the changing argument must be tested in the termination condition:
when using `car`, test termination with `null?`.

---

## 4. numbers games

---

作者喜欢玩 0/+1/-1

---

### the first commandment (first revision)
when recurring on a list of atoms, lat, ask two questions about it:
(null? lat) and else.
when recurring on a number, n, ask two questions about it:
(zero? n) and else.

### the fourth commandment (first revision)
always change at least one argument while recurring.
it must changed to be closer to termination.
the changing argument must be tested in the termination condition:
when using car, test termination with null? and
when using sub1, test termination with zero?.

### the fifth commandment
when building a value with `+`, always use 0 for the value of the terminating
line, for adding 0 does not change the value of an addition.
when building a value with `*`, always use 1 for the value of the terminating
line, for multiplying by 1 does not change the value of a multiplication.

---

## 5. oh my gawd: it's full of stars

---

- 还是递归，不过判断的条件越来越复杂了。
- 关键还是条件的梳理，把问题拆分
- 后面继续扩展到多个函数互相调用

---

- `(and a b) = (cond [a b] [else #f])`
- `(or a b) = (cond [a #t] [else b])`

---

### the first commandment (final version)
when recurring on a list of atoms, lat, ask two questions about it:
(null? lat) and else.
when recurring on a number, n, ask two questions about it:
(zero? n) and else.
when recurring on a list of S-expressions, l, ask three questions about it:
(null? l), (atom? (car l)), and else.

### the fourth commandment (final version)
always change at least one argument while recurring.
when recurring on a list of atoms, lat, use (cdr lat).
when recurring on a number, n, use (sub1 n).
and when recurring on a list of S-expressions, use (car l) and (cdr l) if
neither (null? l) nor (atom? (car l)) are true.

it must changed to be closer to termination.
the changing argument must be tested in the termination condition:
when using car, test termination with null? and
when using sub1, test termination with zero?.

### the sixth commandment
simplify only after the function is correct.

---

## 6. shadows

---

- 居然是中缀而不是前缀表达式
- 表达式求值
- operand/operator 的抽象，封装操作细节

---

### the seventh commandment
recur on the subparts that are of the same nature:
- on the sublist of a list.
- on the subexpressions of an arithmetic expression.

### the eighth commandment
use help functions to abstract from representations.

---

## 7. friends and relations

---

- 集合操作
- pair, build/first/second

---

## 8. lambda the ultimate

---

- 高阶函数
- 将操作和数据一起作为参数
- 科里化，闭包
- CSP，回调

---

### the ninth commandment
abstract common patterns with a new function.

### the tenth commandment
build functions to collect more than one value at a time.

---

- `(multirember&co a lat col)` 这种递归调用里，每次都会生成一个新的函数用于递归
- 这里的 col 是 collector，其实也就是 continuation
- 调用者提供的 col，只是最后一步使用，其实内部递归时都是在调用临时生成的 col

---

## 9. ...and again, and again, and again, ...

---

- 前面的递归，都是从整体慢慢到局部。比如数组大小逐渐缩小。
- 本章开始出现更一般的情况
- `partial functions`，没控制好会出现死循环等
- 停机问题。假设存在检测函数，然后构造悖论来证明其不存在。
- Y-combinator。递归函数本身作为参数。

---

## 10. what is the value of all of this?

---

- table，查找，环境变量
- interpreter

---

# the seasoned schemer

---

## perface

---

> to think about the nature of computation

这前言和前一本，基本一个模子啊……
不过这本的重点不是递归而是计算。

---

## 11. welcome back to show

---

- 之前都是遍历列表之类的操作，只是遍历一个参数
- 本章开始出现两个参数一起变化的情况（主要是为了状态

---

### the eleventh commandment
use additional arguments when a function needs to know what other arguments
to the function have been like so far.

---

## 12. take cover

---

- 使用了一下 y-combinator，引出 letrec
    书上说 it is better than Y
- 把不变的参数隔离，让递归的部分更加纯粹
    其实就是作用域的问题吧

---

```scheme
(define multirember0
  (lambda (a lat)
    (cond
      [(null? lat) '()]
      [(eq? a (car lat)) (multirember a (cdr lat))]
      [else (cons (car lat) (multirember a (cdr lat)))])))


(define multirember1
  (lambda (a lat)
    ((Y (lambda (mr)
          (lambda (lat)
            (cond
              [(null? lat) '()]
              [(eq? a (car lat)) (mr (cdr lat))]
              [else (cons (car lat) (mr (cdr lat)))]))))
     lat)))


(define multirember2
  (lambda (a lat)
    (letrec ([mr (lambda(lat)
                   (cond
                     [(null? lat) '()]
                     [(eq? a (car lat)) (mr (cdr lat))]
                     [else (cons (car lat) (mr (cdr lat)))]))])
      (mr lat))))
```

---

### the twelfth commandment
use `(letrec ...)` to remove arguments that do not change for
recursive applications.

### the thirteenth commandment
use `(letrec ...)` to hide and to protect functions.

---

## 13. hop, skip, and jump

---

- 引入 `letcc`，感觉主要是为了减少循环的次数

---

```scheme
(define intersectAll
  (lambda (lset)
    (letrec
      ([A (lambda (lset)
            (cond [(null? (cdr lset)) (car lset)]
                  [else (interset (car lset) (A (cdr lset)))]))])
      (cond [(null? lset) '()]
            [else (A lset)]))))

(define intersectAll
  (lambda (lset)
    (letcc
      hop
      (letrec
        ([A (lambda (lset)
              (cond [(null? (car lset)) (hop '())]
                    [(null? (cdr lset)) (car lset)]
                    [else (interset (car lset) (A (cdr lset)))]))])
        (cond [(null? lset) '()]
              [else (A lset)])))))
```

---

### the fourteenth commandment
use `(letcc ...)` to return values abruptly and promptly.

---

```scheme
(define-syntax letcc
  (syntax-rules
    ()
    ((letcc k body ...)
     (call/cc (lambda (k) body ...)))))
```

---

## 14. let there be names

---

- 递归中的环境控制，通过 let 绑定变量来减少不必要的计算
- 然后再次配合 letcc 来及早返回
- （确实可以说是循序渐进，每个例子都是从最傻的写法出发，一步步用前面的原则优化
- （终于开始在代码里用 `if` 了…… `(if a b c) = (cond [a b] [else c])`
- 最后插入了 `(try ...)`

---

```scheme
(define leftmost
  (lambda (l)
    (cond [(atom? (car l)) (car l)]
          [else (leftmost (car l))])))

(define leftmost
  (lambda (l)
    (cond [(null? l) '()]
          [(atom? (car l)) (car l)]
          [else (cond [(atom? (leftmost (car l))) (leftmost (car l))]
                      [else (leftmost (cdr l))])])))

(define leftmost
  (lambda (l)
    (cond [(null? l) '()]
          [(atom? (car l)) (car l)]
          [else (let ([a (leftmost (car l))])
                  (cond [(atom? a) a]
                        [else (leftmost (cdr l))]))])))

(define leftmost
  (lambda (l)
    (letcc skip
           (lm l skip))))
(define lm
  (lambda (l out)
    (cond [(null? l) '()]
          [(atom? (car l)) (out (car l))]
          [else (begin
                  (lm (car l) out)
                  (lm (cdr l) out))])))

(define leftmost
  (lambda (l)
    (letcc skip
           (letrec
             ([lm (lambda (l)
                    (cond [(null? l) '()]
                          [(atom? (car l)) (skip (car l))]
                          [else (begin
                                  (lm (car l))
                                  (lm (cdr l)))]))])
             (lm l)))))
```

---

### the fifteenth commandment (preliminary version)
use `(let ...)` to name the values of repeated expressions.

### the fifteenth commandment (revised version)
use `(let ...)` to name the values of repeated expressions in a function
definition if they may be evaluated twice for one and the same use of function.

---

```scheme
(define-syntax try
  (syntax-rules
    ()
    ((try k a . b)
     (letcc success (letcc k (success a)) . b))))
```

---

## 15. the difference between men and boys...

---

- 开始讲绑定 define/set!
- 控制好作用域，只用于修改闭局部变量

---

### the sixteenth commandment
use `(set! ...)` only with names defined in `(let ...)`s.

### the seventeenth commandment (preliminary version)
use `(set! x ...)` for `(let ([x ...]) ...)` only if there is at least one
`(lambda ...)` between it and the `(let ([x ...]) ...)`.

### the eighteenth commandment
use `(set! x ...)` only when the value that `x` refers to is no longer needed.

---

## 16. ready, set, bang!

---

- 继续讲绑定
- 用 let/set! 实现 letrec 的语义

---

### the nineteenth commandment
use `(set! ...)` to remember valuable things between two distinct uses of
a function.

### the seventeenth commandment (final version)
use `(set! x ...)` for `(let ([x ...]) ...)` only of there is at least one
`(lambda ...)` between it and the `(let ...)`, or if the new value for `x`
is a function that refers to `x`.

---

```scheme
(define length
  (let ([h (lambda (l) 0)])
    (set! h
      (lambda (l)
        (cond [(null? l) 0]
              [else (add1 (h (cdr l)))])))
    h))
```

对上面做拆分
把 `h` 真正的定义从外层剥离

```scheme
(define length
  (let ([h (lambda (l) 0)])
    (set! h ...)
    h))

(define L
  (lambda (length)
    (lambda (l)
      (cond [(null? l) 0]
            [else (add1 (length (cdr l)))]))))

(define length
  (let ([h (lambda (l) 0)])
    (set! h
      (L (lambda (arg) (h arg))))
    h))
```

针对上面的结果，把这种形式总结表示出来
就效果来说，等效于 `letrec`
（这点也可以看 SICP 第四章

```scheme
(define Y!
  (lambda (L)
    (let ([h (lambda (l) '())])
      (set! h
        (L (lambda (arg) (h arg))))
      h)))

(define Y!
  (lambda (f)
    (letrec ([h (f (lambda (arg) (h arg)))])
      h)))

(define length (Y! L))
```

---

## 17. we change, therefore we are!

---

- 继续讲解形式变换，其实都是语法糖咯
- `(let ...)` 和 `((lambda ...) ...)`

---

## 18. we change, therefore we are the same!

---

- 实现 `cons/car/cdr`
- 实现 `set-car!/set-cdr!`
- 重提第六章

---

```scheme
(define kons
  (lambda (kar kdr)
    (lambda (selector)
      (selector kar kdr))))
(define kar
  (lambda (s)
    (s (lambda (x y)  x))))
(define kdr
  (lambda (s)
    (s (lambda (x y) y))))
```

---

## 19. absconding with the jewels

---

- 讲 `letcc`
- 之前的例子大都是作为函数返回值，提前返回来减少计算
- 这里则是流程中途捕获
- 讲 CPS，用用 CPS 改写前面 letcc 的例子
- difference between shadow and the real thing
- CPS 和 letcc 效果是不同的
    letcc 会忽略外层调用
    it forgets everythings around it
    用下面例子来说就是 `(cons (toppings 'why) '())` 和 `(toppings 'why)` 结果相同
- callcc 确实是很复杂的流程控制……

---

### the twentieth commandment
when thinking about a value created with `(letcc ...)`, write down the
function that is equivalent but does not forget. then, when you use it,
remember to forget.

---

```scheme
(define deep
  (lambda (m)
    (cond [(zero? m) 'pizza]
          [else (cons (deep (sub1 m)) '())])))

(define toppings)
(define deepB
  (lambda (m)
    (cond [(zero? m) (letcc jump
                            (set! toppings jump)
                            'pizza)]
          [else (cons (deepB (sub1 m)) '())])))

(define deep&co
  (lambda (m k)
    (cond [(zero? m) (k 'pizza)]
          [else (deep&co (sub1 m)
                         (lambda (x) (k (cons x '()))))])))

(define deep&coB
  (lambda (m k)
    (cond [(zero? m) (let ()
                       (set! toppings k)
                       (k 'pizza))]
          [else (deep&coB (sub1 m)
                          (lambda (x) (k (cons x '()))))])))
```

---

## 20. what's in store?

---

- table，查找，环境变量……
- 又在写解释器……
- 实现 letcc（不过直接用了原生的 letcc 😂

---

### the fifteenth commandment (final version)
use `(let ...)` to name the values of repeated expressions in a function
definition if they may be evaluated twice for one and the same use of function.
and use `(let ...)` to name the values of expressions (without set!) that are
re-evaluated every time a function is used.
