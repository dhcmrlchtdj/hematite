=======
 mysql
=======

.. code::

    > ? show

-------------------------------------------------------------------------------

client timeout
===============

mysql 默认会在客户端空闲 8 小时后断开连接。

.. code::

    > show variables like "%timeout";
    +---------------------+-------+
    | variable_name       | value |
    +---------------------+-------+
    | interactive_timeout | 28800 |
    | wait_timeout        | 28800 |
    +---------------------+-------+


其中，
``interactive_timeout`` 用于交互式连接，
``wait_timeout`` 用于非交互式连接。


可以用如下命令修改等待时间。

.. code::

    > set global wait_timeout=1;
    > set global interactive_timeout=1;


可以用如下命令查看当前有哪些连接。

.. code::

    > show full processlist;
