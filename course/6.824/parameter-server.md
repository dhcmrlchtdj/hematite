# parameter server

- introduction
    - server and worker
        - both data and workloads are distributed over worker nodes
        - the server nodes maintain globally shared parameters, represented as dense or sparse vectors and matrices
    - summary
        - all communication is asynchronous
        - flexible consistency model
        - elastic scalability and fault tolerance
    - models are often shared globally by all worker nodes
        - workers access the shared parameters and refine it
        - network bandwidth，访问带来的网络开销
        - sequential，计算是有序的
        - fault tolerance，机器多导致可用性低

- architecture
    - server group
        - a server manager node
        - many server nodes (partition + replication)
    - worker group
        - a scheduler node
        - many worker nodes (the worker node only communicate with the server node)

- implementation
    - range based communication
        - compress data and vector clocks
    - store the parameters (key-value pairs) by consistent hashing
        - a physical server is often represented in the ring via multiple virtual servers
            - improve load balancing and recovery
            - every node stores k counter clock-wise neighbor key ranges relative to it owns
    - replicate by chain replication
        - modifications to data are pushed synchronously to the slaves
