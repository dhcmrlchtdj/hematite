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

## The object layer

---


---

## The module language

---


---

## Mixing modules and objects

---

