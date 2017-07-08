# eopl

---

## 0. preface

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

## 1. Inductive Sets of Data

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

## 2. Data Abstraction

---

> Chapter 2 introduces a data type facility.
> This leads to a discussion of data abstraction and examples of
> representational transformations of the sort used in subsequent chapters.

- 数据抽象
- 不同数据表示直接的转换

---

> Data abstraction divides a data type into two pieces: an interface and an implementation.

- abstract data type
- interface / implementation
- data abstraction, opaque vs transparent

数据抽象，接口与实现分离，让改动只在小范围里进行。

- representation-independent
- constructor: build elements of the data type
- observer: extract information from values of the data type

---

- environment: associate variables with values

后面就是用各种表示方式来实现 environment 的接口

- procedural representation: data is represented by procedure
- defunctionalized representation

---

> A domain-specific language is a small language for describing a single task
> among a small, well-defined set of tasks.

扯到了 DSL，但这里其实只是在定义类型然后 pattern match，
也就是 constructor 和 observer。

---

- concrete syntax, external representation
- abstract syntax, internal representation
- abstract syntax tree
- parser, parsing, parser generator

基本还是概念性的东西

---

## 3. Expressions

---

> illustrate the binding and scoping of variables by implement interpreters.

> environment: keeps track of the meaning of each variable in the expression
> being evaluated.

本章重点，environment 以及 scope。

---


