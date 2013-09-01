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





http header
============
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
