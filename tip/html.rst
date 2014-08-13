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






图片格式
==========
信息来源
+ http://www.bookofspeed.com/chapter5.html
+ https://hacks.mozilla.org/2014/08/using-mozjpeg-to-create-efficient-jpegs/
+ https://imageoptim.com/

简单总结
+ 使用 png8 代替静态 gif， ``$ optipng *.gif``
+ 对 gif 动画进行优化， ``$ gifsicle -O2 before.gif > after.gif``
+ png 和 gif 用于页面布局，jpeg 用于展示照片等色彩丰富的图片
+ 去除 jpeg 中的无用信息， ``$ jpegtran -copy none -optimize before.jpg > after.jpg``
+ 变换为 progressive 图片， ``$ jpegtran -progressive before.jpg > after.jpg``
+ favico 最好小于 1k，可以限制只使用 16 色来进一步压缩图标
  ``$ convert -colors 16 someimage.png favicon.ico``
+ png 压缩工具太多，分不清楚
