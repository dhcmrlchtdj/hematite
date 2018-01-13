# Programming Languages and Lambda Calculi

---

https://www.cs.utah.edu/~mflatt/past-courses/cs7520/public_html/s06/

---

## ch3. lambda-calculus

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



