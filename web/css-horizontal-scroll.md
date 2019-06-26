# horizontal scroll

---

https://css-tricks.com/pure-css-horizontal-scrolling/

---

```css
.horizontal-scroll-wrapper {
  width: 100px;
  height: 300px;
  overflow-y: auto;
  overflow-x: hidden;
  transform: rotate(-90deg);
  transform-origin: right top;
}

.horizontal-scroll-wrapper > div {
  width: 100px;
  height: 100px;
  transform: rotate(90deg);
  transform-origin: right top;
}
```

JS 实现的滚动，有个问题就是滚动不平滑，受不了。

这个方案比较神奇的地方是，`transform` 旋转之后，还可以用垂直方向的滚动
