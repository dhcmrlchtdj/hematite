# BFCache

---

https://developer.mozilla.org/en-US/docs/Working_with_BFCache
https://developer.mozilla.org/en-US/Firefox/Releases/1.5/Using_Firefox_1.5_caching
https://webkit.org/blog/516/webkit-page-cache-ii-the-unload-event/
http://caniuse.com/#feat=page-transition-events

---

`BFCache / Back-Forward Cache` 会影响浏览器前进后退时的行为。

---

在离开页面的时候，如果满足条件，页面会被加入 BFCache。
整个页面都会冻结，包括各种执行中的 JS。

在点击浏览器的前进、后退时。
如果 BFCache 里没有可用的缓存，那么和打开一个新页面是一样的。
如果 BFCache 里有可用的缓存，那么之前冻结的页面会被重新加载，

如果页面被放入 BFCache，会触发 pagehide 事件。
如果页面是从 BFCache 中加载的，会触发 pageshow 事件。

按照 Firefox 的说法，直到浏览器关闭之前，BFCache 都是有效的。

---

如果出现满足下面的条件，页面不会进入 BFCache

+ 页面注册了 `unload` 或者 `beforeunload` 的回调
+ header 里设置了 `cache-control: no-store`
+ 设置了 `Cache-Control: no-cache` 或 `Pragma: no-cache` 或 `Expires: 0/expired` 的 HTTPS 页面
+ 离开前，页面还没加载完或者有未结束的网络请求
+ 页面正在执行 IndexedDB 事物
+ 页面里有 iframe，并且这个 iframe 满足上述任意条件而无法进入 BFCache
+ 页面本身在 iframe 里，用户又在这个 iframe 上加载了新页面

---

打开一个页面的正常流程

1. User navigates to a page.
2. As the page loads, inline scripts run.
3. Once the page is loaded, the onload handler fires.
4. (optional) fire unload/beforeunload event.

如果是从 BFCache 中读取的页面，不会触发 2/3/4。

想要利用 BFCache 又想要知道用户进入或离开页面，可以用 `pageshow/pagehide`。
按 Can I Use 的数据，除了 IE 都支持。

条件允许，就使用 pageshow/pagehide 代替 load/unload。
在后退之类的场景，用户体验会有所提升。

---

TODO

BFCache 碰到 pushState 之类的 API 会怎么样
待测试
