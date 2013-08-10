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
