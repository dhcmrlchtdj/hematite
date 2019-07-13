# MapReduce

- introduction
    - parallelize the computation, distribute the data, handle failures, load balancing, locality optimization
    - the model is easy to use
    - map KV to intermediate KV, merge(reduce) intermediate values with the same intermediate key

- programming model
    - Map 阶段，将 KV 列表转换成 KV 列表的列表
    - Reduce 阶段，将较大的 value 列表转换为较小的 value 列表
    - `map: ('k1 * 'v1) -> ('k2 * 'v2) list`
    - `reduce: ('k2 * 'v2 list) -> 'v2 list`

- implementation
    - G 家方案的硬件背景，大量 PC 联网
        - large clusters of commodity PCs connected together with switched Ethernet
    - 为了减少带宽需求
        - map 之后的数据保存在本地，只会把标识发给 master
        - master 把标识发给 reduce，reduce 会去 map 机器获取数据
        - 但是 reduce 的输出并不保存在本地，有专门存储输出的节点
    - master 存储任务状态，worker 跑 map 和 reduce
    - fault tolerance
        - worker
            - master 发 heartbeat 检测 worker 状态
            - 出现异常就把该 worker 的 map 任务状态重置，重新开始（reduce 结果在 GFS，不需要重新跑
            - 即使是网络问题，导致执行了重复的 map/reduce 也没关系
                - master 单节点，重复的 map 返回值会被丢弃
                - GFS 来保证 reduce 输出不会重复
        - master
            - 定期保存状态，可以从 checkpoint 恢复（可能丢失部分执行结果
            - G 家的策略，client 发现 master 挂了，自己重启任务。不从 checkpoint 自动恢复 master
            - MapReduce 过程应该是幂等的
    - locality
        - G 的数据量级，机器间的带宽是稀缺资源
        - MapReduce 数据存储在 GFS，master 会主动将 map 任务分配到离数据较近的机器上（甚至是同一台机器
    - task granularity
        - G 家，worker=2000，M=200000, R=5000
        - 拆分粒度细一些，负载更平衡，节点异常时重启任务成本更低。但是 master 需要处理的状态也就更多
        - M 的数量根据输入来，每个任务处理 16~64M 数据
        - R 的数量由用户指定，通常是 worker 的数倍
    - backup tasks
        - 在 MapReduce 快要结束的时候，把一些任务交给多个机器重复执行
        - 根据不同机器的完成时间，评估机器状态
            - 可能因为机器故障导致运行较慢
            - 也可能因为其他任务争抢资源

- conclusion
    - 对模型进行限制，能简化其他方面的处理。MapReduce 本身就是一种模型限制
    - 问题的尺度放大，面临的核心矛盾会转移。比如 G 家的 MapReduce 要提高带宽的利用效率
