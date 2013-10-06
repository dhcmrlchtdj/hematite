singleton
==========
对象字面量本来就是唯一的。

使用构造函数的情况，可以将实例缓存为构造函数的某个属性。


factory
==========
一个例子：

.. code:: javascript

    var o = new Object();
    var s = new Object("string");
    var n = new Object(42);
    var b = new Object(true);

    o.constructor === Object;
    s.constructor === String;
    n.constructor === Number;
    b.constructor === Boolean;

``Object`` 就算是一个工厂，不同输入生产不同的对象，隐藏了具体实现。

iterator
===========
有专门列举的必要吗……

decorator
============
参考 python 的修饰器语法糖吧。

strategy
==========
运行时选择某种实现。

facade
========
对经常被一起使用的方法进行包装。
比如对 ``event.preventDefault`` 和 ``event.stopPropagation`` 进行封装。

proxy
=======
感觉就像是层缓存。

mediator
=========
在不同组件之间添加中间层。

observer
==========
各种事件机制/发布订阅都算观察者吧。
