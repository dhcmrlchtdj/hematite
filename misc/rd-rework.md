# rework parse

---

简单解释下 postcss 将 css 解析为 ast 的过程。

---

使用如下方式获得 ast

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
