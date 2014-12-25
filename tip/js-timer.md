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
var firefoxSetInterval = function(fn, timeout) {
    var last = Date.now();
    var _innerTimeout;
    setTimeout(function _inner() {
        fn();
        var now = Date.now()
        _innerTimeout = now - last;
        _innerTimeout = (_innerTimeout > timeout ?
                         timeout - _innerTimeout % timeout :
                         timeout);
        last = now;
        setTimeout(_inner, _innerTimeout);
    }, timeout);
};
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

requestAnimationFrame 在前文描述的 event loop 的 3 里面，属于 macrotask 吧。

在执行的时候和 microtask 有点类似，会按照注册的顺序，一次性执行所有的 requestAnimationFrame 回调。

---

#### timeout

event loop 3 的最后一步，会渲染页面。
因此，MDN 用下面这种说法来描述 requestAnimationFrame。

> call a specified function ... before the next repaint

---

#### polyfill

简单讲就是，requestAnimationFrame 的特性太复杂，不可能原原本本模拟出来。

```js
var myRequestAnimationFrame = requestAnimationFrame || function(fn) { setTimeout(fn, 1000/60); };
```













+ https://html.spec.whatwg.org/multipage/webappapis.html
+ https://developer.mozilla.org/en-US/Add-ons/Code_snippets/Timers












+ http://www.nczonline.net/blog/2013/07/09/the-case-for-setimmediate/
+ https://html.spec.whatwg.org/multipage/webappapis.html#event-loops
+ https://github.com/YuzuJS/setImmediate
+ https://github.com/kriskowal/asap

