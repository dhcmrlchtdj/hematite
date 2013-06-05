=====
 gdb
=====

break point
============

add breakpoint
---------------

.. code::

    (gdb) break
    (gdb) b [line]
    (gdb) b [function]
    (gdb) b [file:line]
    (gdb) b [file:function]
    (gdb) b [+offset]
    (gdb) b [-offset]
    (gdb) b [*address]


show breakpoint
----------------

.. code::

    (gdb) info breakpoints
    (gdb) i b


remove breakpoint
------------------

.. code::

    (gdb) i b

    (gdb) delete N
    (gdb) d 1

-------------------------------------------------------------------------------

execute
========

start
------

.. code::

    (gdb) run
    (gdb) r [arguments]

    (gdb) start     // add breakpoint at main


next step
----------

.. code::

    (gdb) step      // jump to function
    (gdb) s

    (gdb) next      // not jump
    (gdb) n


run to next breakpoint
-----------------------

.. code::

    (gdb) continue
    (gdb) c


run to line
------------

.. code::

    (gdb) until LINE
    (gdb) u 10


-------------------------------------------------------------------------------

frame
======

.. code::

    (gdb) info stack
    (gdb) i s
    (gdb) where
    (gdb) backtrace
    (gdb) bt

    (gdb) bt N
    (gdb) bt -N
    (gdb) bt full [[-]N]
    (gdb) bt full 10

-------------------------------------------------------------------------------

variable
=========

get
----

.. code::

    (gdb) info registers
    (gdb) i reg

    (gdb) print [name]
    (gdb) p $register_name
    (gdb) p variable_name

    (gdb) p/d   // signed
    (gdb) p/u   // unsigned
    (gdb) p/x   // hex
    (gdb) p/o   // oct
    (gdb) p/t   // bin
    (gdb) p/a   // address
    (gdb) p/f   // float
    (gdb) p/c   // char
    (gdb) p/s   // string
    (gdb) p/s a_string

    (gdb) x/NFU addr    // N=>length, F=>auxotafcsi, U=>bhwg
    (gdb) x/10i $pc    // print 10 assemble command

    (gdb) show values


set
----

.. code::

    (gdb) set variable key = value
    (gdb) set variable a_string = "hello world"

    (gdb) set $debug_string = "used to debug"

-------------------------------------------------------------------------------

history
========

.. code::

    (gdb) show history

    (gdb) p $           // last print value
    (gdb) p $$          // 2
    (gdb) p $n          // n
    (gdb) p $_          // last x address
    (gdb) p $__         // last x value
    (gdb) p $_exitcode  // exit code
    (gdb) p $bpnum      // last breakpoint number

-------------------------------------------------------------------------------

core file
==========

.. code::

    (gdb) generate-core-file
    (gdb) gcore

-------------------------------------------------------------------------------

attach
=======

.. code::

    $ pgrep progress_name
    pid

    $ gdb
    (gdb) attach pid

    (gdb) bt
    (gdb) i proc
