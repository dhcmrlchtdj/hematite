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
    top: 0px;
    left: 0px;
    right: 0px;
    bottom: 0px;
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
