# Types and Programming Languages

---

## Instroductory

---

### 01. Introduction

---

> there are two major branches to the study of type systems.
> The more practical, which concerns applications to programming languages, is
> the main focus of this book.
> The more abstract focuses on connections between various "pure typed
> lambda-calculi" and varieties of logic, via the Curry-Howard correspondence.

---

- Detecting Errors
- Abstraction
- Documentation
- Language Safety
- Efficiency

---

### 02. Mathematical Preliminaries

---

## Untyped Systems

---

### 03. Untyped Arithmetic Expressions

---

- three basic approaches to formalizing semantics
    - operational semantics，通过定义一个 abstract machine 来定义如何处理语义
        - structural operational semantics (small-step)
        - natural semantics (big-step)
    - denotational semantics
    - axiomatic semantics

- operational semantics 是目前研究最深入的（？）
- 为什么叫 small-step，因为过程是每次替换一点点 term，直到变成一个 value

---

### 04. An ML Implementation of Arithmetic Expressions

---

### 05. The Untyped Lambda-Calculus

---

> In lambda-calculus, all computation is reduced to the basic operations of function definition and application

关于 lambda-calculus，PLLC 里内容更丰富

---

### 06. Nameless Representation of Terms

---

在 EOPL 里也降到 nameless 这种优化。
我理解，主要的好处就是把查询环境变量变成一个 O(1) 的操作。

---

### 07. An ML Implementation of the Lambda-Calculus

---

## Simple Types

---

### 08. Typed Arithmetic Expressions

---

> Properties of the typing relation will often be proved by induction on
> derivation trees, just as properties of the evaluation relation are typically
> proved by induction on evaluation derivations.

- the most basic property of type system is safety (soundness)
- a well-typed term can never reach a stuck state during evaluation
    - stuck state: a closed term is stuck if it is in normal form but not a value.
- Safety = Progress + Preservation
    - Progress: A well-typed term is not stuck (either it is a value or it can take a step according to the evaluation rules).
    - Preservation: If a well-typed term takes a step of evaluation, then the resulting term is also well typed.

---

到这里为止，所有的内容还是比较易读的。
不过这个易读的前提，是已经有了一定的知识储备。

---

### 09. Simply Typed Lambda-Calculus

---


