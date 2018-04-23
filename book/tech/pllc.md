# Programming Languages and Lambda Calculi

---

https://www.cs.utah.edu/~mflatt/past-courses/cs7520/public_html/s06/

---

> https://www.zhihu.com/question/42315543/answer/226226734
> 操作语义（Operational Semantics），形式化地定义和描述解释器是如何运行的
> 抽象机（Abstract Machine），使用小步语义（Small-Step Operational Semantics）描述解释器如何运行

---

## PART I

---

### ch3. λ-calculus

---

- grammar and reduction
    - grammar, M
        - X
        - (λX.M)
        - (M M)
    - free variable
    - reduction
        - α, `λX1.M` -> `λX2.M[X1 <- X2]` (rename)
        - β, `((λX.M1) M2)` -> `M1[X <- M2]` (apply)
        - η, `(λX.(M X))` -> `M`
    - convention
        - `M1 M2 M3` = `((M1 M2) M3)`
        - `λX.M1 M2` = `λX.(M1 M2)`
        - `λXYZ.M` = `λX.λY.λZ.M`
- encoding
    - boolean
        - true = `λx.λy.x`
        - false = `λx.λy.y`
        - if = `λv.λt.λf. v t f`
    - pair
        - `<M N>` = `λs.s M N`
        - mkpair = `λx.λy.λs s x y`
        - fst = `λp.p true`
        - snd = `λp.p false`
    - number
        - 0 = `λf.λx.x`, 1 = `λf.λx.f x`, 2 = `λf.λx.f (f x)`
        - iszero = `λn.n (λx.false) true`
        - add1 = `λn.λf.λx.f (n f x)`
        - sub1 = `λn.λf.λx.snd (n (wrap f) <true, x>)`
            - wrap = `λf.λp.<false, if (fst p) (snd p) (f (snd p))>`
- recursion
    - fixed-point operator
    - Y = `λf.(λx.f (x x)) (λx.f (x x))`
- normal form
    - an expression is a normal form if it cannot be reduced by β or η

---

- 语法上有些缩写，一开始容易看花
- 没有类型的，比如 `0` 和 `false` 用了相同的表示
- 无法表达递归的概念，引出不动点（标题就起的非常明白，recursion via self-application

---

## PART II

---

### ch4. ISWIM

---

> one goal of this book is to illustrate the design, analysis and use of
> equational theories like the λ-calculus in the context of programming
> language design and analysis.

---

- goal
    - define the idealized core of all programming languages and an equational calculus that defines its semantics
- ISWIM vs λ-calculus
    - more like real programming languages (comes with a set of basic constants and primitive operations
    - more closely models the core of call-by-value languages such as Scheme and ML
    - call-by-value reduction rules
        - call-by-value: the arguments to a function must be fully evaluated before the function is applied
- ISWIM
    - expression, value, reduction
    - functions in ISWIM accept only fully-evaluated arguments
    - the core (only) reduction relation for ISWIM is β
        - α-equivalence is used to compare expressions
- consistency
- observational equivalence: program evaluation, program transformation

---

- Y-combinator
    - `Y f` -> `(λf.(λx.f (x x)) (λx.f (x x))) f` -> `(λx.f (x x)) (λx.f (x x))` -> `f ((λx.f (x x)) (λx.f (x x)))`
        - the argument to f in the outermost application is not a value, and cannot be reduced to a value
        - avoid the infinite reduction by changing each application M within Y to (λX.M X)
            - inverse-η transformation puts a value in place of an infinitely reducing application
    - `Yv` = `(λf.(λx.( (λg.(f (λx.((g g) x)))) (λg.(f (λx.((g g) x)))) x )))`
    - Yv combinator works when applied to a function that takes a function and returns another one

---

### ch5. Standard Reduction

---

- the **standard reduction** defines a **textual machine** for **ISWIM**
- A good evaluation strategy based on reductions should only pick redexes that are outside of abstractions.
    - 某些规约方式，可能陷入循环，得不到结果。这里提出了正确的规约过程，应该满足什么条件
    - https://softwareengineering.stackexchange.com/questions/228722/redex-and-reduction-strategies
    - If the expression is an application and all components are values, then, if the expression is a redex, it is the next redex to be reduced; if not, the program cannot have a value.
    - If the program is an application such that at least one of its sub-expressions is not a value, pick the leftmost non-value and search for a redex in there.
- divide a program into an application consisting of values and a context

---

- Two expressions are of the same kind if both are values or both are applications (non-values).

---

- what kind of behavior can we expect from a machine given an arbitrary program?
- A program in pure ISWIM can only evaluate to a **value**, a **stuck program**, or **diverge**.
    - 程序或许可以规约成一个预期的值（value），也可能出现死循环等情况而没有结果（diverge）
    - stuck 有点不好理解。
        - value 是规约出了结果，diverge 是可以无限规约。
        - stuck 是还没规约出结果，但已经无法继续规约了。
        - 比如，调用了一个没有实现的函数。理论上应该执行调用，但却无法进行。
    - 死循环和 stuck 其实都算在 diverge 里
- programs for which  −→v is undefined are called stuck states

---

### ch6. Machines

---

- Every evaluation cycle in the standard-reduction textual machine performs three steps:
    - It tests whether the program is a value; if so, the machine stops.
    - If the program is an application, the machine partitions the program into an evaluation context, E, and an application, (U V ) or (on V1 . . . Vn).
    - If the application is a βv or δ redex, the machine constructs the contractum M and fills the evalutaion context E with the contractum M.

---

- CC Machine
    - separate program states into the “current subterm of interest” and the “current evaluation context”
    - these two elements are paired together to form the machine’s state: ⟨M,E⟩
    - In addition to the reduction tasks of the textual machine, the CC machine is responsible for finding the redex
    - eval_CC = eval_V

- SCC Machine (Simplified CC)
    - simplified CC machine has fewer transitions and no side-conditions
    - eval_SCC = eval_CC

- CK Machine (continuation)
    - The  −→ck relation maps an expression-continuation pair to a new expression-continuation pair.
    - given an SCC state, we can find a corresponding CK state and vice versa
    - eval_CK = eval_SCC

- CEK Machine (environment, continuation)
    - (CC/SCC/CK) the reduction of a βv-redex requires the substitution of a value in place of all occurrences of an identifier.
    - delay the work of substituion until it is actually needed. (closure, environment)
    - continuations in CEK machine contain closures instead of expressions (in CK machine)
    - eval_CEK = eval_CK

---

- CC 是 standard reduction 的直译
- SCC 是简化了一部分过程的表示
- CK 是用 continuation 来表示一些过程
- CEK 推迟替换这一操作，引入了环境变量

---

### ch7. SECD, Tail Calls, and Safe for Space

---

- Since we are trying to work towards a realistic implmentation of ISWIM, we must consider resource-usage issues as well as efficiency issues.
- SECD machine, evaluates expressions to the same result as eval_V, but which has different resource-usage properties.
- the notion of tail calls, and of continuations as values

---

- SECD machine does not work directly on source ISWIM expressions
- first compile ISWIM source expressions to a sequence of “bytecodes”
- eval_SECD = eval_CEK

---

- The difference between SECD and CEK is in how context is accumulated and saved while subexpressions are evaluated.
    - CEK, context is created when evaluating an application function or argument
        - λ-calculus, scheme
    - SECD, context is created by function calls
        - C, JAVA
- forever loop, `Ω = (λx.x x)(λx.x x)`
    - CEK machine's state will never grow beyond a certain size while evaluating
    - SECD machine's state will grow in size forever
    - the CEK machine evaluates Ω as a loop, while the SECD machine evaluates Ω as infinite function recursion
    - In languages that support tail calls, a recursive definition can be just as efficient as a loop.

---

- CEK might use more space than SECD
- A machine with the same space consumption as  −→v is called *safe for space*.

---

### ch8. Continuations

---

- The CEK machine explains how a language like ISWIM can be implemented on a realistic machine:
    - Each of three parts of state in the CEK machine (the current expression, environment, and continuation) can be stored in a register.
    - Each CEK step can be implemented with a fairly simple sequence of processor instructions. Environment lookup has a fairly obvious implementation.
- register
    - the C register contains an expression
    - the E register contains an environment, can be captured by using a λ (to form a closure)
    - the K register does not correspond to anything that the programmer can write or capture within the language

- the only useful operation on a continution is replacing the current continuation
- extend ISWIM with *letcc* and *cc* forms

- a continuation is an inside-out evaluation context
    - error-handling mechanism
    - cooperative threads
    - saving and restoring speculative computations

- `callcc = λf.(letcc k (f (λy.(cc k y))))`

---

### ch9. Errors and Exceptions

---

- 直接中文总结一下。
    - 首先是解释器本身可能进入 stuck state（比如除 0），需要有个机制把状态抛出来
    - 其次是程序需要主动抛出错误的场景（比如用户输入有误），也需要某种机制支持
    - 所以需要有异常机制
    - 有了异常机制，很自然会想要异常处理机制
    - 纯 ISWIM 缺少异常及异常处理的机制

- Error ISWIM, adding error constructs to the syntax of ISWIM
- Handler ISWIM, extends plain ISWIM with *throw* and *catch* forms

- CCH machine (handler stack)
    - the standard context of a CC machine state is represented as a stack of handlers and evaluation contexts
    - given such a stack, we can simply create a single standard context that creates the stack

---

### ch10. Imperative Assignment

---

- extend the syntax of ISWIM expressions with a assignment expression
- A mathematical variable represents some fixed value, but assignable identifiers denote a varying association between names and values
- We call the association of an identifier with a current value as its *state* and refer to the execution of assignments as *state changes*
- our experience with CEK suggests that we shouldn’t try to think of the variable mapping as exactly an environment
    - the solution is to think of memory as a new slot in the machine
    - variable lookup is replaced by slot lookup, and assignment corresponds to changing the value of a slot
    - the collection of slots is called a *store*
- forgetting unused slots is the essence of garbage collection

- CS machine
- CEKS machine
    - a store in the CEKS machine maps slot addresses to value closures

---

## PART III

---

### ch11. types

---

- expression checkers that can detect and reject “bad” expressions before evaluating them
    - the “expression” (`+ 1 -`) does not get struck, does not signal an error, and does not loop forever; because it’s not an expression at all.
    - the expression (`+ 1 (λx.9)`) will get stuck if we try to evaluate it

- A language that consists of an expression grammar, evaluation relation, and type relation is a typed language.
- A language that comprised only an expression grammar and a reduction relation is an untyped language.

- A typed language is *sound* if its type system and evaluation rules are consistent
    - if the type system assigns an expression a type, then the expression does not get stuck when evaluated

---

### ch xx

- polymorphism
- type inference
- recursive types
- data abstraction and existential types
- subtyping
- objects and classes
