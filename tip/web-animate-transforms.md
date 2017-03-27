# expand & collapse animations

---

https://developers.google.com/web/updates/2017/03/performant-expand-and-collapse
https://developers.google.com/web/fundamentals/performance/rendering/
https://developers.google.com/web/fundamentals/performance/rendering/stick-to-compositor-only-properties-and-manage-layer-count

---

js -> style -> layout -> paint -> composite

- 可以认为 composite 是不可避免的
- layout 修改要出发 reflow，开销最大，因为后续的 paint/composite 也还是要执行
- paint 即绘制，重绘开销比重排小一点，毕竟少了 layout 的计算
- `opacity` 和 `transform` 都只要 composite，实现动画时应该优先考虑
- 用 `will-change: transform`/`transform:translateZ(0)` 来出发硬件加速

---

`transition: width 600ms ease-out, height 600ms ease-out;`

像这样用宽高实现动画，性能其实不好。
绘制每一帧的时候都要重新计算。

---

`transition: clip 600ms ease-out;`

像这样用 clip 实现动画，虽然可以啦。
但是，支持不多，而且 clip 本身已经被废弃了。

---

结合前面说的，想也能想到，直接用 `transform` 来实现动画。
先对容器进行 `scale` 缩小，再对内容进行 `scale` 放大，实现打开、关闭的效果。
