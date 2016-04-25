# viewport

---

重新整理一次

---

https://developers.google.com/speed/docs/insights/ConfigureViewport
https://developers.google.com/web/fundamentals/design-and-ui/responsive/fundamentals/set-the-viewport
http://www.quirksmode.org/blog/archives/2012/07/more_about_devi.html
http://www.quirksmode.org/mobile/metaviewport/

---

几个关键概念

+ `hardware pixel`，设备的实际像素，比如 iphone5 是 `640`，iphone6 是 `750`
+ `device-independent pixel（dip）`，设备独立像素，比如 iphone5 是 `320`，iphone6 是 `375`
+ `CSS pixel`，CSS 中指定 px 时的实际像素

物理像素和独立像素之间可以进行换算，比值为 `devicePixelRatio`。
`devicePixelRatio = hardware pixels / dip`
比如 iphone6 为 `2 = 750 / 375`。

---

## `width=device-width`

width 指定了 `CSS pixel` 的数量。
`device-width` 的值，就是 `dip` 计算下对应的设备宽度。
合起来就是 `CSS pixel = dip`。

在 `width=device-width` 的情况下，可以通过 `document.documentElement.clientWidth` 获取 `dip`。
（看 PPK 的总结，`screen.width` 是不准确的。）

---

## `initial-scale=1`

`scale = CSS pixel / dip`，即 scale 是 CSS 和 dip 的比值。
其中 dip 是定值，所以实际作用是设置 CSS 意义下的像素大小 `CSS = scale * dip`。

其中在 `scale = 1` 的时候，CSS 意义下的宽度即为 dip 计算下的设备宽度。
结果上等价于 `width=device-width`。

另外可以推导出，要让宽度为实际像素，即
`CSS / hardware = 1 = (dip * scale) / hardware = (hardware / devicePixelRatio * scale) / hardware = scale / devicePixelRatio`
也就是 `scale = 1 / devicePixelRatio`。

---

## conflict

当 `initial-scale` 和 `width` 的定义发生冲突的时候，
会取两者中让 CSS 像素比较小的那一个，也就是宽度比较大的那一个。

---

以下为旧内容

---

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

---

https://developers.google.com/speed/docs/insights/ConfigureViewport
https://developers.google.com/web/fundamentals/design-and-ui/responsive/fundamentals/set-the-viewport

google 的说法

---

+ 推荐使用 `<meta name=viewport content="width=device-width, initial-scale=1">`
+ 没有 viewport 时是自动适配 width 是个范围而不是固定值，从 800 到 1024
+ `width=device-width` 时，iOS 和 WP 在旋转的时候会选择缩放页面而不是重排
+ `width=device-width` 将页面宽度设置为 dip 的大小
    （即 physical pixels / devicePixelRatio，比如 iphone5 为 640/2=320，iphone6p 为 1242/3=414）
+ 加上 `initial-scale=1` 会让 css pixel:dip = 1:1
+ Hardware pixel／Device-independent pixel／CSS pixel
+ `devicePixelRatio = physical pixels / dips`
