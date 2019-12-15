# Naiad

- introduction
    - Naiad is a distributed system for executing data parallel, cyclic dataflow programs
        - high throughput of batch processors
        - low latency of stream processors
        - iterative and incremental computations
        - Naiad 整合了这三者
    - timely dataflow is a powerful general-purpose low-level programming abstraction for iterative and streaming computation
    - timely dataflow graphs are directed and may include cycles
    - related work
        - dataflow
            - extend acyclic batch dataflow to allow dynamic modification of the dataflow graph
            - support iteration and incremental computation without adding cycles to the dataflow
        - asynchronous computation
            - asynchronously update distributed shared data structure
                - low-latency incremental updates
                - fine-grained computational dependency
    - performance: throughput, latency, scale

- timely dataflow
    - graph structure
        - each message has an integer epoch
        - input vertices and output vertices
        - loop contexts
            - ingress vertex, egress vertex, feedback vertex
        - logical timestamp based on the dataflow graph structure
            - timestamp = (epoch, [loop_counter, c2, c3, ...])

- distributed implementation
    - Naiad is a distributed implementation of timely dataflow
    - how to achieve high performance
        - data parallel
        - workers
        - distributed progress tracking
        - fault tolerance
