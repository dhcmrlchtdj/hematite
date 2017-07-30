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

## The Heap-Based Model

---

- caller build call frame
    - actual parameters
    - link to caller's stack frame
    - return address
- caller jump to callee
    - push local variables to stack
- callee return to caller
    - reset the frame link
    - remove the frame
    - jump to the return address

> the state of each active call is recorded on the stack, and this state is
> destroyed once the call has been completed.

stack-based 的一般流程。
每次函数调用都是创建一个新的 call frame。
函数返回就是销毁当前 frame 并跳转回之前的位置。

但是 scheme 要求支持 continuation，前面这种直接销毁 frame 的方式无法满足要求。
所以考虑用 heap，把 call frame 和 environment 都放到 heap 上。

> Recall that a continuation is a closure that, when invoked, returns control to
> the point where the continuation was obtained.

---

- data structure to support the core of scheme
    - environment
        - a list of pairs of lists, `env = (var list, val list) list`
        - 提及了一个优化，将 variables 干掉，只保留 values。eopl 里的 nameless 吗
    - call frame
        - pending computation
        - `call frame = (next_expression, env, rib, next_frame)`
        - 上面的 rib 是用于记录已经计算出的 argument 的值
    - control stack
        - `stack = frame list`
        - current -> previous -> previous previous
    - closure
        - `closure = (body, env, var list)` / `closure = (body, env)`
    - continuation
        - a special closure containing a reference to the current frame

---

> in order not to build up the control stack on a tail call, a new call frame is
> not added to the stack.

EOPL 里反复提及这点。
tail position 进行函数调用，可以不增加额外的 control context。

---


