XSS Experimental Minimal Encoding Rules
========================================
https://www.owasp.org/index.php/XSS_Experimental_Minimal_Encoding_Rules

在 script 标签内
-----------------
如 ``<script>{{DATA}}</script>``

+ 只使用这些转义 ``\\ \r \n \b \t \f \' \" \/`` 。
+ 对于 ``0..0x19`` 之间的字符，使用 16 进制转义。
+ 对于非 unicode 编码，对大于 ``0x7e`` 的字符，使用 ``\u`` 进行转义。


在事件处理函数内
-----------------
如 ``onclick="{{DATA}}"``

+ 只使用这些转义 ``\\ \r \n \b \t \f`` 。
+ 对 ``' " &`` ，使用 16 进制转义。
+ 对于 ``0..0x19`` 之间的字符，使用 16 进制转义。
+ 对于非 unicode 编码，对大于 ``0x7e`` 的字符，使用 ``\u`` 进行转义。


在普通标签中（html）
--------------------
如 ``<div>{{DATA}}</div>``

+ 对 ``< &`` 进行实体转义。
+ 指定页面的字符集（charset），避免 UTF7 攻击。


在普通标签中（xhtml）
---------------------
如 ``<div>{{DATA}}</div>``

+ 对 ``< & >`` 进行实体转义。
+ 限制输入编码
