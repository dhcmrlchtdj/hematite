# compiling with continuations

---

## 01. OVERVIEW

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

## 02. CONTINUATION-PASSING STYLE

---

in a well-formed CPS expressions
- the arguments to a function are always atomic (variables or constants)
- a function application can never be an argument of another application

- 会有这种性质，是因为这是在对冯诺伊曼机进行建模，每次操作的参数都是寄存器的值
- 程序的控制流（control flow）在转换到 CPS 时确定了，比如参数的求职顺序。
- 所有的函数调用，都变成了尾调用。

---

## 03. SEMANTICS OF THE CPS

---

> In the CPS language it is possible to write syntactically correct but meaningless programs.

这就是类型系统想解决的问题呀

---

## 04. ML-SPECIFIC OPTIMIZATIONS

https://dev.realworldocaml.org/runtime-memory-layout.html

---

> most optimizations (partial evaluation, dataflow, register allocation, etc.) are done in the CPS representation.

在编译成 CPS 之前，可以进行一些语法、类型相关的优化。

---

## 05. CONVERSION INTO CPS

---

- 把 lambda lang 转换成 CPS lang

- pattern match

- exception handling
    - 作者给了两个方案，但是不管哪个，其实都是将 handler 存储在某个地方
    - 方案一是全局变量，每次 handle 就写入新处理函数，raise 就读取执行
    - 方案二是作为函数参数传递
    - 全局变量 还是 函数参数，这种取舍其实日常也经常会碰到
    - https://stackoverflow.com/questions/8564025/ocaml-internals-exceptions/8567429#8567429
        - When a try `expr` with `handle` is evaluated, a "trap" is placed on the stack, that contains information about the handler.
        - A trap also stores the address of the previous trap, which is restored in the register at raise time.

- callcc

---

## 06. OPTIMIZATION OF THE CPS
## 07. BETA EXPANSION
## 08. HOISTING
## 09. COMMON SUBEXPRESSIONS

---

- 转换成 CPS 之后，还有三步
    - CPS optimization
        - more efficient
        - 通过优化，得到相同语义，但是更高效的 CPS 表示
    - closure introduction
        - unnest all functions and simplify the environments of variable bindings
        - 让程序贴近 von Neumann machine 的表达方式（毕竟机器码没有 closure 的概念
    - abstract machine-code generation

- 06-09 这几章都在讲 CPS 优化

- beta-reduction
    - 也就是函数 inline
    - 属于比较危险的优化，不一定是有效，甚至可能负优化

- hoisting
    - narrow or broaden the scope of a variable in the CPS representation
    - conservative approach: an operator will be hoisted only when the transformation is guaranteed to reduce execution time
    - greedy approach: bottom up. for each FIX, we first attempt to push it down to join another FIX, if that fails, we pull the IFX up as far as its scope will allow

- common-subexpression elimination
    - 要考虑到，提取出来的公共表达式可能会出异常，影响原本的执行流程

（必须吐槽，一堆 CPS IR 在一起，肉眼 parse 的成本挺高的。

---

## 10. CLOSURE CONVERSION

---

- 虎书里也有一节专门讲 activation records

```ocaml
let g : int -> (int -> int) = fun x ->
    let f = fun y -> x + y in
    f
```

- 以上面这个代码为例
    - the function f is statically nested inside the function g
    - f can refer to the variables of g
- access links: the activation for the function f contains a pointer to the activation record for g
- (pass f as an argument) a pair comprising the machine-code address for f and the activation record for g is passed
    - such a pair is called a closure
- closure
    - the variables in the activation record of g may now be used after g has returned
    - activation records can no longer be stored on a stack, but must instead be allocated on a heap

---

- closure-passing style
    - representing closures as explicit records does not require the use of continuations
- after closure conversion
    - the function k is now a closure record
    - k' is a function without free variables, which can thus be represented as just a machine-code pointer

---

- closure representation
    - how free variables are to to be arranged in the closure record
    - flat vs linked
        - 顾名思义，展开成 array 那样的或者使用 linked-list 那种链表的形式
- closure allocation
    - It is not at all clear that stack allocation is worthwhile.
    - Garbage collection need not be particularly expensive, so the difference in cost between stack allocation and heap allocation is not large.
    - 至少 SML/NJ 用的是 heap allocation，而且他们觉得自己性能不错
    - callcc 对于 stack allocation 也是个问题
        - any continuation or downward-escaping function may have an arbitrary extent

---

## 11. REGISTER SPILLING
## 12. SPACE COMPLEXITY
## 13. THE ABSTRACT MACHINE
## 14. MACHINE-CODE GENERATION

---

> The spill phase of the CPS compiler comes after closure conversion; its job is
> to produce a CPS program obeying the rule that every subexpression has fewer
> than N free variables, where N is the number of registers on the target machine.

---

> Another advantage of continuation-passing style for reasoning about garbage
> collection is that there is no "runtime stack" of activation records. Only the
> local variables of the current procedure (the procedure executing when the
> collector is invoked) are "roots" of garbage collection.

tracing gc 需要 root set

> Starting with some "root set" of variables, the collector traverses all values
> reachable from those variables, reclaiming the storage of the unreachable values.

然后就是如何找到 root set

> Upon entry to a function f(x), the value f is reachable, and the values x are
> reachable.

> This definition implies that it is permissible to invoke the collector only at
> the beginning of a function.
> In the CPS representation (after the spill phase), each variable will
> correspond to a machine register; the collector can just use the registers as
> roots of the reachable graph. At the beginning of each function, a test can be
> made for exhaustion of the free space, and the garbage collector can be
> conditionally invoked.

---

- 定义了 abstract-continuation-machine 这么一个 IR
    - translate CPS into abstract-continuation-machine instructions
    - translate the abstract-machine instructions into the machine code of a particular concrete machine

> The abstract machine has a state comprising several parts: memory, integer
> registers, floating-point registers, and a program counter.
> The abstract-machine program is a linear sequence of instructions, labels, and
> literal data; it is essentially an assembly-language program.

---

> the garbage collector must be able to understand which of the general-purpose
> registers are pointers, and which are just integer values (or other nonpointers).

（JS 里有 NaN Boxing，OCaml 有 tagged pointer

这几章都在讲生成机器码的前置步骤，但我眼里看到的都是 GC 相关的……

---

> first, from abstract-machine into assembly code
> then, from assembly code into machine code

（一层套一层，说好三年又三年的感觉。作为一个不懂汇编的鶸……我肯定是选择输出 LLVM 的 bitcode

---

## 16. THE RUNTIME SYSTEM

---

> The most important job of a runtime system is to manage and garbage collect
> the heap, and do so as efficiently as possible.

这节其实主要是讲 GC。

- Cheney's copying collection algorithm
    - 广度优先遍历
    - to space 充当了 queue 的角色
    - scan 之后值待处理，next 之后的空余空间，scan 和 next 重合，就处理完了
- generational garbage collection
- data format
