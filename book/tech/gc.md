# the garbage collection handbook

---

## mark-sweep
## mark-compact

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

