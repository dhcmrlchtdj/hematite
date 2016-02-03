# viewport

+ http://www.quirksmode.org/mobile/metaviewport/
+ https://github.com/amfe/lib-flexible/blob/master/src/flexible.js

---

+ `width`
+ `initial-scale`
+ `minimum-scale`
+ `maximum-scale`
+ `user-scalable`

---

+ 获取页面宽度可以用 `document.documentElement.clientWidth`
+ ios 下，使用 `screen.width` 拿到的始终是 `portrait` 下的宽度，拿不到 `landscape` 时的宽度。

---

`initial-scale` 会设置宽度，有了 `initial-scale` 就不需要 `width` 了。

+ 在 android 下，`initial-scale` 只能设置为 `1`。
+ 在 android 下，`initial-scale` 和 `width` 同时存在时，最小值为 `device-width`，超过时以 `width` 为准。
+ 其他环境中，两者同时存在时，实际宽度会取两者中较大的一个。

---

```js
(function() {
    var isIPhone = window.navigator.appVersion.match(/iphone/i);
    var devicePixelRatio = window.devicePixelRatio;
    var dpr = 1;
    if (isIPhone) {
        if (devicePixelRatio >= 3) {
            dpr = 3;
        } else if (devicePixelRatio >= 2) {
            dpr = 2;
        }
    }
    var scale = 1 / dpr;

    var metaViewport = '<meta name="viewport" content="initial-scale=' + scale + '" />';
    document.write(metaViewport);

    var docEl = document.documentElement;
    //var width = docEl.getBoundingClientRect().width;
    var width = docEl.clientWidth;
    if (width / dpr > 450) width = dpr * 450;
    var rem = width / 6.4;
    docEl.style.fontSize = rem + 'px';
})();
```

---

https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/UsingtheViewport/UsingtheViewport.html

发现写了这么久的页面，对于 viewport，还是没有完全理解。

---

+ 如果没有设置 viewport，ios 默认为 `width=980`。
+ 如果 viewport 中没有显式设置 `initial-scale` `width` `height`，safari 会自动推断一个值。
+ 只设置 `initial-scale=1`，则会推断出 `width=device-width`。
    文档中的说法，是横屏时取 `device-width` 竖屏时取 `device-height`，但是和测试的结论对不上。
    如果按文档的说法，`device-width` 应该和横屏竖屏无关。
    但是显式指定 `width=device-width` 时，`device-width` 仍然会随横竖屏变化。
    只能认为，文档太久……
+ 当只设置 `width` 时，上面说了 `device-width` 的情况，不再提了。感觉后面不靠谱
+ 当同时设置了 initial-scale 和 width 时，文档的说法是会维持比例，可是这个是什么和什么的比例呀……
