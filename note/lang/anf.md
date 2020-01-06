# ANF

---

https://dram.cf/p/cps-anf-monad-callback/

最早听到 ANF 这个概念，应该是看王垠文章的时候。
对 ANF 有个感性认知，其实是上面这篇文章。

```ocaml
let cps_main cont =
    let m_read_line k = read_line () |> k
    and m_print_newline s k = print_endline s |> k in
    m_read_line (fun name ->
        m_print_newline ("Hello, " ^ name) (fun () ->
            m_read_line (fun age ->
                m_print_newline ("Hello, " ^ age ^ "-year-old " ^ name) cont ) )
    )

let anf_main () =
    let name = read_line () in
    let () = print_endline ("Hello, " ^ name) in
    let age = read_line () in
    let () = print_endline ("Hello, " ^ age ^ "-year-old " ^ name) in
    ()
```

到这里的理解，ANF 是把 CPS 换了个写法。
这个完全可以在语法层面去完成。

---

https://slang.soe.ucsc.edu/cormac/papers/pldi93.pdf

The Essence of Compiling with Continuations

- 在编译器中用 CPS 作为 IR，可以将许多优化变成 beta/eta reduction 的组合。
    - α, `λX1.M` -> `λX2.M[X1 <- X2]` (rename)
    - β, `((λX.M1) M2)` -> `M1[X <- M2]` (apply)
    - η, `(λX.(M X))` -> `M` (point-free)
- 上面这篇论文，说的是 CPS 和 ANF 是等价的

---

https://www.microsoft.com/en-us/research/wp-content/uploads/2007/10/compilingwithcontinuationscontinued.pdf

Compiling with Continuations, Continued

- 不过这篇论文又说 ANF 带来了额外的复杂性
