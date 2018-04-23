缩放
=====
opera 不知道什么时候开始会自己把大图给缩放了，也不知道在哪里改设置。
看了下，搞个全局变量就能干掉。

::

    // ==UserScript==
    // @include *.gif
    // @include *.jpg
    // @include *.png
    // ==/UserScript==

    (function() {
        window.donotrun = true;
    })();
