.. contents::

+ https://wiki.theory.org/BitTorrentSpecification

torrent & magnet
===================

+ http://en.wikipedia.org/wiki/Torrent_file
+ http://en.wikipedia.org/wiki/Magnet_URI_scheme
+ http://bittorrent.org/beps/bep_0009.html


torrent
---------

一个 torrent 就是个二进制文件。里面的信息使用 bencode 编码过的哈希表。

有几种情况

+ 带服务器/带多个服务器/不带服务器（使用 DHT)。
+ 单文件/多文件

::

    {
        "info": {}, # 下面单独讲
        # announce 和 nodes 选一个
        "announce": "tracker", # tracker 地址
        "announce-list: [ ["tracker1", "tracker2"], ["backup"], ... ], # 多 tracker
        "nodes": [ ["host", "port"], ... ], # DHT
        # 以下可选
        "encoding": "utf-8?", # info["pieces"] 使用的编码
        "created by": "name-version", # 客户端版本
        "creation date": <timestamp>, # 创建日期
        "comment": ""
    }

    "info": {
        "piece length": <bytes>,
        "pieces": "SHA1SHA1SHA1...", # 20-byte 的 SHA1 值直接相连
        "private": 1, # 可选，是否启用 PT，开启（1）后只能通过 tracker 交换用户
        # 单文件
        "name": "name",
        "length": <bytes>,
        "md5sum": "32 hex string", # 可选，md5 编码
        # 多文件
        "name": "path", # 文件路径
        "md5sum": "", # 没用，兼容
        "files": [
            # 注意路径的书写，自身是不带分割符的
            {"path": ["x", "y", "z", "name"], "length": <bytes>},
            {"path": ["name"], "length": <bytes>},
            ...
        ]
    }


magnet
--------


magnet 相对一个 torrent 缺失的部分称为 metadata。
其实就是 info 部分啦。

magnet 和 HTTP 的查询字符串使用相同的编码方式。
组成大概是下面这样

::

    magnet:?
        xt=urn:btih:<info-hash> &
        dn=<name> &
        tr=<tracker-url> &tr=<url>&tr=<url>

    dn = display name = 下载 torrent 前显示的名字。可选
    tr = tracker = tracker 地址，可以有多个。

    xt = exact topic = urn。
    把 torrent 的 info 进行 hex 编码的到的。长度为 40 个字符。
    为了兼容以往的链接，要支持使用 base32 编码的情况，长度为 32 个字符。








DHT
=====

+ http://en.wikipedia.org/wiki/Distributed_hash_table
+ http://en.wikipedia.org/wiki/Kademlia
+ http://en.wikipedia.org/wiki/Mainline_DHT
+ http://en.wikipedia.org/wiki/BitTorrent_tracker

+ http://www.bittorrent.org/beps/bep_0005.html


概念
-----

发现自己之前写的东西连概念都没弄清楚。

+ DHT 是一种去中心化的分布式系统，类似于散列表。
+ Kademlia 是一种用于点对点连接的 DHT。
+ Mainline_DHT 是目前 BT 使用的 DHT，基于 Kademlia。

下面提到 DHT 都是在讲 Mainline_DHT。

在 DHT 之前，BT 下载需要一个服务器（tracker），通过服务器获得 peer 的信息。
有了 DHT 之后，可以直接在其他 peer 那里交换信息，不需要通过服务器。
想法是挺好，不过 DHT 在启动的时候，还是需要连上一个 tracker 或者 peer，
才能开始获取其他 peer。


peer 是实现了 BT 协议的客户端/服务器，使用 TCP 通信。
node 是实现了 DHT 协议的客户端/服务器，使用 UDP 通信。



KRPC
-----

krpc 是一种 RPC 机制，使用 UDP 来传送数据，数据用 bencode 进行编码。

krpc 传送的数据只有 3 种类型： ``query`` ， ``response`` ， ``error`` 。

传送的时候，使用 ``krpc["t"]`` 区分数据来源（transaction ID），
里面存储 2 个字母（char），更准确地说，是 16-bit 。
数据类型用 ``krpc["y"] = "q|r|e"`` 表示。

query 使用 ``krpc["q"]`` 表示查询的类型，
``krpc["a"] = {}`` 表示查询的参数。

response 使用 ``kprc["r"] = {}`` 表示返回的数据。

error 使用 ``kprc["e"] = [code, "desc"]`` 表示错误信息。

错误有

+------+-----------------------------------------------------------------------------+
| code | description                                                                 |
+======+=============================================================================+
| 201  | Generic Error                                                               |
+------+-----------------------------------------------------------------------------+
| 202  | Server Error                                                                |
+------+-----------------------------------------------------------------------------+
| 203  | Protocol Error, such as a malformed packet, invalid arguments, or bad token |
+------+-----------------------------------------------------------------------------+
| 204  | Method Unknown                                                              |
+------+-----------------------------------------------------------------------------+

peer 的信息被编码成了 6-byte 的字符串，4 位是 IP，剩下 2 位是端口。
node 的信息被编码成了 26-byte 的字符串，20 位是 node 的 ID，
剩下 6 位是 peer 的信息。


DHT
--------

DHT 使用 krpc，有 4 种 query：
``ping`` ， ``find_node`` ， ``get_peers`` ， ``announce_peer`` 。

ping
`````````

判断死活的东西，互相传送 node ID。

::

    arguments: {"id": "<query node id>"}
    response: {"id": "<response node id>"}

    Query = {
        "t": "aa",
        "y": "q",
        "q": "ping",
        "a": {
            "id": "abcdefghij0123456789"
        }
    }
    Response = {
        "t": "aa",
        "y": "r",
        "r": {
            "id": "mnopqrstuvwxyz123456"
        }
    }



find_node
````````````

用来寻找某个 node。
收到该请求后，返回自己路由表中，与目标 node 距离最近的 8 个 node。

::

    arguments: {"id": "<query node id>", "target": "<target node id>"}
    response: {"id": "<response node is>", "nodes": "<node info>"}

    Query = {
        "t": "aa",
        "y": "q",
        "q": "find_node",
        "a": {
            "id": "abcdefghij0123456789",
            "target": "mnopqrstuvwxyz123456"
        }
    }
    Response = {
        "t": "aa",
        "y": "r",
        "r": {
            "id": "0123456789abcdefghij",
            "nodes": "def456..."
        }
    }


get_peers
````````````

查找拥有 torrent 的 peer。
所以查询的参数包括 torrent 的 infohash。

如果被查询的 node 知道 peer 的信息，返回信息。
如果不知道，返回最接近的几个 node 的信息。
返回的时候，还会带有一个 token，这个是 announce_peer 用的。

::

    arguments: {"id": "<query node id>", "info_hash": "<torrent hash info>"}
    # 知道 peer 的情况
    response with peers: {
        "id": "<response node id>",
        "token": "<opaque token>",
        "values": ["<peer 1 info string>", "<peer 2 info string>"]
    }
    # 不知道 peer 的情况
    response with nodes: {
        "id": "<response node id>",
        "token": "<opaque token>",
        "nodes": "<node info>"
    }

    Query = {
        "t":"aa",
        "y":"q",
        "q":"get_peers",
        "a": {
            "id":"abcdefghij0123456789",
            "info_hash":"mnopqrstuvwxyz123456"
        }
    }
    Response with peers = {
        "t":"aa",
        "y":"r",
        "r": {
            "id":"abcdefghij0123456789",
            "token":"aoeusnth",
            "values": ["axje.u", "idhtnm"]
        }
    }
    Response with nodes = {
        "t":"aa",
        "y":"r",
        "r": {
            "id":"abcdefghij0123456789",
            "token":"aoeusnth",
            "nodes": "def456..."
        }
    }


announce_peer
````````````````

表示自己在下载某个 torrent。

发送自己的 node id，torrent 的 info hash，
自己下载使用的端口，以及之前 get_peers 收到的 token。

还有一个 implied_port，这个值非 0 表示之前的 port 字段无效。
应该使用 node 的 UDP 端口代替。

::

    arguments: {
        "id" : "<query node id>",
        "info_hash": "<torrent hash info>",
        "port": <port number>,
        "token": "<opaque token>"
        "implied_port": <0 or 1>,
    }
    response: {"id": "<response node id>"}

    Query = {
        "t":"aa",
        "y":"q",
        "q":"announce_peer",
        "a": {
            "id":"abcdefghij0123456789",
            "implied_port": 1,
            "info_hash":"mnopqrstuvwxyz123456",
            "port": 6881,
            "token": "aoeusnth"
        }
    }
    Response = {
        "t":"aa",
        "y":"r",
        "r": {
            "id":"mnopqrstuvwxyz123456"
        }
    }



routing table
``````````````````

node 会维护一张路由表，里面存储着其他 node 的信息。

路由表里的节点是有优先级的。
15 分钟内有交流的节点算是正常节点，15 分钟内没交流的节点视为问题节点。
所谓交流，可以是对方响应请求，也可以是对方发起请求。

node ID 是 sha1 编码的，sha1 有 160-bit，所以 ID 有 2^160 种可能。

路由表在结构上，划分成了一个个格子（bucket），
每个格子都可是当作一个长度为 8 的数组。
在一个格子被装满后，会添加一个新的格子。
（感觉有点不对劲啊。）

要下载的时候，先取出 torrent 的 info_hash，去路由表中寻找距离最近的 node。
如果对方知道哪些 node 在下载该 torrent，对方会返回相应节点的信息。
如果对方不知道，那么返回的是距离接近的几个节点的信息。
