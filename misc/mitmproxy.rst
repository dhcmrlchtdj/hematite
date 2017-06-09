.. contents::


安装
======

::

    $ brew install mitmporxy

使用
=====

::

    $ mitmproxy --palette light -i '~q|~s' -s script.py

修改请求数据
==============

.. code:: python

    def request(ctx, flow):
        req = flow.request
        if req.host == 'baidu.com':
            req.host = 'google.com'
            req.headers['Host'] = ['google.com']

    def response(ctx, flow):
        res = flow.response
        # blah blah
