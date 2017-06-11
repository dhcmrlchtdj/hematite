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

- Class-Based OOP
- Duck Typing
- Subclassing and Inheritance
- Overriding and Dynamic Dispatch
    - dynamic dispatch / late binding / virtual method calls

---

overriding and dynamic dispatch is the biggest thing that distinguishes
object-oriented programming from functional programming.

objects and dynamic dispatch, nothing more than pairs and functions

---

### unit8

---

- In FP, break programs down into functions that perform some operation.
- In OOP, break programs down into classes that give behavior to some kind of data.

划分代码的方式不同，FP 根据操作分，OOP 根据数据分。

---

FP

- define datatype for expressions, with constructor for each variant
- define function for each operation
- in each function, have a branch for each variant of data

breaking the problem down into procedures corresponding to each operation.

---

OOP

- define class for expressions, with abstract method for each operation
- define subclass for each variant of data
- in each subclass, have a method definition for each operation

breaking the problem down into classes corresponding to each data variant.

---

FP 是函数处理不同数据，OOP 是类有不同方法。

---

which is better?
- depend on which one is “more natural” to lay out the concepts by row or by column.
- depend on what the software is about.
- depend on what programming language are using, how useful libraries are organized, etc.

和后续如何扩展其实也有关系。

---

FP
- adding a new operation is easy
- adding a new data variant is less pleasant

OOP
- adding a new variant is easy
- adding a new operation is less pleasant

这里判断的基准是是否需要修改原有代码

the programming styles “just work that way.”

---

- OOP, visitor pattern (implement by double dispatch)
- FP, define datatypes to have an “other” possibility and operations to take in a function that can process the “other data”.
    - 提前定义一个其他类型，未来用高阶函数的方式进行扩展

---

- multimethods / multiple dispatch / static overloading

---

- multiple inheritance
- mixins / traits
- interfaces

---

abstract methods and higher-order functions

---

- static types for functional programs
    - parametric polymorphism / generics
- static types for object-oriented programs
    - subtype polymorphism / subtyping

---

substitutability: If we allow t1 is subtype of t2, then any value of type t1
must be able to be used in every way a t2 can be.

---

- Good Subtyping Rules
    - “Width” subtyping, a subtype can have “extra” fields
    - “Permutation” subtyping, fields order of supertype is trivial
    - Transitivity, t1 is subtype of t2, t2 is subtype of t3, then t1 is subtype of t3
    - Reflexivity, t is subtype of t
- Bad
    - “Depth” subtyping, t1 is subtype of t2, then {f:t1} is subtype of {f:t2}

---

depth subtyping is unsound if record fields are mutable.

if a field is not settable, then the depth subtyping rule is sound and useful.

depth 讲的是嵌套的情况。
如果容器里属性是不可变的，那么 subtyping 是没问题的；
但如果属性可以变化，那么就无法保证变化后是否还能满足 subtyping 的要求。

---

function subtyping

- if t1 is subtype of t2, then t->t1 is subtype of t->t2. (covariant)
    - the subtyping for the return types works “the same way” (co) as for the types overall
- if t1 is subtype of t2, then t2->t is subtype of t1->t. (contravariance)
    - the subtyping for argument types is the reverse (contra) of the subtyping for the types overall
- if tX is subtype of tY,  tM is subtype of tN, then tY->tM is subtype of tX->tN

---

classes and types are different things.

- A class defines an object’s behavior.
- Subclassing inherits behavior, modifying behavior via extension and override.

- A type describes what fields an object has and what messages it can respond to.
- Subtyping is a question of substitutability and what we want to flag as a type error.

---

subtyping

- A subtype can have extra fields.
- fields are mutable, a subtype cannot have a different type for a field.
- A subtype can have extra methods.
- methods are immutable, a subtype can have a subtype for a method, which means the method in the subtype can have contravariant argument types and a covariant result type.

---

subclass

- A subclass can add fields but not remove them
- A subclass can add methods but not remove them
- A subclass can override a method with a covariant return type
- A class can implement more methods than an interface requires or implement a required method with a covariant return type

---

- Subtyping is a Bad Substitute for Generics
- Generics are a Bad Substitute for Subtyping

When you use Object and downcasts, you are essentially taking a dynamic typing approach.

But subtyping is great for allowing code to be reused with data that has “extra information”.

---

bounded generic types
