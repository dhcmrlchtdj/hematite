========
 python
========

yield from
===========

yield-from clause acts as a "transparent channel"




__getattr__, __getattribute__ and __setattr__
==============================================

+ ``__getattribute__`` is invoked before looking.
+ ``__getattr__`` is invoked while attribute was not found.


``__getattribute__`` should return attribute value or
raise an ``AttributeError`` exception.

in order to avoid infinite recursion,implementation should always call
base class method with same name to access any attribute it needs.
``object.__getattribute__(self, name)``.

``__getattr__`` should return attribute value or 
raise an ``AttributeError`` exception.
if ``__getattribute__`` not raise ``AttributeError``,
``__getattr__`` will not be invoked.

read http://docs.python.org/3/reference/datamodel.html#special-lookup
for more.

use ``object.__setattr__(self, name, value)`` to assign attribute.

可以使用 ``self.__dict__`` 直接对实例进行赋值，而不经过 ``__setattr__`` 。
但是一样是通过 ``__getattribute__`` 来寻找 ``__dict__`` 的。

重写一个 ``__getattr__`` 应该是比较常见的情况。

上面三个方法都是针对实例的。想要在类的层面进行，可以自己定义 ``metaclass`` 。




__call__
=========

``__call__`` 是让实例变成可调用。
