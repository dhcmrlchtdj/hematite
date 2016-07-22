# js timer

---

https://tc39.github.io/ecma262/#sec-jobs-and-job-queues
https://w3c.github.io/html/webappapis.html#integration-with-the-javascript-job-queue
https://html.spec.whatwg.org/multipage/webappapis.html#animation-frames

---

上次写 timer 的时候，规范还没明确。
最近看人聊起，又翻了一下。

js 里的 `job`， 到 html 里会是 `microtask`。

---

现在文档都在 github 上更新了呀。

---

突然开始纠结 `requestAnimationFrame` 是 microtask 还是 macrotask。

查了下文档，浏览器会维护一个回调队列，`list of animation frame callbacks`。
这个 list 是有序的，先入先出。

在开始执行回调的时候，浏览器会把这个 list 复制一份，再清空原来的 list。
所以嵌套的 requestAnimationFrame 调用，在下一次渲染时才执行。

至于前面的 microtask 还是 macrotask，以前的笔记里就有，属于 macrotask。
人果然健忘……
