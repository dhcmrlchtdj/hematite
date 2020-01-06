HPACK lastest draft (2014.08.08)

.. contents::


1 introduction
===================
+ HPACK 是一种压缩格式
+ HPACK 能高效表示 HTTP/2 的 header field


3 compression process
=========================
+ 文档只定义了如何进行解码（decode），编码只要结果符合解码需求即可

+ 编码解码的时候都要保持 header field 在 header list 中的顺序
+ 在解码的时候，解码器要维护一个 header table，
  编码器要维护这个 header table 的拷贝
+ 在使用 HTTP 通信时，接收和发送使用的 header table 是分开的。

3.3 indexing tables
----------------------
+ static table 是预定义的，除了常见的 http header，还有常用的方法／返回值
+ header table 是个 FIFO 队列，初始为空
+ header table 中允许出现重复的值
+ 实际查找时，static table 在 header table 之前
+ 编号是从 1 开始的

::

    <----------  Index Address Space ---------->
    <-- Static  Table -->  <-- Header  Table -->
    +---+-----------+---+  +---+-----------+---+
    | 1 |    ...    | s |  |s+1|    ...    |s+k|
    +---+-----------+---+  +---+-----------+---+
                           ^                   |
                           |                   V
                    Insertion Point      Dropping Point

3.4 header field representation
---------------------------------
+ 编码后的 header field 可以是字面量，也可以是编号
+ 字面量是个名值对，值是完整的字符，名字可以是完整字符，也可以是编号
+ 字面量可能会加入到 header table 中，也可能不会


5 header table management
===========================

5.1 maximum table size
-------------------
+ header table 的大小由编码器决定
+ 解码器在 HTTP 请求中会注明 SETTINGS_HEADER_TABLE_SIZE，
  但是最后大小是由编码器决定的。
  注意不能大于 SETTINGS_HEADER_TABLE_SIZE
+ header table 的大小是元素大小的总和
+ 元素大小是名值对的长度再加上 32
+ 32 是用来对元素进行编号之类的用处

5.2 size change
----------------
+ 当 header table 的大小减小的时候，会从 header table 末尾开始剔除元素，
  直到满足大小需求

5.3 new entry
-----------------
+ 如果新元素比整个 header table 还大，会导致整个 header table 被清空
+ 如果剩余空间不足，会从 header table 末尾开始剔除元素，直到满足需求
+ 如果新元素中有对之前某元素的引用，在剔除的时候要注意不要把被引用元素剔除了

6 primitive type representations
==================================
+ HPACK 在编码时就两种基本类型：无符号整形和字符串。
  （unsigned variable length integer, strings of octets）

6.1 integer
------------
+ HPACK 出现的数字只有 字符串长度和 header table 编号
+ 数字使用 N-bit prefix 的表示

    - 如果 N-bit 足够表示数字，那么直接表示。
      也就是说 2^N -1 > number，注意不能是相等
    - 如果 N-bit 不能表示数字，那么 N-bit 全部用 1 填充。
      数字使用 unsigned variable length integer 表示

6.2 string literal
-------------------
+ 可以直接为 octet，也可以经过哈夫曼编码

  - 第一位表示是否使用了哈夫曼编码，1 表示使用了哈夫曼，0 表示未使用
  - 后面一个 7-bit 的数字，表示字符串长度
  - 再后面是具体内容

::

    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+---+
    | H |    String Length (7+)     |
    +---+---------------------------+
    |  String Data (Length octets)  |
    +-------------------------------+

+ 哈夫曼编码使用的频率是由本文档给出的
+ 最后不够 8-bit 的会进行填充



7 binary format
===================

7.1 indexed header field
--------------------------
+ indexed 就是该元素在 header table 中的位置

::

    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+---+
    | 1 |        Index (7+)         |
    +---+---------------------------+


+ 第一位是 1，后面是位置，使用 6.1 讲过的数字表示，7-bit prefix
+ 位置不能为 0

7.2 literal header field
---------------------------
+ 分为 header name 是 indexed name 和 new name 两种情况

7.2.1 with incremental indexing
```````````````````````````````````
+ 用于把 header field 加入 header table

::

    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+---+
    | 0 | 1 |      Index (6+)       |
    +---+---+-----------------------+
    | H |     Value Length (7+)     |
    +---+---------------------------+
    | Value String (Length octets)  |
    +-------------------------------+

::

    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+---+
    | 0 | 1 |           0           |
    +---+---+-----------------------+
    | H |     Name Length (7+)      |
    +---+---------------------------+
    |  Name String (Length octets)  |
    +---+---------------------------+
    | H |     Value Length (7+)     |
    +---+---------------------------+
    | Value String (Length octets)  |
    +-------------------------------+

+ 都使用 01 开头，上面是使用 indexed name，下面是 new name
+ indexed name 是个 6-bit prefix 的数字，new name 后面全为 0


7.2.2 without indexing
````````````````````````
+ 不把 header field 加入 header table

::

    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+---+
    | 0 | 0 | 0 | 0 |  Index (4+)   |
    +---+---+-----------------------+
    | H |     Value Length (7+)     |
    +---+---------------------------+
    | Value String (Length octets)  |
    +-------------------------------+

::

    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+---+
    | 0 | 0 | 0 | 0 |       0       |
    +---+---+-----------------------+
    | H |     Name Length (7+)      |
    +---+---------------------------+
    |  Name String (Length octets)  |
    +---+---------------------------+
    | H |     Value Length (7+)     |
    +---+---------------------------+
    | Value String (Length octets)  |
    +-------------------------------+

+ 使用 0000 开头，indexed name 是个 4-bit prefix 的数字


7.2.3 header field never indexed
``````````````````````````````````
+ 不把 header field 放入 header table

::

    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+---+
    | 0 | 0 | 0 | 1 |  Index (4+)   |
    +---+---+-----------------------+
    | H |     Value Length (7+)     |
    +---+---------------------------+
    | Value String (Length octets)  |
    +-------------------------------+

::

    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+---+
    | 0 | 0 | 0 | 1 |       0       |
    +---+---+-----------------------+
    | H |     Name Length (7+)      |
    +---+---------------------------+
    |  Name String (Length octets)  |
    +---+---------------------------+
    | H |     Value Length (7+)     |
    +---+---------------------------+
    | Value String (Length octets)  |
    +-------------------------------+

+ 使用 0001 开头，indexed name 是个 4-bit prefix 的数字
+ 内容上和 7.2.2 是等价的
+ 主要是为了避免对 field value 进行压缩（？）

7.3 update size
-------------------
+ 要修改 header table 大小的时候，要发送一个信号

::

    0   1   2   3   4   5   6   7
    +---+---+---+---+---+---+---+---+
    | 0 | 0 | 1 |   Max size (5+)   |
    +---+---------------------------+

+ 前面三位是 001，后面是大小，使用 6.1 讲过的数字表示，5-bit prefix
+ 数字不能大于 SETTINGS_HEADER_TABLE_SIZE
