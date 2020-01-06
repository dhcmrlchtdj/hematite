# point free style

---

https://en.wikipedia.org/wiki/Tacit_programming
https://github.com/hemanth/functional-programming-jargon#point-free-style
http://stackoverflow.com/questions/944446/what-is-point-free-style-in-functional-programming
https://www.quora.com/What-are-the-advantages-of-using-point-free-style

---

tacit programming 是什么鬼啦

---

> Point-free style means that the arguments of the function being defined are
> not explicitly mentioned, that the function is defined through function
> composition

并不是什么特殊的东西，只是用其他方式来表达出函数
比如 compose 之类的

```js
const pointful = (x) => (x + 1);
const pointfree = pointful;
```

如果我的理解没错，连上面这种例子都算
只要不提及具体参数，就算 point free

---

> The biggest advantages are **reducing syntactic noise** and
> **not introducing unnecessary names**

很多时候，只是为了写起来，看着看着简洁一些

> you should only use point-free style in simple cases.

只用在简单的场景下

---

感想：一群人闲的蛋疼，强行造概念
这也能算编程范式？连语法糖都不算啊

能否降低人肉解析成本是语法选择的唯一标准
