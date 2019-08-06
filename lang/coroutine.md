# coroutine

https://www.quora.com/Why-is-it-that-with-a-stackless-coroutine-only-the-top-level-routine-may-be-suspended
https://www.zhihu.com/question/65647171/answer/233495694

这两篇文章之前都看过，但是没怎么看明白。今天好像突然有点明白了。

> stackless coroutine passes control up
> stackful coroutine passes control down

> 1）从当前函数返回
> 2）调用一个新的函数

这里讲的 control 和 离开函数，其实是一回事。
返回一个 future 对象，控制权自然交给了调用方。
而调用一个新函数，控制权自然交给了新调用的函数。
