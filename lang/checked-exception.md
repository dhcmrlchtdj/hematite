# checked exception

---

要不要 checked exception 呢？
甚至，要不要异常呢？

借助 result 或 checked exception，通过静态检查确定所有分支都被处理。
这应该是非常实用的特性。
那么问题出在哪里呢？大型项目的特殊性？

---

https://www.artima.com/intv/handcuffs2.html

- version
    - function 新增 exception，就像 interface 新增 method
        - 实践中的做法，会增加新接口而不是直接修改旧接口
    - 这里的着眼点是兼容旧版，不管新增 method 还是创建新 interface，新代码都是要修改的
    - 即使不使用 checked exception，抛出新异常一样会导致旧代码出错，感觉兼容问题并没解决
        - 实践中，调用方只需要处理自己关心的异常，不能处理的继续上抛即可，上层会兜底或者退出程序
- scalable
    - 其实还是兼容性问题。系统包含多个子系统，新增异常所需进行的修改，工作量过大。

---

https://www.zhihu.com/question/30428214/answer/528317237
- 场景（比较接近底层的系统还能相对的设计出比较完备严谨的异常体系的，那么业务系统上这个干是严重吃力不讨好的
- 业务兜底（业务系统都会有个收底的错误处理，这个处理可能在业务系统的最高层
- 异常中立（大部分不需要认真处理的异常往上抛。当真的意识到某个问题是个值得仔细处理下时，可能才会专门为它仔细的设计Exception和相应的处理。

https://www.zhihu.com/question/60240474/answer/173856389
- 异常是与实现相关的，而不是接口
- 非汇报性的异常处理需要三个条件：一、知道宏观上在做什么事；二、知道出了什么错误；三、具备处理错误所需的资源

---

https://github.com/FrankHB/pl-docs/blob/master/zh-CN/cpp-exceptions.md
https://blog.csdn.net/pongba/article/details/1815742

- 异常中立（不抛出也不捕获异常（异常隐式地向上层调用者传递
