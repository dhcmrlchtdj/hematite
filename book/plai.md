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

substitution 和 lexical scope 的执行结果是相同的。
作者直接把 dynamic scope 视为错误。

---


