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

---

core
    `let` / `let rec` / `type` / `mutable` / `fun` / `function` / `exception` / `val`
    `;;` / `;`
    `unit` / `()`
    `int` / `float` / `bool` / `char` / `string`
    `tuple`
    `array`
        `[|1;2|]` / `arr.(0)` / `arr.(0)<-3`
    `list`
        `[]` / `::`
    `type variable` / `polymophic`
        `'a`
    `record`
        `{x=1;y=2}` / `r.x` / `r.x<-3`
    `variant`
        `Int of int`
    `ref` / `!` / `:=`
    `if...then...else...` / `match...with...` / `try...with...`
    `for i = 0 to 1 do...done` / `while true do...done`
    `label`
        `fun ~x -> x`
        `fun ~x:x1 -> x1`
    `optional`
        `fun ?x -> match x with | None -> 0 | Some y -> y`
        `fun ?(x=1) -> x`
    `polymophic variant`
        [\`On; \`Off]
module
    `module ModName = struct ... end` / `ModName.field`
    `module type ORDER_TYPE = sig ... end`
    `module Set = functor (Elt:ORDER_TYPE) -> struct ... end`
        `module StringSet = Set(OrderString)`
    `module type SETFUNCTOR = functor (Elt:ORDER_TYPE) -> sig ... end`
    `sig` -> `mli` -> `cmi` / `struct` -> `ml` -> `cmo`
object-oriented
    `class point = object val mutable x = 0 method get_x = x end`
    `class point x_init = object ... end`
    `class point = fun x_init -> object ... end`
    `let p = new point 7;; p#get_x`
    immediate object
        `let p = object ... end`
    init
        `class point = let ... in object ... initializer ... end`
        `let ...` evaluated before object constructed
        `initializer ...` evaluated after object constructed
    self reference
        `class point = object (self) ... end`
    virtual (cannot be instantiated)
        `class virtual abstract_point_m = object method virtual get_x : int end`
        `class virtual abstract_point_v = object inherit abstract_point_m val mutable virtual x : int end`
        `class point = object inherit abstract_point_v val mutable x = 1 method get_x = x end`
    private method (inherited and visible in subclass by default)
        `method private fff x = ...`
        `method private virtual fff x = ...`
        ...
    friend
        ...
    interface
        `class type point_interface = object ... end`
    inheritance (all initializers evaluated in order)
        `class colored_point = object inherit point as super ... end`
    parameterized (if use reference cell)
        `class ['a] oref x = object ... end`
    polymophic
        `class intlist (l:int list) = object method fold : 'a. ('a -> int -> 'a) -> 'a -> 'a = ... end`
        ...
    subtyping
        subtyping and inheritance are not related
            subtyping is a semantic relation between types
            inheritance is a syntactic relation between classes
        coercion
            `let colored_point_to_point cp = (cp : colored_point :> point)`
    functional object (without assignment)
        `class functional_point y = object val x = y method move d = {< x = x + d >} end`
    clone object (shallow copy)
        `let p = new point 7;; let q = Oo.copy p`
    binary method (argument has same type with self)
        `class virtual comparable = object (_ : 'a) method virtual leq : 'a -> bool end`
