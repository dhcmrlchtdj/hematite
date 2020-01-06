# inline height

---

早就该写了，却拖到现在。

---

## `font-size`

+ 可以是百分比，相对于父元素的 font-size 计算
+ 实在没太多可说的，毕竟比较简单

---

## `line-height`

https://www.w3.org/TR/CSS22/visudet.html#propdef-line-height
https://developer.mozilla.org/en-US/docs/Web/CSS/line-height

+ 在 block level element 中，line-height 指定了 element 中 line box 的最小高度
+ 在 non-replaced inline element 中，line-height 指定的高度被用于计算 line box 的高度
+ 在 replaced inline element 中，line-height 无效。（MDN 说规范这么规定，实际都有效……）

+ 值为百分比时，computed value 是根据元素的 font-size 的 computed value 计算出来的定值。
+ 值为无单位数字时，computed value 仍是这个无单位数字。
    由于 CSS 继承的是父元素的 computed value，所以这个结果通常比百分比更符合预期。
+ 值的单位为 em 这种相对单位时，可能的问题和百分比是相同的。影响继承的元素。

---

## `vertical-align`

https://www.w3.org/TR/CSS22/visudet.html#propdef-vertical-align
https://developer.mozilla.org/en-US/docs/Web/CSS/vertical-align
http://www.zhangxinxu.com/wordpress/2015/08/css-deep-understand-vertical-align-and-line-height/

+ 是对 inline box 生效的属性
+ 应用于 inline-level elements 和 'table-cell'。
    在 table 下 baseline 之类的关键字语义是不同的，下面只记录 inline 的情况。

+ top/bottom 以外的取值，都是相对父元素来确定位置的。
    对于 inline non-replaced element，对齐的 box 是高度为 line-height 的 box。
    对于其他元素，对齐的 box 是 margin box。
+ 百分比是相对于 line-height 计算的，0% 等同 baseline，相对 baseline 移动多长的距离
+ 一个不可继承的属性，默认值 baseline 的意思是将元素的 baseline 与父元素的 baseline 对齐。
    如果元素本身没有 baseline，将 bottom margin edge 与父元素的 baseline 对齐。
+ 取值 middle 时，是父元素的 baseline 加上父元素的半个 x-height。
    简单理解，X 的下边界，就是 baseline，中间就是 middle。

+ 值为 top/bottom 时，是相对于 line box 来对齐的。

line-height 还是太复杂……
