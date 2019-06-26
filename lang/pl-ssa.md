# SSA

--

https://en.wikipedia.org/wiki/Static_single_assignment_form

---

- Static Single Assignment form
- Intermediate Representation
- Control Flow Graph

- SSA is a property of an IR
    - each variable is assigned exactly once
    - every variable is defined before it is used
- SSA is equivalent to a subset of CPS excluding non-local control flow

- SSA simplifies the properties of variables
    - which simplifies and improves the results of a variety of compiler optimizations

- SSA 是对 IR 的限制（变量先声明后使用，且只能赋值一次），这让编译器的优化变得更简单更高效

---

- how to convert ordinary code into SSA form
    - replacing the target of each assignment with a new variable
    - replacing each use of a variable with the version of the variable reaching that point
- how to merge two nodes
    - Φ (phi) function
    - x3 = phi(x1, x2)
- given an arbitrary CFG, how can I tell where to insert Φ functions, and for what variables
    - dominance frontiers

---

- dominator
    - a node A *strictly dominates* a different node B in the control flow graph
        if it is impossible to reach B without passing through A first
    - A dominates B: A strictly dominates B OR A = B
    - 处理 B 之前，A 要么处理过了（A strictly dominate B），要么正在处理（A=B） （充要条件
- dominance frontier
    - a node B is in the dominance frontier of a node A
        if A does not strictly dominate B,
        but does dominate some immediate predecessor of B
    - A 可以到 B，同时存在其他路径到 B （充分不必要条件
- where we need Φ functions
    - variables defined in node A
    - entering the dominance frontiers of node A
    - 从 A 路线进入 B 的时候，考虑到有其他路线可能定义了相同的变量，所以需要一个 phi function
