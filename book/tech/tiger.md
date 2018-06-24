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
