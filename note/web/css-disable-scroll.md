# css disable scroll

---

http://luxiyalu.com/playground/overlay/

---

在弹出 modal 的时候，会希望 modal 可以滚动，但是背后的也没是不能滚动的。

---

在 pc 上是比较好处理的

```css
body {
    overflow: hidden;
    position: absolute;
}
```

但是 `position: absolute` 在移动端不能阻止滚动啊。
使用 `position: fixed` 是可以阻止滚动，但是会自动跳转到页面顶部，完全不能用啊。

---

搜了一圈，找到一个不错的做法。
虽然对 html 结构有要求，但是能满足不滚动的要求啦。

```html
<div class="overlay">
    <div class="overlay-content"></div>
</div>

<div class="background-content">
    lengthy content here
</div>
```

```css
.overlay{
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.8);

    .overlay-content {
        height: 100%;
        overflow: scroll;
    }
}

.background-content{
    height: 100%;
    overflow: auto;
}
```

---

果然最近又遇到这个问题了。
确实是非常赞的方案。

最主要的，其实是 `.background-content` 上的属性设置。
首先，内容的高度固定，即从 `html` 一直到 `.background-content` 都设置了 `height:100%`
其次，内容溢出时设置了 `auto`，这使得内容的高度不超出容器高度，对外层来说，就不需要滚动了。
可以把几个 height 去掉，把 auto 去掉测试一下能更直观的理解吧。
