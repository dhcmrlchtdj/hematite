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

## do it, do it again, and again, and again...

---

开始讲递归

- lat?, list of atom
- member?

---

### the first commandment (preliminary)
always ask `null?` as the first question in expressing any function.

---

## cons the magnificent

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

## numbers games

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

## oh my cawd: it's full of stars

---

