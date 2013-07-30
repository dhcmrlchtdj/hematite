折行
=====
使用 ``\`` 来折行。

.. code::

    $ ls \
    > -a


变量作用域
===========
默认是全局变量，也可以声明为局部变量。

.. code:: bash

    global1=1 # 全局变量

    func() {
        global2=2 # 全局变量
        local local1=1 # 局部变量
        declare local2=2 # 局部变量
    }




修改环境变量
=============

.. code:: bash

    $ cat example.sh
    #!/usr/bin/env bash
    var=10
    export var

    $ chmod u+x example.sh
    $ ./example.sh
    $ echo $var
    (nil)

    $ . ./example.sh
    $ echo $var
    10

    $ source example.sh
    $ echo $var
    10

直接执行脚本，会把变量导出到一个新的 shell 中。
要修改当前的环境变量，要使用 ``source`` 或者 ``.`` ，
都是 shell 的内置命令，用来在当前的 shell 之执行脚本的内容。
