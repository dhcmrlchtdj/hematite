### data-main
requirejs 从 data-main 开始加载脚本。

虽然时从 data-main 开始载入的，但是所有再如过程时异步的，
所以不能保证 data-main 一定比后面的文件先载入。
因此，data-main 经常放 config，并引入最初的模块。


### 关于 baseUrl
1. 在 config 中设置了 baseUrl。使用配置的 baseUrl。
2. 没 config，设置了 data-main。使用 data-main 的目录作为 baseUrl。
3. 没 config 也没 data-main。使用引入 requirejs 的 html 的目录作为 baseUrl。

引入依赖的时候，使用的相对路径都是相对 baseUrl 进行查找的。


### 关于 js 后缀
requirejs 假设所有依赖都是 js，模块 id 后面不能出现 `.js`。（原因在下面。）


### 直接引入文件

在满足如下条件时，文件不再相对 baseUrl 进行查找。

* 以`.js`结尾。（相对 html 文档目录进行查找。）
* 以`/`开头。（绝对路径）
* 包含协议，如 file:，https:。


### 查找依赖文件

```
requirejs.config({
    baseUrl: "js/lib",
    paths: {
        app: "../app"
    }
})
requirejs([jQuery, app/sub], function(jq, sub) {});
```

在 config 里面，设置了 baseUrl，所以后面的 jQuery 就是去查找`js/lib/jQuery.js` 。
在 config 的 paths 里，设置了 app，所以后面的 app/sub 会被拓展成 `../app/sub`，
再加上 baseUrl，变成了 `js/lib/../app/sub.js` 也就是 ``js/app/sub.js`。

简单总结就是 baseUrl + paths + id + .js。

baseUrl 在前面，.js 在后面，paths 会替换掉 id **开头** 的部分。
paths 只会替换最前面的部分，替换一次。



### 执行过程

requirejs 为每个依赖创建一个 script 标签，然后使用 head.appendChild() 插入文档中。

在执行时，requirejs 会等待所有依赖载入，然后按照顺序调用这些模块。


### 配置

配置可以放在 data-main 里面，也可以直接放在页面上。

```
<script src="path/to/require.js"></script>
<script>
require.config({
    baseUrl: "another/path",
    paths: {
        ex: "example"
    },
    waitSeconds: 0
);
require(
    ["zepto", "ex", "a.js", "http://xxx.xxx/xxx.js"],
    function optionalCallback($, ex, a, xxx) {
        // callback will be called while all dependences be loaded.
    }
);
</script>
```

除了放在后面，还可以放在前面。

```
<script>
var request = {
    deps: ["zepto", "ex", "a.js", "http://xxx.xxx/xxx.js"],
    optionalCallback: function($, ex) {}
}
</script>
<script src="path/to/require.js"></script>
```

下面时具体配置选项

* baseUrl  
* paths  
    这个默认是相对 baseUrl 的路径。
    但是，如果 paths 以 `/` 或协议开头，会被是为绝对路径，不再涉及 baseUrl。
* waitSeconds  
    等待文件载入，默认等待 7 秒，超过会抛出超时错误。设为 0 可以禁用该功能。
* shim  
    用来处理非 AMD 模块的依赖。

    ```
    shim: {
        "backbone": {
            deps: ["underscore", "jquery"],
            exports: "Backbone"
        },
        "underscore": {
            exports: "\_"
        },
        "backbone.layoutmanager": {
            deps: ["backbone"],
            exports: "Backbone.LayoutManager"
        }
    }
    ```

    可以设置依赖和暴露的变量。  
    需要注意一点，shim 的模块不能依赖于 amd 的模块，
    只能依赖于 shim 的模块或无依赖。
