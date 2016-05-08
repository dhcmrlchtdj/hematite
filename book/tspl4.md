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
