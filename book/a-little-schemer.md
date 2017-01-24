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
- list / null (empty list)
- car / cdr / cons
- null?
- atom? (and (not pair?) (not null?))
- eq?

---

### the law of car
the primitive car is defined only for non-empty lists.

### the law of cdr
the primitive cdr is defined only for non-empty lists.
the cdr of any non-empty list is always another list.

### the law of cons
the primitive cons takes two arguments.
the second argument to cons must be a list.
the result is a list.

### the law of null?
the primitive null? is defined only for lists.

### the law of eq?
the primitive eq? takes two arguments.
each must be a non-numric atom.

---

## do it, do it again, and again, and again...

---


