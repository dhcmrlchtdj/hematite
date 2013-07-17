create static/shared library
=============================

+ http://www.tldp.org/HOWTO/Program-Library-HOWTO
+ http://www.adp-gmbh.ch/cpp/gcc/create_lib.html

static
-------

.. code::

    # compile
    $ gcc -c sample.c -o sample.o

    # create static library
    $ ar rsc libsample.a sample.o

    # link
    $ gcc -static main.c -L. -lsample -o statically_linked


shared
-------

.. code::

    # compile
    $ gcc -fPIC -c sample.c -o sample.o

    # create shared library
    $ gcc -shared -Wl,-soname,libsample.so -o libsample.so sample.o

    # link
    $ gcc main.c -L. -lsample -o dynamically_linked

    # add directory to path
    $ export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
    $ ./dynamically_linked





kernel io buffer
=================

内核中维护有缓存，系统调用 :code:`write` 也不是在直接读写硬盘。

所以调用 write(fd, 1-byte, 1) 1000 次和调用 write(fd, 1000-byte, 1) 1 次，
内核对硬盘的读写操作是可能是相同的。

但是，系统调用 write 还是会有开销，所以调用一次的情况下，性能还是要更好些。






sparse file
============

使用 :code:`lseek` 写入时，如果超出了文件大小，就会产生空洞（file hole），
这样的文件被叫做稀疏文件（sparse file）。

如果要避免产生空洞，或者说要确保硬盘空间足够，
可以使用 :code:`fallocate` 来给文件分配空间，这样就不会产生空洞了。
