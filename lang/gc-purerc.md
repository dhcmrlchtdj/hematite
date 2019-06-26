# A Pure Reference Counting Garbage Collector

https://github.com/JetBrains/kotlin-native/blob/v1.3.0/runtime/src/main/cpp/Memory.cpp#L35
https://github.com/dcodeIO/purerc

- 第一次看到这篇论文，是 kotlin native 说自己的用了这个算法。
- 第二次看到这篇论文，是 AssemblyScript 的作者用 JS 实现了一遍（似乎是想用到 AssemblyScript 里？

所以，看一看

---

整体流程不复杂，循序渐进。
先讲 RC，然后并发 RC，接着处理循环引用，再并发。

- synchronous RC
    - 并不是实时回收，而是将操作记录在 buf 里面
    - 等到内存不够了，一次性更新所有计数，清理无用的对象
    - 延迟处理，是个 stop the world 的 RC 算法
    - 实时更新计数，那么计数操作需要保证原子化。延迟处理，放宽了这个限制
    - 这里 synchronous 是 stop the world 的意思
- concurrent RC
    - not parallel
    - producer-consumer system
    - mutator, multi-thread，每个进程都有自己的计数
    - collector, single-thread，专门的进程处理空间
    - mutator 进行 inc/dec 计数，collector 实际回收空间
    - 计数信息，存储在 mutation buffer 里
    - 内存分配再回收的过程，分成一个个 epoch，分阶段处理
    - 每个 epoch，collector 会给 mutator 分配新的 mutation buffer
    - 有了 epoch，可以避免 mutator/collector 在工作时互相影响
- synchronous cycle collection
    - previous work
        - programming idioms
        - tracing collector
        - remove internal reference counts
    - 个人理解
        - 第一种，（大概）是指弱引用
        - 第二种，配合标记清除算法
        - 第三种，（大概）是说先减少引用计数，看资源是否会被回收
    - 用了各种颜色做状态标记

具体实现不展开了，作者给了很多伪代码

---

- 很多场景使用 RC 是为了实时回收，这里用 mutation buffer 实现批量更新，就不实时了。
- 如何处理循环引用
    - 要求用户标明弱引用，等于暴露了具体实现，某些场景可能不适合。
    - 配合标记清除，有没有一种认输的感觉。😂
    - 类似本文的状态标记，或许是比较好的办法吧。
