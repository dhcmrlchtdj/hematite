.. contents::




metaclass
==========

``metaclass`` 是 ``type`` 的子类。

在定义类的时候，会生成一个元类的实例，
也就是调用 ``metaclass.__init__()`` 。
在生成实例的时候，会调用元类的实例 ``metaclass_instance()`` ，
也就是 ``metaclass_instance.__call__()`` 。




__new__
========

.. code:: python

    class example(type):
        def __new__(cls, clsname, bases, clsdict):
            return super().__new__(cls, clsname, bases, clsdict)




execution
===========

`https://docs.python.org/3/reference/executionmodel.html`_

即使使用 ``from A import B`` 的形式导入，还是会执行整个 ``A`` 。

类中的代码是在定义后执行的，而不是创建实例的时候。

.. code:: python

    class A:
        print("execute")




yield from
===========

+ https://docs.python.org/3/reference/expressions.html#yieldexpr
+ http://legacy.python.org/dev/peps/pep-0380/
+ https://groups.google.com/forum/#!topic/python-tulip/bmphRrryuFk

要理解这东西，一个办法是先写点演示代码，去 `pythontutor.com`_ 看执行过程，
然后再好好研究文档，弄清楚怎么回事。

基本语法
---------

``result = yield from <expr>``

yield-from 后面必须是个可以遍历（iterable）的对象，
比如一个数组，比如一个生成器。

``yield from range(10)`` 这种简单语句，
可以等价于 ``for i in range(10): yield i`` 。

这里主要是讲 ``<expr>`` 是个生成器的情况（不包括 ``<genexpr>`` ）。

.. code:: python

    def gen1():
        yield from range(10)
        print("gen1 stop")

    def gen2():
        yield from gen1()
        print("gen2 stop")

    def gen3():
        yield from gen2()
        print("gen3 stop")

    def main():
        for i in gen3():
            print(i)

    if __name__ == "__main__":
        main()

yield-from 相当于一个中间层，
让调用者（ ``main`` ）和子生成器（ ``gen1()`` ）直接进行交互。
在子生成器结束的时候，yield-from 才返回，继续执行下面的语句。


返回值
-------

yield-from 和 yield 的返回值有很大区别。

yield 的返回值是 ``.send(value)`` 接收的参数：

.. code:: python

    def gen1():
        while 1:
            ret = yield 1
            print("yield return", ret)

    g = gen1()
    next(g)
    g.send("test")

yield-from 的返回值是子生成器的返回的值。
更准确地说，是 ``StopIteration`` 的第一个参数。

.. code:: python

    def gen1():
        yield from range(10)
        return "end"
        # raise StopIteration("end")

    def gen2():
        ret = yield from gen1()
        print("yield from return", ret)

    for i in gen2():
        print(i)

gen1 使用了 ``return value`` ，
这在子生成器中等价于 ``raise StopIteration(value)`` 。
两者在语义上是相同的，不过 return 要更直观些吧。

之前曾经提到过，子生成器结束的时候，yield-from 才返回。
所谓的结束，就是指这里的 StopIteration 了。


异常
------

.. code:: python

    def gen1():
        yield from range(5)

    def gen2():
        yield from gen1()
        print("gen2 continue")
        yield from range(5)

    def gen3():
        yield from gen2()
        print("gen3 continue")
        yield from range(5)


    g = gen3()
    for i in g:
        print(i)
        if i == 3:
            g.throw(StopIteration)

之前提到， ``StopIteration`` 之后，yield-from 返回。
上面的代码里， ``g`` 主动抛出 ``StopIteration`` ，结果就是最里层的 gen1 结束，
gen2 继续执行。继续抛异常，gen2 结束，gen3 继续执行。


把上面的 ``StopIteration`` 那句改成 ``g.throw(GeneratorExit)``
或者 ``g.close()`` ，那么所有生成器都会停止。

其他
-----

``inspect.getgeneratorstate`` 可以获取一个生成器的状态。




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




instance attribute
===================

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
