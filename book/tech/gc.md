# the garbage collection handbook

---

## allocation

- sequential
- free list: first-fit, next-fit, best-fit
- segregated-fit: multiple free list

---

## mark-sweep

- mutator: one or more. user process. `new/read/write` memory.
- collector: single. stop the world.

- tricolor
    - black: alive
    - grey: scanning
    - white: dead

- bitmap
- lazy sweep

---

## mark-compact

- mark 过程和 mark-sweep 一样的，主要是增加 compact
- 减少碎片化，能让内存分配变得更快更简单（直接线性分就好了）
- 如何 compact
    - arbitray，不管一开始 allocation 的顺序
    - linearisity，按引用关系
    - sliding，按一开始 allocation 的顺序
- compact 算法：two-finger / lisp2 / threaded / one-pass

- two-finger
    - two-pass, arbitray
    - 适合固定大小

- lisp2
    - three-pass, sliding
    - 额外的空间开销
    - 计算出每个元素应该被移动到哪里；更新指针指向；实际移动元素

---

## copying

- 空间消耗较大，但是实现简单、速度快、没有碎片化问题
- Cheney algorithm
    - 维护 `scan/free` 两个指针。
    - `scan` 指向接下来要扫描的对象，`free` 指向剩余空间。
    - `scan` 到 `free` 中间是待扫描的对象。

- locality
    - 按什么顺序遍历存活的对象，能让 locality 最优。
    - DFS/BFS 都有自己的适合和不适合的场景，没有最优解，NP 问题。
    - 不像 mark-compat 有 sliding 这样明确的较优方法

- issue
    - allocation
    - space and locality
    - moving objects

---

## reference counting

- native
    - 更新 reference count 的操作，需要是原子化的
    - 引用太多，导致 count 字段溢出

- 减少更新 reference count 的开销
    - deferred reference counting
        - 引用归 0 时，不马上清理。而是放到一个待处理队列，之后一并清理
    - coalesced reference counting
        - 引用加加减减，不马上更新计数。`+1 -1` 合并处理可以减少不必要的更新操作。
    - buffered reference counting

- 处理循环引用的数据结构
    - 配合 tracing gc
    - 要求区分 strong/weak 引用，不允许出现循环
    - trial deletion。减少计数看下会不会被回收掉

---

## generational


