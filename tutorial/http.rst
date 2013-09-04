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


缓存可以细分浏览器缓存、代理缓存、网关缓存（CDN 就属于这种）。
和缓存相关的 http header 有八个。

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

    如果过期了，客户端就会发起新请求。这个过期时间不适合设置地太长。

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

    请求的有效时间，和 ``Expires`` 不同，这个是相对时间。


Pragma
    ``Pragma: no-cache``

    不是规范中的内容，所以没在表格里列出来，而且已经不再使用了。
    如果有需要，用 ``Cache-Control: no-cache`` 代替。




缓存的处理的方式如下。

1. 如果回应（response）明确表示不要缓存，不会缓存。

2. 如果请求（request）需要认证或者走 https 等，不会缓存。

3. 在如下的两种情况下，

   + 缓存设置了过期时间，现在这个时间还没到。
   + 缓存在近期还被使用，而且很久没修改过了。

   那么，缓存会被认为是可用的。

4. 如果缓存过期（stale）了，会向服务器确认（validate），看缓存是不是还能用。

5. 如果没有联网，会使用过期的资源。
