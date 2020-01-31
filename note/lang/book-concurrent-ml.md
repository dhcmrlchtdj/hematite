# Concurrent Programming in ML

---

## Perface

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

## An Introduction to Concurrent ML

---

> since SML provides updatable references, this is a fiction that must be
> maintained by programming style and convention

concurrent language 还是应该完全重新设计。

---

### thread

```ocaml
val spawn : (unit -> unit) -> thread_id
val exit : unit -> 'a
```

> CML does not attach any semantics to the parent-child relationship.

> the termination of the parent thread does not affect the child.
> once created, the child thread is an independent agent.

> such an exception is local to the thread in which it is raised;
> it does not propagate to its parent.

这个设计和 go 类似。不过我觉得 structural concurrency 更好。

> the CML run-time system uses periodic timer interrupts to provide
> preemptive scheduling.

抢占式调度是我比较喜欢的。
文中说到，抢占式有个好处，可以直接复用普通代码，不需要加调度逻辑。

> incorporating sequential code into a concurrent program still requires some
> care, since the code may not be reentrant
> (it may use globally allocated mutable data structures)

也不能完全无脑就是了。
如果一开始就是 concurrent language，只有 message-passing，是不是就没问题了呢

---

### channel

```ocaml
type 'a chan
val channel : unit -> 'a chan
val recv : 'a chan -> 'a
val send : ('a chan * 'a) -> unit
```

> message passing is synchronous.
> message passing involves both communication of data and synchronization.

用于通信和同步

> do not name the sender or receiver
> do not specify a direction of communication
> more than one thread may attempt to send or recv a message on the same channel

chan 的特点

---

### selective communication

```ocaml
val select : 'a event list -> 'a
```

> allow a thread to block on a nondeterministic choice of several blocking
> communications -- the first communication that becomes enabled is chosen.
> If two or more communications are simultaneously enabled, then one is chosen
> nondeterministically.

> The select operator is actually syntactic sugar for the composition of the
> sync operator and the choose event combinator.

这个 event combinator 见下文

---

### first-class synchronous operations

```ocaml
type 'a event

(* base-event constructors *)
val sendEvt : ('a chan * 'a) -> unit event
val recvEvt : 'a chan -> 'a event

(* operator *)
val sync : 'a event -> 'a

(* event combinators *)
val choose : 'a event list -> 'a event
val wrap : ('a event * ('a -> 'b)) -> 'b event
val guard : (unit -> 'a event) -> 'a event
```

> The basic idea is to decouple the description of a synchronous operation
> (e.g., "send the message m on channel c") from the actual act of
> synchronizing on the operation.

chan 操作，可以通过 event 操作组合出来的

```ocaml
val select : 'a event list -> 'a
let select evt_list = evt_list |> choose |> sync

val recv : 'a chan -> 'a
let recv ch = ch |> recvEvt |> sync

val send : ('a chan, 'a) -> unit
let send (ch, x) = (ch, x) |> sendEvt |> sync
```

> The purpose of this separation is to permit user-defined communication and
> synchronization abstractions that are "first-class citizens."

---

## The Rationale for CML

---

> (this chapter) focus on core CML -- synchronous message passing plus the event
> combinators.

> The actual side-effects are hidden in the context switching and communication
> operations.

> combining synchronization and communication into the same mechanism provides a
> more robust programming model than shared-memory with mutex locks and
> condition variables.

CML 的核心是 message-passing
把 synchronous 和 communicate 合并为一个流程，提供了一个更好的并发模型

---

> how much synchronization should be provided

最终 CML 选择的是同步模型，下面是一些论据

> Asynchronous message passing can be implemented with very low overhead.
> Programs based on asynchronous message passing often require sending
> acknowledgement messages explicitly; once the cost of these extra messages is
> factored in, the performance advantages of asynchronous message passing may be
> lost.

asynchronous channel 实现起来性能更好，但开发中性能优势并不成立。

> Synchronous message passing also has the advantage that its failure mode is
> typically deadlock

synchronous channel 排查异常更容易

> If this protocol is based on synchronous message passing, then the semantics
> of the local and distributed implementations are different.

使用 synchronous channel 需要区别对待远程通信和本地通信。
使用 asynchronous 能有更一致的模型。
不过作者认为，远程、分布式的场景，差异很大，本来就应该单独处理。

---

## Implementing Concurrency in SML/NJ

---

- callcc
- coroutine
- shared-memory
    - mutex
    - condition variable
    - concurrent-read, exclusive-write
- message-passing
    - asynchronous
    - synchronous
    - selective communication

---

> using the shared-memory primitives of the previous section, one can implement
> higher-level concurrency mechanisms, such as message-passing primitives.

> represent channels as a pair of queues:
> one for pending sends and one for pending receives.

在 shared-memory 的基础上，实现 message-passing

> The select operation is structured into three phases:
> first it polls for available input; if all of the channels are empty, then it
> waits for input; and when resumed, it removes the unused input continuations.

---

```ocaml
type 'a event = ('a cont -> 'a)
```

> an event value can be represented as a function that
> abstracts over the resumption continuation

直接实现 message-passing，可以先用 continuation 实现 event，再用 event 实现 channel。
不过这种方式，无法实现 select 操作。

---

> CML uses preemptive thread scheduling.
> This is done in a straightforward manner using an interval timer provided by
> the operating system, and the SML/NJ signal mechanism.
> The interval timer is set to generate an alarm signal every n milliseconds
> (n is typically in the range from 10 to 50).
> CML installs a signal handler that forces a context switch on each alarm.

以前看 EOPL 是靠指令数量来分片的，这里 CML 是靠系统时钟。

> The implementation of CML uses a two-level scheduling queue; interactive
> threads are scheduled out of the primary queue, while computationally
> intensive threads are sched- uled out of the secondary queue.
