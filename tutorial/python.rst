========
 python
========

yield from
===========

yield-from clause acts as a "transparent channel"





instance attribute
===================

仔细通读
http://docs.python.org/3/reference/datamodel.html#customizing-attribute-access

这几个方法都是作用于实例的。
通过定义元类（metaclass），也可以控制类的查找等操作。

不管是实例的属性还是实例的方法，下面都叫实例属性了。


__getattribute__
-----------------

每次查找实例属性时都会调用这个方法。

甚至是 ``instance.__getattribute__`` 都要调用 ``__getattribute__``
来查找来寻找 ``__getattribute__`` 。

查找失败时应该抛出 ``AttributeError`` 这个异常。

为了避免在 ``__getattribute__`` 中引起无限递归，
在 ``__getattribute__`` 的实现中应该使用
``object.__getattribute__(self, name)`` 或者是
``super().__getattribute__(name)`` 来查找实例属性。


__getattr__
------------

在 ``__getattribute__`` 抛出 ``AttributeError`` 时，会调用 ``__getattr__`` 。

通常都是通过 ``__getattr__`` 方法来实现特殊属性的查找，
而不是修改 ``__getattribute__`` 。

查找失败时同样应该抛出 ``AttributeError`` 。


__setattr__
------------

和 ``__getattribute__`` 对应，每次设置实例属性都会调用 ``__setattr__`` 方法。
在调用 ``__init__`` 设置实例属性时，一样会调用这个方法。

可以借助 ``object.__setattr__(self, name, value)`` 或者
``super().__setattr__(name, value)``  来设置实例属性。
也可以直接通过修改 ``instance.__dict__`` 来修改属性。

同样，想要跳过 ``__setattr__`` 设置属性时，
也可以通过修改 ``__dict__`` 来实现。
不过 ``__getattribute__`` 是跳不过去的。



descriptor
===========

仔细通读
http://docs.python.org/3/reference/datamodel.html#implementing-descriptors

然后看看
https://github.com/inglesp/Discovering-Descriptors

调用 ``a.x`` 的时候，其实是这么一个过程，
先是 ``a.__dict__['x']`` ，也就是查找实例属性，如果没找到，
接着查找 ``type(a).__dict__['x']`` ，也就是查找类属性，
这样一步步往父类查找。（元类会被略过。）


``descriptor`` 也就是对 ``x`` 动些手脚，来完成特别的需求。

只要 ``x`` 实现了相应的接口，
也就是 ``__get__`` ， ``__set__`` 和 ``__del__`` ，
这些函数就会在相应的时候被调用。

+ 通过 ``x`` 自身来调用， ``x.__get__(a)`` 。
+ 通过实例 ``a`` 来调用，
  ``a.x`` 实际上执行了 ``type(a).__dict__['x'].__get__(a, type(a))`` 。
  也就是通过类进行调用，通过第一个参数来指定实例。
+ 通过类 ``A`` 来调用，
  ``A.x`` 实际执行 ``A.__dict__['x'].__get__(None, A)`` 。
+ 通过 super，有点复杂……


也就是说，实例 ``a`` 的属性 ``x`` 是个实现了 ``__get__`` 方法的实例，
那么获取 ``a.x`` 时，就会调用 ``x.__get__`` 来获取相应的值。
我们把 ``x`` 叫做 ``descriptor`` 。

-------------------------------------------------------------------------------

其实感觉就像是 ``property()`` 一样，那么有实际应用呢？
其实前面的链接就讲到了，而且在 `bottle.py` 里还能找到相同的代码。

+ https://github.com/inglesp/Discovering-Descriptors/blob/master/descriptors.py#L56
+ https://github.com/defnull/bottle/blob/master/bottle.py#L173

用来做修饰器，达到缓存结果的效果。

.. code:: python

    class cached_property:
        def __init__(self, func):
            self.func = func

        def __get__(self, instance, owner=None):
            instance.__dict__[self.func.__name__] = self.func(instance)
            return instance.__dict__[self.func.__name__]

    class Example:
        @cached_property
        def slow_at_first_time(self):
            import time
            time.sleep(10)
            return 42

    e = Example()
    print(e.__dict__) # {}
    print(e.slow_at_first_time) # return 42, after a long sleep
    print(e.__dict__) # {'slow_at_first_time': 42}
    print(e.slow_at_first_time) # return 42, immediately



__call__
=========

``__call__`` 是让实例变成可调用。
