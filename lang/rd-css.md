# css parser

---

## tl; dr

---

从编码角度，个人偏爱 postcss。
其一是因为编码规范相近，看 rework 的的代码到处都是报警，不得不把代码检查关掉。
其二是组织方式，rework 所有代码都在一个 js 文件中，相比之下 postcss 按功能对 js 进行了划分，清晰不少。

---

从实现角度，也不好说什么好坏。
rework 简直是教科书式的递归下降法，代码就是对 css 语法进行完整翻译。
postcss 将大部分递归改成了迭代，不过还是递归下降法，也很容易理解。

---

## rework

---

rework 使用如下方式获得 ast

```js
var ast = css.parse(css, options);
```

---

解析代码比较混乱

```js
// https://github.com/reworkcss/css/blob/v2.2.1/lib/parse/index.js#L80

  function stylesheet() {
    var rulesList = rules();

    return {
      type: 'stylesheet',
      stylesheet: {
        rules: rulesList,
        parsingErrors: errorsList
      }
    };
  }
```

上面的 `rules` 开始了循环

---

```js
// https://github.com/reworkcss/css/blob/v2.2.1/lib/parse/index.js#L112

  function rules() {
    var node;
    var rules = [];
    whitespace();
    comments(rules);
    while (css.length && css.charAt(0) != '}' && (node = atrule() || rule())) {
      if (node !== false) {
        rules.push(node);
        comments(rules);
      }
    }
    return rules;
  }
```

去掉空白和注释后，正式开始循环解析。
后面的细节不展开了，教科书式的递归下降写法。

---

## postcss

---

postcss 使用如下方法获得 ast

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
