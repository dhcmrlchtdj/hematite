# morden compiler implementation in ml

---

## Part I Fundamentals of Compilation

---

### introduction

---

- phases
    - lex
    - parse
    - semantic action
    - semantic analysis
    - frame layout
    - translate
    - canonicalize
    - instruction selection
    - control flow analysis
    - dataflow analysis
    - register allocation
    - code emission

---

### lexical analysis

---

- specify lexical tokens using **regular expressions**
- implement lexers using **deterministic finite automata**
- RE - NFA - DFA
- **lexical analyzer generator** translate REs into a DFA

---

### parsing

---

- context-free grammar
- recursive descent
- ambiguous grammar
- eliminating left recursive

---

### abstract syntax

---

- semantic actions
    - the values returned by parsing functions
    - or, the side effects of parsing functions
- abstract parse tree / concrete syntax tree
- positions (for error report)

---

### semantic analysis (type-checking)

---

- symbol tables (environments)
    - mapping identifiers to types and locations
    - efficient
        - hash table for imperative
        - binary search tree for functional

- two separate name spaces
    - types
    - functions and variables

- type-checker is a recursive function of the abstract syntax tree

- mutually recursive types/functions
    - first pass, gather "header" information to the ENV
    - second pass, process "body" in the ENV
    - (implement by `ref`

---

- 这章主要是演示了一下如何实现 type-checker
- 示例代码很多

---

### activation records (stack frames)

---

- 用 stack 来支持变量
    - 本章不考虑高阶函数，所以不支持闭包
    - 变量要支持读写，所以仅有 push/pop 是不够的
- stack
    - frame pointer
    - stack pointer
- 嵌套函数能够访问上层变量，这种特性被叫做 block structure
    - 实现方式有 static link / display / lambda lifting
    - lambda lifting
        - 把闭包需要的环境变量，都改写成显式参数传递，这样就没有 free variable 了
        - 再把闭包提出来，就没有嵌套函数了

- 研究发现函数的参数一般少于四个，几乎都不超过六个。然后编译器会在这个假设的基础上做优化。（这都行 🙄️

---

### translation to intermediate code

---

- intermediate representation

---

### basic blocks and traces

---

### instruction selection

---

### liveness analysis

---

- control-flow graph

---

### register allocation

---

## Part II Advanced Topics

---

### garbage collection

---

- mark-and-sweep collection
    - DFS (non recursive) 递归的栈使用可能非常大
    - pointer reversal 重复利用回收的空间
    - fragmentation 空间的碎片化问题
- reference counts
    - problems: cycle reference, operation is expensive
- copying collection
    - from-space and to-space
        - to-space is compact (no fragmentation)
    - forwarding pointers
    - Cheney's algorithm (BFS, simple but poor locality)
    - DFS (better locality, but inconvenient and slow)
- generational collection
    - newly created objects are likely to die soon
- incremental/concurrent collection
    - tricolor marking (white, grey, black)
    - invariants
        - no black object points to a white object
        - every grey object is on the collector's data structure
    - allow mutator to get work done while preserving the invariants
    - write-barrier algorithm
        - each write by mutator must be checked to make sure an invariant is preserved
    - read-barrier algorithm
        - each read instruction must be checked
    - write/read barrier must synchronize with collector
    - Baker's algorithm
        - based on Cheney's copying collection algorithm

---

- data layout
    - 比如 ocaml 好像是有 1bit 数据表示类型？
- generational, tricolor mark-and-sweep 算是标配吗

---

### object-oriented language

---

- inheritance
    - single
    - multiple
- runtime type-tag
- class (static) / prototype (dynamic)

---

### functional programming language

---

- flavors
    - impure, higher-order functions (ML, scheme)
    - strict, pure, higher-order functions (pure functional subset of ML)
    - non-strict, pure, higher-order functions (Haskell)
- closures (runtime representation)
- continuations
- inline expansion
- lazy

---

### polymorphic types

---

- polymorphic (many shape)
    - parametric polymorphic (generic)
    - ad hoc polymorphic (overloading)
        - dynamic overloading (overriding)
- type constructor
- Hindley-Milner type inference

---

- fully boxed
- coercion-based
- types as runtime arguments

---


