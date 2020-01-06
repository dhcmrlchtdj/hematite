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

## 5.Lazy Rebuilding

---

> lazy rebuilding, a variant of global rebuilding

主要是为了讲 lazy，先介绍下 batched 和 global。

---

### Batched Rebuilding

---

批量更新。

> it is usually too expensive to restore perfect balance after every update

> an attractive alternative is to postpone rebalancing until after a sequence
> of updates, and then to rebalance the entire structure, restoring it to
> perfect balance

假设目标是平摊后时间复杂度为 O(f(n))，进行一次完整转化的时间复杂度为 O(g(n))。
则可以在 C*g(n)/f(n) 进行一次完整的转化。

---

BST 之类的数据结构，操作时要保证结构满足某些特性，才能保证时间复杂度。
这里的核心思路就是不急着去满足这些特性，比如删除了就先标记，不急着重新平衡。
等到积累了一定量的操作后，一次性重构整个平衡树。

比如一次完整重构的时间复杂度为 g(n)=O(n)，
目标是平摊后删除操作的时间复杂度为 f(n)=O(logN)，
则需要 n = g(n)/f(n) 个删除来平摊这一次完整重构的开销。

---

> Under persistent usage, the amortized bounds degrade to the cost of the
> rebuilding transformation because it is possible to trigger the transformation
> arbitrarily often.
> In fact, this is true for all data structures based on batched rebuilding.

前面分析过这种问题，进行完整重构的操作可能会被重复。
（不过前面也说了 lazy 来解决呀？

---

### Global Rebuilding

---

全局副本？

> The basic idea is to execute the rebuilding transformation incrementally,
> performing a few steps per normal operation.

> Unlike batched rebuilding, global rebuilding has no problems with persistence.
> Unfortunately, global rebuilding is often quite complicated.

---

同时维护两份数据，primary 和 secondary。

外部能接触到的读写都在 primary 进行。
然后每次操作时，都在 secondary 跑一点重建数据结构的操作，使得 secondary 满足约束。
等到 secondary 满足约束后，就替换调 primary。
可以等几次操作后，就生成一个新的 secondary，又开始进行结构的重建。

一个问题是 primary 的写操作如何同步到 secondary。
文章里说到用 buffer，然后每步重建都批量执行一点。

（这个 secondary 这么搞，感觉确实挺复杂的……

---

### Lazy Rebuilding

---

> Global rebuilding has two advantages over batched rebuilding:
> it is suitable for implementing persistent data structures
> and it yields worst-case bounds rather than amortized bounds.

> Lazy rebuilding shares the first advantage, but yields amortized bounds.
> if desired, worst-case bounds can often be recovered using the scheduling techniques

---

## 6.Numerical Representations

---

numerical representation: choose a representation of natural numbers with
certain desired properties and define the functions on the container objects
accordingly.

---

random-access list / heap 这样的容器，和数字在表示、操作上都存在相似之处。
介绍一些在操作数字时，递增 O(1)，相加 O(logN) 的表示方式。

---

### Positional Number Systems

---

> each digit Bi has weight Wi, the value is SUM(Bi*Wi).

就是数字表示啦，对 Bi/Wi 加一点限制，就是二进制、十进制了。

---

### ???

---

## 7.Data-Structural Bootstrapping

---

> problems whose solutions require solutions to (simpler) instances of the same problem.

- data-structural bootstrapping
    - structural decomposition: involves bootstrapping complete data structures from incomplete data structures
    - structural abstraction: involves bootstrapping efficient data structures from inefficient data structures

---

### Structural Decomposition

---

1. taking an implementation that can handle objects only up to some bounded size
2. extending it to handle objects of unbounded size

---

分治？

---

### Structural Abstraction

---

> For many implementations, designing an efficient insert function is easy,
> but designing an efficient join function is difficult.

> Structural abstraction creates collections that contain other collections as
> elements. Then two collections can be joined by simply inserting one
> collection into the other.

> The basic idea of structural abstraction is to somehow represent bootstrapped
> collections as primitive collections of other bootstrapped collections.

- primitive type / bootstrapped type

---

### ???

---

## 8.Implicit Recursive Slowdown

---

### Recursive Slowdown

---

> recursive slowdown is a variant of binary numbers that can be incremented in
> O(1) worst-case time.

---

### Implicit Recursive Slowdown

---

> The essence of the recursive-slowdown implementation of binary numbers is a
> method for executing carries incrementally.

> By combining the ideas of recursive slowdown with lazy evaluation, we obtain
> a new technique, called implicit recursive slowdown.
