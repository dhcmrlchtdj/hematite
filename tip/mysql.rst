.. contents::


重置密码
=========

+ https://wiki.archlinux.org/index.php/MySQL#Reset_the_root_password
+ https://dev.mysql.com/doc/refman/5.7/en/resetting-permissions.html#resetting-permissions-generic

::

    $ # 停止服务
    $ systemctl stop mysqld

    $ # 无需密码 禁用远程连接
    $ mysqld_safe --skip-grant-tables --skip-networking

    $ # 登录修改密码
    $ mysql -uroot mysql
    mysql> UPDATE mysql.user SET Password=PASSWORD('MyNewPass') WHERE User='root';
    mysql> FLUSH PRIVILEGES;
    mysql> exit;




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





sql mode
=========

查看、修改使用的 sql mode

.. code::

    > SELECT @@sql_mode;
    > SELECT @@GLOBAL.sql_mode;
    > SELECT @@SESSION.sql_mode;
    > SET GLOBAL sql_mode='modes'; -- need super privilege
    > SET SESSION sql_mode='modes';

常见的几个 sql mode

ANSI
    更改语法和行为，使之符合标准 SQL。

STRICT_TRANS_TABLE
    不能插入就放弃该语句。

TRADITIONAL
    插入的值不正确时，给出错误而不是警告。

对于 InnoDB，还要考虑 ``innodb_strict_mode`` 。
