======
 cron
======

basic control
==============

.. code::

    # list crontab
    $ crontab -l

    # edit crontab
    $ crontab -e

    # edit other's crontab
    $ crontab -u username -l


crontab time
=============

.. code::

    # <minute>  <hour>  <day_of_month>  <month>         <day_of_week>       <command>
    # 00-59     00-23   01-31 ? L W     01-12 jan-dec   0-6 sun-sat ? L #
    # command can be any shell command, even a script

    # * / , - are supported by all


+-----------------------+--------------------+
| type                  | command            |
+=======================+====================+
| at startup            | @reboot            |
+-----------------------+--------------------+
| once a year           | @yearly            |
|                       | @annually          |
|                       | 0 0 1 1 *          |
+-----------------------+--------------------+
| once a month          | @monthly           |
|                       | 0 0 1 * *          |
+-----------------------+--------------------+
| once a week           | @weekly            |
|                       | 0 0 * * 0          |
+-----------------------+--------------------+
| once a day            | @daily             |
|                       | @midnight          |
|                       | 0 0 * * *          |
+-----------------------+--------------------+
| once an hour          | @hourly            |
|                       | 0 * * * *          |
+-----------------------+--------------------+
| every minute          | `*`/1 * * * *      |
+-----------------------+--------------------+
| every hour            | * `*`/1 * * *      |
+-----------------------+--------------------+
| every day             | * * `*`/1 * *      |
+-----------------------+--------------------+
| every week            | * * `*`/7 * *      |
+-----------------------+--------------------+
| every month           | * * * `*`/1 *      |
+-----------------------+--------------------+
| every year            | * * * `*`/12 *     |
+-----------------------+--------------------+
| every year and a half | * * `*`/6 `*`/12 * |
+-----------------------+--------------------+


example
========

.. code::

    01 * * * * /bin/echo "hello world!"
    # echo "hello world!" on **first minute** (xx:01)
    # of every hour of every day of every month

    DAY = `date +"%F"`
    @daily bsdtar cvaf ~/backup/${DAY}.txz ~
    # backup ~ directory every day

    *0,*5 9-16 * 1-5,9-12 1-5 /bin/echo "crazy"
    # at 5 minute intervals (00, 05, 10, 15 ...)
    # from 9:00 AM to 4:55 PM
    # on monday to friday
    # except during June, July, August

    */5 * * jan mon-fri /bin/echo "well"
    # every 5 minutes
    # on monday to friday
    # during January


special character
==================

asterisk *
    wildcard. every minute/hour/day/month/week.

slash /
    specify increments.

cmmma ,
    special additional values.

hyphen -
    special ranges.

question mark ?
    wildcard. whatever day/week it is.

L
    stands for last.
    in day_of_month, L means the last day of the month.
    in day_of_week, L means 7.
    in day_of_week and follows a value, means the last xxx day of the month.
    example: :code:`6L` in day_of_week means the last friday of the month.

W
    stands for weekday.
    specify the weekday (mon-fri) nearest the given day.
    example: :code:`LW` means last weekday of the month.

hash #
    special the nth xxx day of the month.
    must be follow by number between 1 and 5.
    example: :code:`0#1` means first sunday of the month.

percent %
    used in command. canbe escaped with backslash(\).
    will be changed into newline.
