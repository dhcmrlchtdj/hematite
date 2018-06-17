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

### activation records

### translation to intermediate code

### basic blocks and traces

### instruction selection

### liveness analysis

### register allocation

---

## Part II Advanced Topics

---
