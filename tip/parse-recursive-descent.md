# recursive descent

---

+ http://www.engr.mun.ca/~theo/Misc/exp_parsing.htm
+ http://eli.thegreenplace.net/2012/08/02/parsing-expressions-by-precedence-climbing

---

## top-down operator precedence

为每个操作符编写独立函数。实现与语法能够对应起来。

---

## shunting yard

使用两个栈，根据优先级来选择出栈入栈。

---

## precedence climbing

每次读取，都只处理优先级高于自己的操作符。
起始优先级为 0，达到处理全部输入的目的。

---

END
