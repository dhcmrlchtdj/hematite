# codebase

---

http://cacm.acm.org/magazines/2016/7/204032-why-google-stores-billions-of-lines-of-code-in-a-single-repository/fulltext
https://medium.com/@aboodman/in-march-2011-i-drafted-an-article-explaining-how-the-team-responsible-for-google-chrome-ships-c479ba623a1b

---

- google 的大部分代码都在一个仓库里集中管理
- 其代码控制系统是自己维护的
- trunk-based development

---

- 数据存储在 piper，同步使用了 paxos 算法，有大量缓存和异步操作
- 在 piper 之前，使用的是 perforce
- 支持文件级别的权限控制，读写操作都有日志记录
- 工程师通过 CitC (Clients in the Cloud) 这个 FUSE 来查看、操作代码
- CitC 会将所有操作都同步到服务端
- piper 也可以单独使用，不过大部分人都使用 CitC

---

- 一个主线分支，mainline(trunk)
- 所有修改都是单线、有序的
- 分支更多是用于发布代码，而不是开发功能
- 使用 trunk-based development 能避免出现复杂的代码冲突
- 各种问题修复也是先在 mainline 上完成，然后 cherry-pick 到发布分支去
- 开发新功能带来的新旧代码，使用 conditional flags 来控制

---

- 几乎所有代码都会经过 review
- 自动化的测试、构建、回滚
- 大量辅助用的工具

---

- google 从 CVS 向 Perforce 迁移的适合，选择了现在这种单一仓库的开发方式
- 一开始没有想到代码会达到现在的规模
- 周边设施基本完善、迁移至 DVCS 的巨大成本，所以一直延用

---

======

---

这些大型仓库有个特点，就是迭代速度快
快到合并一个外部分支需要处理大量的冲突

未完成的功能还是需要开关，所以有了 compile-time checks 或者 runtime checks
（但是感觉这更适合需要编译发布的项目，前端项目也能这样吗？

这样的工作流，需要大量的辅助工具支撑
包括自动化的检查、测试等

> large projects that have fast-moving upstream dependencies

> no branches, runtime switches, tons of automated testing,
> relentless refactoring, and staying very close to HEAD of our dependencies.

---
