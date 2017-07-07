# eopl

---

## preface

### goal

> What does a program do?
> The study of interpreters tells us this.

### organization

- programming language (1,2)
- interpreter (3)
- state (4)
- CPS interpreter (5,6)
- type checker / type infer (7)
- module (8)
- object-oriented (9)

### usage

> exercises are a vital part of the text and are scattered throughout.

---

## ch1

---

> Chapter 1 emphasizes the connection between inductive data specification and
> recursive programming and introduces several notions related to the scope of
> variables.

- 归纳型数据与递归间的关系
- 变量作用域相关的概念

---

- 程序的结构大都是嵌套的、树形的，而递归在处理这样的结构时是有优势的
- 用归纳法的方式定义数据
    - 比如长度为 0 时怎么样，非 0 时如何变化
- 为定义的每种构造都实现对应的操作
    - 比如长度为 0 时的操作，非 0 时如何操作慢慢减小到 0
- 用递归的方式让问题慢慢缩小
- auxiliary procedure 的参数用途要清晰明了

---

## ch2

---

> Chapter 2 introduces a data type facility.
> This leads to a discussion of data abstraction and examples of
> representational transformations of the sort used in subsequent chapters.

- 数据抽象
- 不同数据表示直接的转换

---

## ch3

---

> Chapter 3 uses these foundations to describe the behavior of programming
> languages.
> It introduces interpreters as mechanisms for explaining the runtime behavior
> of languages and develops an interpreter for a simple, lexically scoped
> language with first-class procedures and recursion.
> The chapter ends by giving a thorough treatment of a language that uses
> indices in place of variables and as a result variable lookup can be via a
> list reference.

- 实现一个解释器

---

## ch4

---

> Chapter 4 introduces a new component, the state, which maps locations to
> values.
> Once this is added, we can look at various questions of representation.
> In addition, it permits us to explore call-by-reference, call-by-name, and
> call-by-need parameter-passing mechanisms.

- 引入 state 的概念
- 如何描述数据
- 不同的参数传递方式

---
