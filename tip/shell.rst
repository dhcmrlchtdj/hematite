trim space
===========

.. code::

    var=" test  ";
    echo ${var// };




替换
=====

.. code::

    $ for i in *; do echo ${i/old/new}; done






查找命令
=========

有这么几个命令，平时也没注意区别。

type
-----

用来查看命令的类型，是个函数。

.. code::

    $ type type
    type is a shell builtin

    $ type ls
    ls is an alias for ls --color=auto --group-directories-first -vF


where
------

也是个函数，会列出 ``$PATH`` 下所有符合的命令。

.. code::

    $ type where
    where is a shell builtin
    $ where where
    where: shell built-in command

    $ where ls
    ls: aliased to ls --color=auto --group-directories-first -vF
    /usr/bin/ls



which
------

用 ``where`` 会发现有个函数叫 ``which`` ，有个命令也叫 ``which`` 。

可以看 ``man 1 which`` ，
函数 ``which`` 是对 ``/usr/bin/which`` 的一个包装。

功能是列出 ``$PATH`` 下第一个符合名字的命令。

使用 ``which -a`` 可以列出所有命令，和 ``where`` 一样。
大概 ``where`` 也是对 ``/usr/bin/which`` 的包装吧。

.. code::

    $ where which
    which: shell built-in command
    /usr/bin/which

    $ type which
    which is a shell builtin

    $ which ls
    ls: aliased to ls --color=auto --group-directories-first -vF

    $ which -a ls
    ls: aliased to ls --color=auto --group-directories-first -vF
    /usr/bin/ls



whence
-------

whence 也是个函数。
可以查看一个命令实际上执行了什么，是个函数还是别名还是程序。
也可以模拟上面三个命令。

.. code::

    $ type whence
    whence is a shell builtin

    $ whence whence # function
    whence

    $ whence mkdir # command
    /usr/bin/mkdir

    $ whence ls # alias
    ls --color=auto --group-directories-first -vF

    $ whence -v ls # type
    ls is an alias for ls --color=auto --group-directories-first -vF

    $ whence -c ls # which
    ls: aliased to ls --color=auto --group-directories-first -vF

    $ whence -ca ls # where, which -a
    ls: aliased to ls --color=auto --group-directories-first -vF/usr
    /bin/ls


whereis
--------

会列出所有符合名字的二进制文件、源码、帮助文件。看 ``man 1 whereis`` 吧。

.. code::

    $ type whereis
    whereis is /usr/bin/whereis

    $ whereis ls
    ls: /usr/bin/ls /usr/share/man/man1/ls.1p.gz /usr/share/man/man1/ls.1.gz








输出到其他终端
===============
::

    $ w
    # 可以看到几个不同的 TTY
    $ echo 'message' > /dev/pts/0

通过重定向，可以输出到其他终端。
