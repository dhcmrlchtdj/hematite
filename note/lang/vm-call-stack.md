# call stack

http://manticore.cs.uchicago.edu/index.html
https://kavon.farvard.in/papers/index.html

From Folklore to Fact: Comparing Implementations of Stacks and Continuations
Weighing Continuations for Concurrency

---

- continuation
    - one-shot vs multi-shot
        - 看能调用几次，以及生命周期
    - call/cc: multi-shot and has an unlimited lifetime
    - call/1cc: one-shot, but have an arbitrary lifetime
    - escape continuation: one-shot continuation whose lifetime is limited to its lexical scope
        - equal to setjmp/longjmp

---

- how to allocate call stack (stack 要能够被捕获
    - CPS, immutable, heap-allocated continuation closures
    - contiguous stack, a large fixed-size region
        - dynamic array, initially small and resize when the stack overflow
    - segmented stack, fixed-size segments, linked
    - linked stack, linked list of frames

> once a continuation is reified (or captured), a pointer into the stack exists
> in the heap, so it is no longer safe to move that frame during an overflow
> without keeping a remembered set of captured continuations.

- the linked strategy should always be avoided
- the CPS strategy is a much simpler choice for a garbage collected runtime system
- the contiguous stack have better sequential performance without advanced control-flow mechanisms
- resizing stack is the better choice because of its space efficiency (compare with segmented stack

---

- reuse stack frames
    - cons
        - better performance
        - increase cache locality
        - reduce garbage collector burden
    - pros
        - increase runtime system complexity
        - make first-class continuations expensive to use

