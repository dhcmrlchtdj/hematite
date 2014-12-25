# js timer

---

## event loop

---

虽然要讲的是 timer，不过 event loop 这东西还是要简单提一下。

1. 从 task queues 中取出待执行任务，然后执行该任务。
2. 执行 microtasks，直到 microtask queues 为空。
3. 渲染页面。
4. 回到 1。

---

简单讲，就是任务队列有 macrotask 和 microtask 之分。
调用下个 macrotask 之前，会把现有的 microtask 全部执行。

---

## timer

---

### setTimeout && setInterval

两者唯一的区别在于 `repeat flag` 是 `true` 还是 `false`。

两者都属于 macrotask。

---

#### 4ms

说 setTimeout/setInterval 的最小间隔为 4ms 是不准确的。
只有在 setTimeout/setInterval 发生多次嵌套的时候，才有最小 4ms 的限制。

> If nesting level is greater than 5, and timeout is less than 4, then increase timeout to 4.

执行如下代码，可以看到前几次并没有等待 4ms。

```js
(function() {
    "use strict";
    var loop = 1;
    var last = Date.now();
    setTimeout(function fn() {
        var now = Date.now();
        console.log(loop, now - last);
        last = now;
        if (++loop < 10) setTimeout(fn);
    });
})();
```

---

#### repeat

setTimeout 是多少毫秒后执行一次，setInterval 是每多少毫秒执行一次。

问题在于，如果在这个多少毫秒之后，函数还没执行，要怎么办。
setTimeout 的表现相当统一，虽然延迟了，回调还是要继续执行的。
setInterval 需要在执行后继续设置回调，如何理解“每”实在有点微妙，因为相同的代码在 chrome/firefox 下的表现不一致。

> Let task be a task that runs the following substeps:
> 3. If the repeat flag is true, then call timer initialisation steps again, passing them the same method arguments, the same method context, with the repeat flag still set to true, and with the previous handle set to handler.

个人认为，从上面这段话理解的话，setInterval 是在执行完当前回调之后，才设置下个回调的。

```js
// 文档描述的 setInteval 类似这种感觉
var chromeSetInterval = function(fn, timeout) {
    setTimeout(function _inner() {
        fn();
        setTimeout(_inner, timeout);
    }, timeout);
};

// 但 firefox 的 setInterval 是这种感觉
// 这也是我学习 js 时，对 setInterval 的理解
// 应该算 bug 吧
// 代码删了，感觉逻辑不对，改天重写
```

---

```js
// 赠送一段在 firefox/chrome 下表现不一致的代码
(function() {
    var start = Date.now();
    var last = Date.now();
    setInterval(function() {
        var now = Date.now();
        console.log('interval from last ', now - last, ' from start ', now - start);
        last = now;
    }, 1000);
})();

setTimeout(function f() {
    //console.log('delay start=======');
    var now = Date.now();
    var i = 0;
    while (Date.now() - now < 1000) i++;
    //console.log('delay end======');
    setTimeout(f, 3500);
}, 1500);
```

---

### requestAnimationFrame

requestAnimationFrame 在前文描述的 event loop 的 3 里面，应该算是属于 macrotask 吧。

在执行的时候和 microtask 有点类似，会按照注册的顺序，一次性执行所有的 requestAnimationFrame 回调。

---

#### timeout

event loop 3 的最后一步，会渲染页面。
因此，MDN 用下面这种说法来描述 requestAnimationFrame。

> call a specified function ... before the next repaint

回调的间隔不是 60fps 的 1000/60 ms，而是看浏览器什么时候开始渲染页面。
即使整个 event-loop 处在空闲的状态，没到渲染的时候，渲染函数都不会执行。

---

#### polyfill

因为回调间隔和浏览器渲染页面相关，所以靠 setTimeout 是不可能原原本本模拟出来的。
目前好像没有其他方法能获取浏览器下次渲染页面的时间吧。

```js
var myRequestAnimationFrame = requestAnimationFrame || function(fn) { setTimeout(fn, 1000/60); };
```

---

### setImmediate

可预见的未来内，chrome/firefox 都不会支持 setImmediate，不得不说是悲剧……

setImmediate 也是在 macrotask 中设置回调，但是没有 4ms 的限制。
下面直接讲讲如何用其他手段模拟 setImmediate。

---

### postMessage

说是 chrome 下用 postMessage 模拟出来的 setImmediate，性能比 ie 下原生的 setImmediate 还好。
所以为什么不好好实现一个 postMessage 呢……

---

简单实现

```js
var addMacrotask = function(cb) {
    var ch = Date.now();
    window.addEventListener("message", function(e) {
        if (e.data !== ch) return;
        cb();
    });
    window.postMessage(ch, "*");
};

```

---

### script onreadystatechange

给不支持 postMessage 的 ie6-8 用。

```js
var addMacrotask = function(cb) {
    var body = document.body;
    var script = doc.createElement("script");
    script.onreadystatechange = function() {
        script.onreadystatechange = null;
        body.removeChild(script);
        script = null;
        cb();
    };
    document.body.appendChild(script);
};
```

---

### process.nextTick

node 提供的这个方法，在 node 0.9 之前，是类似 setImmediate 的存在。
但从 node 0.9 开始，变成添加 microtask 了。

后面讲讲如何从浏览器中的 microtask。

---

### mutation observers

除了 mutation observe，同步的 xhr 请求使用了 microtask，html5.1 的 sortable 也用到了microtask。
但是，这么一列举，会发现根本没一个通用的方法在所有浏览器中操作 microtask。

---

下面是个简单的实现。

```js
var addMicrotask = function(cb) {
    var observer = new MutationObserver(cb);
    var node = document.createTextNode("");
    observer.observe(node, {characterData: true});
    node.data = 0;
};
```

---

+ https://html.spec.whatwg.org/multipage/webappapis.html
+ https://developer.mozilla.org/en-US/Add-ons/Code_snippets/Timers
+ https://github.com/YuzuJS/setImmediate
+ https://github.com/kriskowal/asap
+ http://www.nczonline.net/blog/2013/07/09/the-case-for-setimmediate/

---

+ https://promisesaplus.com/#point-67
+ https://bugzilla.mozilla.org/show_bug.cgi?id=686201
+ https://code.google.com/p/chromium/issues/detail?id=146172
