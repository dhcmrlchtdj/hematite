离线缓存
=========
也不是什么新鲜东西了，不过之前一直没了解。

+ http://caniuse.com/#feat=offline-apps
+ http://www.whatwg.org/specs/web-apps/current-work/multipage/offline.html#offline
+ http://developers.whatwg.org/offline.html#offline
+ http://www.w3.org/html/wg/drafts/html/master/browsers.html#offline
+ http://appcachefacts.info
+ https://developer.mozilla.org/en-US/docs/HTML/Using_the_application_cache
+ http://diveintohtml5.info/offline.html
+ http://html5doctor.com/go-offline-with-application-cache/
+ http://www.html5rocks.com/en/tutorials/appcache/beginner/



启用离线缓存
-------------
下面直接上代码

.. code:: html

    <!DOCTYPE html>
    <html manifest="/path/to/manifest.appcache">
        <head></head>
        <body></body>
    </html>

只要在 `html` 后面指定缓存列表（cache manifest）就可以了。
如果离线应用由多个页面组成，每个页面都要引入这个列表。
注意下，缓存列表的 MIME 类型是 ``text/cache-manifest`` ，
推荐的后缀名是 ``.appcache`` 。

chrome 可以到 `<chrome://appcache-internals>`_ 查看缓存的资源。


缓存列表的格式
---------------

::

    CACHE MANIFEST
    # comment start with hash

    # without explicit section
    # resources will be cached as in CACHE section
    ./index.html

    # inside CACHE section
    # resources will be cached and available offline
    CACHE:
    ./style.css
    ./app.js

    # inside NETWORK section
    # resources will never be cached
    NETWORK:
    ./example.png

    # if page unavailable, use fallback instead
    FALLBACK:
    / /offline.html

    SETTINGS:
    prefer-online

简单讲就是把要缓存的内容放到 ``CACHE:`` 下面，
不该缓存的放到 ``NETWORK`` 下面，
如果有些缓存不可用，会用 ``FALLBACK:`` 里的替代品代替。
在 ``SETTINGS`` 里面只有有一个选项， ``prefer-online`` 或者 ``fast`` ，
在联网状态下，优先下载资源还是优先使用缓存的资源。



更新资源
---------
要注意一点，缓存了的资源是不会主动更新的，只有在离线列表发生改变的时候，
才会更新离线资源。
所以可以在离线列表里，用注释加上版本信息等，进行离线资源的更新。

::

    CACHE MANIFEST
    # 2013-08-15T12:57:12

就像上面这样，每次修改资源后，同时修改离线列表里的更新时间就可以了。



缓存
-----
在 ``window.applicationCache`` 之下，有一系列与缓存相关的事件，
还可以通过 ``window.applicationCache.status`` 检查缓存的状态。
此外可以通过 ``window.navigator.onLine`` 检查是否处于离线状态。
这里不展开了，可以查阅 MDN。

下面讲下浏览器是怎么进行缓存的。

首先，只要缓存列表的资源，只要有一项没能缓存下来，那么整个缓存就都不可用。
这会触发 ``window.applicationCache.status.onerror`` ，但是没有错误的细节信息。

浏览器分三步检查缓存列表是否发生改变。

1. 依照 HTTP 的头部信息，检查缓存列表是否需要更新。需要更新，就下一步。
2. 如果过期了，向服务器请求新版本。如果返回值不是 304，就下一步。
3. 下载新的缓存列表，然后和原来的缓存列表进行比较。
   根据结果判断是否需要重新下载列表中的资源。

在缓存列表里加上时间戳或版本号只是解决第三步，
需要更新缓存列表时，还要考虑前两步，也就是浏览器通常的缓存。





html 实体符号
==============

+ http://developers.whatwg.org/syntax.html#syntax-charref
+ http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
+ http://www.howtocreate.co.uk/sidehtmlentity.html

在对特殊符号进行转义的时候，
可以使用十进制（ ``&#nnnn;`` ），
也可以使用十六进制（ ``&#xHHHH;`` ）。
要注意一下，在 XML 中，十六进制的 ``x`` 必须是小写（html 里无所谓）。
还有一部分符号可以用 ``&name;`` 的形式表示，符号名称可以去上面的链接找。







WebVTT
=======

webvtt 的 MIME 类型是 ``text/vtt`` 。

简单讲下字幕构成

::

    WEBVTT

    1
    00:00:00.000 --> 00:10:00.000
    blah

    2
    05:00.000 --> 15:00.000 line:0% position:100%
    blahblah
    blahblahblah

    NOTE 注释比较奇怪一点。
    可以换行，和字幕一样，用空行来划分范围。

第一行，id，可选。
第二行，时间，可以加上一些字幕选项。
第三行，字幕，可以多行。

id 没有任何要求，重复的都可以。

时间要求很简单，结束时间要大于开始时间，而开始时间要大于等于之前的开始时间，
时间上是允许重合的。写时间的时候，小时可以省略，其他必须写。

字幕选项有五个，注意下这些选项是区分大小写的。

+----------+------------------+---------------------------+-------------+
| 选项     | 可选值           | 解释                      | 例          |
+==========+==================+===========================+=============+
| vertical | rl, lr           | 竖排，左往右还是右往左。  | vertical:rl |
+----------+------------------+---------------------------+-------------+
| line     | 百分比，数字     | 文字的位置（上下）。      | line:100%   |
|          |                  | 0% 是顶端，100% 是底端。  |             |
|          |                  | 0 顶端，正值是从上到下，  |             |
|          |                  | -1 底端，负值是从下到上。 |             |
+----------+------------------+---------------------------+-------------+
| position | 百分比           | 文字的位置（左右）。      | position:0% |
|          |                  | 0% 是左边， 100% 是右边。 |             |
+----------+------------------+---------------------------+-------------+
| size     | 百分比           | 文字的宽度。              | size:100%   |
|          |                  | 100% 是正常宽度。         |             |
+----------+------------------+---------------------------+-------------+
| align    | start,middle,end | 文字对齐。                | align:end   |
+----------+------------------+---------------------------+-------------+

字幕里要将 ``&<>`` 转义为 ``&amp;&lt;&gt;`` ，另外不能在在字幕里出现 ``-->`` 。

字幕提供了几个默认样式，也可以使用样式表自定义。

+--------------+------------------------+-----------------------------------------+
| 标签         | 用途                   | 例                                      |
+==============+========================+=========================================+
| <c>          | 样式表                 | <c.classname>style</c>                  |
+--------------+------------------------+-----------------------------------------+
| <i>          | 斜体                   | <i>italics</i>                          |
+--------------+------------------------+-----------------------------------------+
| <b>          | 粗体                   | <b>bold</b>                             |
+--------------+------------------------+-----------------------------------------+
| <u>          | 下划线                 | <u>underline</u>                        |
+--------------+------------------------+-----------------------------------------+
| <ruby>，<rt> | 注音                   | <ruby>WWW<rt>world wide web</rt></ruby> |
+--------------+------------------------+-----------------------------------------+
| <v>          | 声音（用来指明说话人） | <v NAME>text</v>                        |
+--------------+------------------------+-----------------------------------------+

字幕里还可以使用时间戳。时间戳的范围必须在开始时间和结束时间之间。
比如字幕里带个时间戳 ``some text<00:10:00.000>some text`` ，这个有什么用，
没看明白……


javascript
-----------
``var vtt = document.querySelector('track').track``
这样获得的是个 ``TextTrack`` 对象，也就是载入的字幕。
其中包括当前显示的字幕，全部字幕，状态，切换字幕的事件等。


track
------
最后回头来讲下 ``track`` 标签。

浏览器选择字幕时，首先考虑的是 ``srclang`` ，在语言不匹配的情况下，
会选择带 ``default`` 的字幕。
如果没有，那么默认是不显示字幕的（可以手动开启字幕）。
如果同时有多个字幕满足条件，则会按照文档中的顺序，优先选择靠前的那个字幕。





存储
=====
记录下 ``sessionStorage`` 和 ``localStorage`` 。

限制
-----
每个域名下的存储上限是 5 MB，二级域名和主域名是分开的，
不会也没办法互相影响。

``sessionStorage`` 只会持续到关闭页面为止，刷新页面不会丢失，
不在多个标签中共享。
只要标签没有关闭，访问其他页面后再回来， ``sessionStorage`` 不会丢失。
``localStorage`` 则是长期保存，而且可在多个标签中共享。

保存的时候只能保存字符串。如果不是字符串，会自动调用 ``String`` 进行转换，
对于引用类型，也就是先 ``toString`` 再 ``valueOf`` 地进行尝试，
得到基本类型，再转换成字符串。如果没能得到字符串，会抛出错误。

要保存对象类型的值可以使用 JSON。


操作接口
---------
存储的接口就像是从数组和对象的拿了些拼起来的。
赋值读取可以像对象一样操作，也可以使用 ``getItem`` 和 ``setItem`` 方法，
但是删除必须使用 ``removeItem`` 而不能使用 ``del`` ，清空可以用 ``clear`` 。
可以像数组一样获得长度，和数组不同的是，这个长度是只读的。
可以使用 ``key`` 方法获得某个位置上的键名（可以靠这点来遍历整个存储）。


事件
-----
在其他标签修改 ``localStorage`` 的时候，会触发存储事件。
也就是说， ``sessionStorage`` 没有存储事件，读取不会触发存储事件，
本页面修改 ``localStorage`` 也不会触发存储事件。
通过参数可以得到键名，新旧值，引起事件的地址等。





页面加载顺序
=============
JS 有可能会修改 DOM.
JS 的执行有可能依赖最新样式。
prefetch 优化

定律一：资源是否下载依赖 JS 执行结果。
定律二：JS 执行依赖 CSS 最新渲染。
定律三：现代浏览器存在 prefetch 优化。







ie 注释
========
+ http://docs.webplatform.org/wiki/concepts/proprietary_internet_explorer_techniques

.. code:: html

    <!--[if IE]>
    IE can see this whereas other browsers think this is an inline comment
    <![endif]-->

    <!--[if IE 8]>
    Only IE 8 can see this
    <![endif]-->

    <!--[if lte IE 8]>
    All IEs up to version 8 can see this (lte = lower than, or equal)
    <![endif]-->

    <!--[if gt IE 8]>
    IEs higher than version 8 can see this (gt = greater than)
    <![endif]-->

    <!--[if !IE]> -->
    This is visible to every browser except IE
    <!-- <![endif]-->


.. code:: javascript

    // ie4-9

    /*@cc_on
        @if (@_jscript_version >= 5.8)
            // executed by IEs with JavaScript (aka JScript) engine >= v5.8 or higher (equals IE 8)
            // See: http://de.wikipedia.org/wiki/JScript
        @else
            // executed by IEs older than IE 8
        @end
    @*/





跨站 http 请求
===============
当网页请求不同域名的资源时，就会发起跨站 http 请求，
也就是 cross-site http requests，又叫 CORS（cross origin resoirce sharing）。

+ http://docs.webplatform.org/wiki/tutorials/using_cors
+ https://developer.mozilla.org/en-US/docs/HTTP/Access_control_CORS
+ http://fetch.spec.whatwg.org

html5 的新属性 ``crossorigin`` ，可以用于限制跨站请求。
``crossorigin="anonymous"`` 不会设置 ``credentials`` ，
``crossorigin="use-credentials"`` 会设置 ``credentials`` 。
``credentials`` 意味着会交换信息。
设置之后，请求的头部会加上 ``Origin: null`` 。


可以通过 ``Access-Control-Allow-Origin`` 设置一个跨站白名单。

通常 xhr 请求是不会携带 cookie 之类的信息的，但是可以开启。
首先要在 http 头部设置 ``Access-Control-Allow-Credentials: true`` ，
之后在发起请求前设置 ``withCredentials`` 。

.. code:: javascript

    var xhr = new XMLHttpRequest();
    xhr.withCredentials = true;







图片加载
=========
+ http://timkadlec.com/2012/04/media-query-asset-downloading-results/

关于图片加载的测试，如何避免载入多余图片。

从结论上讲， ``img`` 无解，能动手脚的只有背景图片。
直接隐藏也没有用，必须绕个弯。

可以选择把父元素隐藏，这样就不会加载子元素的背景图片了。
可以使用 `media query` 来为不同情况载入不同背景图片。





id 和 class 命名
=================
+ http://www.whatwg.org/specs/web-apps/current-work/multipage/elements.html#the-id-attribute
+ http://www.whatwg.org/specs/web-apps/current-work/multipage/elements.html#classes
+ http://google-styleguide.googlecode.com/svn/trunk/htmlcssguide.xml?showone=ID_and_Class_Name_Delimiters#ID_and_Class_Name_Delimiters
+ http://www.w3.org/TR/html4/types.html#type-name
+ http://www.w3.org/TR/CSS2/syndata.html#characters

最近写 id 和 class 写得人都乱了，去查了下文档。

id
    必须是唯一的，不能有空格，不能是空值。
    只有这三个限制，可以是纯数字，可以是标点，什么都可以。

class
    使用空格分隔不同的 class，没有其他限制了。

这个条件未免太宽了点。

google 的风格指南里面，推荐使用连字符（hyphen）作为分割符号。

里面还有些奇怪的建议，比如在 css 里面使用单引号，css 的 url 不加引号，
还有把所有可以省略的标签都省略掉。


更新：
现实和理想还是有差距的。

一个是 css 无法识别这些特殊符号，
一个是 ``document.querySelector`` 无法识别这些符号。
（但是 ``document.getElementById`` 可以。）

按照 html4 的标准，合法的命名是 ``[a-zA-Z][-_:.0-9a-zA-Z]`` 。
不过实际上， ``:`` 和 ``.`` 在使用上还是有问题。

根据 css 的规范，合法的符号有 ``[-_0-9a-zA-Z]`` 和其他一些符号，
不能以数字开头，有两个符号不能是两个连字符或连字符加数字。
关于其他符号可以看 http://mathiasbynens.be/notes/css-escapes 。

取个交集再做个限制，按照 ``[a-z][-0-9a-z]`` 来写好了。
分割使用连字符，下划线和骆驼什么的，通通不要出现。





接近标准模式（almost standards mode）
======================================
一直没好好关注下，这个和标准模式的唯一差别在于，处理表格中的图片时，
渲染方式和怪异模式相同。

使用 ``<!DOCTYPE html>`` 的时候， ie67 会采取接近标准模式来渲染页面。





重排重绘
=========
+ http://www.aliued.cn/2012/11/12/浏览器的重绘repaints与重排reflows.html
+ https://developers.google.com/speed/articles/reflow
+ http://www.stubbornella.org/content/2009/03/27/reflows-repaints-css-performance-making-your-javascript-slow/
+ http://dev.opera.com/articles/view/efficient-javascript/#reflow

重绘（repaint）
    修改元素的外观。

重排（reflow）
    浏览器重新计算元素的位置和大小。

重排的开销很大，所以要尽可能减少重排的次数。

对上面的链接总结了一下：

+ 使用绝对定位（ ``position:absolute|fixed`` ），让经常重排的元素脱离文档流。

    绝对定位的元素发生重排，不会对其他元素造成影响。
    尤其是用于实现动画的元素，应该进行定对。

    此外，对于动画效果，可以考虑牺牲动画效果的流畅性来换取性能。


+ 添加新元素的时候，设置好样式再添加到文档中。

    添加后再修改样式，可能引起重排，造成不必要的开销。


+ 修改旧元素的时候，考虑：

    + 克隆元素（ ``cloneNode`` ），修改好样式后，
      再替换（ ``replaceNode`` ）原来的元素。
    + 隐藏元素（ ``display:none`` ），修改好样式后，再显示出来。
    + 合并样式操作，用修改 ``class`` 代替修改行内样式。
      行内样式会引起重绘。


+ 压缩 css，减少其中的样式。

    样式越多，渲染越慢。


+ 避免在 css 中使用复杂的选择器（甚至是后代选择器）。

    选择器越复杂，解析越慢，筛选元素慢，渲染更慢。


+ 减少标签的嵌套。

    结合下面理解。


+ 避免修改元素的 ``class`` 属性。

    看似和前面的说法矛盾，其实是这样的：
    在修改了 ``class`` ，那么后代的样式也可能产生改变，
    这就需要重新解析，重新渲染。嵌套的越多，工作量越大。


+ 缓存读取的 DOM。

    包括获取的样式属性，获取的元素。

    读取样式，可能需要重新计算元素的样式，这个重新计算可能引起重排。

    重新获取元素要重新解析文档，属于额外开销。（这个和重排关系不大就是了。）


+ 遍历元素集合（包括 NodeList HTMLCollection 什么的）时注意：

    + 不要在遍历时修改 DOM（添加删除什么的）。
    + 避免属性比较，考虑用 DOM2 的遍历接口
      （ ``NodeIterator`` ``TreeWalker`` ）。


+ 渲染表格的速度比一般元素要慢。
