visual formatting model
========================
http://www.w3.org/TR/CSS2/visuren.html
http://www.w3.org/TR/CSS2/visudet.html
https://developer.mozilla.org/en-US/docs/Web/CSS/Visual_formatting_model
https://developer.mozilla.org/en-US/docs/Web/CSS/Block_formatting_context

浏览器如何展示一个页面。

决定因素包括元素的大小、类型、位置、子节点和兄弟节点、浏览器窗口大小、
内部图片的大小，还有其他外部信息。

元素（box）是沿其容器（containing block）边界开始渲染的，
元素会为其后代提供容器，但是元素在渲染时并不受容器限制。
超出容器的情况，被称为溢出（overflow）。

-------------------------------------------------------------------------------

元素的类型由 ``display`` 属性决定。

block-level
------------
块级（block-level）属性有： ``block`` 、 ``list-item`` 和 ``table`` 。

每个块级元素（block-level element），至少会有一个块级盒（block-level box）。

block-level boxes

block formatting context
    块级格式化上下文

blocks containing boxes

block boxes


匿名元素会继承父元素的可继承属性，不可继承属性会被设置为初始值。
例如 ``display`` 就是不可继承的。

块级盒容器（block containing boxes）内，
要么全部是行内盒元素（inline-level boxes），
要么全部是块级盒元素（block-level boxes）。

如果出现混合的情况，匿名元素会作为块级盒元素处理。


inline-level
-------------
行级（inline-level）属性有： ``inline`` 、 ``inline-block`` 和 ``inline-table`` 。

inline-level boxes
    可以分为 ``inline boxes`` 和 ``atomic inline-level boxes`` 。

inline formatting context
    行级格式化上下文

inline boxes
    参与 ``inline formatting context`` 。如 ``inline`` 。

atomic inline-level boxes
    不参与 ``inline formatting context`` 。
    如 ``inline-block`` 和 ``inline-table`` 。


-------------------------------------------------------------------------------

元素的位置由 ``position`` 和 ``float`` 决定。

正常流（normal flow）
----------------------
::

    position: static | relative
    float: none

元素一个挨着一个排列，在 BFC 中垂直分布，在 IFC 中水平分布。



浮动（floats）
---------------
::

    position: static | relative
    float: left | right

在当前行排列。其他通常的元素会被挤到浮动元素的边缘。
其他元素可以使用 ``clear`` 来避免被挤开。

浮动且设置 ``position: relative`` 时，定位是相对于浮动后的位置进行的。


绝对定位（absolute positioning）
---------------------------------
::

    position: absolute | fixed

元素完全移出文档流，不再相互影响。
元素定位依赖于其容器（containing block）和 ``top,bottom,left,right`` 。

``fixed`` 的容器是整个窗口（ ``viewport`` ）。

-------------------------------------------------------------------------------

块级格式化上下文（block formatting context）
---------------------------------------------

::

    float: left | right
    position: absolute | fixed
    display: inline-block | table-cell | table-caption | flex | inline-flex
    overflow: hidden | scroll | auto

根元素和应用如上样式的元素，都会创建一个新的 BFC 。
BFC 会包含内部的所有元素。

浮动和清理只会应用于相同的 BFC 中。

（使用 ``overflow:hidden`` 来清理浮动的原理就在于此。）

（ie 下面还受到 ``hasLayout`` 的影响。）
