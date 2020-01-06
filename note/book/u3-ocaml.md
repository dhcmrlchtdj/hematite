# Using, Understanding, and Unraveling The OCaml Language

---

https://caml.inria.fr/pub/docs/u3-ocaml/index.html

---

## Core ML

---

- syntax
- dynamic semantics
    - approaches to defining the semantics
        - operational semantics
            - describe the computation process
            - many low-level details
            - somehow too concrete
        - denotational semantics
            - build the mathematical structure
            - more abstract
    - operational semantics
        - small-step operational semantics (Structural Operational Semantics)
            - reduction semantics (a case of operational semantics)
        - big-step operational semantics (Natural Semantics)
- static semantics
    - simple types
    - type inference
    - unification (for simple types)
    - polymorphism
- recursion
    - fix-point combinator
    - recursive types

---

### dynamic semantics

---

- core ML is based on the lambda-calculus
- lambda-calculus
    - variable `x`
    - function `λ x. a`
    - application `a1 a2`

---

- constants are partitioned into constructors and primitives

- call-by-value reduction semantics for ML
    - values are
        - functions
        - constructed values
            - a constructor applied to as many values as the arity of the constructor
        - partially applied constants
            - a primitive
            - a constructor applied to fewer values than the arity of the constant

---

> The advantage of the reduction semantics is its conciseness and modularity.
> one drawback of is its limitation to cases where values are a subset of programs.

reduction semantics 不能处理 environment。

---

> call-by-need is simple to implement.
> call-by-need is slightly more complicated to formalize than call-by-value and
> call-by-name, because of the formalization of sharing.

---

- big-step semantics
    - values are
        - closures
            - a closure is a pair written `⟨λ x. a, e⟩` of a function and an environment
        - partially applied constants
        - totally applied constructors

---

> the big-step operation semantics is much more verbose than the small-step one
> the big-step operation semantics cannot describe properties of diverging programs

> the big-step semantics is less interesting (because less precise) than the small-steps semantics in theory
> the big-step semantics' implementation is intuitive, simple and lead to very efficient code

> the big-step implementation could also be seen as efficient implementation of the small-step semantics obtained by (very aggressive) program transformations.
> the non modularity of the big-step semantics remains a serious drawback in practice.

small-step 和 big-step 其实就是 SICP 里的替换模型和环境模型啦。

---

### static semantics

---

> Type soundness asserts that well-typed programs cannot go wrong.

---

### recursion

---

- `fix: ∀ α1,α2.((α1 → α2) → α1 → α2) → α1 → α2`
- `fix f → f (fix f)`
- `let rec f = λx.a1 in a2` = `let f = fix (λf.λx.a1) in a2`
- `λf'.(λf.λx.f'(f f) x) (λf.λx.f'(f f) x)`
    - this expression is not typable in ML (without recursive types)

- `let rec fix f x = f (fix f) x`

---

> recursive types are sometimes too powerful since they will often hide
> programmers' errors

---

## The core of OCaml

---

- data type, pattern matching
- mutable storage, side effects
- exceptions

---

> the fix-point combinator, and more generally the whole lambda-calculus,
> can be encoded using variant datatypes.

---

> store-reduction preserves store-typings.
> store locations cannot be polymorphic.

> value-only polymorphism is unambiguously the best compromise between
> simplicity and expressiveness.

---

## The object layer

---

- type
- class
    - build from scratch `object ... end`
    - build from other classes by inheritance `object interit <super_class> ... end`
    - class types are not regular types
- object
    - create from classes by instantiation `new <class_name>`
    - create from other objects by cloning or overriding `Oo.copy <object_name>`
    - object types are regular types

---

- there is no correspondence to be made between sub-classing and subtyping
    - classes may be in an sub-classing relation
    - object types may be in a subtyping relation
- subtyping should not be confused with inheritance
    - inheritance relates classes
    - subtyping relates object types (not even class types)

- subtyping: an object with a larger interface may be used in place of an object
    with a smaller one.
- parametric classes are polymorphic, objects of parametric classes are not.

- binary methods: the argument is an object of the same type as the type of self
    - inheriting from such classes in often a problem

---

- objects are not structural.
- object types are structural.
    - use row variables to allow polymorphism

- Structural types mean that the structure of types is always transparent and
    cannot be hidden by opaque names.

---

## The module language

---

- a functor is a function from modules to modules.

---

## Mixing modules and objects

---

- module
    - can be embedded
    - can be parameterized by types and values
    - allow value and type abstraction on a large scale
- class
    - provide inheritance
    - provide late binding mechanism
    - can be parameterized by values on a small scale
