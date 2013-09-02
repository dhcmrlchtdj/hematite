upper and lower
================

normal mode
------------
``~`` => change between lower and upper

visual mode
------------
+ ``u`` => lower
+ ``U`` => upper




去除重复的行
=============

排序再替换。

::

    :'<,'>sort
    :'<,'>s/\v(^.*$)(\n\1)+/\1/g



标记跳转
=========
``m[a-z]`` 标记， ``\`[a-z]`` 跳转。
