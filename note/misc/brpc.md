# brpc

https://github.com/apache/incubator-brpc/tree/master/docs/cn

---

负载

> Little's Law：在服务处于稳定状态时，concurrency = latency * qps。
> 这是自适应限流的理论基础。
> 通常情况下要让服务不过载，只需在上线前进行压力测试，并通过 little's law 计算出 best_max_concurrency 就可以了。

---

队列

> 最有效的解决方法很直白：尽量避免共享。
> 一个依赖全局 多生产者多消费者队列(MPMC) 的程序难有很好的多核扩展性，
> 因为这个队列的极限吞吐取决于同步 cache 的延时，而不是核心的个数。
> 最好是用多个 SPMC 或多个 MPSC 队列，甚至多个 SPSC 队列代替，在源头就规避掉竞争。

---

lock-free

> 值得提醒的是，常见想法是 lock-free 或 wait-free 的算法会更快，但事实可能相反，因为：
> - lock-free 和 wait-free 必须处理更多更复杂的 race condition 和 ABA problem，完成相同目的的代码比用锁更复杂。代码越多，耗时就越长。
> - 使用 mutex 的算法变相带“后退”效果。后退(backoff)指出现竞争时尝试另一个途径以临时避免竞争，mutex出现竞争时会使调用者睡眠，使拿到锁的那个线程可以很快地独占完成一系列流程，总体吞吐可能反而高了。

> mutex 导致低性能往往是因为临界区过大（限制了并发度），或竞争过于激烈（上下文切换开销变得突出）。
> lock-free/wait-free 算法的价值在于其保证了一个或所有线程始终在做有用的事，而不是绝对的高性能。
> 但在一种情况下 lock-free 和 wait-free 算法的性能多半更高：就是算法本身可以用少量原子指令实现。
> 实现锁也是要用原子指令的，当算法本身用一两条指令就能完成的时候，相比额外用锁肯定是更快了。

---

IO

> 而 non-blocking IO 一般由少量 event dispatching 线程和一些运行用户逻辑的 worker 线程组成，这些线程往往会被复用（换句话说调度工作转移到了用户态），event dispatching 和 worker 可以同时在不同的核运行（流水线化），内核不用频繁的切换就能完成有效的工作。
> 线程总量也不用很多，所以对 thread-local 的使用也比较充分。这时候 non-blocking IO 就往往比 blocking IO 快了。
> 不过 non-blocking IO 也有自己的问题，它需要调用更多系统调用，比如epoll_ctl，由于epoll实现为一棵红黑树，epoll_ctl并不是一个很快的操作，特别在多核环境下，依赖epoll_ctl的实现往往会面临棘手的扩展性问题。
> non-blocking 需要更大的缓冲，否则就会触发更多的事件而影响效率。non-blocking 还得解决不少多线程问题，代码比 blocking 复杂很多。

> 当 IO 并发度很低时，non-blocking IO 不一定比 blocking IO 更高效，
> 因为后者完全由内核负责，而 read/write 这类系统调用已高度优化，效率显然高于一般得多个线程协作的 non-blocking IO。
> 但当 IO 并发度愈发提高时，blocking IO 阻塞一个线程的弊端便显露出来：
> 内核得不停地在线程间切换才能完成有效的工作，一个 cpu core 上可能只做了一点点事情，就马上又换成了另一个线程，cpu cache 没得到充分利用，
> 另外大量的线程会使得依赖 thread-local 加速的代码性能明显下降，如 tcmalloc，一旦 malloc 变慢，程序整体性能往往也会随之下降。

---

同步异步

> 判断使用同步或异步：计算 qps * latency(in seconds)，如果和cpu核数是同一数量级，就用同步，否则用异步。
> 这个公式计算的是同时进行的平均请求数，和线程数、CPU 核数是可比的。
> 当这个值远大于 CPU 核数时，说明大部分操作并不耗费 CPU，而是让大量线程阻塞着，使用异步可以明显节省线程资源（栈占用的内存）。
> 当这个值小于或和 CPU 核数差不多时，异步能节省的线程资源就很有限了，这时候简单易懂的同步代码更重要。

> 比如
> - qps = 2000，latency = 10ms，计算结果 = 2000 * 0.01s = 20。和常见的32核在同一个数量级，用同步。
> - qps = 100, latency = 5s, 计算结果 = 100 * 5s = 500。和核数不在同一个数量级，用异步。
> - qps = 500, latency = 100ms，计算结果 = 500 * 0.1s = 50。基本在同一个数量级，可用同步。如果未来延时继续增长，考虑异步。

---

重试

> brpc 中重试默认只在连接出错时发起，避免了流量放大，这是比较有效率的重试方式。
> 如果需要基于超时重试，可以设置 backup request，这类重试最多只有一次，放大程度降到了最低。

> brpc 中的 RPC 超时是 deadline，超过后 RPC 一定会结束，这让用户对服务的行为有更好的预判。
> 在之前的一些实现中，RPC 超时是单次超时*重试次数，在实践中容易误判。
