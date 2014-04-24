.. contents::


http://en.wikipedia.org/wiki/Distributed_hash_table
http://en.wikipedia.org/wiki/Kademlia
http://en.wikipedia.org/wiki/Mainline_DHT
http://en.wikipedia.org/wiki/BitTorrent_tracker

https://wiki.theory.org/BitTorrentSpecification
http://www.bittorrent.org/beps/bep_0005.html

概念
=====

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
======

krpc 是一种 RPC 机制，使用 UDP 来传送数据，数据用 bencode 进行编码。
（是因为决定用 krpc 的时候没有 JSON 吗？）

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
====

DHT 使用 krpc，有 4 种 query：
``ping`` ， ``find_node`` ， ``get_peers`` ， ``announce_peer`` 。

ping
-----

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
-------------

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
-----------

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
---------------

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
