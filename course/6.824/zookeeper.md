# ZooKeeper

- introduction
    - ZK is a service for coordinating processes of distributed applications
    - ZK provides
        - a per client guarantee of FIFO execution of requests
        - linearizability for all requests that change the ZK state
    - ZK can be used to implement configuration, group membership, leader election, lock
        - lock can be used to implement group membership, leader election
    - use replication to archive high available and performance
    - wait-free data objects organized hierarchically as in file systems
    - guarantee FIFO client ordering of all operations
    - only writes are linearizable
        - leader-based atomic broadcast protocal, Zab
    - ZK application is dominated by read operations and it becomes desirable to scale read throughput
        - servers process read operations locally, do not use Zab to totally order them
    - caching data on the client side
        - watch mechanism, a client can watch for an update to a given data object

- ZooKeeper service

- ZooKeeper implementation

- conclusion
    - wait-free by exposing wait-free objects to clients
    - read-dominant workload
    - weak consistency guarantee

- performance
    - throughput
    - latency of requests

- use case
    - configuration metadata
    - failure detect and group membership (track the status of the master and slaves)
    - leader election (handle master failover)
