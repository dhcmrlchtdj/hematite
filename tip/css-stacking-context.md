# stacking context

---

https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Positioning/Understanding_z_index/The_stacking_context

---

以前看 z-index 文档的时候，关于什么时候会创建 stacking context，留下一句查最新文档。
最近还真的踩坑了。

之前都不知道 `-webkit-overflow-scrolling: touch` 也会创建新的 stacking context。
电脑上的浏览器又不支持这个属性，结果就是手机上测试的时候才发现结果不符合预期。

就个人来说，想要创建 stacking context 的时候，
都会修改元素的 `position` 属性，指定元素的 `z-index`。
其他属性自顾自地创建 stacking context，其实都是不符合我个人期望的……
浏览器的这些规则，更多是出于性能考虑吗？

---

再抄一段 mdn 的文档

+ root element
+ `position: fixed`
+ `position: absolute | relative` + `z-index: val`
+ `opacity`
+ `transform`
+ `filter`
+ `-webkit-overflow-scrolling set: touch`
+ `perspective`
+ `mix-blend-mode`
+ `will-change`
+ `isolation`
