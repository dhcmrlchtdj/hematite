# a little schemer

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
