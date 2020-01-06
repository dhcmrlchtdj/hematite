# java ForkJoinPool

---

https://github.com/openjdk/jdk/blob/master/src/java.base/share/classes/java/util/concurrent/ForkJoinPool.java

- WorkQueues
    - work-stealing queues
    - a deques that support push, pop, and poll(steal)
- 呃

---

http://gee.cs.oswego.edu/dl/papers/fj.pdf

## design

- standard thread frameworks are just too heavy to support most fork/join programs
- optimization for fork/join design
    - a pool of worker threads
    - all fork/join tasks are instances of executable, not instances of thread
    - queue and schedule
    - control and management facility
- work-stealing
    - each worker thread has own scheduling queue
    - scheduling queue is a deque, support LIFO push/pop and FIFO take
    - subtask will be add to worker's task queue
    - worker process deque in LIFO order
    - when local deque is empty, worker will attempt to take (steal) tasks from another worker, in FIFO order
- LIFO for own tasks, but FIFO for stealing other tasks
    - this is optimal for a wide class of recursive fork/join design
    - owner 和 stealer 从不同的方向去获取任务，减少线程冲突
    - 该框架处理的大都是 divide-and-conquer 的任务，FIFO 顺序被偷取的任务会是比较大的任务
        - 之后大任务分解成小任务，是线程内操作，不需要继续偷取
- example

```kotlin
class Fib(n: Int) : ForkJoin.Task {
    val num = n
    val threshold = 13

    var ans: Int

    fun fib(n: Int) : Int = when (n) {
        in 0..1 -> n
        else -> fib(n-1) + fib(n-2)
    }

    fun run() {
        if (num < threshold) {
            ans = fib(num)
        } else {
            val f1 = Fib(n-1)
            val f2 = Fib(n-2)
            ForkJoin.coInvoke(f1, f2)
            ans = f1.ans + f2.ans
        }
    }
}

fun main() {
    val groupSize = Runtime.getRuntime().availableProcessors()
    val group = ForkJoin.RunnerGroup(groupSize)
    val f = Fib(35)
    group.invoke(f)
    println("fib(35)=${f.ans}")
}
```
