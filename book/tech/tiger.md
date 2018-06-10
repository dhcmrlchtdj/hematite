# morden compiler implementation in ml

---

## introduction

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

## lexical analysis

---

- specify lexical tokens using **regular expressions**
- implement lexers using **deterministic finite automata**
- RE - NFA - DFA
- **lexical analyzer generator** translate REs into a DFA

---

## parsing

---

- context-free grammar
- recursive descent
- ambiguous grammar
- eliminating left recursive

---

## abstract syntax

---

- semantic actions
    - the values returned by parsing functions
    - or, the side effects of parsing functions
- abstract parse tree / concrete syntax tree
- positions (for error report)


---

## semantic analysis (type-checking)

---

- symbol tables (environments)
    - mapping identifiers to types and locations
    - efficient
        - hash table for imperative
        - binary search tree for functional

