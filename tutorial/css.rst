visual formatting model
========================
+ http://www.w3.org/TR/CSS2/visuren.html
+ https://developer.mozilla.org/en-US/docs/Web/CSS/Visual_formatting_model

浏览器如何展示一个页面。

决定因素包括元素的大小、类型、位置、子节点和兄弟节点、浏览器窗口大小、
内部图片的大小，还有其他外部信息。

元素（box）是沿其容器（containing block）边界开始渲染的，
元素会为其后代提供容器，但是元素在渲染时并不受容器限制。
超出容器的情况，被称为溢出（overflow）。






元素类型
==========
+ http://www.w3.org/TR/CSS2/visuren.html#box-gen
+ https://developer.mozilla.org/en-US/docs/Web/CSS/Visual_formatting_model

元素的类型由 ``display`` 属性决定。

block-level
------------
块级（block-level）属性有： ``block`` 、 ``list-item`` 和 ``table`` 。

除表格和可替换元素（replaced element）之外，
块级元素都是块容器（block container box）。

块容器和块级元素（block-level boxes）的交集称为块级盒元素（block boxes）。
块容器中，除了有块级盒元素外，
还有不可替换的行内块（non-replaced inline blocks）
和不可替换的表格（non-replaced table cells）。

块容器的特点是，其中的元素要么全为块级元素（block-level boxes），
要么全为行级元素（inline-level boxes）。
只要出现了块级元素，其他匿名元素会变成匿名块级元素。
这些匿名元素会继承父元素的可继承属性，不可继承属性会被设置为初始值。
（可不可是指在默认情况下，是否会进行继承。）



inline-level
-------------
行级（inline-level）属性有： ``inline`` 、 ``inline-block``
和 ``inline-table`` 。

行级元素（inline-level boxes）又分为
行级盒元素（inline boxes）（如 ``inline`` ）
和行级不可分元素（atomic inline-level boxes）（如 ``inline-block`` ）。






元素位置
==========
+ http://www.w3.org/TR/CSS2/visuren.html#positioning-scheme

元素的位置由 ``position`` 和 ``float`` 决定。


+ 正常流（normal flow）

    ::

        position: static | relative
        float: none

    元素一个挨着一个排列，在 BFC 中垂直分布，在 IFC 中水平分布。


+ 浮动（floats）

    ::

        position: static | relative
        float: left | right

    在当前行排列。其他通常的元素会被挤到浮动元素的边缘。
    其他元素可以使用 ``clear`` 来避免被挤开。

    浮动且设置 ``position: relative`` 时，定位是相对于浮动后的位置进行的。


+ 绝对定位（absolute positioning）

    ::

        position: absolute | fixed

    元素完全移出文档流，不再相互影响。
    元素定位依赖于其容器（containing block）和 ``top,bottom,left,right`` 。

    ``fixed`` 的容器是整个窗口（ ``viewport`` ）。

浮动和绝对定位都让元素脱离了文档流（flow），这样的元素就溢出了。








块级格式化上下文（block formatting context）
=============================================
https://developer.mozilla.org/en-US/docs/Web/CSS/Block_formatting_context

::

    float: left | right
    position: absolute | fixed
    display: inline-block | table-cell | table-caption | flex | inline-flex
    overflow: hidden | scroll | auto

根元素和应用如上样式的元素，都会创建一个新的 BFC 。
BFC 会包含内部的所有元素。

浮动和清理只会应用于相同的 BFC 中。

使用 ``overflow:hidden`` 来清理浮动的原理就在于此。
BFC 内的元素会根据 BFC 来计算其位置。

（ie 下面还受到 ``hasLayout`` 的影响。）

更新：

原来以为根元素是指 ``body`` ，事实上 ``html`` 才是根元素。
另外，似乎无法使用 ``overflow`` 在 ``body`` 中创建 BFC（？）。







替换元素（replaced element）
===============================
+ http://www.w3.org/TR/CSS21/conform.html
+ https://developer.mozilla.org/en-US/docs/Web/CSS/Replaced_element

经常出现的一个概念。

这些元素的内部不受 css 约束，
比如 ``img`` ``video`` ``input`` ``textarea`` 都是替换元素，
另外 ``audio`` ``canvas`` 在某些场合下也是替换元素，
使用 ``content`` 属性生成的内容属于匿名替换元素。








外边距叠加（margin collapsing）
================================
+ http://www.w3.org/TR/CSS2/box.html#collapsing-margins
+ https://developer.mozilla.org/en-US/docs/Web/CSS/margin_collapsing

首先，浮动和绝对定位的元素不会发生外边距叠加。
也就是说，只有正常流（normal flow）中的元素才会发生外边距叠加。
（这个也可以理解为生成了 BFC，BFC 和内部元素，BFC 之间，都不会叠加。）

其次，水平方向不会进行外边距叠加。
也就是说，只有上下外边距可能出现外边距叠加的情况。

三种情形下会发生外边距叠加：

+ 相邻的兄弟元素的上下外边距。
+ 父元素和第一个子元素的上边距或者是最后一个子元素的下边距。
+ 没有内容的元素，元素自身的上下外边距。

在叠加的时候，正值取最大的，负值取最小的。

发生外边距叠加的详细条件：

1. 在正常流中的，且属于同一个 BFC 的两个块级元素的外边距。
2. 没有边界，内边距，没有进行浮动清理。
3. 属于下面某种情况：

   + 元素的上边距和第一个子元素的上边距。
   + 元素的下边距和下个兄弟元素的上边距。
   + 元素的下边距和最后一个子元素的下边距。
   + 一个元素没有在内部创建 BFC，没有正常流的子元素（脱离了正常流的话没关系），
     并且 ``min-height`` 最终为 0， ``height`` 最终为 0 或 auto。
     这个元素的上下边距。





容器（containing block）
=========================
http://www.w3.org/TR/CSS2/visudet.html#containing-block-details

容器决定了元素如何排列

+ 根元素（html）的容器称为起始容器（initial containing block）。
+ 正常流中的元素，容器是最近的祖先的容器。
+ ``position:fixed`` 的元素，容器是整个浏览器窗口（viewport）。
+ ``position:absolute`` 的元素，容器是设置了 ``position`` 的祖先元素。
  （寻找时是一层层向根元素推进的，如果都没设置，那么容器就是起始容器。）

  （文字方向（direction）会造成一点影响，尤其是祖先是行内元素且有多行的时候。）
