# Three Implementation Models for Scheme

---

http://www.cs.indiana.edu/~dyb/pubs/3imp.pdf

---

## Introduction && The Scheme Language

---

介绍了三种模型

- heap-based model
- stack-based model
- string-based model

区别在于如何存储 `call frames and variable bindings`。

---

- lexically-scoped
- block-structured
- closures
- continuations
- λ-calculus
- weakly-typed

作者列举了一些 scheme 的特点

closures, assignments, and continuations

---

`(((call/cc (lambda (c) c)) (lambda (x) x)) 'HEY!)`

> This is probably the most confusing Scheme program of its size!

（其实我感觉下面这个更难懂
`((let ([comeback (call/cc (lambda (c) c))]) (comeback (lambda (x) x))) 'HEY!)`

---


