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

+ http://1234n.com/?post/j02rfx

所以我们可以这样来归类异常和错误：
不会终止程序逻辑运行的归类为错误，会终止程序逻辑运行的归类为异常。

错误和异常需要分类和管理，不能一概而论
错误和异常的分类可以以是否终止业务过程作为标准
错误是业务过程的一部分，异常不是
不要随便捕获异常，更不要随便捕获再重新抛出异常
在捕获到异常时，需要尽可能的保留第一现场的关键数据

唔，不会终止逻辑 和 知道如何恢复，应该可以归类为相同的说法。



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




conway's law
=============

在 https://github.com/substack/webapps-of-the-future 看到这么一句调侃

::

    java programmers built Angular
    rails programmers built Ember

团队的结构影响最终产物的结构，好像确实是这样……




一个前端的自我修养
==================

http://taobaofed.org/blog/2016/03/23/the-growth-of-front-end/

技术圈里流行一个笑话，说的是一个人，工作了三年，却只有一年的经验，因为后面两年都在重复第一年的工作。

心有戚戚



> 子组件对外部一无所知
> 唯一的数据入口是 props
> 唯一的行为出口是 event


******

v2ex 上遇到一个神奇的网址 https://cloudflare.com/cdn-cgi/trace
只要用了 cloudflare 的 CDN，都可以访问这个路径
网上搜了下，https://www.cloudflarestatus.com/ 可以查到里面具体指哪个数据中心
从地图上看，https://www.cloudflare.com/network-map/，国内不少啊，是百度提供的吗
