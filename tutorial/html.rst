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
