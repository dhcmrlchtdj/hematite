# regular expression

---

`a` / `(a)` / `a*` / `ab` / `a|b`
暂时只考虑这几种组合

`a+ = aa*` / `a? = a|epsilon` / `[a-z] = a|...|z`
还有更复杂的先不管了。

---

### string => AST

---

- recursive descent
    - 定义所有操作的优先级
    - parse_alternation, parse_concatenation, parse_repeation, parse_atom
    - 实际写了下，会有大量递归，而且是非尾调用。不是简单的 LL(1)，还是有不少特例要处理。

- shunting yard
    - 定义所有操作优先级
    - operator stack 和 operand stack
    - 每加入一个 char operand，同时推入一个 concat operator
    - operand 新元素直接入栈
    - operator 保证新元素的优先级不高于栈顶元素
        - 如果高于栈顶，operator 先出栈处理掉相应的 operand
    - 关于括号。
        - ( 本身直接入栈，后续加入的新 operator 也直接入栈
        - ) 最高优先级，匹配到 ( 为止
        - 实际写了下，匹配时特殊处理即可
    - 关于 concatenation
        - 处理每一个 token 前，都考虑下是否要先插入一个 concatenation。
        - 具体的插入的规则和 AST 有关系，concatenation 定义在 AST 哪个层级，然后排查其开始符号结束符号。
        - 毕竟不像四则运算那么简单，所以处理起这类问题还是有点麻烦的。
            - https://www.oilshell.org/blog/2017/04/22.html 还列举了更多的例子
            - 比如 `-x`, `b?x:y`, `a[i]`, `f(x,y)` 之类的。
        - 修改了下实现，在 lexer 之后，处理一遍，加上必须的 concat，之后的处理就变得简单了。
            - 把方法再重复一下，强化印象。分析几种情况即可。
                - `abc` `a|b` `a*b` `a(b)` `(a)b`
                - `a ^ b ^ c` `a|b` `a* ^ b` `a ^ (b)` `(a) ^ b`
                - 对于每一种 token，前面后面是否应该插入，就都很清晰了。
                - 实现的时候，需要 lookahead(2) 来判断是否需要插入

- precedence climbing
    - 和 shunting yard 其实很像。不过是递归的实现。
    - 同样是比较优先级，遇到高优先级符号时进行递归调用，就是入栈遇到了更高优先级操作符先对栈进行处理。对应的。
    - 遇到低优先级的，就返回匹配结果。由低优先级的符号继续驱动匹配。
    - 括号，还有其他特殊符号，也都一样，需要特殊处理。
    - 简单的正则处理起来还是比较容易的，结合性可以全部当作右结合，优先级只要处理 concat,alter,repeat,group 就可以了。
    - 考虑几点，首先是优先级，然后是 binary/unary 及结合性的判断。

- pratt
    - 前面三种算法，只有 shunting yard 写出了尾递归的版本……
    - 按说 pratt 的模式，比前面的更通用？期待下吧。
    - 算是看完了 Bob Nystrom 的 pratt 教程，几个关键点
        - arity, associativity, precedence
        - prefix, postfix, infix-left, infix-right, ternary, group
    - 优先级的设想，和 precedence climbing 是一样的
    - 再想想，感觉自己写了假的 pratt，完全没有什么 nud，led

---

再总结一次，加深下印象。

- 整个解析过程都是以 operator 为中心。
    - 每个 operator 都要定义优先级（比如 `*/` 高于 `+-`
    - 结合性可以用优先级来表达
    - 相同的字符，在不同的位置，可以有不同的优先级（比如 `-2` 和 `2-1`
- 一开始，就要将所有 operator 归类
    - prefix like
        - closfix: '(' expr ')'
        - prefix: token expr
        - operand: expr
    - infix like
        - postfix: expr token
        - infix left/right: expr token expr
        - mixfix:
            - conditional: expr '?' expr ':' expr
            - apply: expr '(' expr* ')'
            - subscript: expr '[' expr ']'
- 优先级决定了一个解析过程是返回当前结果，还是继续吃掉下一个 expr
- prefix like 不关心之前的优先级，只需要普通 lookahead 往前解析就好了
- infix like 都是先吃掉一个 expr，在吃掉一个 token，视情况要不要继续吃其他内容
    - infix like 不能无脑 lookahead 向前走，需要比较优先级
    - 优先级决定了第一个 expr 属于前面的其他 token，还是属于正要解析的下一个 token
- mixfix 可以用相同的思路解析，不过要注意下 mixfix 的第二个 token

由于 infix 这种会去解析第二个 expr，再构造 infix 的 ast。
所以代码组织起来就不是尾调用的。
这可以通过将状态维护到栈上来解决，就又到 shunting yard 了。

---

### AST -> NFA

---

AST 如下

```ocaml
type re =
    | Epsilon
    | Character of char
    | Repeation of re
    | Concatenation of re * re
    | Alternation of re * re
```

NFA 的图就不画了

- 每一种 re 对应两个 state，表示起止。比如 `S1 --a--> S2`
- state 需要两个出口，因为 `a|b` 这种需要根据 a b 进入不同的状态
    - 如果需要更多的出口，可以靠增加 state 来表示
- 如果要保持变量的不可变性，在构造 state 的时候，要从出口往入口构建
    - `val build: ast -> out_state -> in_state`
    - 传入 AST 和出口的 state，返回 AST 入口的 state
    - 每一种 re 都根据自己的需要，来新增一些 state，用 epsilon 边连接起来
    - 实际写了下，不可变给自己挖坑。
        - 其他状态还好，Repeation 的会遇到问题
        - `a*` 的生成顺序会是 `S4 --> S3-a->S2 --> S1 --> Sout`
        - 其中 S1 S4 又需要互相引用，就导致了鸡生蛋蛋生鸡的问题（上 mutable 了
        - 搜了一下，haskell 里的 state monad，temporary mutable state 什么鬼
        - 今天突然想到，为什么要去构造 state 呢。全部放在数组里摊平了也可以的吧。

---

### NFA match

---

写了一下，发现问题好多。
`e*` 的循环怎么避免，没想明白。
结果发现是我自己构造 nfa 时出毛病了。

浪费了大把时间 😂

---

给 NFA 换了新的数据结构之后，整个世界都变干净了。

之前的

```ocaml
type edge = Eps | Ch of char
and out = (edge * state) option
and state = {
    state: int;
    _end: bool;
    mutable next1: out;
    mutable next2: out;
}
```

之后的

```ocaml
type state = int
and edge = Eps | Ch of char
and arrow = state * edge * state
and states = arrow list
and nfa = states * state
```

---

### NFA -> DFA

---

在纸面上梳理逻辑很简单。
但在实现时要做到不可变的话，就把代码搞复杂了。
总归都是思维不够活络。

---

写完之后，感觉心情不错的。
包括匹配的实现都比 NFA 简单很多。

DFA 的基本结构

```ocaml
type state = int * bool
and edge = char
and arrow = state * edge * state
and states = arrow list
and dfa = states * state
```

---

### AST -> Inst

---

对于 VM 这块，确实还比较陌生。
正好熟悉下。
