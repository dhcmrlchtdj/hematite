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
