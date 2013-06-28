compile pthread programs
=========================

programs use Pthreads API must be compiled with ``-pthread`` options.

it will

+ define ``_REENTRANT`` macro.
+ link `libpthread` library (what ``-lpthread`` do).




thread-local storage
=====================

thread-local storage provides persistent per-thread storage.

和 thread-specific 类似，用起来更简单些。

注意下这个是拓展实现，不是标准定义的。

.. code:: c

    #include <stdio.h>
    #include <stdlib.h>
    #include <pthread.h>

    #define MAX_ERROR_LEN 256

    static __thread char buf[MAX_ERROR_LEN]; //  thread-local buffer

    char *strerror_tl(int err) {
        if (err < 0 || err >= _sys_nerr || _sys_errlist[err] == NULL) {
            snprintf(buf, MAX_ERROR_LEN, "Unknown error %d.", err);
        } else {
            strncpy(buf, _sys_errlist[err], MAX_ERROR_LEN - 1);
            buf[MAX_ERROR_LEN - 1] = '\0';
        }
        return buf;
    }

上面的代码里面， ``__thread`` 是个关键字，让每个线程持有一个独立的 ``buf`` 。
会在线程结束的时候自动释放掉。

**注意** ： ``__thread`` 必须 **直接** 跟在 ``static`` 或 ``extern`` 后面。





