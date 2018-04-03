# OTP Design Principles

---

http://erlang.org/doc/design_principles/users_guide.html

---

## Overview

---

- supervision tree
    - 是一个 process structuring model
    - 进程分为 worker 和 supervisor
        - worker 进行计算
        - supervisor 进行监控，可以执行重启之类的操作
    - 让系统具备 fault-tolerant 能力
- behaviour
    - 对 supervision tree 中常见场景的抽象
    - 每个 process 可以分成两部分， generic part 和 specific part
        - generic part 被抽象成了 behaviour
        - specific part 通过 callback 的方式，与 behaviour 进行整合
    - 内置的四种 behaviour
        - gen_server, the server of a client-server relation
        - gen_statem, state machines
        - gen_event, event handling functionality
        - supervisor, the supervisor in a supervision tree
- application
    - 即其他场景说的 component
    - 包括对 directory structure (modules) 和 program structure (processes) 的要求
- release
    - 将 application 组成一个完整的系统，即为 release
- release handling
    - 热更新的机制

---

OTP 是一个 framework，规划了各种场景、制定了各种约定。
开发者按需求往里面填逻辑。

---

## Releases && Release Handling

---

- release 先生成 package，package 再被部署成 target system
- Release Resource File 是配置文件，用来生成 boot script 和 release package
- 在 erlang 中进行动态的 code replacement 操作，称为 release handling

---


