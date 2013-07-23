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
