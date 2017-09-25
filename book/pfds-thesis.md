# Purely Functional Data Structures

---

## 1.Introduction

---

### Functional vs. Imperative Data Structures

---

- persistent: a data structure that supports multiple versions
- ephemeral: a data structure that allows only a single version at a time

functional 的一个特性是数据不可变。
所以在修改数据结构时，会产生新旧两个版本的数据，即 persistent。
而不讲究数据不可变的时候，旧版数据通常在赋值后就丢失了，即 ephemeral。

---

> this thesis shows that it is often possible to devise functional data
> structures that are asymptotically as efficient as the best imperative
> solutions.

---

### Strict vs. Lazy Evaluation

---

- strict
    - ease of reasoning about asymptotic complexity
    - strict languages can describe worst-case data structures, but not amortized ones
- lazy
    - lazy languages can describe amortized data structures, but not worst-case ones
- memoization

---

### Overview

---

- ch1: introduction
- first part (Chapters 2~4) concerns algorithmic aspects of lazy evaluation
    - ch2: lazy evaluation; $-notation
    - ch3:
        - how lazy evaluation combins amortization and persistence
        - how to analyze the amortized cost of lazy evaluation
    - ch4: the power of combining strict and lazy evaluation
- second part (Chapters 5~8) concerns the design of functional data structures
    - a handful of general techniques for designing efficient functional data structures
    - ch5: lazy rebuilding
    - ch6: numerical representations
    - ch7: data-structural bootstrapping
    - ch8: implicit recursive slowdown
- ch9: conclusion

---

## 2.Lazy Evaluation and $-Notation

---

> Supporting lazy evaluation in a strict language requires two primitives:
> delay: one to suspend the evaluation of an expression
> force: one to resume the evaluation of a suspended expression (and memoize the result)

```ocaml
type 'a lazy_t
val delay: unit -> 'a -> 'a lazy_t
val force: 'a lazy_t -> 'a
```

---

- $-notation
    - `$e` = `delay (fun () -> e)`
    - `force ($e)`

---

### Streams

---

- hmm, just stream

---

## 3.Amortization and Persistence via Lazy Evaluation

---


