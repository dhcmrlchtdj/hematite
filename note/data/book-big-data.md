# big data: principles and best practices of scalable realtime data systems

---

## a new paradigm for big data

- the system continued to get more and more complex: queues, shards, replicas, resharding scripts, and so on
- what does a data system do? `query = function(all_data)`
    - low latency
    - scalability
    - generalization
    - extensibility
    - ad hoc query
    - minimal maintenance
    - debuggability
- solutions can be compared on three axes: accuracy, latency, throughput
- the lambda architecture
    - build big data system as a series of layers
    - speed layer + serving layer + batch layer
- batch layer
    - do
        - stores master dataset (immutable)
        - computes arbitrary views
    - the batch layer runs in a while(true) loop, and continuously recomputes the batch views from scratch
    - `batch_view = function(all_data); query = function(batch_view)`
- serving layer
    - do
        - random access to batch views
        - updated by batch layer
- speed layer (streaming)
    - do
        - compensate for high latency of updates to serving layer
        - fast, incremental algorithms
        - batch layer eventually overrides speed layer
    - the speed layer only looks at recent data, whereas the batch layer looks at all the data at once
    - `realtime_view = function(realtime_view, new_data)`

---

