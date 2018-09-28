# Operating Systems: Three Easy Pieces

---

http://pages.cs.wisc.edu/~remzi/OSTEP/

---

three pieces

- virtualization
- concurrency
- persistence

---

mechanisms: how to do
policies: what to do
mechanism enable policy

---

locality: spatial, temporal

---

## virtualization

### CPU, process
- process
    - running, ready, blocked (IO, schedule
    - fork() then exec()
    - user mode, kernel mode, system call, trap
    - cooperative, preemptive (time interrupt)
    - context switch
- schedule metrics
    - turnaround time
    - response time
- scheduling policies
    - FIFO
    - SJF, Shortest Job First
    - STCF, Shortest Time-to-Completion First / preemptive shortest job first
    - RR, Round-Robin / time-slicing
    - MLFQ, multi-level feedback queue
        - queues with different priority level
        - choose first job from the highest priority queue
        - RR for same priority
        - new job has the highest priority
        - if job used all time, reduce priority
        - periodically boost all jobs to the highest priority
    - proportional-share / fair-share
        - lottery scheduling
            - ticket
            - random
        - stride scheduling
            - deterministic
- multiprocessor scheduling
    - differences (vs single-CPU)
        - cache locality
        - synchronization / lock
        - cache affinity
    - scheduling
        - SQMS, single-queue multiprocessor scheduling
            - BF scheduler, proportional-share
        - MQMS, multi-queue multiprocessor scheduling
            - O(1) scheduler, MLFQ like
            - CFS, completely fair scheduler, stride like

### memory, address space
- memory
    - malloc(), free(), GC
    - code, heap, stack
- address translation
    - dynamic relocation / hardware-based / base register and bounds register
    - static relocation / software-based
    - segment, sparse address space
- allocation
    - best fit, worse fit, first fit, next fit
    - slab allocator, segregated list, size pool
    - buddy allocator, binary
- paging
    - vs segmentation
    - segmentation: chop up object to variable-size
    - paging: chop up space to fixed-size
    - page table, store address translation, map virtual page number to physical page number, per process
    - paging is too slow and too big
    - TLB, Translation-Lookaside buffer, address translation cache, hardware-managed TLB, TLB context switch
    - hybrid paging and segment, get rid of invalid regions
    - multi-level page tables, also get rid of invalid regions
- swap
    - present bit
    - page-fault handler
    - cache missing: cold-start miss, capacity miss, conflict miss
    - policy: FIFO, random, LRU, LFU,

---

## concurrency

- event
    - easier than thread, control schedule
    - block vs non-block, synchronous vs asynchronous
    - rule: no blocking calls are allowed
    - polling vs interrupt
    - hybrid: event for network packets, thread pool for other IO
    - state management, callback, continuation

- thread
    - share the same address space (heap)
    - thread-local variable (stack)
    - parallelism (faster), avoid block IO, easy to share data
    - uncontrolled scheduling, the result depend on the timing execution of code

- problems
    - non-deadlock
        - atomicity violation, need lock
        - order violation, need condition variables
    - deadlock
        - livelock

- lock
    - evaluate: correctness, fairness, performance
    - lock(), unlock()
    - disable interrupt while locked
    - spin lock, spin-wait
        - test-and-set instruction
        - compare-and-exchange instruction
        - fetch-and-add instruction
    - without spin: yield, sleep

- condition variables
    - wait(), signal()
    - hold the lock when calling wait or signal
    - always use while loop (not if)
    - producer/consumer, bounded buffer

- semaphores
    - sem_post(), sem_wait()
    - binary semaphore, lock
    - reader-writer lock
    - can be implement by lock and condition variables

---

## persistence

- IO
    - memory bus, IO bus, peripheral bus
    - interface: status, command, data
    - polling, interrupt, hybrid

- RAID
    - large, fast, reliable; capacity, reliability, performance
    - chunk size
    - parallelism reads/writes to multi-disk
    - RAID0, striping
        - no redundancy, good capacity, good performance
    - RAID1, mirroring
        - mirror level 2, keep 2 physical copy of 1 logical chunk, RAID10
        - consistent-updata, write-ahead log
        - well redundancy, expensive capacity, performance ok
    - RAID4, save space with parity
        - XOR, 4disk plus 1parity
        - performance ok, capacity ok, tolerate 1 disk failure
        - small-write problem
    - RAID5, rotating parity
        - better than RAID4

- file
    - inode number (each file)
    - dictionary is a map from human-readable name to low-level name (inode)
    - file descriptor, open file table, reference count
    - permission, ACL

- crash consistency
    - fsck
    - journaling (write-ahead logging)

- distributed system
    - failure, performance, security
    - communication
        - checksum for integrity
        - UDP, TCP
        - RPC, remote procedure call, protocol compiler and runtime library
    - stateless, idempotent operations
    - cache consistency
