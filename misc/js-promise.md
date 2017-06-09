# promise

---

修改了几次后，内容变得相当凌乱……
因为我自己对 promise 的理解也已经变得相当混乱……

难以理解的地方就直接看链接的一手资料吧。

---

+ https://github.com/kriskowal/q/blob/v1/design/README.js
+ http://blog.getify.com/promises-part-1/
+ https://blog.domenic.me/youre-missing-the-point-of-promises/
+ https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
+ http://people.mozilla.org/~jorendorff/es6-draft.html#sec-promise-objects

---

### promise && function

看过一次 q 的那篇文章，当时将 promise 理解为对函数的抽象。

promise 的许多细节，都可以用函数的行为来解释。
比如解析后状态不可改变，又比如最终会返回执行结果或是抛出错误。

---

### promise && callback

```js
$.get(url, callback);
$.get(url).done(callback);

$.post({
    url: url,
    data: data,
    success: callback
});
$.post({
    url: url,
    data: data
}).done(callback);
```

就我之前的体验来说

+ 简单情况下，promise 在写法上没什么优势。
+ 多层回调嵌套的情况下，由于可以链式调用，逻辑可以更连贯，还是有优势的。
+ 实际上，promise 还是在传递回调函数，只是换了个位置。

---

### promise && callback hell

+ promise 就是为了解决嵌套回调吗？
+ 还是在回调，那说好的能解决 callback hell 呢？
+ 话说回来，callback hell 到底是什么？

---

### callback hell

+ 不是语法上发生嵌套
+ 不是逻辑上被分割
+ 而是失去了回调函数的控制权

> 为什么要害怕失去控制权？
> 因为不知道异步调用会怎么处理回调函数。

---

### promise

使用 promise 之后，情况就发生了改变。

之前是异步调用在完成时调用回调函数，如何使用回调函数由异步调用决定。
现在是异步调用在完成时返回执行结果，如何处理返回值由当前程序控制。

> 不还是在传递回调吗？怎么就有控制权了？
> 只要返回的 promise 符合 `Promise/A+` ，那么行为就是可测的。

> 如果第三方提供的异步调用不安全，怎么保证返回的 thenable 对象符合 `Promise/A+` ？
> 对第三方提供的 thenable 对象进行一次封装，就能得到符合 `Promise/A+` 的 promise。

---

### js concurrency

小插曲，区分两个概念。

+ concurrency 并发，交替执行多个任务，真正在执行的只有一个
+ parallelism 并行，同时执行多个任务

js 在执行时采取并发的方式执行多任务。

---

### event

事件机制是 js 中常见的一种回调方式。

```js
window.addEventListener("load", callback);
stream.on("data", callback);
```

要说的话，我个人感觉 promise 和 event 在很多地方都很像。

```js
var ret = asyncCall();
ret.on("fulfilled", callback);
ret.then(callback);
```

---

### promise && event

不过，虽然都是在回调，但差别也很大。
`ret.on` 的 `ret` 是个事件通道，`ret.then` 的 `ret` 是 promise。
见 http://yuilibrary.com/yui/docs/promise/#diff 。

两者的要达到的目标也不太一样。
event 想要达到的效果，就是在不同事件发生时被触发，要求的就是异步处理。
promise 处理的则是函数调用没有返回值的情况，理想情况下，这些调用应该是同步的。

---

### promise && usage

```js
var p1 = new Promise(function(resolve, reject) { resolve(true); });
var p2 = Promise.resolve(123);
var p3 = Promise.all([p1, p2]);
var p4 = Promise.reject(new Error('string'));
var p5 = Promise.race([p3, p4]);
var p6 = p5.then(function(value) { console.log(value); });
var p7 = p6.catch(function(reason) { console.log(reason); });
```

---

### promise && usage

```js
var p1 = Promise.reject();
var p2 = Promise.resolve(p1);
p1 === p2; // true

var p3 = new Promise(function(resolve, reject) {
    throw new Error("blah"); // reject(new Error("blah");
});

var p4 = Promise.all([p1, p2, p3]); // reject one OR resolve all
var p5 = Promise.race([p1, p2, p3, p4]); // reject OR resolve the first
```

---

### promise && pain points

+ promise 拥有 addEventListener 的能力，却没有 removeEventListener 的能力。
+ ie678，`catch` 是保留字。

了解不多，不知道还有哪些痛点。
总之，promise 还太过简陋。
就像 on 比 addEventListener 好用一样，promise 还需要一个更称手的工具。

---

### promise && yield

http://wiki.ecmascript.org/doku.php?id=strawman:async_functions

---

END
