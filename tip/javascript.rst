timestamp
==========

.. code::

    // get milliseconds since the epoch
    console.log( Date.now() ); // fastest
    console.log( + new Date() );
    console.log( (new Date()).getTime() );

    // convert to timestamp
    console.log( Math.round(Date.now()/1000) )





滚动条
=======
元素的滚动条可以用 :code:`el.scrollTop` 来操作，
比如滚动到底部用 :code:`el.scrollTop = el.scrollHeight` 。

还可以用 :code:`el.scrollByPages` 和 :code:`el.scrollByLines` 。
不过 opera 不支持啊。

还是用 :code:`el.scrollTo` 来滚动吧。







HTMLElement
============
所有的 DOM 节点都继承了 HTMLElement。
不过我们不能自己调用这个构造函数来构造新节点就是了。
通过修改 HTMLElement 的原型（prototype），可以给节点添加方法。





节点文字
=========
可以使用 :code:`textContent` 来获取和修改节点包含的文本。





Object.create
==============
:code:`Object.create` 的第一个参数是新对象的原型。








鼠标移动事件
=============

``mouseenter`` 和 ``mouseleave`` 分别在进入和离开
**注册事件的节点** 时被触发。
类似于 css 中的 ``:hover`` 。

``mouseover`` 和 ``mouseout`` 分别在进入和离开节点时触发，
但是不仅仅是注册了事件的节点，在进入或离开其子节点时，同样会触发事件。

专业点的说法是 ``mouseenter`` 和 ``mouseleave`` 不会冒泡（bubble），
而 ``mouseover`` 和 ``mouseout`` 会冒泡。

在节点上移动鼠标时，会触发 ``mouseover`` 事件，同样会冒泡。
