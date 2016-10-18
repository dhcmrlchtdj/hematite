# web performance

---

http://calendar.perfplanet.com/2012/deciphering-the-critical-rendering-path/
http://calendar.perfplanet.com/2010/the-truth-about-non-blocking-javascript/
http://www.lognormal.com/blog/2013/11/11/calculating-first-paint/

---

最近又开始搞性能优化，测数据、查资料、做优化、测数据。
基本是这么个循环。

主要关注下 DOMContentLoaded 和 load 两个指标。

---

测数据这块，chrome 的 devtools 基本够用了。
Network / Timeline / Audits 三个面板基本能把问题都定位出来。

---

对于 DOMContentLoaded，有影响的无非两个东西，JS 和 CSS。

JS 加上 defer 后不会阻塞后续的资源加载，同时能保证执行顺序。
但是需要注意，脚本是在 DOMContentLoaded 事件之前执行的。
（原因：DOMContentLoaded 要求是 DOM 和 CSSOM 都完成构建。
DOM 完成构建后，defer 的脚本开始执行，这个时候还是可能影响 CSSOM 构建的
所以会等到 JS 执行完才触发 DOMContentLoaded。

想要不影响 DCL，比较直接的方式就是把 defer 换成 async。
这其实就是个资源在哪里进行控制的问题，只要有个优先的加载管理器，
入口文件 async 应该不是个问题。

CSS 要处理的话比较简单，必要的 CSS 可以內联，剩下的直接 JS 插入即可。

（有没有必要做这些事情，看实际需求了

---

对于 load，先考察一下 JS。

async 对不保证执行时间，不保证执行顺序。
但前面也说了，合格的加载器应该把这些问题都解决掉，所以并不是问题。
但是有一点，async 的脚本会在 load 之前执行。

如果想要让 load 的时间尽量提前，可以用 `setTimeout` 配合动态插入脚本。
所以还是加载器的事情
（还有就是页面依赖的第三方脚本给不给面子了

---

写到这里，我都还不知道，到底 DOMContentLoaded / load 受什么影响……

https://www.w3.org/TR/uievents/#event-type-load
