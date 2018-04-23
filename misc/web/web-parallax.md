# parallax scrolling

---

https://developers.google.com/web/updates/2016/12/performant-parallaxing
http://keithclark.co.uk/articles/pure-css-parallax-websites/

---

> avoid a JavaScript-based solution that moves elements based on scroll events
> change background-position causes the browser to repaint the affected parts of the page on scroll

scroll event 和 background-position 都不好方法

---

```html
<style>
.container {
  width: 100%;
  height: 100%;
  overflow-x: hidden;
  overflow-y: scroll;
  perspective: 1px;
  perspective-origin: 0 0;
}

.parallax-child {
  transform-origin: 0 0;
  transform: translateZ(-2px) scale(3);
}
</style>

<div class="container”>
  <div class="parallax-child”></div>
</div>
```

主要是 3 个相关属性
通过 perspective 和 translateZ 计算出 scale
- `perspective: 1px` `translateZ(-2px)`
- (perspective - distance) / perspective => (1 - -2) / 1 = 3
- `scale(3)`

---

```html
<div class="container”>
  <div class="parallax-container”>
    <div class="parallax-child”></div>
  </div>
</div>

<style>
.container {
  overflow-y: scroll;
  -webkit-overflow-scrolling: touch;
}

.parallax-container {
  perspective: 1px;
}

.parallax-child {
  position: -webkit-sticky;
  top: 0px;
  transform: translate(-2px) scale(3);
}
</style>
```

ios 的 safari 比较麻烦，所以有了上面的方案
