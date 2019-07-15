# Raft

- introduction
    - Raft is more understandable than Paxos
    - Raft separates leader election, log replication, and safety
    - novel features
        - strong leader, log entries only flow from the leader to followers
        - leader election, uses randomized timers to elect leader
        - membership changes, joint consensus

- replicated state machines
    - RSMs are used to solve a variety of fault tolerance problems in distributed systems
    - GFS/HDFS use a separate RSM to manage leader election and store configuration
        - such as Chubby, ZooKeeper
    - RSMs are implemented using a replicated log
        - log contains the same commands in the same order
    - properties of consensus algorithms
        - safety under all non-Byzantine conditions
        - available as long as majority of servers are operational
        - do not depend on timing to ensure the consistency of the logs
        - a minority of slow servers not impact overall system performance

- Paxos
    - Paxos defines a protocol for reaching agreement on a single decision
        - combine multiple instances of this protocol to facilitate a series of decision (such as log)
    - Paxos ensures safety and liveness, and it supports changes in cluster membership
    - drawbacks (single-decree Paxos is dense and subtle)
        - difficult to understand
        - the Paxos architecture is poor for building practical systems

- the Raft consensus algorithm
    - raft implements consensus by first electing a leader
        - having a leader simplies the management of the replicated log
    - raft decomposes the consensus problem into three independent subproblems
        - leader election
        - log replication
        - safety
    - raft basics
        - 2f+1 servers
        - three possible state: leader, follower, candidate
        - raft divides time into terms (consecutive integers)
            - terms act as a logical clock
        - at most one leader in a given term
    - leader election
        - 

- cluster membership changes
    - first switch to joint consensus configuration, then transition to new configuration

- log compaction
    - snapshot is the simplest approach to compaction
        - incremental approach, such as log cleaning and log-structured merge trees
    - when? take a snapshot when the log reaches a fixed size in bytes
    - each server takes snapshots independently
        - the leader must occasionally send snapshots to followers that lag behind
        - for example, a new server joining the cluster

- client interaction
    - how clients find the cluster leader
        - client first connects to a randomly-choesen server
        - follower reject the client's request and tell client the info about leader
        - if leader crashes, client try again with randomly-choesen servers
    - how raft supports linearizable semantics (execute exactly once
        - write
            - prevent from execute a command multiple times
            - leader crashes after commited, before responding to client
            - client will retry the command with a new leader
            - client assign unique serial numbers to every command
            - if the cluster receives duplicated command, it responds without re-executing the command
        - read
            - linearizable reads must not return stale data
            - leader commit a blank no-op entry
            - exchange heartbeat messages with a majority of the cluster before responding to client
