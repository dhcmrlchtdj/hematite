# Programming Languages and Lambda Calculi

---

https://www.cs.utah.edu/~mflatt/past-courses/cs7520/public_html/s06/

---

## ch3. λ-calculus

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

## ch4. ISWIM

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

