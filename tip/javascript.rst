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

    var track = document.createElement('track');
    track.src = './invalid.srt'; // 没发起请求
    track.default = true; // 发起请求了
    video.appendChild(track); // 没发起请求
    track.src = '../invalid.srt'; // 马上发起请求


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

``track`` 有个类似于样式表的额外控制因素，是否开启了字幕。
可以简单理解成是 ``default`` 属性，而且必须是在插入 ``video`` 之前设置好。
如果开启了字幕，那么插入和修改都会马上发起请求，
如果没有开启字幕，不管插入还是修改，都不会发起请求。
而且插入后再设置 ``default`` ，是不会开启字幕的。
（可以通过插入设置了 ``default`` 但没有 ``src`` 的 ``track`` 来开启字幕。）
只要开启了字幕，单个 ``track`` 是否设置了 ``default`` 就不是重点了。
所有的插入修改操作，都会发起请求。
（大体是这样，还有一些无法理解的细节……）


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
