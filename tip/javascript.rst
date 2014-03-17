.. contents::


timestamp
==========

.. code:: javascript

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
动态加载 js 能够达成异步加载的效果。

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
所以 manifest 不受这个影响， http://developers.whatwg.org/semantics.html#the-base-element 。






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





inline 与 src
==============
如果两者并存，那么优先下载脚本文件，而内联的代码不会执行。





动态修改资源地址
=================
下面都是 chrome 30.0.1599.14 dev 下的测试结果。

.. code:: javascript

    var img = document.createElement('img'); // new Image() 也是一样的
    img.src = './invalid.png'; // 马上发起请求了，然后失败了
    img.onerror = function(e) {console.log(e);}; // 这次不会执行，失败时触发的是 null
    document.body.appendChild(img);
    img.src = '../invalid.png'; // 马上发起请求，继续失败，这次调用 error 了

    var script = document.createElement('script');
    script.src = './invalid.js'; // 没发起请求
    document.body.appendChild(script); // 插入才发起请求
    script.src = '../invalid.js'; // 不会发起请求

    var link = document.createElement('link');
    link.href = './invalid.css'; // 不会发起请求
    document.head.appendChild(link); // 还是没发起请求
    link.rel = 'stylesheet'; // 发起请求了
    link.href = '../invalid.css'; // 再次发起请求

    link.rel = 'alternate'; // 修改类型
    link.src = './invalid.html'; // 不会发起请求了
    link.rel = 'stylesheet'; // 马上发起请求

css 的特别之处在于， ``link`` 有其他用途，所以不会主动发起请求。
一旦指定为 ``stylesheet`` （不管是在插入文档之前还是之后），
行为方式和 ``img`` 一样。

修正一下：网上说，修改 ``script`` 的 ``src`` 后，
ie9 会载入脚本，但不会执行，ie6/7/8 会载入并执行脚本。


.. code:: javascript

    var iframe = document.createElement('iframe');
    iframe.src = './invalid.html'; // 不发起请求
    document.body.appendChild(iframe); // 发起请求
    iframe.src = '../invalid.html'; // 修改后，马上发起请求

``iframe`` 和 ``frame`` 都是一样的，插入文档后才会发起请求，
更改地址，马上发起新请求。


.. code:: javascript

    var audio = document.createElement('audio');
    audio.src = './invalid.mp3'; // 马上发起请求
    audio.src = '../invalid.mp3'; // 更改后马上发起请求
    audio.load(); // 会再次发起请求

    var source = document.createElement('source');
    var audio2 = document.createElement('audio'); // 插入之前的 audio 是无效的
    source.src = './invalid.mp3'; // 没发起请求
    audio2.appendChild(source); // 插入到 audio 或者 video 里面，马上发起请求
    source.src = '../invalid.mp3'; // 没有发起请求
    audio2.load(); // 要重新载入，才会发起请求
    audio2.src = './invalid.mp3'; // source 无效了

    var video = document.createElement('video');
    video.appendChild(source); // 注意下，source 会从 audio2 移动到 video ，
                                // 并且重新发起请求（虽然没有修改过 source）
    video.poster = './invalid.png'; // 马上发起请求
    video.onerror = function(e) {console.log(e);};
    video.poster = '../invalid.png'; // 马上发起请求，虽然失败了，但是不会触发 onerror
    video.src = './invalid.mp4'; // source 被抛弃了，马上发起请求，触发了 onerror


``audio`` 和 ``video`` 都跟 ``img`` 是一路的，
就算没插入文档，只要设置或修改了 ``src`` ，马上发起请求。
另外，虽然有 ``new Audio()`` ，但是没有 ``new Video()`` 。
还有，如果指定了 ``src`` ，就不会管内部有没有 ``source`` 了，
这点又和 ``script`` 有点类似。即使开始使用的是 ``source`` ，
一旦设置了 ``src`` ，马上就会把 ``source`` 抛弃掉。

``source`` 在首次插入 ``audio`` 或 ``video`` 时，会尝试下载。
（前面说了，如果 ``audio`` 或 ``video`` 有 ``src`` ，插入是无效的。）
如果插入时没有 ``src`` ，没东西可下，也就没有请求了。
插入之后再修改 ``src`` ，不会自动发起请求，要手动载入。
注意下，不用插入到文档中，只要插入 ``audio`` 或 ``video`` 下面就可以了。

``track`` 有点类似样式表，有个额外的控制因素，是否开启了字幕。
如果开启了字幕，那么插入和修改都会马上发起请求，
如果没有开启字幕，不管插入还是修改，都不会发起请求。

那么要怎么开启字幕呢？首先，作为一个字幕（ ``kind="subtitles`` ），
必须标注语言（ ``srclang="en"`` ），具体什么语言看实际情况了。
如果这个和用户设置的浏览器语言匹配，那么就会启用这个字幕。
如果所有字幕都不匹配，会寻找设置了 ``default`` 的默认字幕。

这里这个情况，可以就简单理解成 ``default`` 属性就算开启字幕。
注意下，必须是在插入 ``video`` 之前设置好 ``default`` ，
插入后再设置，是不会开启字幕的。
（可以通过插入设置了 ``default`` 但没有 ``src`` 的 ``track`` 来开启字幕。）
只要开启了字幕，所有 ``track`` 的插入/修改都会发起请求。
（大概是这个样子，还有一些无法理解的细节……）


.. code:: javascript

    var embed = document.createElement('embed');
    embed.src = './invalid.mov'; // 不会发起请求
    document.body.appendChild(embed); // 发起请求
    embed.src = '../invalid.mov'; // 不会发起请求

``embed`` 和 ``script`` 比较像，都是插入时才会发起请求，
而且之后再修改 ``src`` 都不起作用。







chrome cors
============
用 chrome 调试本地页面的时候，
可以加上 ``--allow-file-access-from-files`` 选项，
这样就可以请求其他本地文件了。







undefined 与 +
===============
没声明的 ``undefined`` 和声明为 ``undefined`` 是不一样的。

.. code:: javascript

    (function() {
        console.log(undefined + 0); // NaN
        console.log(undefined + false); // NaN
        console.log(undefined + undefined); // NaN
        console.log(undefined + null); // NaN
        console.log(undefined + ""); // "undefined"
        console.log(undefined + {}); // "undefined[object Obejct]"
        console.log(undefined + []); // "undefined"
        console.log(undefined + /pattern/); // "undefined/pattern/"
        console.log(undefined + function(){}); // "undefinedfunction (){}"
    })();

上面是直接和 ``undefined`` 相加的情况，和变量声明为 ``undefined`` 是一样的。
包括显式赋值为 ``undefined`` 和声明后没赋值的情况。

但事实上，如果没有声明过，结果是抛出错误。

.. code:: javascript

    typeof(un) == "undefined"; // true

    console.log(un + 0);
    console.log(un + false);
    console.log(un + undefined);
    console.log(un + null);
    console.log(un + "");
    console.log(un + {});
    console.log(un + []);
    console.log(un + /pattern/);
    console.log(un + function(){});

虽然 ``un`` 的类型确实是 ``undefined`` ，但是尝试执行上面的语句，
都只会得到 ``ReferenceError: un is not defined`` 。

http://stackoverflow.com/questions/833661/what-is-the-difference-in-javascript-between-undefined-and-not-defined
上的解释是：因为没有声明过，所以 ``un`` 是没有类型的，换句话说，类型没有定义，
所以返回了 ``undefined`` 。
（很巧的是， ``undefined`` 这个值的类型，也叫 ``undefined`` 。）

因为 ``un`` 没有声明过，所以对其引用造成了运行时的错误。








arguments
==========
``use strict`` 模式下， ``arguments`` 和形式参数没有关联，不会互相影响。

.. code:: javascript

    (function(a1, a2, a3) {
        "use strict";
        console.log(a1, a2, a3); // 1 2 3
        a1 = 100;
        arguments[1] = 200;
        console.log(a1, a2, a3); // 1 2 3
        console.log(arguments); // [2, 3]
    })(1, 2, 3);

但是在非严格模式下， ``arguments`` 有一点点坑。
建议使用 ``Array.prototype.slice`` 复制一个 ``arguments`` ，
避免对 ``arguments`` 的直接操作。

下面讲下坑在哪里。

首先，参数和 ``arguments`` 相互关联，对其中一个进行修改会影响另一个。

.. code:: javascript

    (function(a1, a2, a3) {
        console.log(a1, a2, a3, arguments); // 1 2 3 [1,2,3]
        a1 = 100;
        arguments[1] = 200;
        console.log(a1, a2, a3, arguments); // 100 200 3 [100, 200, 3]
    })(1, 2, 3);

但是，这个关联又不是十分紧密。

.. code:: javascript

    (function(a1, a2, a3) {
        console.log(a1, a2, a3, arguments); // 1 2 undefined [1,2]
        a3 = 3;
        console.log(a1, a2, a3, arguments); // 1 2 3 [1,2]
    })(1, 2);

    (function(a1, a2, a3) {
        console.log(a1, a2, a3, arguments); // 1 2 undefined [1,2]
        arguments[2] = 300;
        console.log(a1, a2, a3, arguments); // 1 2 undefined [1,2,300]
    })(1, 2);

我的理解是 ``arguments`` 作为实际参数，
在 **初始化** 时，与 **对应** 的形式参数建立了联系，
记录了配对的数量。（ **注意** ：这个配对数会减少，但不会增加。）
之后，在 ``arguments`` 中添加新值、给没有配对的形式参数赋值，
由于两者没有关联，结果没有互相影响。

在进行一些数组操作时，配对数的影响很明显。

.. code:: javascript

    (function(a1, a2, a3) {
        console.log(a1, a2, a3, arguments); // 1 2 3 [1,2,3]
        Array.prototype.pop.call(arguments);
        console.log(a1, a2, a3, arguments); // 1 2 3 [1,2]
        Array.prototype.push.call(arguments, 300);
        console.log(a1, a2, a3, arguments); // 1 2 3 [1,2,300]
        a3 = 30;
        console.log(a1, a2, a3, arguments); // 1 2 30 [1,2,300]
    })(1, 2, 3);

在 ``pop`` 之后， ``a3`` 和 ``arguments`` 的联系就切断了，
``shift`` 的情况要更加复杂。

.. code:: javascript

    (function(a1, a2, a3) {
        console.log(a1, a2, a3, arguments); // 1 2 3 [1,2,3]
        Array.prototype.shift.call(arguments);
        console.log(a1, a2, a3, arguments); // 2 3 3 [2,3]
        Array.prototype.unshift.call(arguments, 100);
        console.log(a1, a2, a3, arguments); // 100 2 3 [100,2,3]
        a3 = 30;
        console.log(a1, a2, a3, arguments); // 100 2 30 [100,2,3]
    })(1, 2, 3);

虽然是第一个元素被移出 ``arguments`` ，但是断开联系的却是 ``a3`` 。
也就是说，配对数量减少时，受影响的是后面的元素。

另外，配对数只在 ``arguments`` 的元素个数（和 ``arguments.length`` 有点区别）
小于配对数时，才会减小。

如果修改了 ``arguments.length`` ， ``arguments`` 的表现会显得更加诡异。
因为 ``pop`` ``shift`` 这些数组方法依赖于 ``length`` 属性，
但是 ``arguments`` 的元素个数又不受 ``length`` 的影响。


更准确的描述，需要去翻文档了。







渲染模式
=========
``document.compatMode`` 可以用来检查浏览器使用的是标准模式还是怪异模式。
在怪异模式下，返回 ``BackCompat`` 。
在其他模式下，返回 ``CSS1Compat`` ，
也就是说标准模式和进标准模式的返回值没有区别。





获取文本
=========
+ https://developer.mozilla.org/en-US/docs/Web/API/Node.textContent

获取文本的时候， ``innerText`` 和 ``textContent`` 都是可以的。
今天发现一点区别，查了下 MDN，
说是 ``innerText`` 会保留样式，并且会触发重排（reflow）。
但 ``textContent`` 不会。






contains
=========
+ http://ejohn.org/blog/comparing-document-position/

简单讲，就是判断节点 A 是不是节点 B 的子节点。

暴力一点就是查找 A 的父节点，看是否是 B，或者遍历 B 的子节点。
聪明点的可以用 John Resing 上面提到的办法，
使用 ``contains`` 或 ``compareDocumentPosition`` 来判断。

之前想到过，能否使用 ``insertBefore`` 来判断。
可惜 ``insertBefore`` 只能处理直接后代的情况，在嵌套了多层的情况下，无法使用。



Object.keys
============
在 python 里，可以使用 ``dir`` 来获取对象的属性，相当方便。
在 js 里面，可以用 ``Object.keys`` 达到类似的效果。





arguments.length
==================

.. code:: javascript

    function example(x, y, z) {
        console.log(arguments.length, x, y, z);
    }
    example(); // 0, undefined, undefined, undefined
    example(undefined); // 1, undefined, undefined, undefined

这么一个例子就可以啦。

直接判断是否为 ``undefined`` 是不靠谱的，
应该借助 ``arguments.length`` 来判断参数个数。






constructor && this
======================

这里讲的是构造函数，不是 ``prototype.constroctor`` 。

在构造函数里面，
可以使用 ``(this instanceof CONSTRUCTOR)`` 来判断是否使用了 ``new`` 。

如果没有使用 ``new`` ，
在 ``use strict`` 的情况下 ``this === undefined`` ，
非严格模式下 ``this === window`` 。

更新一点关于 ``constructor`` 的看法。
测试了一下 ``prototype.constroctor`` ，发现对 ``instanceof`` 操作没有半点影响。

不过在
http://stackoverflow.com/questions/8453887/why-is-it-necessary-to-set-the-prototype-constructor
，还是有人给 ``prototype.constroctor`` 找到了个实际应用中的例子。





Error && setTimeout
======================
举两个例子：

.. code:: javascript

    setTimeout(function A() {
        setTimeout(function B() {
            setTimeout(function C() {
                throw new Error("error in C");
            }, 1);
        }, 1);
    }, 1);

可以看到，错误信息的堆栈信息里只有 ``C`` ，没有 ``A`` ``B`` 。
因为超时调用的作用域是全局作用域。

.. code:: javascript

    try {
        setTimeout(function() {
            throw new Error("error message");
        }, 1);
    } catch (e) {
        console.log(e);
    }

可以看到，错误没有被捕获。原因和之前提到的一样，
回调函数执行的时候，作用域已经脱离了 ``setTimeout`` 的作用域。


要处理回调中的异常，除了直接在回调函数里处理，
还可以使用 ``window.onerror`` 。








map
========

+ http://www.2ality.com/2013/10/dict-pattern.html
+ http://www.nczonline.net/blog/2012/10/09/ecmascript-6-collections-part-2-maps/
+ https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map

js 里面的对象经常被用作关联数组，第一个链接指出了一个小问题。

.. code:: javascript

    var map = {};
    var key = "toString";
    console.log(key in map); // true

来自 ``Object.prototype`` 的属性和方法，会影响 ``in`` 的判断。

一种做法是使用 ``Object.create`` 。

.. code:: javascript

    var map = Object.create(null);
    var key = "toString";
    console.log(key in map); // false
    console.log(map instanceof Object); // false

这样生成的对象不会继承 ``Object`` 。

在 es6 里面会有内置的 ``Map`` 类型，不知道什么时候能用上。









requestAnimationFrame
=========================
+ https://developer.mozilla.org/en-US/docs/Web/API/window.requestAnimationFrame
+ http://www.nczonline.net/blog/2011/05/03/better-javascript-animations-with-requestanimationframe/
+ http://www.paulirish.com/2011/requestanimationframe-for-smart-animating/

文章都是 2011 年的了，但没怎么使用啊。

.. code:: javascript

    var i = 0;
    requestAnimationFrame(function example(ts) {
        if (++i < 100) {
            console.log("requestAnimationFrame", new Date(), ts);
            requestAnimationFrame(example);
        }
    });

    var j = 0;
    setTimeout(function example() {
        if (++j < 100) {
            console.log("setTimeout", new Date());
            setTimeout(example, 16);
        }
    }, 0);

感觉就像是省略了时间的 ``setTimeout`` ，同样是等主线程空闲之后执行回调函数。
上面的代码基本上是在交替输出。

当然还是有个特别点的地方， ``requestAnimationFrame`` 会给回调函数传递一个参数，
表示回调函数被调用的时间（？）。

和 ``setTimeout`` 一样有个返回值，用于终止回调。
终止函数为 ``cancelAnimationFrame`` ，用法和 ``clearTimeout`` 一样，
就不给例子了。







获取 global
=============

.. code:: javascript

    (function() {
        "use strict";
        var global = this || (0, eval)("this");
    })();

来自 knockoutjs，稍加修改。

首先，这是外层，假如没有 `"use strict"` ，那么 `this` 应该指向 `window` 。

由于 `"use strict"` 的关系， `this` 是 `undefined` ，所以执行的是后面的语句。
就算直接执行 `eval("this")` ，同样是 `undefined` 。

所以说，关键大概在 `(0, eval)` ，但实际上，返回的就是 `eval` 。
真正的关键是直接调用还是间接调用。







如何包装类库
==============

.. code:: javascript

    (function(undefined) {
        "use strict";
        var global = (0, eval)("this");

        (function(factory) {
            if (typeof(require) == "function" &&
                typeof(exports) == "object" &&
                typeof(module) == "object") {
                // commonjs/nodejs
                var target = module["exports"] || exports;
                factory(target);
            } else if (typeof(define) == "function" && define["amd"]) {
                // amd
                define(["exports"], factory);
            } else {
                // <script>
                factory(global["libName"] = {});
            }
        })(function(libName) {
            // code here
        });
    })();

最外面一个自执行函数，获取个全局变量，没啥可说的。
里面一个自执行函数，其实可以拆开，不过这样看起来高大上一些……
真正的类库代码都在参数中，将类库的所有功能都暴露给 ``libName`` 。

如果是直接引入，其实就是在给 ``window["libName"]`` 赋值，
如果是 amd 引入，就是 ``define(["exports"], function(libName) {})`` ，
如果时 node 引入，就是 ``(function(exports) {})()`` 。

总之，就是通过一个中间层，使得类库能够适应各种环境。

https://github.com/jrburke/requirejs/wiki/Differences-between-the-simplified-CommonJS-wrapper-and-standard-AMD-define#magic
http://nodejs.org/api/modules.html#modules_module_exports


另外，外层的参数 undefined 其实没有任何特殊意义，只是为了压缩体积。
后面代码出现 undefined 的时候，会被压缩工具替换掉。
