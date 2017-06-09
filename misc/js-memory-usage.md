# memory usage

---

https://docs.webplatform.org/wiki/apis/timing/properties/memory
https://github.com/mathieuancelin/js-repaint-perfs/blob/gh-pages/lib/memory-stats.js#L61

---

virtual dom 的演示页面上，大都会有内存使用的监控。
看了下，都是用 chrome only 的 `performance.memory` 来实现的。

`usedJsHeapSize` is the total amount of memory being used by JS objects including V8 internal objects
`totalJsHeapSize` is current size of the JS heap including free space not occupied by any JS objects

---

`open -a "Google Chrome" --args --enable-precise-memory-info` 的结果会更精确一些。
