# big pipe

---

https://www.facebook.com/notes/facebook-engineering/bigpipe-pipelining-web-pages-for-high-performance/389414033919
http://taobaofed.org/blog/2015/12/17/seller-bigpipe/
http://huoding.com/2011/06/26/88
http://www.onebigfluke.com/2015/01/experimentally-verified-why-client-side.html

---

1. 直接同步加载
2. 滚动同步加载
3. 异步加载
4. 滚动异步加载
5. 分块加载

淘宝列出的这五种模式中，只玩过 1 和 3

最早听说 bigpipe，以为是类似于异步加载的技术。
实际上，更接近后端渲染的直接同步加载。

---

bigpipe 的前提，页面可以拆分成多个部分，或者叫 pagelet。
使用异步渲染的方式，会是前端发送 xhr 请求数据，渲染 pagelet。
而 bigpipe 的做法，是由后端去请求数据，渲染 pagelet，再发送给前端。

如果只是这样，和普通的后端渲染就没有区别了。
不同点在于，bigpipe 不是在页面完全渲染好才返回给前端，
而是渲染好一块 pagelet 就发送一块。

为了让发送顺序可以更灵活，可以将组装页面交给 js。
后端一开始像异步渲染一样，先给出一个 layout 的 pagelet，浏览器渲染出 layout。
然后每个 pagelet 都包含一段 js，由 js 把这个 pagelet 放到 layout 中正确的位置。

---

相比普通的后端渲染，bigpipe 在用户看来，可能会快一些。
前提是，后端的不同接口之间存在这种肉眼可见的差距。

相比异步渲染，bigpipe 减少了浏览器的请求数。
一般服务器之间的请求都是内网调用，即使不是，至少带宽、网络等应该会比用户好一些。
所以，数据请求的速度应该应该会比客户端好一些。
服务端的渲染速度，可能会比浏览器更快些。
合起来，应该可能会比客户端异步渲染要快一些。
