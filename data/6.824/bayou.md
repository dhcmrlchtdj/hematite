# Bayou

- introduction
    - Bayou is a replicated, weakly consistent storage system
        - maximize availability
        - move towards eventual consistency
        - redo according to a global serialization order
    - application-specific mechanisms to detect and resolve the update conflicts
        - automatic conflict resolution (detect/resolve 都不要求用户参与)
        - application must be aware that they may read weakly consistent data
        - application must be involved in the detection and resolution of conflicts
        - app 自己才知道最合适的手段
    - the system guarantees eventual consistency by ensuring that
        - all updates eventually propagate to all servers
        - servers perform updates in a global order
        - any update conflicts are resolved in a consistent manner at all servers
    - multi-leader 的架构
        - non-transparency
        - application-specific conflict detection
        - per-write conflict resolvers
        - partial and multi-object updates
        - tentative and stable resolutions
        - security
    - access control
        - public-key cryptography

- system model
    - a client and a server may be co-resident on a host
        - client: client stub + application
        - server: storage system + server state
    - write contains
        - information that lets each server decide if there is a conflict and how to fix it
        - a globally unique WriteID assigned by the server that first accepted the write


- conflict detection and resolution
    - dependency checks
        - support write-write conflicts and read-write conflicts
        - clients can emulate the optimistic style of concurrency control
    - merge procedures
        - once a conflict is detected, a merge propagate is run by the Bayou server
        - 解决不了的场景，让用户人工处理

- replica consistency
    - eventually consistency
        - all server eventually receive all writes via the pair-wise anti-entropy process
        - two servers holding the same set of writes will have the same data contents
    - order
        - tentative writes are ordered according to timestamps assigned to them by their according servers
        - committed writes are ordered according to the times at which they commit and before any tentative writes
    - logical clocks, pair (timestamp, ID)

- write stability and commitment
    - one server designated as the primary takes responsibility for commiting updates
    - writes accepted by other servers simply remain tentative until they eventually reach the primary

- implementation
    - write log
        - committed
            - tuple store (on disk, checkpoint)
            - timestamp vector (Committed Vector)
        - tentative
            - tuple store (in memory)
            - undo log (in memory)
            - timestamp vector (Full Vector)
    - write log is sorted by their global committed or tentative order
        - committed 之后，log 就可以丢弃了
        - server does not re-accept the same writes
    - tuple store is a database, execute the write in order, process read request
        - tuple store holds two distinct views, committed and full(committed+tentative)
