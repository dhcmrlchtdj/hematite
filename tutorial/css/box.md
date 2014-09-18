+ http://www.w3.org/TR/CSS2/box.html

---

## negative

+ margin 允许负值
+ padding 不允许负值
+ 规范没有规定负值的渲染方式，取决于具体实现

---

## percentage

+ 百分比是根据容器的宽度计算的
+ 规范没有规定，在容器宽度取决于元素时，如何计算百分比

---

## margin collapsing

+ 相邻的垂直外边距会叠加，除非
    - 元素是 root
    - 元素清理了浮动
+ 注意下是垂直，水平方向不会叠加
+ 相邻的外边距才会叠加，所谓相邻是指
    - 两个元素都是 in-flow 块级元素，且属于同一个 BFC
    - 两个外边距之间没有 行内元素／清理浮动／边界／内边距
    - 满足如下任一条件
        * top margin of parent／top margin of first child
        * bottom margin of box／top margin of next sibling
        * bottom margin of last child／bottom margin of parent（要求父元素的高度为 auto）
        * top／bottom of box（要求没有建立 BFC，高度为 0，没有 in-flow 子元素）
+ 总结起来就是
    - 浮动元素不会发生外边距叠加，不管是外部还是内部
    - 建立 BFC 的元素不和内部元素的外边距叠加
    - `absolute` 和 `fixed` 的元素不会发生外边距叠加，不论内外
    - `inline-block` 的元素不会发生外边距叠加，不论内外

---

## non-replaced inline

+ non-replaced inline 的元素不会渲染 margin-top 和 margin-bottom

---

### replaced element

大概可以理解成
+ 内部样式不受 css 控制的元素
+ 或者说是内容不是写在 html 中，而是从外部引入的元素
+ 实例有 img video textarea 等

更详细参考
+ https://developer.mozilla.org/en-US/docs/Web/CSS/Replaced_element
+ http://www.w3.org/TR/CSS2/conform.html#replaced-element

---

## margin

+ 个人理解
+ margin 的值是 margin edge 到 border egde 的距离，也就是 margin area 的宽度
+ margin-top margin-left 让 border edge 发生偏移，不影响 margin edge 的位置
+ margin-bottom margin-right 让 margin edge 发生偏移，不影响 border edge 的位置
+ 正负决定了偏移的方向
+ margin edge 是元素真正的边界

---

## margin auto

+ margin:auto 常用于块级元素居中
+ 规范里简单粗暴
    - margin border padding width，全部加起来为容器的宽度
    - width 为 auto 时，其他的 auto 都为 0
    - margin 为 auto 时，margin-left 和 margin-right 相等
