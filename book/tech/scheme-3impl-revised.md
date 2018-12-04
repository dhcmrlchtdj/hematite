# Three Implementation Models for Scheme

---

http://www.cs.indiana.edu/~dyb/pubs/3imp.pdf

---

这两天重看 3impl

我们写代码，是树状或图状的思维。
经过 lexer 变成线性的符号，经过 parser 变成语法树。
这时候可以用 type checker 对树进行检查，可以用 interpreter 对树进行解析，
也可以用 compiler 把树变回线性的 bytecode，当然也可以是机器码。
（所以，我在说什么呢，😂

---

回到正题，第三章讲 heap-based 实现。
除了 bytecode，VM 还需要一些其他数据。

程序需要环境变量。
环境变量，其实就是一个映射表，从名映射到值。
可以用链表把多个映射表串连起来，模拟出嵌套的作用域。
静态作用域的语言，可以把命改成坐标，map 变成 array，优化访问速度。

程序也需要调用栈。
解决从哪来来、到哪里去的问题。
尾递归、尾调用，都可以在这里实现，替换掉之前的调用栈。

程序还需要闭包，以及 scheme 还需要 continuation。
闭包嘛，代码加上环境变量。
continuation 嘛，闭包加上调用栈。

VM 执行 bytecode，和解释器解析语法树，也不差很多吧。

---

- 寄存器：环境变量、调用栈、参数、语句、返回值
- 这篇论文的 instruction 是树型的结构，里面甚至直接使用了 datum，😂


