# js codebase structure

---

https://facebook.github.io/react/contributing/codebase-overview.html#shared-code

---

如何组织比较大的项目，一直是个难题。
毕竟每个人对如何取舍都有自己的想法、偏好。

react 这个方法，vue 也在用
虽然我感觉很丑……但是易懂、可行，
有 react/vue 这样的项目在用，尝试说服他人时会比较方便

---

> ... need to share functionality between two groups of modules.
> ... hoist the shared module up to a folder called **shared**
> inside the closest common ancestor folder of the modules that
> need to rely on it

需要共享的文件，提到共同祖先上，创建一个叫 shared 的目录
