# Why Logical Clocks are Easy

https://queue.acm.org/detail.cfm?id=2917756

---

> The relations of potential cause and effect between events
> are fundamental to the design of distributed algorithms.

> This *external causality* cannot be detected by the system and
> can only be approximated by physical time.

---

- Happened-before Relation
- causal histories => `{a1,a2,b1,b2,b3,c1,c2,c3}`
- vector clocks => `[2,3,3]`
- dotted vector clocks => `[2,1,0]b2 => [2,2,0]`
    - the last event is usually stored outside the vector (and is sometimes called a dot)
    - simplify comparison by simply checking the last event
- version vectors && dotted version vectors

简单理解
- causal history 是 event logs
- vector clock 是 snapshot
- dotted vector clock 就是 snapshot 加最新一个 event
- version vector 其实和 vector clock 差不多
    - 不过每一个节点都有了启始状态
    - 节点内部发出事件，状态变化
    - 收到其他节点的事件后，状态也变化
    - 收到事件，状态变化，是为了更明确事件间的顺序关系
