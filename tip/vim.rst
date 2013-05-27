=========
 vim tip
=========

upper and lower
================

normal mode
------------
:code:`~` => change between lower and upper

visual mode
------------
+ :code:`u` => lower
+ :code:`U` => upper


去除重复的行
=============

排序再替换。

.. code::

    :'<,'>sort
    :'<,'>s/\v(^.*$)(\n\1)+/\1/g

