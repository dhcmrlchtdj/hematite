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

> Implementations with good amortized bounds are often simpler and faster than
> implementations with equivalent worst-case bounds.

- two traditional techniques for analyzing amortized data structures
    - the banker’s method
    - the physicist’s method
- how lazy evaluation can mediate the conflict between amortization and persistence

---

### Traditional Amortization

---

- the running time of a sequence of operations
- define the amortized cost of each operation
- prove that for any sequence of operations, the total amortized cost of the operations is an upper bound on the total actual cost
- prove that at any intermediate stage in a sequence of operations, the accumulated amortized cost is an upper bound on the accumulated actual cost

> The key to proving amortized bounds is to show that expensive operations occur
> only when the accumulated savings are sufficient to cover the cost, since
> otherwise the accumulated savings would become negative.

---

```ocaml
let enqueue x = function
    | { front=[]; rear=r } -> { front=List.rev (x::r); rear=[] }
    | { front=f; rear=r } -> { front=f; rear=x::r }
```

分析下这个队列实现的耗时。
`enqueue` 可能是 O(1)，也可能是 O(n)。
假设执行了一次 O(n) 的操作，即 rear 的长度 n->0，front 的长度 0->n；
那么接下来的 n 次操作都会是 O(1) 的。
结果平摊之后还是个 O(1) 的时间复杂度。

---

### Persistence: The Problem of Multiple Futures

---

```ocaml
let enqueue x = function
    | { front=[]; rear=r } -> { front=List.rev (x::r); rear=[] }
    | { front=f; rear=r } -> { front=f; rear=x::r }
let dequeue = function
    | { front=[] } -> empty
    | { front=[x]; rear=r } -> { front=List.rev r; rear=[] }
    | { front=fh::ft; rear=r } -> { front=ft; rear=r }
```

还是以前面的 queue 为例。
假设先执行 N 次 enqueue，会得到一个 q={front=[A1];rear=[A2;...;An-1]}。
此时对 q 进行 dequeue 的时间复杂度是 O(n)。
由于数据的不可变，所以在 q 上多次执行 dequeue，始终是 O(n) 的复杂度。

---

> the inherent weakness of any accounting system based on accumulated savings,
> that savings can only be spent once.

N 次 O(1) 的操作，也只够平摊一次 O(n) 的操作。
所以在前面的情况下，实际情况和平摊的预期不同。

---

### Reconciling Amortization and Persistence

---

> we must find a way to guarantee that if the first application of _f_ to _x_ is
> expensive, then subsequent applications of _f_ to _x_ will not be.

用 lazy 来解决 O(n) 的操作被重复执行的问题。

> Lazy evaluation can be viewed as a form of self-modification,
> and amortization often involves self-modification.

---

- call-by-value (strict evaluation)
- call-by-name  (lazy evaluation without memoization)
- call-by-need  (lazy evaluation with memoization)

---

> ocaml doc:
> If x has already been forced,
> Lazy.force x returns the same value again without recomputing it.

---

#### cs3110

http://www.cs.cornell.edu/courses/cs3110/2013sp/lectures/lec21-amortized/lec21.html
http://www.cs.cornell.edu/courses/cs3110/2013sp/supplemental/recitations/rec21.html

- aggregate method
    - where the total running time for a sequence of operations is analyzed
- accounting (or banker's) method
    - where we impose an extra charge on inexpensive operations and use it to pay for expensive operations later on.
- potential (or physicist's) method
    - in which we derive a potential function characterizing the amount of extra work we can do in each step.

---

## 4.Eliminating Amortization

---

> in some application areas, it is important to bound the running times of
> individual operations, rather than sequences of operations.
> Real-time systems / Parallel systems / Interactive systems

> it is sometimes easier to design an amortized data structure, and then
> convert it to a worst-case data structure.

> scheduling is a technique for converting many lazy amortized data structures
> to worst-case data structures by systematically forcing lazy components in
> such a way that no suspension ever takes very long to execute.

---

### Scheduling

---

> worst-case data structures that use lazy evaluation internally.

> To achieve worst-case bounds, we must guarantee that every suspension executes
> in less than the allotted time.

---

> The first step in converting an amortized data structure to a worst-case data structure is to
> reduce the intrinsic cost of every suspension to less than the desired bounds.
> The second step in converting an amortized data structure to a worst-case data structure is to
> avoid cascading forces by arranging that, whenever we force a suspension, any other suspensions on which it depends have already been forced and memoized.

---

### Real-Time Queues

---


```ocaml
let enqueue x { front=f; rear=r; } = schedule { front=f; rear=x::r }
let dequeue = function
    | { front=[]; } -> empty
    | { front=fh::ft; rear=r; } -> schedule { front=ft; rear=r }
```

大约是说，使用类似上面的做法，将原本比较耗时的操作，分散到操作中。
在 schedule 的时候，可能执行一部分的合并操作。
（此处没完全理解……

---

## Lazy Rebuilding

---

> lazy rebuilding, a variant of global rebuilding

---

### Batched Rebuilding

---


