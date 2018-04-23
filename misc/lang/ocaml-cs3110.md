# ocaml

---

http://www.cs.cornell.edu/courses/cs3110/2011sp/lecturenotes.asp

---

## why OCaml

---

> So it's important to understand programming models and programming paradigms
> because in this fast changing field, you need to be able to rapidly adapt.
> It's crucial that you understand the principles behind programming that
> transcend the specifics of today.
> There's no better way to get at these principles than to approach programming
> from a completely different perspective.

- 理解 model 和 paradigm 才能跟上变化
- 理解背后的 principle
- 从完全不同的角度出发，更有助于理解 principle

---

> Java and OCaml are pretty good general-purpose languages (at least when
> compared to their predecessors.)

> Java and OCaml are type-safe and statically typed. This means that most
> errors are caught before running the program.

作者挺喜欢 ocaml 和 java 的。

---

## expressions and declarations

---

- bool / int / float / char / string
- `e ::= c | unop e | e1 binop e2 | if e1 then e2 else e3 | (e)`
- `d ::= let id = e`
- `e ::= ... | id | let d in e`
- `d ::= ... | let id (x1:t1, ..., xn:tn):t = e | let rec id (x1:t1, ..., xn:tn):t = e`
- `e ::= ... | id (e1,...,em)`

---

- 基本数据类型
- 基本数据类型组合成表达式
- 使用表达式进行绑定
- 绑定变量可用于表达式
- 绑定函数
- 函数调用

---

> Running an OCaml program is just evaluating a term.

没有赋值，所以都视为 substitution 也是可以的。

---

## Tuples, records and datatypes

---

### tuple

- `type t = (t1 * ... * tn)`
- `type t = ()`
- `type t = unit`

- `let v:t = (e1, ..., en)`
- `let v:t = ()`

- `let (x1:t1, x2:t2, ..., xn:tn) = e`
- `let y (x1:t1, x2:t2, ..., xn:tn) = e`

---

可以感受下用于函数参数的时候，使用 tuple 和多参数时的区别

```ocaml
# let max1 (x, y) = if x > y then x else y;;
val max1 : 'a * 'a -> 'a = <fun>
# max1 (10, 20);;

# let max2 x y = if x > y then x else y;;
val max2 : 'a -> 'a -> 'a = <fun>
# max2 10 20;;
```

调用的时候，可以把 tuple 的参数视为 pattern match

---

> `->` is right-associative

- 优先级高低和结合性，都是针对 binary operator 来说的。
- `A op1 B op2 C`
    - op1 优先级大于 op2，则 `(A op1 B) op2 C`
    - 优先级相同，左结合则 `(A op1 B) op2 C`，右结合则 `A op1 (B op2 C)`

---

### record

- `type t = {x1:t1; x2:t2; ... ; xn:tn}`
- `let record:t = {x1 = e1; x2 = e2; ...; xn = en}`
- `let x1 = record.x1`
- `let {id1 = x1; id2 = x2; ...; idn = xn} = record`

tuple 可以视为 record 的语法糖

---

### datatype

- `type id = id1 | id2 | id3 | ... | idn`
- `match exp with pat1 -> exp1 | pat2 -> exp2 | ... | patn -> expn`

if 语句算是 match 语句的语法糖

---

### algebraic datatype

- record/tuple 是类型间的 and
- datatype 是类型间的 or

---

- `type num = Int_num of int | Real_num of float`

---

## Scope, Currying, Lists

---

### scope

- `let x = e1 in e2`
- `let x = e1 and y = e2 in e3`
- `let rec even x = ... and odd x = ... in odd 10`

---

- `Pervasives.abs 10`
- `abs 10`
- `String.length "hello"`
- `open String;; length "hello";;`

可以用 `open` 来引入模块。
没用 open 则在使用时要带上模块名，用了 open 变量就被引入到当前环境中。
默认 open 了 `Pervasives` 模块。

---

### curry

- `let plus (x, y) = x + y`
- `let plus = function (x, y) -> x + y`
- `let plus = fun z -> match z with (x, y) -> x + y`

- `let plus x y = x + y`
- `let plus = function x -> function y -> x + y`
- `let plus = fun x -> fun y -> x + y`

---

在 ocaml 里，可以认为 function 是 fun 的语法糖。
function 只能接一个参数，后面必须是 `pattern-matching` 语句。
fun 可以任意多个参数，后面可以是任意语句。

---

- ocaml 里可以认为函数都只有一个参数，不过会自动 currying。
- binary operator 也是函数，比如`(+)` 的签名为 `int -> int -> int = <fun>`

---

### list

- `[]` => `'a list`
- `[1;2;3]` => `int list`
- `[1;2;3] @ [4;5]`
- `1::[]`
- `1::[2;3]`

ocaml 里列表是不可变的（immutable），列表里数据的类型相同（homogeneous）。
是个单向链表。

---

- `match lst with [] -> 0 | [x] -> 1 | _ -> 2`
- `match lst with [] -> 0 | h::t -> ...`

---

## Higher-order Functions, Anonymous Functions, Currying, Side effects, Printing and Exceptions

---

- Higher-order Functions
- Anonymous Functions
- Currying
- Side effects
- Printing

---

```ocaml
let y = let x = 3 in
let () = print_string (string_of_int x) in
x + 1;;

let y = let x = 3 in
print_string (string_of_int x);
x + 1;;
```

---

### Exceptions

- `exception Error`
- `raise Error`

- `exception Failure of string`
- `raise (Failure "Some error message")`

---

> Excessive use of exceptions can lead to unreadable spaghetti code.

> Exceptions should only be raised in truly exceptional cases, that is, when
> some unrecoverable damage has been done.

> avoid an exception by checking bounds or using options

- 异常过多会导致逻辑散乱。
- 只有无法处理的情况，才抛出异常。
- 检查边缘情况、使用 `option` 等手段来减少异常。

---

## Variant Types and Polymorphism

---

### variant

> variant types, sometimes known as algebraic datatypes or just datatypes.

> the ability to have a variable that contains more than one kind of value.

---

- `type answer = Yes | No | Maybe`
- `let x = Yes`

普通的 variant 就像是 enum。
每个类型其实都是 `constructor`，要求首字母大写。

- `type eitherPoint = TwoD of float * float | ThreeD of float * float * float`
- `let x = TwoD (10.0, 20.0)`

作为构造函数，也是可以携带数据的。
之后可以用 pattern match 来获取数据。

- `type T = X1 [of t1] | ... | Xn [of tn]`

总结一下就是这样的了

---

- `type intlist = Nil | Cons of (int * intlist)`
- `type inttree = Empty | Node of node and node = {value:int; left:inttree; right:inttree}`
- `type nat = Zero | Next of nat`

递归数据的定义
（函数式编程的教程里总是能看到 0 1

---

### pattern matching

---

### Polymorphism

> avoid writing the same algorithm for different types

> a function may not use parameter in any way that would identify its type.
> It must treat x as a black box.

---

- `let swap (x, y) = (y, x)` => `val swap : 'a * 'b -> 'b * 'a = <fun>`
- type variables, `'a, 'key, 'any`，引号开头即可

---

### Parameterized Types

polymorphic datatypes

- `type 'a alist = Nil | Cons of ('a * 'a alist)`, parameterized variant type
- `'a`, type parameter
- `alist`, parameterized type constructor
    - `il: int alist` / `fl: float alist` / `sl: string alist`
- 为不同的类型构造 variant（感觉就像是个函数一样，输入类型，返回 variant
- `polymorphic functions`

---

## Datatype pitfalls, polymorphism, lists

---

- `type 'a option = Some of 'a | None`

> use of option is type-safe.
> the type system forces you to account for the possibility of None.

---

## Mapping, Folding, and the Map-Reduce Paradigm

---

## Folding and tail recursion

---

```ocaml
let rec fold_left f acc lst =
    match lst with
          [] -> acc
        | x :: xs -> fold_left f (f acc x) xs;;

let rec fold_right f lst acc =
    match lst with
          [] -> acc
        | x :: xs -> f x (fold_right f xs acc);;
```

在上面的实现里，fold_left 是尾递归，理论上性能更好。

---

## The Substitution Model of Evaluation

---

> We build a more formal and precise description of the evaluation process.
> This is a model of evaluation based on the basic notion of substitution, in
> which variable names are replaced by values that they are bound to.
> This corresponds to the mathematical notion that two equal things are interchangeable.

> substitution model is accurate for describing purely functional execution
> (when there are no side effects or mutable objects)

---

替换模型中，会碰到递归函数的问题。可以靠 YC 解决。

---

### Lexical (static) vs. dynamic scoping

> Dynamic scoping can be confusing because the meaning of a function depends
> on the context where it is used, not where it was defined.

---

`let x = v in e  =>  e{v/x}`，奇怪的表示方式

---

## Modular Programming: Modules and Signatures

---

> two kinds of abstraction
> Abstraction by parameterization.
> Abstraction by specification.

---

- `module ModuleName = struct module_implementation end`
    - type
    - exception
    - let
    - open
    - include
    - signature
- `module type SIGNAME = sig signature_definitions end`
    - type
    - val
    - exception
- `module ModuleName : SIGNAME = struct module_implementation end`

---

## Abstraction Functions and Representation Invariants

---

### Abstraction Functions

- `user_view = abstraction_function (implementer_view)`
- abstraction function is a mapping from the space of concrete values to the abstract space

用 SET 来举例的话。
对用户来说，只是一个 set；
但是对实现 SET 模块的开发者来说，会有一些额外的信息，比如 set 在内部是怎么表示的。

---

> Whenever you write code to implement what amounts to an abstract data type,
> you should write down the abstraction function explicitly, and certainly
> keep it in mind.

将抽象的方式描述清楚，有助于维护代码

---

##  Functors, Parameterized Modules

---

> A functor is a mapping from modules to modules.

> A functor is a module that is parameterized by other modules.

泛型定义其实也可以理解成函数吧，输入类型，返回类型。

---

> Another good reason for not specifying the signature is that modules can
> implement lots of different signatures and can be used in different ways.

不明确指定，只要实现方法就行。
这个不是被碰的一个点吗？

上网搜了下，应该用 include 来将多个签名合成一个签名

```ocaml
module type SIG_X = sig
    include SIG_Y
end
```

---

`Contravariance`

学单词，给没有签名的模块加上签名，使得模块受到限制。
这种加限制的操作，叫做 upcast。

- covariant
- contravariant
- invariant

---

## Refs and Arrays

---

> whenever we coded a function, we never changed variables or data.
> Rather, we always computed new data.

> in some situations, it is more efficient or clearer to destructively modify
> a data structure than to build a new version.

---

```ocaml
sig
    type 'a ref
    val ref : 'a -> 'a ref
    val (!) : 'a ref -> 'a
    val (:=) : 'a ref -> 'a -> unit
end
```

ref 就是个容器，`ref` 和 `!` 分别是装进容器和取出内容。
通过 `:=` 修改容器内容。

---

## The Environment Model

---

> 1. it's not straightforward to extend the model with support for side effects
> 2. it's not a very efficient or realistic model of how we really evaluate OCaml programs

substitution model 的问题

---

> the basic idea of the environment model is to combine the process of
> substitution with the process of evaluation into a single pass over the code.

---

> A closure is just a pair of the function and its environment, and represents
> a promise to substitute the values in the environment whenever we go to
> evaluate the function.
> So, a closure is nothing more than a lazy substitution.

---

## Soundness and Completeness

---

> A deductive system is said to be complete if all true statements are
> theorems (have proofs in the system).

> A deductive system is called sound if all theorems are true

---

## Concurrency

---

- coordination
    - synchronization, where multiple processes wait for certain conditions.
    - communiction, where messages are passed between processes.

---

## Memoization

---

> Even when programming in a functional style, O(1) mutable map abstractions
> like arrays and hash tables can be extremely useful.

所以说，该用就用

---

> overlapping subproblems property

> optimal substructure property, the optimal answer to a problem is computed
> from optimal answers to subproblems

> The key to using memoization effectively for optimization problems is to
> figure out how to write a recursive function that implements the algorithm
> and has the two properties.

到底什么情况算 greedy 什么情况算 DP 呢……

---

对于非递归函数，可以靠高阶函数来做记忆化（就是写个新函数替换掉啦……）
但是对于递归函数，就没有那么直接了，需要该递归的结构（YC 就能用在这种地方了）

---

## Streams and Lazy Evaluation

---

### stream

> It is possible to simulate lazy evaluation by using thunks.
> A thunk is a function of the form `fun () -> ....`
> the body of a function is not evaluated when the function is defined, but
> only when it is applied.

这里值得一题的是，有可能被优化掉。
比如 `fun () -> 1 + 1` 变成 `fun () -> 2`。

---

- call-by-value
- call-by-name

---

### stream

- `type 'a list = Nil | Cons of 'a * 'a list`
- `type 'a stream = Nil | Cons of 'a * (unit -> 'a stream)`

> get infinite streams by deferring the creation of the tail using thunks

---

## Memory and Locality

---

> boxed type: its values are too large to fit inside the memory location of a
> variable, and so need their own memory locations, or boxes.

---

## Garbage Collection

---

- generational
- copying
- mark-sweep
- reference counting

---

## λ-Calculus

---

> notion of computation

> formal mathematical definition for algorithm

- `Turing machines`
- `μ-recursive functions`
- `rewrite systems`
- `the λ-calculus`
- `combinatory logic`

这些表示方式都是等价的

---

### λ-calculus

- everything is a function. encode everything using functions.
- no notions of state or side effects. purely functional.
- not specify an evaluation order.
- all functions are unary.

---

> Computation in the λ-calculus is effected by substitution.
> 1. α-conversion (renaming bound variables)
> 2. β-reduction (substitution rule)

- `α-conversion`
    - `λx.λy.xy => λz.λy.zy`,x=z
- `β-reduction`
    - `(λx.λy.xy) (λz.z) => λy.(λz.z)y`, MN=M(N)

---

- `normal form`, 不能再进行 `β-reduction` 的表达式
    - 这样的表达式，可以视为一个值（value）
    - 即使进行 `α-conversion`，也只是表示上的区别了
- `normalizable`, 可以进行 `β-reduction` 的表达式
    - 可计算的感觉？

---

```
true  = λx.λy.x
false = λx.λy.y

and = λx.λy.xyx
or  = λx.λy.xxy
not = λx.(x false true)

pair = λx.λy.λc.cxy
fst  = λd.(d true)
snd  = λd.(d false)


list   = pair
hd     = fst
tl     = snd
[]     = λx.true
isNull = λd.(d λx.λy.false)

0 = λf.λx.x
1 = λf.λx.fx
2 = λf.λx.f(fx)
...

add1   = λn.λf.λx.f(nfx)
isZero = λn.(n λz.false true)
```

---

## Fixpoints and Recursion

---

> Recursive definitions require self-reference.
> We cannot do this in the λ-calculus directly, because there are no names -
> all functions are anonymous.

---

- `λx.W(xx) λx.W(xx)`
- β-reduction, `λx.W(xx) λx.W(xx)  =>  W (λx.W(xx) λx.W(xx))`
- fixpoint combinator, `Y  =  λw.(λx.w(xx) λx.w(xx))`

---

> 1. OCaml is typed, and the lambda calculus is not.
> 2. OCaml is eager, but the encoding of recursion using the traditional
> fixpoint combinator Y yields looping behavior if evaluated using an eager
> reduction strategy.

问题二靠 thunk 可以解决。
问题一不是很懂……

---

```ocaml
type 'a fix = Fix of ('a fix -> 'a)
let y t = let p (Fix f) x = t (f (Fix f)) x in p (Fix p)

type church = Ch of ((church -> church) -> church -> church)
let add1 (Ch n) = Ch (fun f -> fun x -> f (n f x))
let zero = Ch (fun f -> fun x -> x)
```

---

```ocaml
let rec fix f x = f (fix f) x;;
let fix f = (fun (`X x) -> f(x (`X x))) (`X(fun (`X x) y -> f(x (`X x)) y));;
```

---

## Type Inference and Unification

---

> unification is the process of finding a substitution that makes two given terms equal.
> pattern matching is done by applying unification to OCaml expressions.
> type inference is done by applying unification to type expressions.

---

> The unification algorithm consists of two mutually recursive procedures
> `unify` and `unify_one`, which try to unify a list of pairs and a single pair,
> respectively.

> The result of the computation is the most general unifier for the list of
> pairs or the pair, respectively.

---

## Continuations and CPS Conversion

---

```ocaml
let rec sum s =
    match s with
        | [] -> 0
        | x::xs -> x + sum xs
```

普通递归。
这个 sum 展开来就是 `(x1 + (x2 + (... + (xn-1 + (xn + 0))...)))`。
加法要等右边计算完成才进行，被叫做 `deferred operation`。

---

```ocaml
let sum s =
    let rec sum' s a =
        match s with
            | [] -> a
            | x::xs -> sum' xs (a + x)
    in
    sum' s 0
```

尾递归。
展开来变成 `(((...((0 + x1) + x2) + ...) + xn-1) + xn)`。
这里加法不需要等待，马上就进行了，所以没有 `deferred operation`。

- `tail recursive`: no deferred operations on any recursive call.

---

```ocaml
let sum s =
    let rec sum' s k =
        match s with
            | [] -> k 0
            | x::xs -> sum' xs (fun a -> k (x + a))
    in
    sum' s (fun x -> x)
```

continuation 版本的递归。
little schemer 就喜欢这种……这门课的教授也挺喜欢的样子……

最后的会变成类似直接递归的 `(x1 + (x2 + (... + (xn-1 + (xn + 0))...)))`，
不过中间过程是 `(fn x -> x) o (fn a -> x1 + a) o (fn a -> x2 + a) o ... o (fn a -> xn-1 + a) o (fn a -> xn + a)`。

和直接递归一样，都要记录 `deferred operation`，不过实现方式不太一样。
直接递归靠的是 `runtime stack`，continuation 靠的是 `closures of continuations`。
所以不是尾递归都能节省空间，至少 continuation 版本和直接递归在空间开销上是接近的。

---

```ocaml
let rec inf = 0::inf in
sum inf
```

直接递归，爆栈。
尾递归，死循环，常数大小的内存。
continuation 尾递归，死循环，耗尽内存。
