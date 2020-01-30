# Concurrent Programming in ML

---

## perface

---

> higher-order languages and concurrent languages

> the communication and synchronization operations are first-class values, in
> much the same way that functions are first-class values in higher-order
> languages

high-order language 是说 high-order function
concurrent language 里，通信、同步也是 first-class 的

> the concurrency and process interaction are explicit

具体到 CML 里，不仅是 first-class，还是 explicit 的。

---

> While first-class continuations provided an important mechanism for
> implementing concurrency primitives, they did not provide a mechanism for
> preemptive scheduling, which is key to supporting modular concurrent
> programming.

抢占式的调度，erlang 和 golang 都只做了一半吧。
都是插入调度点，没有做到 time-slice

---

## Introduction

---

> We say that operations in a program are concurrent if they can be executed in
> parallel, and we say that operations in hardware are parallel if they overlap
> in time.

parallel 和 concurrent 的区别，已经被说无数次了。

---

> The power of CML is that a wide range of communication and synchronization
> abstractions can be programmed using a small collection of primitives.

> Its basic model of communication and synchronization is
> synchronous message-passing (or rendezvous) on typed channels.

**synchronous message-passing (or rendezvous) on typed channels**

---

## Concepts in Concurrent Programming

---

> the execution of a concurrent program is nondeterministic

> a concurrent program defines a partial order on its actions,
> whereas a sequential program defines a total order

---

> The concurrency support can be divided into three different kinds of mechanism:
> - process
> - communicate (shared-memory vs message-passing)
> - synchronize

> the choice of synchronization and communication mechanisms are the most
> important aspects of concurrent language design

---

- 如何创建 process，比如 fork/spawn
- process 之间的影响，比如 critical region

---

### shared-memory

> there are two kinds of situations in which synchronization is required between
> processes:
> to avoid interference when accessing shared variables,
> and to ensure that operations are only performed under certain conditions.

- mutex
- condition variables
- semaphore
- monitor (state + mutex)

---

### message-passing

> message-passing imposes an causal order on the actions of the program.

- asynchronous message-passing
    - (in practice, the receive operation is almost always a blocking operation
    - with FIFO ordering, or not
    - an asynchronous channel can be viewed as a semaphore with data
    - flow-control
    - more performance than synchronous message passing
        - but, most uses of asynchronous message passing invoke synchronization via acknowledgement messages
        - it is likely to be more expensive than synchronous message passing
- synchronous message-passing
    - the sender is blocked until its message is received
        - either the sender waits or the receiver waits
        - synchronous message passing is sometimes called rendezvous
    - no extra communication is required for flow-control
    - easier to reason about
- selective communication
    - allows a process to block until one of a choice of operations is possible
    - select from a choice of several blocking communications
        - a polling operation (or non-blocking receive operation)
    - input-only selective communication
        - asymmetric
        - easy to implement efficiently
- remote procedure call
    - disadvantage: it is asymmetric

---


