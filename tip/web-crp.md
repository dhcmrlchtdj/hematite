# critical rendering path

https://developers.google.com/web/fundamentals/performance/critical-rendering-path/

---

浏览器渲染一个页面需要如下步骤

1. 将 HTML 转化成 `DOM`

    - devtools 中叫做 `Parse HTML`

2. 将 CSS 转化成 `CSSOM`

    - devtools 中叫做 `Recalculate Style`

3. 将 `DOM` 和 `CSSOM` 组合成 `render tree`

    - `render tree` 中只包含需要渲染的节点
    - 排除的有 `<script>` 之类的标签和 `display:none` 的节点

4. 计算 `render tree` 中节点的样式

    - devtools 中叫做 `Layout`
    - 计算的结果就是我们熟知的 `box model`
    - 重新计算的过程就是所谓的 `reflow`

5. 将 `render tree` 绘制到页面上

    - devtools 中叫做 `Paint`

上述每个步骤都会阻塞页面渲染，要优化 `critical rendering path`，
即是优化上述五个步骤的处理速度。

---

+ 下载和处理 HTML 和 CSS 会阻塞渲染
+ 这种阻塞渲染的资源叫做 `render blocking resources`
+ media types 和 media queries 能让 css 不阻塞渲染
    - 例如标记为打印使用的 css 就不会阻塞页面渲染
+ 不管是否阻塞渲染，css 都会被下载

---

+ 要优化页面渲染，必须理解 HTML/CSS/JS 之间的依赖关系
+ 执行 JS 会阻塞 DOM 构造
+ JS 能够读取节点的属性，所以会等待 CSSOM 完成解析后再执行

---

`performance.timing` 中和渲染紧密相关的有

+ `domInteractive` 是 DOM 可用
+ `domContentLoadedEventStart` 是 DOM 和 CSSOM 可用
+ `domComplete` 是页面中的资源都可用了

---

优化渲染的通常思路是

1. 分析页面渲染依赖的资源数量、大小
2. 然后尽可能减少资源数量，消除非必须的，延迟无关紧要的
3. 优化必须资源的加载顺序
4. 减小必要资源的体积
