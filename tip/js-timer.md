# js timer

---

+ https://developer.mozilla.org/en-US/Add-ons/Code_snippets/Timers
+ http://www.nczonline.net/blog/2013/07/09/the-case-for-setimmediate/
+ https://html.spec.whatwg.org/multipage/webappapis.html#event-loops
+ https://github.com/YuzuJS/setImmediate
+ https://github.com/kriskowal/asap

---

### setTimeout

+ 下限为 4ms。
+ 实际间隔只多不少。

---

### setInterval

+ 下限为 4ms。
+ 实际间隔没谱。
+ 发现 chrome 的间隔变成两次调用之间的间隔，而是不固定时间间隔了。

---

### requestAnimationFrame

+ 近似于 `setTimeout(fn, 16)`。
+ mdn 上说，页面不活动时，raf 会降低频率。没感觉出来，不知道怎么测试……
+ 回调函数有个参数，接近 `performance.now()` 的值。

---

### setImmediate

+ 在当前代码执行完毕后，立刻执行回调。

