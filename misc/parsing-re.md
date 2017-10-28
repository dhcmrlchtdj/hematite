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
        - 处理每一个 token 前，都考虑下是否要先插入一个 concatenation。alternation 之类的其他符号，那就不需要了
        - 处理每一个 token 后，都考虑下之后是否需要插入一个 concatenation，比如 char 之后就可能需要。需要就设置一个 flag。
        - 毕竟不像四则运算那么简单，所以处理起这类问题还是有点麻烦的。
            - https://www.oilshell.org/blog/2017/04/22.html 还列举了更多的例子
            - 比如 `-x`, `b?x:y`, `a[i]`, `f(x,y)` 之类的。
- precedence climbing
    - 和 shunting yard 其实很像。不过是递归的实现。
    - 同样是比较优先级，遇到高优先级符号时进行递归调用，就是入栈遇到了更高优先级操作符先对栈进行处理。对应的。
    - 括号，还有其他特殊符号，也都一样，需要特殊处理。
- pratt

