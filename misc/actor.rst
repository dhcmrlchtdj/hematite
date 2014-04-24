.. contents::

http://www.artima.com/articles/io_design_patternsP.html
https://groups.google.com/d/msg/python-tornado/FKzsUYdjmJs/k-8laTZU1lwJ


概念
=====

重新梳理下概念。

同步 synchronous，完成任务后才返回。
异步 asynchronous，没完成任务，直接返回。
（任务完成时，会告知调用者。这个过程会使用一些辅助手段，
比如回调函数、信号、promise/future。）

阻塞（blocking）和非阻塞（non-blocking）通常讲网络 IO 或硬盘 IO。
阻塞是在读写完成后才返回；非阻塞是执行读写函数后马上返回，不等待读写操作。

目前，win 支持非阻塞硬盘 IO，而 unix-like 不支持非阻塞硬盘 IO，或者说不成熟吧。
有种预感，等到 linux 支持硬盘的非阻塞 IO，会出现群魔乱舞的场景。
感觉就像 css3 的 ``box-sizing: border-box`` ，以前喷 ie 的盒模型如何不标准，
到最后 w3c 自己也觉得 ie 的盒模型好用，开始到处推荐。打脸打得啪啪响。

好像扯远了……


io 复用
========

io 复用有 reactor 和 proactor 两种模型。
我的理解是 reactor 除了进行数据处理，还要自己进行 IO 的读写操作。
而 proactor 只进行数据处理，将 IO 读写操作委托给了系统。



