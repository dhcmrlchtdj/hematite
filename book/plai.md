# Programming Languages: Application and Interpretation

---

http://cs.brown.edu/courses/cs173/2012/book/

---

## 0 setup racket

---

https://github.com/mflatt/plai-typed

```
$ raco pkg install plai-typed
```

---

直接用 ocaml 来实现其实挺好的。
自带类型系统，pattern match 更强力。
看完书上代码需要稍微进行一点点翻译，又不会差别太大。

---

## 1 Introduction

---

Including mistakes makes it impossible for you to read passively: you must
instead engage with the material, because you can never be sure of the veracity
of what you’re reading.

为了让读者自己思考，这也是不择手段了……

---

it makes sense to provide a long and descriptive name when defining the
datatype (because you probably won’t use that name again)

定义时变量名具体明确，使用时变量名可以简短。
作者这里提供的判断的标准居然是使用的频率。

感觉作用域大小决定变量名长短更合理些。
另外现在自动补全这么强，不需要过分追求短小了吧。

---

## 2 Everything (We Will Say) About Parsing

---

Parsing is the act of turning an input character stream into a more structured, internal representation.

from our perspective parsing is mostly a distraction.

parse 就是为了个 AST，没别的了。
PLAI 这书重点并不在 parse。

在这方面，s-exp 确实很棒，天然的 AST 结构。

---

## 3 A First Look at Interpretation

---

直接解析 AST，这种计算器直接模式匹配就好了。

---

## 4 A First Taste of Desugaring

---

讲 syntactic sugar。

原来的 `interp : (arithI -> int)` 只支持加法和乘法。
增加新方法 `desugar : (arithD -> arithI)` 用加法和乘法来表示减法。

不修改原解释器，而是通过改写 AST 的方式来增加新功能。

macro

---

- `a - b = a + (-1) * b)`
- `-b = 0 - b = 0 + (-1) * b = (-1) * b`

关于 `-b` 的改写，作者提出了两个关于改写成 `0 - b` 的问题。

- `generative recursion`
- 这种改写依赖于 `0-b` 的实现，而 `0-b` 的支持不是底层提供的。
    非底层原生的问题在于，实现可能变化。
    虽然语义可能不变，但也许会加入 log 之类的副作用。

而改写成 `(-1)*b` 直接依赖于底层提供的乘法，不会有其他副作用。
同时逻辑上是个 `structural recursion`。

---

http://www.ccs.neu.edu/home/matthias/HtDP2e/part_five.html#%28part._sec~3astruct-gen-rec%29
https://en.wikipedia.org/wiki/Recursion_%28computer_science%29#Structural_versus_generative_recursion

> generative recursion is strictly more powerful than structural recursion.
> all functions using structural recursion are just special cases of generative recursion.

总体来说，structural 是 generative 的特例。

区分两者看参数，参数范围逐渐缩小的是 structural，参数范围没有明显变换的是 generative。
输入没有明显变化，所以递归时的终止条件会相对复杂。

---

## 5 Adding Functions to the Language

---

- function definition: what's the function
- function application: use a function
- substitution model: search-and-replace
- eager / lazy
    - eager: evaluate arguments before substitute them in functions

---

substitution 的过程中，遍历函数定义的 AST，将所有 paramater 替换为 argument。
处理后的 AST 交给原来的解释器来执行。

argument 在什么时候进行计算，是替换前还是替换后，决定了是 eager 还是 lazy。

---

## 6 From Substitution to Environments

---

> substitution traverses everything.
> substitution forces the program to be traversed once for substitution and
> once again for interpretation.
> substitution is defined in terms of representations of the program source.

substitution 的不足。
而 environment 可以处理上面这三种问题。

---

```ocaml
(* substitution *)
| App (n, a) ->
    let Func (_, param, body) = (get_fundef n fds) in
    let arg = interp a fds in
    let expr_new = subst arg param body in
    interp expr_new fds

(* environment *)
| App (n, a) ->
    let Func (_, param, body) = (get_fundef n fds) in
    let arg = interp a env fds in
    let env_new = extend (Bind (param, arg)) env in
    interp body env_new fds
```

上代码会更直观些。
前面都一样，找到要执行的函数，计算出参数的值。
substitution 先对函数的 body 进行替换，然后继续 interp 替换的结果。
environment 先对 env 进行扩展，然后在新的 env 下 interp 函数的 body。

---

终于讨论到了 scope 的问题。

```ocaml
let rec
f1 x = f2 4
and
f2 y = x + y
in
f1 3
```

这样的代码在 ocaml 里会提示 f2 中的 x 是个 `Unbound value`。
但是用上面那种环境模型，执行结果会是 7。
因为使用了执行（f1）时的 env，而不是定义（f2）时的 env。

---

- dynamic scope: the environment accumulates bindings as the program executes
- lexical scope / static scope: the environment is determined from the source without running

正确的 substitution 和 lexical scope， 执行结果是相同的。
作者直接把 dynamic scope 视为错误。

---

## 7 Functions Anywhere

---

> What value does a function definition represent?

函数到底是什么，明确这点才能够把函数作为 first-class 的值到处传递呀。

---

- immediate function: function definitions are written at the point of application

---

> A function value needs to remember the substitutions that have already been applied to it.
> A function value therefore needs to be bundled with an environment.
> This resulting data structure is called a closure.

为了正确实现 lexical scope，closure 是必须的。
其实也就是函数定义及定义时的环境。

---

> A function no more needs a name than any other immediate constant.
> A function is inherently anonymous.

lambda 才是函数的本质属性。

---

> capture-free substitution

substitution 也不是完全没有问题，比如 `(((lambda (f) (lambda (x) (f 10))) (lambda (y) (+ x y))) 2)`。
呃，确实不容易看……
总之直接把 f 替换为后面的函数的话，会得到 `((lambda (x) ((lambda (y) (+ x y)) 10)) 2)`。
显然这里 `x` 出问题了，本来应该是 unbound value 才对，这里却会被影响。
这种情况下就需要 capture-free substitution 了。
类似于这样 `((lambda (x1) ((lambda (y) (+ x y)) 10)) 2)`，重命名 x 使得内外不影响。
（想到了 hygienic macro）

> Environments automatically implement capture-free substitution!

environment 模型下，不需要再处理这种问题，替换时只会处理参数 `y`，所以没有影响。

---

变量绑定也可以视为匿名函数的语法糖。
形参实参就是绑定变量。

但是简单的匿名函数无法处理递归调用（虽然我们知道 YC，也先假装不知道好了）。

---

## 8 Mutation: Structures and Variables

---

> The introduction of time has profound effects on reasoning about programs.

变量和时间。

---

> the box must be lexically the same, but dynamically different.

变量的容器，在使用过程中要满足这样的特性。

---

`val interp : (expr * env) -> value`

执行相同的 expr，想要得到不同的 value，那么只有修改 env 了。

`val interp : (expr * env) -> (value * env)`

每次执行 expr 后，env 都一起更新。

---

> The environment already serves an important purpose:
> it holds deferred substitutions.

> The environment already has a precise semantics (given by substitution)
> and we must be careful to not alter that.

> The environment is the repository of lexical scope information.

环境模型，被用来实现 lexical scope。
想要修改环境，前提是保证环境本身的语义不能出错。

而在每次执行 expr 后更新 env 会导致 lexical scope 出错。

---

书中举的例子是 `(let b = ref 0 in 1) + b`。
正确的情况下，右边的 b 应该是 unbound 的。
但如果用前面说的方式来更新 env 的话，左边的语句执行后，环境里会有个 `b=ref 0`。
这个 env 应用于右边，右边的 scope 就出错了。

另一个例子 `let a = ref 1 in let f = fun x -> x + (!a) in (a := 2; f 10)`
`a:=2` 要修改的是最外层的环境，只修改 `f 10` 的环境是不够的。

可见前面那种更新环境的方式不能满足需求。

---

> we need two repositories to accompany the expression, not one.
> the environment to be responsible for maintaining lexical scope.
> the store to be responsible for maintaining the dynamic state of mutated boxes.

直接修改 env 会破坏之前的语义，那我们不直接修改 env 了。
我们增加另一个全局变量 store。
env 不再是 `identifier -> value` 的绑定，而是变成 `identifier -> store` 的绑定。
在 store 里存储数据，同时提供修改数据的能力。

> The whole point was to evaluate the second term in the store returned by the first one.

函数签名变成了 `val interp : (expr * environ * store) -> (value * store)`
过程中新增了 store。
顺序执行语句的时候，前一句的返回的 store 用作后一句的输入。

---

> The environment is passing in recursive-descent pattern.
> The store is passing in store-passing style.

> store-passing style: take store from one branch and pass it on to the next,
> and take the result and send it back out.

---

有了 store 之后，绑定操作起来变得更加复杂了。
原来是 `name -> value`，现在是 `name -> addr -> value`。
查找创建都增加了额外的操作。
（其实原来也只有函数调用有新建的动作啦，现在多了一个创建 box 的时候也要创建 addr）

---

> this decision is now a semantic one.

使用 store-passing style 来写解释器，语句的执行顺序会对整个程序的语义产生影响。

> The store reflects the history of the computation, not its lexical shape.
> Store is persistent.

store 的 dynamic 和 environment 的 static 要仔细区分开。
这是程序中容易犯错的地方。

当 environment 不再引用某个 addr 之后，store 中对应的值就没有用了。
这时就轮到 garbage collection 出厂了。

> Software transactional memory offers one of the most sensible approaches to
> tackling the difficulties of multi-threaded programming, if we insist on
> programming with shared mutable state.

在每次执行某个 expr 之后，都要更新下一个 store，否则之前的操作就丢失了。
store 这种特点，被用于实现 software transactional memory。
不行就回到上个 store 去重新来过。
STM 可以用于处理共享可变数据的多线程编程。

---

> An alternate implementation strategy is to have the environment map names to
> boxed Values.
> You may find it a useful strategy to adopt when implementing your own language.

直接使用可变数据结构来实现 environment，确实就不需要 store-passing 了。
实现新语言的时候这么搞其实没问题，作者用 store-passing 主要是为了演示。

---

前面讲的都是 `structure mutation`，也就是 `ref` 这样包装过的，内容可变的容器。
下面要说的是 `variable mutation`，也就是可以直接修改的变量。

- variable: whose value can change within its scope
- identifier: whose value cannot change within its scope

要引入变量赋值，就需要引入 l-value 的概念。

l-value = left-hand-side (of an assignment) value = memory address

l-value: looking up an identifier in the environment without subsequently
fetching its value from the store.

---

> State provides a form of modularity.
> state is an implicit parameter already passed to and returned from all
> procedures, without imposing that burden on the programmer.

> State makes it possible to construct dynamic, cyclic data structures.

但是引入 state 就失去了 aliasing / referential transparency 等特性。

不支持 variable mutation，强制使用 ref/box 来限制可变性，可以带来一些好处。

> every data structure is considered immutable unless it contains a ref, and
> the presence of a ref is a warning to both developers and programs that the
> underlying value may keep changing.

---

parameter-passing strategy

- call-by-reference
- call-by-value

---

## 9 Recursion and Cycles: Procedures and Data

---

recursive data: a reference of the same kind data

> 1. name an vacant placeholder
> 2. mutate the placeholder so its content is itself

---

recursive function: a reference of the same function itself

> 1. create a placeholder
> 2. refer to the placeholder where we want the cyclic reference
> 3. mutate the placeholder before use

---

> At the top-level, every binding is implicitly a variable or a box.

---

需要注意一点，创建容器和修改容器的值，两个操作要合成原子操作。
在这过程中使用容器并不是预期的使用方式。

---

前面的 create, update, use 看着不错，问题是 ref 的类型要怎么办？
（作者说后面的章节说……）

---

> there is another way to define recursive functions (and hence recursive data)
> that does not leverage explicit mutation operations.

最后推荐了 The Little Schemer。
这几本入门书，感觉可以都读一遍。
概念想通，可以作为复习。
熟悉之后，其实过一遍是很快的。

递归函数可以靠 Y combinator，递归数据也行？

---

## 10 Objects

---

> lexically-scoped functions are central to the design of many secure
> programming techniques.

闭包的重要性

---

> object is a value that maps names to stuff: either values or methods.

对象其实就是个映射啦，包含 value 或者 method。

> methods and functions differ in how they’re called and/or what’s bound in them.

method 和 function 的区别在于调用方式及绑定的作用域。

---

（PLAI 推荐了 OOPLAI，😂

---

> the target language may allow expressions that have no counterpart in the
> source, and hence cannot be mapped back to it.

在 desugar 到目标语言的时候，可能出现前后两种语言表现能力不一致的情况。
只要不要求进行互相转换，倒也不是大问题。

---

汇总一下作者列举的 object 特性

- object
- constructor
- state
- private member
- static member
- self-reference
- dynamic dispatch

> many object features are simple patterns over functions and scope.

总体来说，大部分特性都可以通过高阶函数和闭包组合出来。

---

> an object is a lambda with multiple entry-points.
> a lambda is an object with just one entry-point.

一个函数里定义好多个函数，根据输入去判断调用哪个。
这种做法在 SICP 里也有提到。

---

> a constructor is simply a function that is invoked at object construction time.

用前面这种函数的方式来实现对象，那么 constructor 其实就是个高阶函数。

---

> many people believe that objects primarily exist to encapsulate state.

对象的状态，可以用 mutable 实现。

---

private member 其实不是问题，前面的实现里不主动暴露出去外界都拿不到。
static member，这里作者指的是多个 object 实例间共享的属性，都可以修改。实现时放到构造函数外层就好即可。

---

用 mutable 的方式实现 self-reference，方法和实现递归一样。
创建一个 ref 然后修改指向的内容就可以了。

不使用 mutable 的话，可以显式传递 self 引用。
但是让用户自己显式传递是个很麻烦的事情，所以实现时可以在调用处做个 desugar。
（不过又碰到类型问题了，这里的 self 类型要怎么定义呢
（`let msg obj name arg = ((obj name) obj arg)`

---

> black-box extensible: one part of the system can grow without the other part
> needing to be modified to accommodate those changes.

dynamic dispatch 体现了 OOP 和 FP 在处理数据时的维度区别。
不同维度的可扩展性。

> visitor pattern make object code look more like a function-based organization.
visitor 值得学习。

关于 OOP 和 FP 各自的代码复用方式，作者丢了论文，可以看下。

---

object member 可以按两个维度划分成四种情况。
- member name 是静态的还是动态的。
- member name set 是固定的还是可变的。

后面只分析一下 a fixed set of names and static member name 的情况。

---

- class / prototype
- multiple inheritance
- super
- mixin and trait

---

- open recursion
- extensible recursion

---

> prototypes are more primitive than classes.
> one can recover classes from prototypes but not the other way around.

用 prototype 可以模拟出 class 的行为

---

> diamond inheritance

> Multiple inheritance is only attractive until you’ve thought it through.

作者不喜欢多继承，主要原因还是继承的顺序。

---

> constructors and methods are expected to enforce invariants

> Going up the chain means we view the extension as replacing the parent.
> Going down the chain means we view the extension as refining the parent.

从不同视角解读继承，child->parent 继承是替换，parent->child 继承是提炼。

---

> A mixin is primarily a "function over classes"
`classB = minix(classA)`

前面说 class 的大部分特性都可以看作 lambda 和 lexical scope 的语法糖。
这个角度，这里的 mixin 其实仍是高阶函数的应用。

> Mixins do have one limitation: they enforce a linearity of composition.
> A generalization of mixins called traits says that instead of extending a
> single mixin, we can extend a set of them.

---

## 11 Memory Management

---

> Garbage recovery should neither recover space too early (soundness) nor too
> late (completeness).
> recovering too early is much worse

> in practice, we want a GC that is not only sound but as complete as possible,
> while also being efficient.

又是 sound 和 complete。
一个正确的实现，至少要满足 sound。

---

> automation, soundness, and completeness.
> we face a classic “pick two” tradeoff.

要么手动处理，同时满足 soundness 和 completeness（难度可想而知）。
要么自动处理，只满足 soundness。（计算理论证明无法同时做到？那么就只有 soundness 这个选择了。）

---

- 手动管理的问题有内存的碎片化和可能出现的多次释放等。
- reference counting 要处理的场景非常多，而且不能处理循环引用的问题。
    - 场景多的问题可以靠 ARC 来处理，循环也能靠循环检测算法来判断。
    - 但还是有其他增加了数据体积、额外的计算时间、递归的大量遍历等问题

（作者直接把 RC 踢出了自动内存管理的范围，说这不是一个 fully-automated technique

---

- garbage collection
- key idea of GC: traverse memory by following references between values

> Typically the root set consists of every bound variable in the environment,
> and any global variables.

最早看标记清楚的时候，一直疑惑 root set 怎么判断出来的。
学习了前面的 environment 和 store 之后才明白。

> Depth-first search is generally preferred because it works well with
> stack-based implementations.

遍历的时候，DFS 用得多些。

---

GC 算法的 soundness 依赖于两个假设（分别与实现、语义有关）

- GC 要知道对象是什么类型的值，以及它在内存中的布局
- 代码在下列情况下，不允许生成引用
    - Object references cannot reside outside the implementation’s pre-defined root set.
    - Object references can only refer to well-defined points in objects.

没看懂……

---

- conservative GC
- precise GC

---

## 12 Representation Decisions

---

> focus on the underlying data representations.
> non-uniformity

前面的解释器用了不同的方式来表示数字和函数。
数字直接使用了实现语言的数字，
函数却用了自己的表示方式，没用实现语言的函数。

---

> that doesn’t mean they are what we want: they could be too little or too much.

直接使用系统的数据类型，可表示的范围可能会不符合我们的需求。

> stop and ask what we wanted.
> As language designers, however, you should be sure to ask these hard
> questions up front.

自己设计语言的时候，在设计之前就应该明确“需求”包含哪些不包含哪些。

> understanding

前面的章节不使用系统自带的结构，目的是学习 closure、 mutable 这些特性的原理。

---

> host language “leak through”.
> Using host language features runs the risk that users will see host language
> errors, which they will not understand.

使用语言的功能的时候，要小心错误处理。
内部错误不应该直接暴露给用户，应该经过一层翻译。

> permit only the intended surface language to be mapped to the host language.

总而言之，还是要想清楚需求和边界情况。
避免代码实现与设置的语义出现矛盾。

---

直接转换到底层语言的实现，带来的另一个问题是语义不好修改。
比如 dynamic scope 和 static scope 的语义切换。

---

## 13 Desugaring as a Language Feature

---

> used desugaring in two different ways.
> shrink the language: to take a large language and distill it down to its core.
> grow the language: to take an existing language and add new features to it.

将复杂的特性翻译到核心实现，可以达成两种相反的效果。

那么，
在应用层面支持 desugar 的的语言长什么样？
为什么一些通用语言不提供 desugar 的功能？

---

后面先讲了下 `syntax-rules` 和 `syntax-case`。
都属于 scheme/racket 的语法了。

（syntax-case is a generalized version of syntax-rules.
（syntax-rules can be expressed as a macro over syntax-case.

syntax-case 比 syntax-rules 多了 guard，能在展开前做一些检查。

> guard: a predicate that must evaluate to true for expansion to proceed rather
> than signal a syntax error.

---

> macro: simple form of expression-rewriting. (rewrites while substituting)
> a macro is actually a function from syntax to syntax.
> syntax is actually a distinct datatype.

---

在进行 macro expansion 的时候，可能需要对表示式的部分进行求值。
这带来两个问题：
可能不小心在不需要求值的地方进行了求值，导致副作用；
执行表达式的作用域可能出错。

第一个问题需要写 macro 时小心处理，第二个问题涉及到 hygiene。

> hygiene effectively automatically renames all bound identifiers.

---

## 14 Control Operations

---

> control: any programming language instruction that causes evaluation to proceed.
> control: operations that cause non-local transfer of control.

> control operators change and improve the way we express our intent, and
> therefore enhance the structure of programs.

有没有这些 operator，语言都是 Turing-complete 的。
但这些 operator 能改善语言的语法结构、表达方式上等。

---

利用 macro 将程序中的 operator 都改写成 CPS 的形式

> turn every expression into a procedure of one argument, the continuation.
> all output from CPS will look like `(lambda (k) ...)`.

> administrative lambda: `((lambda (var) ...) val)`

将 interpreter 改写成 CPS 的形式

---

> a generator resumes from where it last left off.
> yielding will namely returning control to whatever called it.

> how to enter and exit a generator
不同 generator 之间的的差异主要体现在 enter/exit 的设计上

- enter
    - `gen = generator(); gen.next()`
    - `gen = generator(); gen()`
- exit
    - yield 是只能在 generator 內使用关键字
    - yield 是个函数

此外，关于 generator 有两点要确定
- yield 是 statement 还是 expression。大部分语言选择 expression，可以接收外部的返回值。
- generator 返回什么。大部分语言选择抛出异常。

---

> CPS conversion provides insight into the nature of the program execution stack.
> every continuation is actually the stack itself.

> traditionally the stack is responsible for maintaining lexical scope,
> which we get automatically because we are using closures in a
> statically-scoped language.

讲了程序运行中，stack 的职责（维持词法作用域）。
而闭包加上静态作用域能达到一样的效果。

> On yielding, the system swaps references to stacks.

generator 中的 yield 就是在切换对 stack 的引用。

> Coroutines, threads, and generators are all conceptually similar: they are
> all mechanisms to create “many little stacks” instead of having a single,
> global stack.

coroutine/thread/generator 都是在创建 stack

---

> function calls do not themselves need to consume stack space: we only need
> space to compute the arguments.

函数调用本身是不需要消耗栈空间的，只是为了维持对参数的引用。

> the term "tail call optimization" is misleading.
> an optimization is optional, whereas whether or not a language promises to
> properly implement tail calls is a semantic feature.

尾递归优化的“优化”是错误的理解。
优化在实现中是可选的，而是否消除尾递归的调用栈则属于程序语义的一部分。

