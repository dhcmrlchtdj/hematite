# JSON.stringify

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify

---

`JSON.stringify(value[, replacer[, space]])` 的后两个参数非常实用。

`space` 在输出 JSON 到文件的时候，能够达到格式化的目的。
`replacer` 在需要对输入进行预处理是非常有用。

---

```js
var pkg = require('./package.json');
pkg.version = patch(pkg.version);
var output = JSON.stringify(pkg, null, 2);
```

---

```js
var obj = {
    name: 'example',
    callback: function() {
        console.log('blahblah');
    }
};
var replacer = function(key, value) {
    if (typeof value === 'function') {
        return 'function';
    } else {
        return value;
    }
};
var original = JSON.stringify(obj); // '{"name":"example"}'
var output = JSON.stringify(obj, replacer); // '{"name":"example","callback":"function"}'
```
