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

- refinement

- conclusion
    - 对模型进行限制，能简化其他方面的处理。MapReduce 本身就是一种模型限制
    - 问题的尺度放大，面临的核心矛盾会转移。比如 G 家的 MapReduce 要提高带宽的利用效率
