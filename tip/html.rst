300ms delay
=============
http://updates.html5rocks.com/2013/12/300ms-tap-delay-gone-away
http://cubiq.org/remove-onclick-delay-on-webkit-for-iphone
http://msdn.microsoft.com/en-us/library/windows/apps/hh767313.aspx

手机浏览器有个点击 300ms 延迟的情况。
利用这个延迟，可以进行各种点击事件的统计。

不过还是记录下，如何处理这个情况。


在禁用了缩放的情况下，android 上的 chrome 和 firefox 是会去除延迟的。

.. code:: html

    <meta name="viewport" content="width=device-width, user-scalable=no">

window phone 上可以靠 css 搞定。

.. code:: css

    html {
        -ms-touch-action: manipulation;
        touch-action: manipulation;
    }

不过这个 pointer event 还只是草案，目前就 ie 支持。

safari 的双击还支持翻页功能，所以禁用缩放没有效果。
一种方案是是用 touch 事件代替 click 事件。
