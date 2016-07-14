# How AMP Speeds Up Performance

---

https://www.ampproject.org/docs/get_started/technical_overview.html

---

翻了一下 AWP，好像对布局限制有点多？

---


+ Allow only asynchronous scripts
	- 避免 JS 阻塞页面渲染
	- 阻止 `document.write` 之类的调用
+ Size all resources statically
	- 分离 document layout 和 resource layout
	- 资源的大小固定，可以一开始就计算出正确的位置
	- 加载资源不会导致页面重绘
+ Don’t let extension mechanisms block rendering
+ Keep all third-party JavaScript out of the critical path
	- 第三方的资源，放到单独的 iframe 里加载执行
+ All CSS must be inline and size-bound
	- CSS 放在页面内，可以避免阻塞、减少请求数
	- inline CSS 的大小限制在 50kb 内
+ Font triggering must be efficient
	- render tree 构造好之后，才会开始请求字体
	- CSS inline，JS async，所以字体的请求能够及早发出
+ Minimize style recalculations
	- 读取元素的大小，会触发 style recalculation
	- AMP 里，DOM 读操作完成后，才会开始写操作
+ Only run GPU-accelerated animations
	- 只允使用 transform/opacity 这种能被 GPU 加速的动画
+ Prioritize resource loading
	- 优先加载必要的资源
	- 预加载开启懒加载的资源（loaded as late as possible, prefetched as early as possible
+ Load pages in an instant
	- 预加载页面
