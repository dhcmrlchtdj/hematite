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
