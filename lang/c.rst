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






signal
=======

信号投递
---------
信号生成之后，首先被标记为进程的未决信号（pending），
然后才被真正投递（deliver）给进程。

如果进程屏蔽了这个信号，那么这个信号就只能当一辈子的未决信号了。
如果进程又不想屏蔽这个信号了，这个未决信号就会被重新投递给进程。

进程收到信号之后，就会执行相应的信号处理函数啦。



信号处理函数
-------------
可以使用 :code:`signal` 或者 :code:`sigaction` 定义信号处理函数。

信号处理函数中要修改的全局变量应该加上 :code:`volatile` 来修饰，
告诉编译器，这个变量可能被异步修改，避免编译器对变量进行特殊的优化。

要在信号处理函数中调用函数，应该保证这个函数是可重入的（reentrant）。

:code:`struct sigaction` 里面
既可以使用传统的 :code:`sa_handler(int)`
也可以使用 :code:`sa_sigaction(int, siginfo_t *, void *)` 接收一些额外信息。
实现上是个 union，要避免混用。



信号处理函数的执行
-------------------
如果程序正在执行一个信号处理函数时，又收到新信号，分两种情况。

如果两个信号是同类型的，那么，新信号会被标记为未决信号，
等到信号处理函数返回后，再进行处理。
也可以使用 :code:`sigprocmask` 来显式地改变这种行为。

如果前后信号是不同的，那么，新信号可以打断信号处理函数，执行新的信号处理函数。
在 :code:`struct sigaction` 中设置 :code:`sa_mask` ，
可以在执行信号处理函数时屏蔽相应信号，避免被打断。


如果信号处理函数打断了系统调用，通常系统调用失败并返回 :code:`EINTR` 。
可以在 :code:`sigaction` 里面设置 :code:`SA_RESTART` ，
让信号处理函数在返回后，重新执行系统调用。



信号的类型
-----------
信号分为标准信号（standard signals）和实时信号（real-time signals）。

两者的区别在于，实时信号可以视为队列而标准信号不能。

对于标准信号，
假如进程执行一个信号处理函数，并在执行过程中屏蔽了其他信号。
那么，进程收到新信号后，会将新信号标记为未决信号，
但是 **不会记录收到信号的顺序和次数** 。
在信号处理函数返回后，进程只是简单的依照未决信号的标记，处理这些信号。
这些信号被投递给进程的顺序与进程收到这些信号的顺序无关。
即使多次收到某种信号，最终也只投递一次。


实时信号记录了收到信号顺序和次数，并且可以携带数据，
见 :code:`man 2 sigqueue` 。
相应的，要获取这些数据，要使用 :code:`sa_sigaction` 来处理信号，
见 :code:`man 2 sigaction` 。

但是实时信号有数量上的限制，从 ``SIGRTMIN`` 到 ``SIGRTMAX`` 。


如果未决信号中有标准信号和实时信号，标准信号会先处理。
