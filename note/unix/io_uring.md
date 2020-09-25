# io_uring

https://developers.mattermost.com/blog/hands-on-iouring-go/

---

> Whenever we make a blocking syscall, the runtime is aware of it, and it
> detaches the thread from the P executing the goroutine, and acquires a new
> thread to execute other goroutines.
> And when the syscall returns, the runtime tries to re-attach it to a P.
> If it cannot get a free P, it just pushes the goroutine to a queue to be
> executed later, and stores the thread in a pool.

go 里 GMP 模型如何处理 syscall

---

> How do we prevent copies happening from user-space to kernel-space?
> that can be done using the `mmap` system call which can map a chunk of memory
> that is shared between the user and kernel.

mmap 共享内存，避免复制的开销

> synchronization
> we need some way to synchronize data access between us and the kernel.
> A ring buffer allows efficient synchronization between producers and consumers
> with no locking at all.

共享数据，需要 mutex 之类的锁来保证数据同步。
mutex 本身也是 syscall，这里用的方法是 ring buffer。

> we need two ring buffers.
> A submission queue (SQ), where the user acts as the producer and pushes
> syscall requests, and the kernel consumes them.
> And a completion queue (CQ), where the kernel is the producer pushing
> completion results, and the user consumes them.

---

> With such a model, we have eliminated any memory copies and locks entirely.
