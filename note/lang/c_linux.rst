compile pthread programs
=========================

programs use Pthreads API must be compiled with ``-pthread`` options.

it will

+ define ``_REENTRANT`` macro.
+ link `libpthread` library (what ``-lpthread`` do).




thread-local storage
=====================

thread-local storage provides persistent per-thread storage.

在 *The Linux Programming Interface* 上看到的。
和 thread-specific（ ``man 3 pthread_setspecific`` ）类似，用起来更简单些。

这是个 gcc 的拓展，详细内容可以查阅
http://gcc.gnu.org/onlinedocs/gcc-4.8.1/gcc/Thread_002dLocal.html

.. code:: c

    #include <stdio.h>
    #include <stdlib.h>
    #include <pthread.h>

    #define MAX_ERROR_LEN 256

    static __thread char buf[MAX_ERROR_LEN]; //  thread-local buffer

    char *strerror_tls(int err) {
        if (err < 0 || err >= _sys_nerr || _sys_errlist[err] == NULL) {
            snprintf(buf, MAX_ERROR_LEN, "Unknown error %d.", err);
        } else {
            strncpy(buf, _sys_errlist[err], MAX_ERROR_LEN - 1);
            buf[MAX_ERROR_LEN - 1] = '\0';
        }
        return buf;
    }

上面的代码里面， ``__thread`` 关键字让每个线程持有一个独立的 ``buf`` 。
并在线程结束的时候自动释放掉。

.. code:: c

    __thread int a;
    static __thread int b;
    extern __thread int c;

**注意** ：只能用上面这三种方式方式进行声明，
只允许使用 ``static`` 和 ``extern`` 这两种标识符（storage class specifier），
而且必须紧跟在标识符后面。

另外，c11 倒是有个新的标识符 ``_Thread_local`` ，好像 llvm 支持了，
可以看 http://clang.llvm.org/docs/LanguageExtensions.html#c11-thread-local





查看使用的 pthread 版本
========================

.. code::

    $ $(ldd /bin/ls | grep libc.so | awk '{print $3}')





backlog
========

就是 ``listen`` 的第二个参数啦，可以看 ``man 2 listen`` 。

可以直接使用 ``sys/socket.h`` 里面定义的常量 ``SOMAXCONN`` 。
这个值由 ``/proc/sys/net/core/somaxconn`` 决定，同时也是可使用的最大值。
