# compiling with continuations

---

## 01.OVERVIEW

---

- CPS
    - makes every aspect of control flow and data flow explicit
    - easy for optimizing compilers to manipulate and transform

---

- representation
    - λ-calculus (lambda calculus)
    - CPS (continuation-passing style)
        - a restricted form of λ-calculus
    - PDG (program-dependence graphs)
    - QUAD (quadruples, register transfers)
    - SSA (static single-assignment form)
        - a restricted form of quadruples

(variables have a single-binding property in both CPS/SSA

- transformation
    - in-line expansions
    - closure representations
    - dataflow analysis
    - register allocation
    - vectorizing
    - instruction scheduling

---

(how to summary a language

- strict vs lazy
- higher-order function support
- parametric polymorphic types vs overloading
- static type, type inference
- garbage collection
- lexical scope
- side effects vs purely functional
- formally defined semantics

---

- a multipass compiler
    - lexing, parsing, type checking => annotated AST
    - => λ-calculus-like representation
    - => continuation-passing style representation
    - => optimize to a better CPS expression
    - => closure conversion
    - => elimination of nested scopes
    - => "register spilling"
    - => target-machine assembly-language
    - => target-machine instructions

(focus on the use of continuations for optimization and code generation.

---

## 02.CONTINUATION-PASSING STYLE

---


