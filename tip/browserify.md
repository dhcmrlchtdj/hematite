# browserify

---

### output

+ browserify 生成的代码，简化后差不多是下面这样的。
+ 实际也不会更复杂，看 browser-pack/prelude.js 去。

```js
(function outer(modules, cache, entry) {
    function newRequire(name, jumped) {
        if (!cache[name]) {
            var m = cache[name] = { exports: {} };
            modules[name][0].call(m.exports, function(x) {
                var id = modules[name][1][x];
                return newRequire(id ? id : x);
            }, m, m.exports);
        }
        return cache[name].exports;
    }

    for (var i = 0; i < entry.length; i++) {
        newRequire(entry[i]);
    }
})({
    "a1b5af78": [
        function(require, module, exports) {
            console.log(require('./foo')(5))
        }, {
            "./foo": "b8f69fa5"
        }
    ],
    "b8f69fa5": [
        function(require, module, exports) {
            module.exports = function(n) {
                return n * 111
            }
        }, {}
    ]
}, {}, ["a1b5af78", "b8f69fa5"]);
```

---

+ 发生循环依赖的时候，得到的是缓存中的空对象。如果使用得当，是可以正常工作的。
+ 语法分析的限制，导致不支持动态 require，好像也不能算什么毛病。
+ 在 require 失败的时候，会尝试调用外部的 require。
+ browserify 在模块外面包了一层 `function(require, module, exports){}`，但实际暴露的变量要更多些。

---

### non-browserify module

有人维护的前端代码，应该都是支持 browserify 的。
不支持也还有各种 transform 能搞定。
实在不行，写个 polyfill 也是分分钟的事情。

```js
require("module-name");
module.exports = window.MODULE_NAME;
```

---

### pros && cons

+ 相比使用 combo，browserify 能保留文件间的依赖关系。
+ 相比使用加载器，browserify 不用担心部分代码加载失败的问题。
+ 相比加载器配合 combo，browserify 确实没什么优势。
+ 需要动态加载代码的时候，browserify 确实不如直接用加载器。
    - 或者应该说这时就算用了 browserify，还是需要一个加载器。
+ 多页面共享基础库时，browserify 不能利用页面缓存，是个不足之处，不过 combo 同样不能。

总体来说，browserify 差不多就是保留了依赖关系的 combo。
即使使用了 browserify，需要动态加载脚本的场景，一个加载器还是必不可少的。

---

### tip

+ 我不直接使用 npm 安装依赖，原因有三
    - 不能多版本共存
    - 前端依赖和开发工具的依赖混在一起
    - 不好对依赖的代码进行修改
