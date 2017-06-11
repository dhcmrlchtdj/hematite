# cse341

---

http://courses.cs.washington.edu/courses/cse341/17sp/#lectures

---

## SML

---

### unit2

---

types

- product types
- sum types
- recursive types

在 boolean algebra 里面，and 像是乘法，or 像是加法。
所以被叫做 product types / sum types。

---

- tuple 和 record 都是 product types，区别只是前者 by position，后者 by name。
- 在函数调用和定义时也有类似的情景，定义是 by name，调用是 by position。

tuple 是 record 的 syntactic sugar。

---

- pattern match, you cannot forget cases
- unit pattern
- wildcard pattern

---

- polymorphic datatypes
- polymorphic functions

---

- type inference

---

- raise / throw
- handling / catching

---

tail call: there is nothing more for the caller to do after the callee returns
except return the callee’s result.

---

### unit3

---

- first-class functions
    - functions can be computed, passed, stored, etc
- function closures
    - functions that use variables defined outside of them
- higher-order function
    - a function that takes or returns other functions

---

functional programming
(often used imprecisely to refer to several distinct concepts

- two most important and most common
    - not using mutable data in most or all cases
    - using functions as values
- considered related
    - A programming style that encourages recursion and recursive data structures
    - Programming with a syntax or style that is closer to traditional mathematical definitions of functions
    - Using certain programming idioms related to laziness

a functional language is one where writing in a functional style is more
convenient, more natural, and more common than programming in other styles.

---

- function argument
- parametric polymorphism / generic types

---

- anonymous function

---

- lexical scope: the body of a function is evaluated in the environment where
    the function is defined, not the environment where the function is called.
- dynamic scope

异常的捕获是类似 dynamic scope 的，无视了当前的 lexical structure

---

a function value (function closure) has two parts

- the code for the function
- the environment that was current when we created the function

---

- function composition
    - compose
    - pipeline
- currying, partial application

---

- value restriction (caused by type-checker)

---

ML ref: a container whose contents can be changed.

---

- closure idiom
    - callback
    - abstract data type (ADT)
        - 在面向对象语言里靠 object 实现
        - 在函数式语言里靠 closure 实现
        - 封装实现，暴露接口

---

object in object-oriented programming
- the functions are methods
- the bindings in the environment are private fields and methods
(this is just lexical scope)

functional programming and object-oriented programming are more similar than
they might first appear (there are also important differences).

---

### unit4

---

- statically typed languages
- dynamically typed languages
- implicitly typed, infer type annotations

---

type inference and type checking are often merged into “the type-checker.”

---

type inference and polymorphism are entirely separate concepts.

---

type system is unsound: accept programs that could have values of the wrong types while running.

通过检查就保证在运行时类型都是正确的

---

the problem results from a combination of polymorphic types and mutable references.

同时有了这两特性之后，可能造成类型检查变得 unsound。
所以引入了 value restriction 这个机制。

---

```ocaml
let x = ref None;;

val x : '_a option ref = {contents = None}

x := Some("hi");;

val x : string option ref = {contents = Some "hi"}
```

在一开始，x 推断出来是 `'_a`，但在对 x 赋值后，类型变成了 `string`。
这就是 value restriction 的效果了。

---

value restriction: a variable is polymorphic type only if the expression in the val-binding is a value or a variable.

这样具体定义看得不是很懂……

---

## racket

---

### unit5

---

do not need to define new types all the time,
but most errors do not occur until run time.

---

macro expansion happens before anything else (type-checking / compiling / evaluation...).

---

hygiene solve: a free variable at the macro-use ended up in the scope of a
local variable in the macro definition.

---

### unit6

---

Programs that run produce similar answers, but ML rejects many more programs as illegal.

Racket is just ML where every expression is part of one big datatype.

---

- A type system is sound if it never accepts a program that, when run with some input, does something we wish to prevent.
- soundness prevents false negatives.
- A sound logic proves only true things.

- A type system is complete if it never rejects a program that, no matter what input it is run with, will not do something we wish to prevent.
- completeness prevents false positives.
- A complete logic proves all true things.

In modern languages, type systems are sound (they prevent what they claim to)
but not complete (they reject programs they need not reject).

---

Soundness is important because it lets language users and language implementers
rely on something we wish to prevent never happening.

---

- Is Static or Dynamic Typing More Convenient?
- Does Static Typing Prevent Useful Programs?
    - 确实会有些场景，动态类型表达能力更强，静态类型更繁琐
    - 这种场景没有那么那么多
- Is Static Typing’s Early Bug-Detection Important?
- Does Static or Dynamic Typing Lead to Better Performance?
    - 静态类型意味着运行时可以不存储或检查类型
    - 这些检查操作开销不大、部分检查能够优化掉、有时就是希望运行时获取类型信息
- Does Static or Dynamic Typing Make Code Reuse Easier?
- Is Static or Dynamic Typing Better for Prototyping?
- Is Static or Dynamic Typing Better for Code Evolution?

---

## ruby

---

### unit7

---


