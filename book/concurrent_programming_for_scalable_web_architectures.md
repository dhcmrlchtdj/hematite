# Concurrent Programming for Scalable Web Architectures

---

http://berb.github.io/diploma-thesis/community/index.html

---

## Infrastructures

http://berb.github.io/diploma-thesis/community/033_archmodel.html

---

## concurrency & scalability

http://berb.github.io/diploma-thesis/community/023_concurrency.html

---

concurrent 主要从三个方面提高性能

+ reduce latency
    大任务被拆分成小任务，通过并行执行小任务来缩短总时间。
+ hide latency
    遇到必须等待的任务时，切换到另一个可以立刻执行的任务。
+ increase throughput
    同时执行多个任务，能提高整体吞吐量

---

concurrency 是程序的某种属性。
两个任务的执行时间发生重叠，就可以认为是 concurrency。
比如 A 执行到一半，先去执行 B，之后再继续执行 A。

parallelism 是运行状态。
两个任务是同时执行的，才是 parallelism。
比如一台双核的机器执行 A 和 B。

concurrent 的难点在于执行顺序的控制。
parallel 则是确定的顺序。

---

+ sequential concurrency
    显式的流程控制，比如 coroutine
+ declarative concurrency
    隐式的流程控制，比如事件
+ message-passing concurrency
    任务之间，只运行通过某种机制传递消息。
+ shared-state concurrency
    多个任务可以贡献一个状态。需要注意一致性和正确性。

---

vertical scale 是增强节点的能力。比如双核变四核
horizontal scale 是增加节点。比如一台变两台

---

## IO models

http://berb.github.io/diploma-thesis/community/041_overview.html
https://groups.google.com/forum/#!msg/python-tornado/FKzsUYdjmJs/k-8laTZU1lwJ

synchronous 执行结束后，将结果返回给调用方
asynchronous 调用后，在执行结束前返回，并提供某种机制，让调用方能拿到结果

non-blocking 通常用于描述 网络IO 或者 磁盘IO，在等待结果时，不会被阻塞。

---

synchronous 和 asynchronous 是如何调用函数函数。
结果就是需要的值，属于 synchronous。
需要通过 promise/callback 之类的方式获取，属于 asynchronous。

blocking 和 non-blocking 描述的是调用的结果。
结果完整返回了，属于 blocking。
结果部分返回，甚至没有返回，属于 non-blocking。

---

+ 大部分普通调用，都是 synchronous blocking 的，比如文件读写的 read/write。
    每次调用，都是等操作完成后返回需要的结果。
+ 设置了 O_NONBLOCK 的 read/write 就是 synchronous non-blocking 的。
    每次调用，都是马上返回当前准备好的结果，完整的数据可能需要多次调用，比如配合 epoll。
+ 像 node 的 fs 等，就属于 asynchronous non-blocking。
    每次调用都直接返回，实际数据通过 callback 的方式获取。
+ asynchronous blocking 的奇葩，不知道有什么常见例子。
    我理解是需要等待操作完成，但是却不直接返回，而是要通过 callback 之类的方式获取结果。
