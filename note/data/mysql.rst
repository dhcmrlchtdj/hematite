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




pagination
=================

PPC 2009 efficient pagination using mysql

+ 避免 ``count(*)`` ，总数是不是必须的？
+ 缓存 ``count(*)`` ，34567 和 34589 的差异是不是很重要？
+ 不给跳页，只给前后页。避免 ``offset M`` ，依靠其他条件来筛选。

  前后页的时候，向数据库提供一个条件，
  比如 id，然后查找该 id 之前或之后 N 条数据。

  这样能保证即使数据更新了，用户看下一页的时候，数据和刚才看到的是连续的。
  不会因为新插入了 N 条数据导致用户看到的是刚刚看过的数据。

个人想法：能够保证顺序这点很棒，但是不能跳页是个很糟糕的体验。
为了能够跳页，即使看到之前的内容也是可以接受的。
另外复杂搜索条件要如何使用这种方法呢？
