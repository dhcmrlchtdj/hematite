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
