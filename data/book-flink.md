# stream processing with apache flink

---

## stateful stream processing

- traditional
    - transactional processing
        - seperate compute and storage
    - analytical processing
        - DBMSs -> ETL -> data warehouse
- stateful stream processing
    - event-driven
        - communicate via event logs (instead of REST calls
        - hold application data as local state (instead of writing/reading data from an external datastore
    - data pipeline
        - store the same data in multiple different systems to improve the performance of data access
            - such as, database and cache and search index
            - the data stores must be kept in sync
        - approach
            - periodic ETL jobs (high latency
            - event log
    - data analytics
        - batch or stream

---

## stream processing fundamentals

- dataflow
    - dataflow graph
        - how data flow between operations, represented as directed graph
        - logical dataflow graph, a high-level of the computation logic
        - physical dataflow graph, how the program executed
    - parallel
        - data parallel, can process large volumns of data and spread the computation load across serveral nodes
        - task parallel, can better utilize the computing reources of a cluster
    - data exchange strategy
        - forward
        - broadcast
        - key-based
        - random
- parallel processing
    - data stream: a potentially unbounded sequence of events
    - performance
        - batch
            - total execution time
        - stream
            - latency
            - throughput
    - latency
        - the time interval between receiveing an event and seeing the effect of processing this event in the output
        - maximum latency, percentile latency
    - throughput
        - how many events the system can process per time unit
        - peak throughput
        - backpressure
    - operations
        - stateless or stateful
        - stateless
            - not maintain any internal state
            - easy to parallelize/failover
        - window operations
            - collect and buffer records to compute their result
            - window type
                - tumbling: no-overlapping buckets of fixed size
                    - count-based, fixed length
                    - time-based, fixed time interval
                - sliding: overlapping buckets of fixed size
                - session
                    - 定义一个时长 session gap
                    - gap 之间没收到 event，则前面的 buffer 构成一个 window
                    - （类似 debounce
- time semantics
    - event time
        - guarantee deterministic results
        - allow to deal with events that are late or even out of order
    - processing time
        - offer low latency
        - depend on the speed of processing and are not deterministic
    - watermark

- state and consistency
    - challenge
        - concurrent update
        - partition
        - recovery
    - failure
        - a batch job can be simply restarted from the beginning
