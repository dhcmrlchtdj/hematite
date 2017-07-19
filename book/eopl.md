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

- source language => AST => interpreter (implementation language)
- source language => AST => compiler => target language
    - machine language => hardware machine
    - bytecode => virtual machine
- compiler = analyzer + translator
- front end = scanning (characters=>tokens) + parsing (tokens=>AST)
- parser generator

---

- LET，讲基本的环境和变量替换（居然没提到 subst 之类的
- PROC，讲函数的表示，引出 lexical scope
- LETREC，讲递归的表示，关键还是环境变量

---

- references vs declarations
    - variable reference is a use of the variable
    - variable declaration introduces the variable as a name for some value
- scope (for declarations)
    - binding: association between a variable and its value
    - shadow: an inner declaration shadows the outer one
    - static/lexical vs dynamic

---

- lexical/static depth
- lexical addresses / de Bruijn indices
- avoid explicitly searching for variables at run time

如何做到不需要 environment

---

## 4. State

---

> state maps locations to values.

> parameter-passing mechanisms: call-by-reference, call-by-name, and call-by-need

讲 state，讲参数传递。

---

- effect is global. an effect affects the entire computation.
- store: reference -> location -> storable value
    - L-value: reference
    - R-value: storable value
- explicit references / implicit references
    - with implicit references, every variable denotes a reference
    - 两者的区别在于，ref 放在 denoted value 还是 expressed value

---

- parameter-passing mechanisms
    - eager
        - α-conversion
        - call-by-value
        - call-by-reference
    - lazy (thunk, memoization
        - β-reduction
        - call-by-name
        - call-by-need

---

## 5. Continuation-Passing Interpreters

---

### 5.1

---

> interpreter in continuation-passing style
> exposes the control mechanisms of the interpreted language

> extend the language with trampolining, exception-handling, and multithreading
> mechanisms.

讲 CPS 及其作用

---

- continuation: an abstraction of the control context
- environment: an abstraction of the data context

- environment: a function from symbols to denoted values
- continuation (of an expression): a procedure that takes the result of the
    expression and completes the computation

continuation 的作用和 environment 很像，一个是数据，一个是控制流。

---

新增绑定会改变 data context，表现出来就是 environment 变化。
然后引出了什么导致 control context / continuation 变化这个问题。

- recursive control behavior (function called in an operand position
- iterative control behavior

> It is evaluation of operands (actual parameters) makes the control context grow.

> Tail calls don’t grow the continuation. (If the value of exp1 is returned as
> the value of exp2, then exp1 and exp2 should run in the same continuation.)

每次需要对参数进行求值的时候，都会引入一个新的 continuation。
而函数调用本身，会将结果返回给当前的 continuation，不需要新增一个 continuation。

---

- procedural representation
- data structure representation

如何表示 continuation 的计算过程，可以有多种方式。
这个就像 environment 也可以用不同的方法来表示一样。

```ocaml
type key = string and value = int
type environ = | Empty | Extend of key * value * environ
let empty () = Empty
let extend env k v = Extend (k, v, env)
let apply env k = match env with ...
;;;
type key = string and value = int
type environ = (key * value) list
let empty () = []
let extend env k v = (k, v) :: env
let apply env k = match env with ...
```

```ocaml
type cont = | EndCout | IsZeroCont of cont | IfCont of exp * exp * env * cont | ...
let apply_cont (k:cont) (v:exp_val) = match k with ...
;;;
let end_cont k = fun v -> ...
let is_zero_cont k = fun v -> ...
let if_cont e1 e2 e k = fun v -> ...
let apply_cont (k:cont) (v:exp_val) = k v
```

感觉就像是 OOP 和 FP 从不同角度组织代码一样。

---

（作者的编排给人循序渐进的感觉，解释也很清晰。有基础的话，可以加快速度。

---

### 5.2

---

> most procedural languages add control context (the stack!) on every procedure call.

> most languages store environment information on the stack, so every procedure
> call must generate a control context that remembers to remove the environment
> information from the stack.

在很多语言中，函数调用意味着 stack 的增长，即每次调用都会让 control context 增长。
而前面分析过，只有 operand 的求值对 control context 有强需求。

这些语言这样实现的其中一个原因，是 data context 存储在 stack 上。
每次调用时 stack 都变化，能够自动处理 environment 的变化。

---

- trampoline

之前的理解，尾递归，递归改循环，避免栈溢出。
这里定义的 `trampoline` 这个函数，做的就是执行循环得到最终值。

> represents a snapshot of the computation in progress

在这个章节里
在解析的过程中，构造大量的 trampoline。
在最终返回给用户前，对 trampoline 求值。

---

### 5.3

---

> A 0-argument tail call is the same as a jump.

- 一组函数，相互之间进行尾调用（tail call）
    - even x 和 odd x
- 那么这些调用可以改写为赋值（assignment）代替绑定（binding）
    - x 提升为全局变量并直接进行赋值，而不是每次调用绑定一个新的值
- 这样的赋值程序又可以被改写成 goto / flowchart
    - 这样 even / odd 就成了 0-argument tail call，可以改成 goto

这种改写的过程被叫做 registerization

（整个过程改写下来，好像感觉对过程中的变化有了更直观的感受，又感觉很乱……
改写的过程中，首先就是把尾调用的参数都提出来改成赋值语句，完

---

### 5.4

---

处理 try...catch../raise... 这个的流程。
主要是 try 要保存好恢复用的环境信息，然后 raise 的时候去寻找最近的 try。

---

### 5.5

---

目标是提供抢占式调度的多线程支持。

thread 的实现，和 trampoline 一样都是 thunk。
只不过 trampoline 直接执行，而 thread 则是将任务加入队列中。

---

关于实现抢占的调度。

本节提供的方法是，每个 continuation 的执行都进行计数。
还允许就继续执行，时间用完了就丢回队列等待。

这里会引出的一个问题是原子操作。
然后就是多线程的同步问题了。

---

## 6. Continuation-Passing Style

---

讲了 CPS 的两种用法。
一个是改写程序，使其不需要构建额外的 control context。
一个是将副作用给显式表示出来。

---

> a systematic method for
> transform any procedure into an equivalent procedure
> whose control behavior is iterative

将代码自动重写成满足 iterative control behavior 的代码。
（具体实现方式，就是转写成 CPS 的形式

---

### 6.1

---

> The CPS Recipe

> To convert a program to continuation-passing style
> 1. Pass each procedure an extra parameter (typically cont or k).
> 2. Whenever the procedure returns a constant or variable, return that value to
> the continuation instead
> 3. Whenever a procedure call occurs in a tail position, call the procedure
> with the same continuation cont.
> 4. Whenever a procedure call occurs in an operand position, evaluate the
> procedure call in a new continuation that gives a name to the result and
> continues with the computation.

---

- inlining: taking each call to a continuation-builder in the program and replacing it by its definition

> an accumulator is often just a representation of a continuation.

---

### 6.2

---

> It is evaluation of operands, not the calling of procedures, that makes the
> control context grow.

> Tail Calls Don’t Grow Control Context
> If the value of exp1 is returned as the value of exp2, then exp1 and exp2
> should run in the same continuation.

- operand position
- tail position
    - tail call (procedure)
    - tail form (expression)

---

> we must understand the meaning of a language in order to determine its tail
> positions.

在 operand 则生成新的 cont，在 tail 则复用现有的 cont。

---

- SimpleExp, never contain procedure calls
- TfExp, be in tail form

把表达式分成两类，一类没有函数调用，一类函数调用都是尾调用。
这样的代码中，所有调用都不会改变 control context。

> there is no completely general way of determining whether the control behavior
> of a procedure is iterative or not.
> Therefore the best we can hope for is to make sure that no procedure call in
> the program will build up control context, whether or not it is actually
> executed.

很难判断程序本身是否属于 iterative，
所以干脆要求所有表示式全部都不要创建新的 control context。

---

### 6.3

---


---

### 6.4

---

> Another important use of CPS is to provide a model in which computational
> effects can be made explicit.

> In using CPS to model effects, our basic principle is that a simple expression
> should have no effects.

---

- printing
- store (using the explicit-reference model)
- nonstandard control flow

---




