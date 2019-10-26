# java concurrency in practice

---

## fundamentals

- manage access to shared, mutable state
    - it is the core of writing thread-safe code
    - protect data from uncontrolled concurrent access
- don't share, or immutable, or synchronization
- synchronization (in java)
    - synchronized, volatile, locks, atomics
- race condition: read-modify-write, check-then-act, ...
- reentrancy means that locks are accquired on a per-thread rather than per-invocation basis
    - if a thread tries to acquire a lock that it already holds, the request succeed.

- memory visibility
    - in the absence of synchronization, the Java Memory Model permits
        - the compiler to reorder operations and cache values in registers
        - CPUS to reorder operations and cache values in processor-specific caches
- volatile variable will not reorder or cache by compiler/CPU
    - volatile is a weaker form of synchronization
        - locking can guarantee both visibility and atomicity
        - volatile variables can only guarantee visibility
    - more fragile and harder to understand than synchronized
    - 根据 Java Memory Model，不保证 64bit 操作的原子性（允许分解成两个 32bit 操作
- thread confinement
    - data is confined to a thread, if it is invisible to other threads
    - thread-local variables

- ownership
    - for better or worse, garbage collection lets us avoid thinking carefully about ownership
    - the garbage collector reduces the cost of many of the common errors in reference sharing, enabling less-than-precise thinking about ownership

- BlockingQueue - producer/consumer
- Deque - work stealing

---

## structuring concurrency applications

---

## liveness, performance, testing

---

## advanced topics

- a intrinsic lock is always released in the same basic block in which it was accquired
- fairness has a significant performance cost because of the overhead of suspending and resuming threads

- build state-dependent class upon state-based preconditions (Semaphore, BlockingQueue, ...)
- build your own synchronizer using condition queues, Condition/Lock, AbstractQueuedSynchronizer

- notifyAll is preferred than notify
    - single notification is prone to a problem akin to missed signals
    - condition queue maybe used for different condition preditions
    - notify is only used for
        - uniform waiters
        - one-in, one-out

- nonblocking: failure or suspension of any thread cannot cause failure or suspension of another thread
- lock-free: at each step, some thread can make progress

- nonblocking algorithms
    - use low-level atomic machine instructions (such as compare-and-swap) instead of locks
    - like locking, compareAndSet provides both atomicity and visibility guarantees
    - how to limit the scope of atomic changes to a single variable while maintaining data consistency
    - some work is done speculatively and may have to be redone
        - 感觉有点像 spin-lock ?
        - nonblocking 在主动 poll，而 lock 在等待 push

- ABA problem
    - arise in algorithms that do their own memory management for link node objects
    - primarily in environments without garbage collection
    - a CAS effectively asks "Has the value of V changed since I last observed it to be A?"
        - if V changed from A to B and back to A
        - it changed, but CAS doesn't know
    - solution
        - letting the garbage collector manage link nodes for you
        - instead of updating the value of a reference, update a pair of values, a reference and a version number

- JMM (java memory model)
    - happens-before
        - partial ordering
            - transitive, irreflexive, antisymmetric
            - 传递性（ A happens-before B 且 B happens-before C 则 A happens-before C
            - 非自反（ 不能 A happens-before A
            - 非对称（ A happens-before B，就不可能 B happens-before A
        - JVM is free to reorder two operations if there is no happens-before relationship
        - lock 之类的同步原语形成了 happens-before 的关系图
    - double-checked locking (DCL) - antipattern
        - just use lazy initialization holder class
        - static initializers are run by the JVM at class initialization time, after class loading but before the class is used by any thread
