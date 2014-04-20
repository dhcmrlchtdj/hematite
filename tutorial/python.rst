.. contents::

Method Resolution Order
========================
https://www.python.org/download/releases/2.3/mro

使用 python 这么久，现在才弄清楚 mro 是怎么弄的。

首先，在父类没有交叉的时候，可以简单理解成 **深度优先遍历** 。
不过 ``object`` 作为最基本的基类，是放在在最后的。

.. code:: python

    class A: pass
    class B: pass
    class C: pass
    class D: pass
    class E: pass
    class F: pass

    class X(A, B): pass
    class Y(C): pass
    class Z(D): pass

    class M(X, Y): pass
    class N(Z, E): pass

    class WTF(M, N, F): pass
    # DFS => WTF MXABYCNZDEF object
    print(WTF.__mro__)

不过深度优先遍历在父类出现交叉的时候，就不管用了。
虽然正常人不会写那么扭曲的代码，还是有必要了解一下。
毕竟菱形交叉的情况还是可能出现的。

.. code:: python

    class A: pass
    class B: pass
    class C: pass
    class D: pass
    class E: pass
    class F: pass

    class X(A, B, C): pass
    class Y(B, D, E): pass
    class Z(E, F): pass

    class M(X, Y, Z): pass

比较容易的方法是从父类往下看，从子类开始看，比较麻烦。

直接从 ``object`` 继承下来 ``ABCDEF`` 比较简单。
``mro(A) = A + merge(O) = AO`` ， ``O`` 是 ``object`` 。

然后，其他情况就不太好说明了，虽然原理其实很简单：

::

    mro(X) = X + merge(mro(A), mro(B), mro(C), ABC)
           = X + merge(AO, BO, CO, ABC)
           # merge 里面第一个出现的是 A。
           # 并且 A 在后面的 ABC 中也出现了，还是第一个（这很重要）。
           # 所以我们就把 A 提取出来。
           = XA + merge(O, BO, CO, BC)
           # 接下来 merge 里第一个是 O。
           # 但是在后面的 BO 中，O 不是第一个，
           # 所以我们考虑 BO 的第一个，也就是 B
           # B 还出现在了 BC 中，是 BC 的第一个，可以提取。
           = XAB + merge(O, O, CO, C)
           # 同样的道理提取出 C
           = XABC + merge(O, O, O)
           = XABCO

可以发现，虽然过程好像挺复杂（好像也不复杂啊），
但就结果来说，还是可以理解成深度优先遍历。
用这样的逻辑可以算出 ``mro(Y) = YBDEO`` ``mro(Z) = ZEFO`` 。
计算 ``mro(M)`` 还是一样的逻辑，再演示一下：

::

    mro(M) = M + merge(mro(X), mro(Y), mro(Z), XYZ)
           = M + merge(XABCO, YBDEO, ZEFO, XYZ)
           = MX + merge(ABCO, YBDEO, ZEFO, YZ)
           = MXA + merge(BCO, YBDEO, ZEFO, YZ)
           # 这里考察 B 时，发现 Y 在 B 前面，所以转为考察 Y
           = MXAY + merge(BCO, BDEO, ZEFO, Z)
           = MXAYB + merge(CO, DEO, ZEFO, Z)
           = MXAYBC + merge(O, DEO, ZEFO, Z)
           # 可以看到，在其他父类都提取出来前，object 一直处于待机状态……
           = MXAYBCD + merge(O, EO, ZEFO, Z)
           = MXAYBCDZ + merge(O, EO, EFO)
           = MXAYBCDZE + merge(O, O, FO)
           = MXAYBCDZEF + merge(O, O, O)
           = MXAYBCDZEFO

输出 ``M.__mro__`` 可以看到一样的结果。
简单的菱形交叉就不再示范了。

会计算 mro 之后，就会明白为什么下面的代码会抛出错误：

.. code:: pytho

    class A: pass
    class B(A): pass
    class C(A, B): pass
    # TypeError: Cannot create a consistent method resolution order (MRO) for bases A, B

简单算一下就会得到 ``mro(C) = C + merge(AO, BAO, AB)`` ，
``BAO`` 里， ``B`` 在 ``A`` 前面， ``AB`` 里面， ``A`` 在 ``B`` 前。
结果就是无限循环，所以出错了。

这应该就没了，mro 好像也就这么点内容，以前居然没好好学习下。






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
也就是 ``__get__`` ， ``__set__`` 和 ``__delete__`` ，
这些函数就会在相应的时候被调用。

+ 通过 ``x`` 自身来调用， ``x.__get__(a)`` 。
+ 通过实例 ``a`` 来调用，
  ``a.x`` 实际上执行了 ``type(a).__dict__['x'].__get__(a, type(a))`` 。
  ``type(a).__dict__['x']`` 得到的是 ``descriptor`` 的实例。
+ 通过类 ``A`` 来调用，
  ``A.x`` 实际执行 ``A.__dict__['x'].__get__(None, A)`` 。
+ 通过 super，有点复杂……


也就是说，实例 ``a`` 的属性 ``x`` 是个实现了 ``__get__`` 方法的实例，
那么获取 ``a.x`` 时，就会调用 ``x.__get__`` 来获取相应的值。
我们把 ``x`` 叫做 ``descriptor`` 。

-------------------------------------------------------------------------------

其实感觉就像是 ``@property`` 一样。

+ https://github.com/inglesp/Discovering-Descriptors/blob/master/descriptors.py#L56
+ https://github.com/defnull/bottle/blob/master/bottle.py#L173

用来做修饰器，达到惰性求值，缓存结果的效果。

.. code:: python

    class cached_property:
        def __init__(self, func):
            self.func = func

        def __get__(self, instance, owner):
            value = self.func(instance)
            setattr(instance, self.func.__name__, value)
            return value

    class Example:
        @cached_property
        def slow_at_first_time(self):
            import time
            time.sleep(10)
            return 42

    e = Example()
    print(vars(e)) # {}
    print(e.slow_at_first_time) # return 42, after a long sleep
    print(vars(e)) # {'slow_at_first_time': 42}
    print(e.slow_at_first_time) # return 42, immediately





__call__
=========

``__call__`` 是让实例变成可调用。





metaclass
==========

``metaclass`` 是 ``type`` 的子类。

在定义类的时候，会生成一个元类的实例，
也就是调用 ``metaclass.__init__()`` 。
在生成实例的时候，会调用元类的实例 ``metaclass_instance()`` ，
也就是 ``metaclass_instance.__call__()`` 。






context manager
================

http://docs.python.org/3/library/stdtypes.html#context-manager-types

一般写 ``contextmanager`` 就是定义一个类，
然后实现 ``__enter__`` 和 ``__exit__`` 。

也可以用生成器来实现 ``contextmanager`` 。


.. code:: python

    from contextlib import contextmanager

    @contextmanager
    def gen_example():
        print("enter")
        yield
        print("exit")



    class cls_example:
        def __enter__(self):
            print("enter")
        def __exit__(self, exc_type, exc_val, exc_tb):
            print("exit")







__new__
========

.. code:: python

    class example(type):
        def __new__(cls, clsname, bases, clsdict):
            return super().__new__(cls, clsname, bases, clsdict)
