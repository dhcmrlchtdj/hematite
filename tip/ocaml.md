# ocaml manual

---

http://caml.inria.fr/pub/docs/manual-ocaml/

---

- int / float / bool / char / string
    - `0`
    - `1.1`
    - `true` / `false`
    - `'c'`
    - `"string"`
- tuple / list / array
    - `(1, 2)`
    - `[1; 2]`
    - `1::2::[]`
    - `[|1; 2|]`
- function
    - `fun x -> 10`
    - `fun a b -> 10`
    - `fun a -> fun b -> 10`
    - `function | x -> 10`
    - `function | [] -> false | _ -> true`
    - `let x a b = 10`
- record / variant
    - `type r = { x : float; y : int; }`
    - `type v = Int | Float`
- array assign / mutable record / ref (single-field mutable record)
    - `arr.(idx) <- 10`
    - `type m = { mutable x : float };; let mm = { x=10. };; mm.x <- 10;;`
    - `ref i`, `!i`, `i := 0`
- exception
    - `exception`
    - `raise`
    - `try ... with ...`

---

- structure
    - `module Mod = struct ... end`
    - `Mod.property`
- signature
    - `module type Sig = sig ... end`
    - `module Mod : Sig = struct ... end`
    - `module Mod = (struct ... end : Sig)`
    - `module ModB = (Mod : Sig)`
- functor
    - structureB = functor(structureA)
    - `module Functor = functor (Mod:Sig) -> struct ... end`
    - `module ModB = Functor(ModA)`
- funtor type
    - `module type FSig = funtor (Mod:Sig) -> sig ... end`
    - `module FunctorB = (Functor : FSig)`

---

- object

---

- label
    - `let f ~x ~y = x - y`
    - `let f ~x:a ~y:b = a - b`
    - `f ~x:3 ~y:2`
    - `f 3 2`
    - `let f ~x:a ~x:b ~x:c = a + b + c`
- optional arguments
    - `let f ?(x=10) y = x - y`
    - `f 5`
    - `f ~x:20 5`
    - `let bump ?step x = match step with | None -> x | Some y -> x + y`
- polymorphic variant
    - `[\`On; \`Off]`
    - `type 'a list = [\`Nil | \`Cons of 'a * 'a list]`
