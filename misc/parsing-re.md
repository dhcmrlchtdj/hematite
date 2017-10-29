# regular expression

---

re => NFA 图

- a
- ab
- a|b
- a?
- a+
- a*

NFA 图 => DFA 图

---

re => ast

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
        - prefix, postfix, infix-left, infix-right, ternary-left, ternary-right, group
    - 优先级的设想，和 precedence climbing 是一样的
    - 再想想，感觉自己写了假的 pratt，完全没有什么 nud，led
