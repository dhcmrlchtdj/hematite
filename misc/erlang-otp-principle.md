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

## Behaviour

---

### gen_server

- client-server model
    - 特点 a central server and an arbitrary number of clients
    - 场景 resource management
- 接口
    - 服务启动、关闭 `gen_server:start_link / init / terminate` `gen_server:start / stop`
    - 同步消息传递 `gen_server:call / handle_call`
    - 异步消息传递 `gen_server:cast / handle_cast`
    - 其他类型信息 `handle_info / code_change`
- 接收消息时，使用模式匹配解析内容

---

### gen_event

- event
    - event manager / event handler
    - event manager 是个 process，里面的 event handler 是 callback
    - event manager 记录 handler 和 handler 的内部状态（internal state）
- 接口
    - handler 相关 `init / terminate / handle_event`
    - manager 相关 `gen_event:start_link / gen_event:stop / gen_event:add_handler / gen_event:delete_handler`
    - event 发送 `gen_event:notify`
    - 其他类型信息 `handle_info / code_change`
- 为不同的 event 创建不同的 handler
    - 这和前面 gen_server 在 handle 里面用模式匹配分辨消息，不太一样呢

---

### gen_statem

- Event-Driven State Machine
    - `State(S) x Event(E) -> Actions(A), State(S')`
    - the input is an event
    - the output is actions executed
    - Mealy machine
- callback mode
    - handle all possible combinations of events and states
        - focus on one state and ensure all events are handled
        - focus on one event and ensure the event is handled in every state
    - state_functions `StateName(EventType, EventContent, Data)`
        - focus on one state at a time
        - restricted to use atom-only states
    - handle_event_function `handle_event(EventType, EventContent, State, Data)`
        - free to mix strategies
        - enables the use of non-atom states

---

### Supervisor

- supervisor
    - start / stop / monitor (child processes)
    - keep child processes alive by restarting them when necessary
    - 子进程的信息，用 ChildSpecification 定义，如何开始，如何重启，进程启动的顺序，等等
    - 可以限制某个周期内重启的次数
- 接口
    - supervisor 相关 `supervisor:start_link / init`
    - child 相关 `supervisor:start_child / supervisor:terminate_child / supervisor:delete_child`
- restart strategy
    - one_for_one 子进程挂了，重启该子进程
    - one_for_all 子进程挂了，杀掉所有子进程，重启所有子进程
    - rest_for_one 子进程挂了，杀掉所有排在该进程后面的进程（按 ChildSpecification 定义的顺序），再重启所有未启动的进程
    - simple_one_for_one

---

## Applications

---

- An application is a component that can be started and stopped as a unit, and which can also be reused in other systems
- An application can include other applications.
    - primary application / included application
- 使用 application resource file 进行配置

---

## Releases && Release Handling

---

- release 先生成 package，package 再被部署成 target system
- Release Resource File 是配置文件，用来生成 boot script 和 release package
- 在 erlang 中进行动态的 code replacement 操作，称为 release handling
