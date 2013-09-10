cookie
=======
http://en.wikipedia.org/wiki/HTTP_cookie#Cookie_attributes

浏览器在传输 cookie 的时候，是不会传送 cookie 属性的，而是单纯的名值对。
这些属性是服务器用来指导浏览器，如何处理 cookie 的。

``Domain`` 和 ``Path`` 指定了 cookie 的所属页面。
``Expires`` 和 ``Max-Age`` 指定了 cookie 的过期时间。
（没设置的话，浏览器会在关闭时删除该 cookie。）
``Secure`` 要求 cookie 只通过 ``https`` 传输。
``HttpOnly`` 要求 cookie 只通过 ``http`` 设置。
（包括 ``https`` ，这个的主要作用的阻止 ``document.cookie`` 读写 cookie。）





http header about secure
=========================
http://hooopo.writings.io/articles/d22fb477
http://www.imququ.com/post/web-security-and-response-header.html

``X-Content-Type-Options: nosniff``
    阻止浏览器猜测文件的 ``MIME`` 类型。

``X-XSS-Protection: 1;mode=block``
    激活 ie 内建的 xss 过滤机制

``X-Frame-Options: SAMEORIGIN``
    是否允许网页被嵌入 ``iframe/frame`` 。
    ``SAMEORIGIN`` 是允许相同域名的网页， ``DENY`` 是阻止所有网页。

``Strict-Transport-Security: max-age=60; includeSubDomains``
    要求浏览器在 ``max-age`` 秒内，将链接重定向到 https。

``Content-Security-Policy``
    限定页面内各种资源的来源。






缓存
=====
+ https://www.varnish-software.com/static/book/HTTP.html
+ http://www.mnot.net/cache_docs/
+ https://developers.google.com/speed/articles/caching
+ https://developers.google.com/speed/docs/best-practices/caching


缓存可以细分浏览器缓存、代理缓存、网关缓存（CDN 就属于这种）。
和缓存相关的头信息（http header）有八个。

+-------------------+---------+---------+
| header            | request | reponse |
+===================+=========+=========+
| Expires           |         | X       |
+-------------------+---------+---------+
| Cache-Control     | X       | X       |
+-------------------+---------+---------+
| Last-Modified     |         | X       |
+-------------------+---------+---------+
| If-Modified-Since | X       |         |
+-------------------+---------+---------+
| Etag              |         | X       |
+-------------------+---------+---------+
| If-None-Match     | X       |         |
+-------------------+---------+---------+
| Vary              |         | X       |
+-------------------+---------+---------+
| Age               |         | X       |
+-------------------+---------+---------+

叉表示发送时可以带上这个信息。

Expires
    ``Expires: GMT formatted date``

    如果过期了，客户端就会发起新请求。
    google 推荐是一月到一年。

    适合用于 js, css 和图片。



Cache-Control
    ``Cache-Control: public, must-revalidate, max-age=2592000``

    会控制代理服务器和浏览器在内的所有缓存环节。

    +----------------------------------------------+---------+---------+
    | argument                                     | request | reponse |
    +==============================================+=========+=========+
    | no-cache                                     | X       | X       |
    | （进行缓存，但是在使用前必须经过服务器验证） |         |         |
    +----------------------------------------------+---------+---------+
    | no-store                                     | X       | X       |
    | （任何环节都不进行缓存）                     |         |         |
    +----------------------------------------------+---------+---------+
    | max-age                                      | X       | X       |
    | （缓存的有效期）                             |         |         |
    +----------------------------------------------+---------+---------+
    | s-maxage                                     |         | X       |
    | （缓存的有效期。只对 public 的资源有效）     |         |         |
    +----------------------------------------------+---------+---------+
    | max-stale                                    | X       |         |
    +----------------------------------------------+---------+---------+
    | min-fresh                                    | X       |         |
    +----------------------------------------------+---------+---------+
    | no-transform                                 | X       | X       |
    +----------------------------------------------+---------+---------+
    | only-if-cached                               | X       |         |
    +----------------------------------------------+---------+---------+
    | public                                       |         | X       |
    | （每个环节都允许进行缓存）                   |         |         |
    +----------------------------------------------+---------+---------+
    | private                                      |         | X       |
    +----------------------------------------------+---------+---------+
    | must-revalidate                              |         | X       |
    +----------------------------------------------+---------+---------+
    | proxy-revalidate                             |         | X       |
    +----------------------------------------------+---------+---------+

    如果 ``Cache-Control`` 和 ``Expires`` 发生冲突，
    ``Cache-Control`` 的优先级更高。


Last-Modified
    ``Last-Modified: GMT formatted time``

    服务器最后修改资源的时间，可以与 ``Last-Modified-Since`` 配合使用。


Last-Modified-Since
    ``Last-Modified-Since: GMT formatted time``

    如果资源在给定时间内没有修改过，服务器会返回 304。


Etag
    ``Etag: "hash code"``

    资源的唯一性，可以与 ``If-None-Match`` 配合使用。


If-None-Match
    ``If-None-Match: "hash code"``

    如果资源没有修改过，服务器会返回 304。


Vary
    ``Vary: Accept-Encoding``

    表示资源会随请求的某些头信息（http heaeder）改变。
    比如 ``Accept-Encoding`` 或是 ``Cookie`` 。


Age
    ``Age: 0``

    以前理解有误。
    来自代理缓存，表示从原始服务器生成该资源算起，经过了多少时间。


Pragma
    ``Pragma: no-cache``

    不是规范中的内容，所以没在表格里列出来，而且已经不再使用了。
    如果有需要，用 ``Cache-Control: no-cache`` 代替。


``Last-Modified`` 和 ``Etag`` 选一个就可以了，
google 是推荐用 ``Last-Modified`` 。
``Expires`` 和 ``Cache-Control: max-age=xxx`` ，
google 推荐 ``Expires`` 。


缓存的处理的方式如下。

1. 如果回应（response）明确表示不要缓存，不会缓存。

2. 如果请求（request）需要认证或者走 https 等，不会缓存。

3. 在如下的两种情况下，

   + 缓存设置了过期时间，现在这个时间还没到。
   + 缓存在近期还被使用，而且很久没修改过了。

   那么，缓存会被认为是可用的。

4. 如果缓存过期（stale）了，会向服务器确认（validate），看缓存是不是还能用。

5. 如果没有联网，会使用过期的资源。






性能优化
=========
+ https://developers.google.com/speed/docs/best-practices/rules_intro

简单记录几点

+ 使用相对路径/绝对路径而不是完整地址。

    寻找完整地址要进行 DNS 查询。
    使用路径，浏览器可以利用之前缓存的 DNS 查询结果。


+ 减少重定向的次数，尽可能内部跳转，不行也返回个 3xx。

    内部跳转不要额外连接，返回 301/302 可以被浏览器缓存。
    如果使用 js 什么的进行跳转，就没有缓存效果了。


+ 合并资源请求。

    js/css 开发时应做到模块化，发布时应该进行合并，减少请求数量。


+ 使用额外的二级域名来存储资源。

    浏览器在在一个时间点，只能向服务器发起两个请求。
    资源分散到多个域名，可以增加并行性。


+ 指定图片的大小。

    为图片指定大小可以减小渲染的开销。


+ 限制请求的大小。

    一个以太网的包约为 1500 bytes，每个请求都应该小于这个大小，避免分为多个包。
    注意 cookie，ua，url，referrer 的长度。


+ 不要在用于分发资源的域名设置 cookie。

+ 压缩资源。

    包括多余的空格，gzip 压缩，图片优化等。






evercookie
===========
+ https://github.com/samyk/evercookie
+ https://hacks.mozilla.org/2010/03/privacy-related-changes-coming-to-css-vistited/
+ http://oldj.net/article/browser-history-sniffing/
+ http://forums.mozillazine.org/viewtopic.php?f=37&t=1997621

记录下里面提到的几种方法。

+ window.name

    生存周期比 ``sessionStorage`` 还短。感觉不实用。

+ Etag

    猜测是服务器发送一个唯一的 etag 来标识用户，
    然后根据浏览器请求里的 ``If-None-Match`` 来判断用户。

+ css color

    好神奇的东西，只能说是真会玩。用来判断用户访问过哪些网站。

    .. code:: javascript

        var a = document.createElement("a");
        a.href = "http://url_to_test";
        document.body.appendChild(a);
        var color = window.getComputedStyle(a, null).getPropertyValue("color");

    简单说就是，检查链接的颜色，根据链接颜色来判断用户是否访问过某个网站。
    具体颜色和 css 有关系，但网站是自己的，怎么玩都可以。

    缺点就是只能检查固定的列表，不能主动去发现了。

+ Storing cookies in RGB values of auto-generated,
  force-cached PNGs using HTML5 Canvas tag to read pixels (cookies) back out.

    看了下代码，大意是说，把内容加密成图片（把字存储在 RGB 里面）。
    然后靠 ``canvas`` 把像素读出来，
    用 ``String.fromCharCode`` 处理每个像素的 RGB 值，获取内容。

    好扭曲。





etag
=====

.. code:: python

    def compute(data):
        hasher = hashlib.sha1()
        hasher.update(data)
        return hasher.hexdigest()

    def compare(etag, inm):
        return inm.find(etag) >= 0

tornado 中计算 etag 的代码，简化之后，大概就是如上的代码。

计算使用的是 sha1。

没看懂的是比较的时候，为什么是 ``>=0`` ，难道不应该是完全相等吗？
