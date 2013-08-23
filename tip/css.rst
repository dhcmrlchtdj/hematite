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
        white-space: no-wrap;
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
  可配合 ``display:table`` 、 ``display::table-cell`` 使用。

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
