# Build Systems a la Carte

---

- a general framework to understand and compare build systems
- two key design choices
    - the order in which tasks are built (the scheduling algorithm)
    - whether or not a task is (re-)built (the rebuilding strategy)
- scheduling algorithm
    - topological
    - restart
    - suspend
- rebuilding strategy
    - dirty bit
    - verifying trace
    - constructive trace
    - deep/deterministic constructive trace

---

- topological
    - build a graph
    - traverse graph
- restart
    - build a rule
    - cancel this rule, schedule it last, build dep
- suspend
    - build a rule
    - pause this rule, build dep, resume

---

- dirty bit
    - a rule is dirty if anything it depends on is dirty
- verifying trace
- constructive trace (cloud build, distributed build systems)
- deep/deterministic constructive trace
    - the output of a rule depends only on its input (deterministic)
    - not support cut-off

---
