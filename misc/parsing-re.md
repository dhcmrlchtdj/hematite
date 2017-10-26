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
    - 关于 concatenation
        - 处理每一个 token 前，都考虑下是否要先插入一个 concatenation。alternation 之类的其他符号，那就不需要了
        - 处理每一个 token 后，都考虑下之后是否需要插入一个 concatenation，比如 char 之后就可能需要。需要就设置一个 flag。
- precedence climbing
