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

## 08. Typed Arithmetic Expressions

---

