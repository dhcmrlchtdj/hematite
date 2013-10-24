.. contents::



How FriendFeed uses MySQL to store schema-less data
====================================================

+ http://backchannel.org/blog/friendfeed-schemaless-mysql

将要存储的信息作为 json 保存在一个表中，json 有相应 id。
为要查询的索引建立一个表格，对应内容到 json 表的 id。

不要求索引的一致性和准确性，只要求 json 表准确。
在查询到结果后，再在程序中进行一次过滤。

一直运行一个索引清理程序，保证索引的准确性。





You're Missing the Point of Promises
=========================================

+ http://domenic.me/2012/10/14/youre-missing-the-point-of-promises/

promise 到底是什么呢？

编写同步函数的时候，可以返回一个值，也可以抛出一个异常。
但是编写异步函数的时候，没有东西可以返回（都还没被计算），
也没办法捕获错误（回调函数不是在当前环境执行的）。

promise 将世界从异步回调的地狱中解救了出来。
异步函数返回一个 promise，promise 可能被返回值给 ``fulfilled`` ，
也可能被异常给 ``rejected`` 。





关于异常
================

+ https://www.v2ex.com/t/85366

binux

捕获你能处理的异常，其他时候请让程序挂掉

定义：能处理的异常
当异常发生时，你知道应该如何恢复/继续执行






Why Python uses 0-based indexing
===================================

+ http://www.reddit.com/r/Python/comments/1p2za1/guido_van_rossum_why_python_uses_0based_indexing/

为什么数组下标从 0 开始。

Guido 表示，最后的决定是为了简化
“获取数组前面 N 个元素”和“获取数组某位之后的 N 个元素”这两种操作。

::

    a[:n]
    a[i:i+n]

更准确些，应该说是 `下标从 0 开始` 和 `前闭后开区间` 合作，
达到了简化操作的目的。

如果数组的下标从 1 开始，就不能这么简便地进行这两种常见操作了。
