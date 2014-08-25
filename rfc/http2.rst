HTTP2 lastest draft (2014.08.12)


.. contents::


4 HTTP Frames
===============

+ 连接建立后，交换的信息称为 frame。


4.1 frame format
------------------
+ frame header 的长度为 9-octet，payload 的长度不定
+ 不过，按图上看，实际占用了 12-octet 啊

::

    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |                 Length (24)                   |
    +---------------+---------------+---------------+
    |   Type (8)    |   Flags (8)   |
    +-+-+-----------+---------------+-------------------------------+
    |R|                 Stream Identifier (31)                      |
    +=+=============================================================+
    |                   Frame Payload (0...)                      ...
    +---------------------------------------------------------------+

+ 开头是 payload 的长度，虽然长度为 24-bit，但是默认不允许超过 2^14。
  接受方可以调整 SETTINGS_MAX_FRAME_SIZE 允许长度大于 16384。
+ type 是该 frame 的类型
+ flags 的语义取决于类型
+ r 是保留字段，目前没有语义，值必须为 0
+ identifier
+ payload 的结构和语义都取决于具体类型

4.2 frame size
---------------
+ payload 的大小由 SETTINGS_MAX_FRAME_SIZE 来决定
+ 取值范围为 [2^14, 2^24-1]，闭区间，单位为 octet

4.3 header compression/decompression
--------------------------------------
+ header 在发送前会被序列化成一个 header block
+ 序列化算法为 HPACK
+ header block 又会被划分成 header block fragment
+ header block fragemt 会放在 frame payload 中，
  相关的 frame 有 HEADERS/PUSH_PROMISE/CONTINUATION
+ 在满足下面任一条件时，可以认为收到了一个完整的 header block

  - flag 中设置了 END_HEADERS 的 HEADERS/PUSH_PROMISE
  - HEADERS/PUSH_PROMISE，然后后面跟着 CONTINUATION，
    最后一个 CONTINUATION 的 flag 设置了 END_HEADERS



5 stream and multiplexing
===========================
+ stream 是 frame 的序列
+ 一个 HTTP/2 连接可以同时包含多个 stream
+ stream 可以是单向的，也可以是双向的
+ 连接双方都有权关闭一个 stream
+ 在一个 stream 中，frame 的顺序很重要
+ 不同的 stream 使用不同的数字进行区分，
  就是 stream header 最后的那个 stream identifier
+ stream identifier 由发起 stream 的那方决定


5.1 stream state
-------------------
+ idle

  - 初始状态
  - 发送或者收到一个 HEADERS frame 的时候，进入 open 状态
  - 发送 PUSH_PROMISE 后，进入 reserved(local) 状态
  - 收到 PUSH_PROMISE 后，进入 reserved(remote) 状态
  - 收到其他 frame 都视为错误

+ reserved(local)

  - 发送 HEADERS 后，进入 half closed(remote) 状态
  - 发送 RST_STREAM 后，进入 closed 状态
  - 只允许发送上述两种 frame
  - 收到 RST_STREAM/PRIORITY 之外的 frame 视为错误

+ reserved(remote)

  - 收到 HEADERS 进入 half closed(local)
  - 发送或收到 RST_STREAM 进入 closed
  - 发送 PRIORITY 改变优先级
  - 收到 HEADERS/RST_STREAM 之外的 frame 视为错误

+ open

  - 连接双方都可以发送任意类型的 frame
  - 发送 END_STREAM 进入 half closed(local)
  - 接收 END_STREAM 进入 half closed(remote)
  - 发送 RST_STREAM 进入 closed

+ half closed(locle)

  - 不能发送数据
  - 只能发送 WINDOW_UPDATE/PRIORITY/RST_STREAM
  - 当收到的 frame 中设置了 END_STREAM，会进入 closed 状态
  - 发送或接收 RST_STREAM 也会进入 closed 状态
  - 允许忽略对方发送的 WINDOW_UPDATE

+ half closed(remote)

  - 不应该继续发送数据，因为双方都没有义务维护这个 stream 了
  - 收到 WINDOW_UPDATE/PRIORITY/RST_STREAM 之外的 frame 视为错误
  - 可以发送任意 frame
  - 发送设置了 END_STREAM 的 frame 或 RST_STREAM 会进入 closed 状态

+ closed

  - 只能发送 PRIORITY 这一种 frame
  - 收到 PRIORITY 以外的 frame 视为错误


5.1.1 stream identifier
`````````````````````````````
+ 是个 31-bit 的非负整数
+ 客户端初始化 stream 时，必须使用奇数，服务端必须使用偶数
+ 标识符 0 被用于控制连接
+ stream 是递增的，不能小于任何一个连接过的 stream
+ 标识符不可重用，如果达到最大值了，必须建立新连接
+ 服务端无法主动发起连接，应该发送一个 GOAWAY frame，让客户端发起新连接
+ 建立一个新的 stream 时，如果存在标识符小于新标识符的空闲 stream，
  会把这些 stream 关闭掉
+ 收到新的 stream 时，同样要关闭掉空闲 stream
+ 将 HTTP/1.1 升级为 HTTP/2 时，服务器返回的标识符为 1

5.1.2 stream concurrency
``````````````````````````
+ 可以通过 SETTINGS_MAX_CONCURRENT_STREAMS 来限制 stream 的并发数
+ 这个只是限制接受到该信息的那方
+ 并发连接，只计算处于 open/half-closed 状态的 stream


5.2 flow control
-------------------
+ 使用 WINDOW_UPDATE frame 进行流控制


5.3 stream priority
----------------------
+ 可以在 HEADERS 中初始化优先级
+ 也可以在 PRIORITY 中修改优先级


5.4 error handling
-------------------
+ 错误分为两类：connection error 和 stream error

5.4.1 connection error handling
`````````````````````````````````
+ 出现 connection error 的时候，应该发送一个 GOAWAY frame，
  使用的 stream 是最后一次收到 frame 的那个 stream
+ GOAWAY 描述错误原因
+ 发送了 GOAWAY 后，必须关闭 TCP 连接
+ 任何时候，想要断开连接，都应该发送一个 GOAWAY
+ GOAWAY 这东西，丢了就丢了，可以不管

5.4.2 stream error handling
``````````````````````````````
+ 出现 stream error 的时候，应该发送一个 RST_STREAM frame，
  使用出错的那个 stream
+ 一样在 RST_STREAM 这描述错误类型



6 frame definitions
====================
+ 前面讲过 frame 的结构，使用一个 8-bit 来标识类型

6.1 DATA
----------
+ type = 0x0
+ 用来传输任意长度的数据，比如 HTTP 的 payload
+ 必须与某个 stream 关联，如果 stream identifier 为 0x0，视为错误
+ DATA 允许携带在数据后面携带 padding，主要是出于安全考虑

6.2 HEADERS
------------
+ type = 0x1
+ 用于开启 stream，同时携带 header block fragment
+ 必须与某个 stream 关联，如果 stream identifier 为 0x0，视为错误

6.3 PRIORITY
--------------
+ type = 0x2
+ 可以在任意状态下发送该 frame
+ 用于改变当前 stream 的优先级
+ 权重是个 8-bit 数字，1~256
+ 必须与某个 stream 关联，如果 stream identifier 为 0x0，视为错误

7 error codes
===============
+ 罗列了 RST_STREAM 和 GOAWAY 中的错误类型，不摘抄了
+ 对于未知的错误类型，不允许进行任何处理，或者视为 INTERNAL_ERROR(0x2)

8 HTTP message exchanges
=========================
+ HTTP/2 只修改了 HTTP/1.1 的一部分，具体讲是 RFC7230

8.1 HTTP request/response exchanges
-------------------------------------
+ client 开启一个新的 stream 并发送 request。
+ server 使用该 stream 返回 response。
+ request/response 的结构如下

  0. 针对 response，可以返回零到多个的 HEADERS，但返回值必须是 1xx
  1. 首先是一个 HEADERS，用于传输 http header
  2. 然后是零到多个的 DATA，用于传输 http payload
  3. 最后可能有一个 HEADERS，用于传输 trailer-part
  4. 上面提到 HEADERS 的地方，后面都允许有 CONTINUATION

+ 最后一个 frame 必须设置 END_STREAM flag
+ 由于 CONTINUATION 是没有 flag 的，所以由 HEADERS 来携带那个 END_STREAM flag。
  也就是说，即使 HEADERS 设置了 END_STREAM，后面还是可能有 CONTINUATION 在传输
+ 过程中的状态变化如下

  - client HEADERS ==> client open ~ server open
  - client END_STREAM ==> client half closed (local) ~ server half closed (remote)
  - server END_STREAM ==> client closed ~ server closed

8.1.1 upgrading from HTTP/2
``````````````````````````````
+ HTTP/2 不支持 status code 101 (Switching Protocols)

8.1.2 HTTP header fields
``````````````````````````````

8.1.2.1 pseudo-header fields
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ HTTP/2 没有 start-line，而是使用 pseudo-header
+ 不允许自定义 pseudo-header，只能用文档规定的几个
+ pseudo-header 使用 ``:`` 开头

8.1.2.3 request pseudo-header fields
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ :method
+ :scheme 允许 http/https 之外的协议
+ :authority
+ :path 使用 http/https 协议时不能为空
+ 没有 HTTP/1.1 之类的版本信息

8.1.2.4 response pseudo-header fields
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ :status 就只有这个



8.2 server push
------------------
+ 可以设置 SETTINGS_ENABLE_PUSH 为 0 来禁用 server push
+ 中间人在收到服务器的 push 请求时，可以不发给客户端
+ 服务器只能 push 可缓存的 response
+ push 的方法只能是安全方法（常用的只有 GET），并且不能携带 request body


8.2.1 push requests
``````````````````````
+ server push 就是服务器发出的 request，放在 PUSH_PROMISE 中
+ 使用的是 PUSH_PROMISE frame
+ 
