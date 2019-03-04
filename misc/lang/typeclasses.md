# type classes

http://okmij.org/ftp/Computation/typeclass.html

- type classes / parametric overloading / bounded polymorphism
    - 默认参数、命名参数，是不是也算一种重载呢
- implement
    - dictionary passing
        - dictionary passing ~ vtable
    - static specialization / static monomorphization
        - static monomorphization ~ c++ template
    - run-time resolution / dynamic intensional type analysis
        - intensional type analysis ~ switch

---

## dictionary passing

```
class Show a where
    show :: a -> String
print :: Show a => a -> IO ()
    print x = putStrLn $ show x
instance Show Int where
    show x = Prelude.show x
instance Show Bool where
    show True  = "True"
    show False = "False"

type 'a show = {show: 'a -> string}
let print : 'a show -> 'a -> unit =
    fun {show=show} x -> print_endline (show x)
let show_int : int show =
    {show = string_of_int}
let show_bool : bool show =
    {show = function | true  -> "True" | false -> "False"}
```

- typeclass 在上面的例子里被实现为 record
- `print :: Show a =>` 和 `let print : 'a show ->`，虽然语义完全不同，但确实以某种形式对应了起来
- haskell 由编译器完成了传递、查找，但在 ocaml 里需要手动传递

---

## static monomorphization

- resolves all overloading at compile time
- re-write with no type classes and no bounded polymorphism
    - monomorphization takes the source program and the resolution environment
    - monomorphization process looks a lot like macro expansion
    - monomorphization rewrites the code after the type checking
        - different from macro expansion or template instantiation
    - monomorphization is a partial evaluation of the result of the dictionary-passing translation
    - monomorphization looks similar to the method of compiling polymorphic functions by specializing
        - performance, no run-time overhead
        - whole program transformation, incompatible with separate compilation
        - cannot be done with polymorphically recursive or higher-rank (first-class polymorphic) functions
- (GHC) first compile with dictionary-passing translation, and then monomorphization output

---

## intensional type analysis

```
let show : 'a -> string = fun x ->
    failwith "failed overloading resolution"

let show : 'a -> string = fun x ->
    match is_bool x with
    | Some x -> bool_to_string x
    | _      -> show x

let show : 'a -> string = fun x ->
    match is_int x with
    | Some x -> int_to_string x
    | _      -> show x

let print : 'a -> unit =
    fun x -> print_endline (show x)
```

- overloading operation is chosen at run-time
- modular, compatible with separate compilation and first-class polymorphism
- a program transformation that eliminates all mentioning of type classes and class constraints
- 构造了所有需要的实现，运行时动态分发（大型的 switch
- 问题
    - ocaml 的泛型支持。`[]/false/0` 在运行时区分不开，不知道该分发给哪个
    - haskell 的惰性求值。要知道类型才知道分发给哪个实现，所以调用不支持惰性求值

```
type _ trepr =
    | Int  : int trepr
    | Bool : bool trepr

let show : type a. a trepr -> a -> string = fun _ x ->
    failwith "failed overloading resolution"

let show : type a. a trepr -> a -> string = function
    | Bool  -> bool_to_string
    | trepr -> show trepr

let show : type a. a trepr -> a -> string = function
    | Int   -> int_to_string
    | trepr -> show trepr

let print : 'a trepr -> 'a -> unit =
    fun trepr x -> print_endline (show trepr x)
```

- GADT
- 上面的例子，解决运行时不知道类型的问题
- 和 dictionary passing 一样传递了额外参数
