# child height

---

http://stackoverflow.com/questions/8468066/child-inside-parent-with-min-height-100-not-inheriting-height
https://www.w3.org/TR/CSS22/visudet.html#propdef-height

---

> The percentage is calculated with respect to the height of the generated
> box's containing block. If the height of the containing block is not
> specified explicitly (i.e., it depends on content height), and this element
> is not absolutely positioned, the used height is calculated as if 'auto'
> was specified.

标准里说，高度为百分比时，会根据父元素的高度来计算。
如果父元素没有指定高度，那么高度会被视为 auto。

看着非常合理，但是那句 `specified explicitly` 却有坑在里面……

---

```css
.parent {
	min-height: 100%;
}
.child {
	height: 100%;
}
```

上面的 CSS，理想情况应该是父元素高度 100%，子元素高度也 100%。
但是，由于父元素没有设置 `height`，所以，子元素实际上是 auto。

。。。

---

stackoverflow 上提供了一个很棒的解决方案。

```
.parent {
	min-height: 100%;
	height: 1px;
}
.child {
	height: 100%;
}
```

是的，加个 1px 的高度就好……

---

在网上问了下，算是想明白了。

核心的问题是，只有 `min-height:100%` 时，高度是不确定的。
如果子元素的高度大于父元素的高度，那么元素的高度是要大于 `min-height:100%` 的。
即子元素的高度决定父元素高度，这时子元素再 `height:100%` 就循环依赖了。
更容易理解的例子，如果父元素 `min-height:100%` 子元素 `height:150%`，
这时根本无法计算，所以规范就将子元素视为 `height:auto` 了。

父元素加上 `height:1px` 之后，父元素的高度就确定了，
也就是 `min-height:100%` 对应的高度。
这个时候子元素的 `height:100%` 才能真正是个可计算的值。
