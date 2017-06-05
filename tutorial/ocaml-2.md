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

## tuples, records, datatypes, pattern matching

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



