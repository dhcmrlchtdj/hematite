# postcss parse

---

简单解释下 postcss 将 css 解析为 ast 的过程。

---

使用如下方法即可获得 ast

```js
var ast = postcss.parse(css)
```

---

解析的代码如下

```js
// https://github.com/postcss/postcss/blob/4.1.16/lib/parse.js#L7

let parser = new Parser(input);
parser.tokenize();
parser.loop();
```

先调用 `tokenize` 进行词法分析，再调用 `loop` 进行语法分析。

---

翻一下 `https://github.com/postcss/postcss/blob/4.1.16/lib/tokenize.js`，
做法就是简单遍历字符，给每种字符写好处理函数，完成整个处理过程。

---

再看 `https://github.com/postcss/postcss/blob/4.1.16/lib/parser.js#L26`
做法还是简单的遍历，每种类型写好处理函数，完成整个处理过程。

---

把主体部分改成了迭代，不过在处理样式时，还是很明显的递归下降解析。
