# parser combinator

---

https://news.ycombinator.com/item?id=7698382

> PEG is a particular parsing technique.
> Combinator is a technique for implementing parsers.

---

http://www.goodmath.org/blog/2014/05/04/combinator-parsing-part-1/

> Writing a parser using recursive descent was a huge pain.
> It’s very tedious and repetitive, and like any meticulous process, it’s very error-prone.
> In short, it’s no damn fun at all.

还没脱离这个阶段……

---

https://pythonhosted.org/parsec/documentation.html

- sequence
- choice
- eof
- many
- many1
- none_of
- one_of

---

http://fsharpforfunandprofit.com/posts/understanding-parser-combinators-3/#5-backtracking

---

最近写完各种 parser，又看到 parser combinator，才有了感觉。
回头看下自己以前写的 PEG，还有最近的 pratt 之类的，其实相通点是很多的。

这里着重提一下这篇文章提到的两个问题。

---

> the second parser must start at the beginning of the original sequence of characters

> we get backtracking “for free” when we use immutable input state

backtracking 意味着要回头重新匹配输入。
默认变量不可变的语言，对此都能提供很好的支持。
但是看过 re 的文章后会发现，更好的做法应该是用广度优先的方式来处理。

---

> Sometimes however, we don’t want to backtrack.

作者这里说的是错误处理。
之前写 parser 时遇到过想要提前退出的情况，和这个其实很类似，都是提前退出。

作者的例子是 `expression = forExpression <|> ifExpression` 处理 `for $$$`。
正确的结果是报告 forExpression 匹配失败，不需要回溯到 ifExpression。

这里如果是用前面说的广度优先的处理方式，问题倒是比较简单。
读取 for 之后，ifExpression 已经匹配失败，而 forExpression 还在进行中。
直到 $$$ 时，forExpression 最后一个失败，此时最后的错误就是需要上报的错误。
不知道有没有更复杂的情况。

作者给出的解决方案是

> if input has been consumed successfully (in this case, the for keyword was
> matched successfully) then do not backtrack.

感觉也类似，但是就需要更多标记了。
