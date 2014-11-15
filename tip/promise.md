# promise

---

+ https://github.com/kriskowal/q/blob/v1/design/README.js
+ http://blog.getify.com/promises-part-1/
+ http://people.mozilla.org/~jorendorff/es6-draft.html

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

就我之前的体验来说，promise 在写法上没什么优势。
更直白些，promise 只是把回调函数换了个位置。

---

### promise && callback hell

说好的能解决 callback hell 呢？

话说回来，callback hell 到底是什么？

---

### callback hell

+ 不是语法上发生嵌套
+ 不是逻辑上被分割
+ 而是失去了回调函数的控制权

> 为什么要害怕失去控制权？
> 是为了使用第三方代码时更加安全。

---

### promise && callback hell

通过换一种写法，从传递回调函数，变成了监听状态。

之前是异步调用在完成时调用回调函数。
现在时异步调用在完成时告知结果。

> 如果第三方提供的异步调用不安全，返回的 promise 又能安全到哪去？
> 再封装一层就可以了。

---

### js concurrency

区分两个概念

+ concurrency 并发，交替执行多个任务，真正在执行的只有一个
+ parallelism 并行，同时执行多个任务

js 执行时采取的是并发的方式。

---

### promise && event
