# The Scheme Programming Language / Fourth Edition

---

+ Scheme is a call-by-value language, but for at least mutable objects (objects that can be modified), the values are pointers to the actual storage.
+ At the heart of the Scheme language is a small core of syntactic forms from which all other forms are built.
+ Scheme programs share a common printed representation with Scheme data structures
+ Scheme variables and keywords are lexically scoped, and Scheme programs are block-structured.
+ To support lexical scoping, a procedure carries the lexical context (environment) along with its code.
+ A special case of recursion, called tail recursion, is used to express iteration, or looping.
+ Scheme implementations are required to implement tail calls as jumps (gotos)
+ Whenever it is invoked, the program immediately continues from the point where the continuation was obtained.

几个点

+ call-by-value
+ small core
+ uniform
+ lexically scoped
+ closure
+ tail recursion & iteration
+ tail call & jump
+ continuation

---

> You might wonder why applications and variables share notations with lists
> and symbols. The shared notation allows Scheme programs to be represented as
> Scheme data, simplifying the writing of interpreters, compilers, editors,
> and other tools in Scheme.

前面提到 Scheme 程序和数据看起来是相同的，说的就是这个了。
目的其实就是为了简化周边工具的开发。

---

> Assignments are commonly used to implement procedures that must maintain
> some internal state.

变量在 scheme 中的一个作用是维持内部状态。

> Local state is sometimes useful for caching computed values or allowing a
> computation to be evaluated lazily, i.e., only once and only on demand.

维持内部状态，可以用来做缓存等。

---

> During the evaluation of a Scheme expression, the implementation must keep
> track of two things: (1) what to evaluate and (2) what to do with the value.

关于 continuation 的这种描述，我之前绝对见过。
这里是原始出处吗

---

> CPS allows a procedure to pass more than one result to its continuation,
> because the procedure that implements the continuation can take any number
> of arguments

这点，对应过来，就是函数的多返回值吧。

---

> It turns out that any program that uses call/cc can be rewritten in CPS
> without call/cc, but a total rewrite of the program (sometimes including
> even system-defined primitives) might be necessary.

这差不多就是 callcc 并不是 core syntax 的理由，可以用 CPS 来模拟。
但是，难度可能略大？

上知乎搜了一下，瞬间感觉不用看了，完全不懂啊……
