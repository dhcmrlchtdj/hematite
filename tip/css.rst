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
