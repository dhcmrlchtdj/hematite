.. contents::





media queries
==============
原来有了个 ``resolution`` 来代替 ``device-pixel-ratio`` 。

.. code:: css

    /* equal to (min-device-pixel-ratio: 2) */
    @media (min-resolution: 2dppx) {
    }

    @media (min-resolution: 300dpi) {
    }

单位有三种：

dpi
    dots per inch
dppx
    dots per 'px'
dpcm
    dots per centimeter

手机平板上， ``dppx`` 最好用了吧。
可以查 http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density 。






font-face
==========

.. code:: css

    @font-face {
        font-family: "fontawesome";
        src: url("../font/fontawesome.woff") format("woff");
    }

    [data-icon]::before {
        font-family: "fontawesome";
        content: attr(data-icon);
    }

主要是 ``attr`` ，这个平常都没用过，
不过这种做法是不是有点混合了样式和文档的感觉。
（图标在文档中定义而不是在样式表中）。

另外就是 ``::before`` ，和 ``:before`` 差不多，
两冒号的写法是 css3 新定义的，可以作用于其他伪选择器。


另外，在 html 里面，转写 unicode 是 ``&#xHHHH (&#xe000)`` ，
而在 css 里面， ``content`` 里面是 ``\HHHH (\e000)`` 。




画三角形的代码
===============

.. code:: css

    div::before {
        display: block;
        width: 0;
        height: 0;
        border-bottom: 5px solid red;
        border-left: 5px solid transparent;
        border-right: 5px solid transparent;

        content: "";
    }




清理浮动
=========

.. code:: css

    .clearfix::after {
        content: "";
        display: block;
        clear: both;
    }

    .clearfix:after {
        content: " "; /* 旧浏览器不支持空内容 */
        visiability: hidden;
        display: block;
        height: 0;
        clear: both;
    }
    .clearfix {
        *zoom: 1; /* 触发 hasLayout */
    }





居中
=====
http://coding.smashingmagazine.com/2013/08/09/absolute-horizontal-vertical-centering-css/

``margin: 0 auto`` 用来居中见多了，今天看到个不一样的。

.. code:: css

    .center {
        margin: auto;
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 100px;
        height: 100px;
    }

如果上面的没看明白的话，拆开看

.. code:: css

    .horizontal {
        margin: 0 auto;
        width: 100px;
        position: absolute;
        left: 0;
        right: 0;
    }
    .vertical {
        margin: auto 0;
        height: 100px;
        position: absolute;
        top: 0;
        bottom: 0;
    }

这是居中的情况，如果要对位置进行调整，这么做

.. code:: css

    .right {
        height: 100px;
        width: 100px;
        margin: auto;
        position: absolute;
        left: auto;
        right: 20px;
        top: 0;
        bottom: 0;
    }

也就是把对应的调整为 ``auto`` 就可以了。


对于图片的居中，高度也不用确定， 可以直接使用 ``height: auto`` 。







文字溢出
=========
之前用 ``text-overflow`` 发现没有效果，后来发现是 ``white-space`` 的影响。

.. code:: css

    .ellipsis {
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        width: 100%;
    }






垂直居中
=========
http://www.cnblogs.com/rubylouvre/archive/2013/07/09/3179534.html

.. code:: css

    .center {
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
    }




居中
=====
http://jinlong.github.io/blog/2013/08/13/centering-all-the-directions/

总结他人的总结

+ ``text-align:center`` 水平居中，用于文字或行内（inline）元素。

+ ``vertical-align:middle`` 垂直居中，用于文字或行内元素。
  可配合 ``display:table`` 、 ``display:table-cell`` 使用。

+ ``line-height:(N)px;height:(N)px`` 用于垂直居中文字。

+ ``margin:0 auto;width:(N)px`` 水平居中。个人最常用的了。

+ ``position:absolute;left:50%;width:(N)px;margin-left:-(N/2)px``
  也算常用了。

+ ``position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);`` 。
  类似于负外边距的方法，特别在于不需要定义宽高，
  ``translate`` 是相对于元素大小进行计算的。

+ ``display:flex;align-items:center;justify-content:center``

+ ``width:Npx;height:Mpx;position:absolute;margin:0;top:0;right:0;bottom:0;left:0``
  这个前面提过了。




flex 布局
==========
一直没去看看，如今做个笔记。

http://the-echoplex.net/flexyboxes/

其实上面的链接更好懂，下面还是简单记一下。

.. code:: html

    <style>
        #box {
            border: 1px solid red;
            width: 100%;
            height: 300px;

            display: flex;

            flex-direction: row-reverse;
            flex-wrap: wrap;

            justify-content: space-around;
            align-items: center;

            /*align-self:auto;*/
        }
        .content {
            border: 1px solid black;
            width: 100px;
            height: 100px;
        }
        #b1 {
            order: 3;
            align-self: center;
        }
        #b2 {
            flex: 100px 1 2;
        }
        #b3 {
            flex: 100px 3 1;
        }
    </style>

    <div id="box">
        <div class="content" id="b1">1</div>
        <div class="content" id="b2">2</div>
        <div class="content" id="b3">3</div>
    </div>

``flex-direction`` 设置排列方式，上到下，下到上，左到右，右到左都可以。
``flex-wrap`` 设置在元素过多，发生溢出时，如何处理。
``justify-content`` 和 ``align-items`` 设置排列位置，对齐平铺等等。

在内部的块中，可以设置 ``order`` 改变排列的顺序，
可以设置 ``align-self`` 改变位置，设置 ``flex`` 改变如何使用该元素进行填充，
三个参数分别为伸缩的基准，空间剩余时的分配比例，空间不足时的分配比例。





css 修改页面内容
=================
http://coding.smashingmagazine.com/2013/04/12/css-generated-content-counters/

``content`` 的用法相当丰富啊。

.. code:: css

    content: none; /* 没东西 */
    content: normal; /* none 一样 */

    content: "prefix"; /* 字符串，可以使用 \HHHH 的形式进行转义 */
    content: url(/path/to/image); /* 会被当成图片处理 */
    content: attr(href); /* 引用标签的属性，没有该属性会返回空值， */

    /* 下面两个可以配合 quotes 使用 */
    quotes: "“" "”" "‘" "’";
    content: open-quote;
    content: close-quote;
    /* 下面两个，在语义上表达嵌套 */
    content: no-open-quote;
    content: no-close-quote;

    /* 上面的效果都是是可以组合起来的，组合之后 none normal 就没用了 */
    content: open-quote " " "prefix" " " attr(href);

还有最后一个用法：计数。

.. code:: css

    ul {
        counter-reset: name; /* 把 name 重置为 0 */
    }

    li::before {
        counter-increment: name; /* name++ */
        content: counter(name); /* 获取 name */
    }

    /* 添加删除 li 的时候，会自动重新计算 */

计数时还可以更加精确：

.. code:: css

    counter-reset: cnt1 -20 cnt2 100; /* 初始化多个计数器，设置初始值 */
    counter-incremnt: cnt1 +10 cnt2 -10; /* 精确控制计数器的增减 */

计数很适合用于目录之类的场景吧，可以自定义基数符号，自己添加分割符号：

.. code:: css

    content: counters(cnt, "."); /* 使用 . 分割，注意是 counters 不是 counter */

    content: counter(cnt, "decimal");
    content: counters(cnt, ".", "decimal");
    /*
        默认是使用数字，下面几种是可选值。
        如果需要处理复杂情形，可以使用多个计数器，把结果拼起来。

        decimal
        decimal-leading-zero
        lower-roman
        upper-roman
        lower-greek
        upper-greek
        lower-latin
        upper-latin
        lower-alpha
        upper-alpha
    */






负外边距
=========
外边距为负值分为两种情况。

``margin-top`` 和 ``margin-left`` 会改变元素本身的位置。
``margin-bottom`` 和 ``margin-right`` 则会改变相邻元素的的 ``margin`` 基准。






查找
=====
+ http://redotheweb.com/2013/05/15/client-side-full-text-search-in-css.html

其实感觉这做法有点傻，蛮记录下来。

关键点是把内容放到一个属性里去，
然后使用属性选择器和反向选择器的组合（ ``E:not([foo*="bar"])`` ），
将不符合的内容隐藏。

这样就作出了查找的效果。







动画化与自适应
================

+ http://css-tricks.com/animated-media-queries/

其实关键只有一点，使用 ``transition`` 。

自己没想到还能这么玩。
