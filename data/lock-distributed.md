# How to do distributed locking

https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html

---

> it is unnecessarily heavyweight and expensive for efficiency-optimization
> locks, but it is not sufficiently safe for situations in which correctness
> depends on the lock.

- what would happen if the lock failed
    - efficiency
    - correctness

---

- for efficiency
    - use a single Redis instance (5 replicas with majority voting, which is too complex for simple case)
    - it is clear to everyone who looks at the system that the locks are approximate, and only to be used for non-critical purposes

---

- lock
    - lease (can be implemented by timeout)
        - prevent data from locking by dead node
        - problem
            - stop-the-world while lease renew
            - then lease be released
            - the other worker take the lock
            - then two worker hold the same lock
        - how to solve
            - lease with fencing token (for example, strictly monotonically increasing number)
            - data will reject worker whois token is invalid (just like http If-Match)

---

- for correctness
    - use a proper consensus system (like ZooKeeper)
