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

在节点上移动鼠标时，会触发 ``mousemove`` 事件，同样会冒泡。





动态插入 js
============

.. code:: javascript

    var script = document.createElement('script');
    node.src = '/path/to/js';
    document.body.appendChild(node);

上面是段动态加载脚本的代码，简单得很。

在看 `seajs` 的加载代码时，看到一个以前没注意过的地方。

.. code:: javascript

    var head = document.head;
    var baseElement = document.querySelector('base');
    var node = document.createElement('script');
    baseElement ?
        head.insertBefore(node, baseElement) :
        head.appendChild(node)

其他东西都省略了，一个是插入在 ``head`` 里面，一个是插入在 ``base`` 之前。

关于插入在 ``head`` 里，我找了半天就找到了
http://stackoverflow.com/questions/12113412/dynamically-inject-javascript-file-why-do-most-examples-append-to-head/12113657#12113657
和 http://www.jspatterns.com/the-ridiculous-case-of-adding-a-script-element/ 。

没什么决定性的理由，
不插入在 ``body`` 里面最合理的解释大概是 IE7 的 ``Operation aborted`` 吧。
对于 `seajs` ，需要支持 css 的动态加载，所以选择了 ``head`` 吧。

至于插入在 ``base`` 之前，是因为 IE，这个不讲了。

下面讲下 ``base`` 元素。

平常写路径的时候，经常使用相对路径，通过设置 ``base`` 的 ``href`` 属性，
可以让相对路径不再相对于当前目录，而是相对于 ``base.href`` 的路径，
就叫基本路径算了。

如果指定了多个 ``base`` 或是里面有多个 ``href`` ，
起作用的只有第一个 ``base`` 的第一个 ``href`` 。

在 js 中，可以通过 ``node.baseURI`` 获取元素的基本路径。
而 ``document.baseURI`` 是整个页面的基本路径，但要注意这个值是只读的。
虽然不能修改 ``document.baseURI`` ，但是 ``base.href`` 是可以修改的。

更新： ``base`` 只会影响之后的元素，把 css 和 js 放在 ``base`` 前面，
是不受 ``base`` 的值影响的。






性能测试
=========
以前测试某种方法的性能，都是用 ``Date.now()`` ，偶然发现一个更简单的。

https://gist.github.com/xionglun/6205140

.. code::

    console.time('id');
    // code here
    console.timeEnd('id');

一直以来都只使用 ``console.log`` ，看来好好研究一下。





获取脚本自己的链接地址
=======================
``seajs`` 的这段代码看了好久才明白过来，果然水平还不够啊。

.. code:: javascript

    var scripts = document.scripts;
    var src = scripts[scripts.length - 1].src;

关键在于，这段代码执行的时候， ``seajs`` 自己是已载入的最后一个脚本，
所以可以使用 ``scripts[scripts.length - 1]`` 获取自己的标签。
这样就不用关心之前已经引入了多少脚本，之后会引入多少脚本也完全不用担心。

平常习惯等到页面完全载入了才执行脚本，
所以看到 ``scripts`` 的第一反映是页面的所有脚本，
就被自己绕进去了。
