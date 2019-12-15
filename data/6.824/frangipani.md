# Frangipani

- introduction
    - a two-layered file system
        - the lower layer, Petal
            - a distributed storage service that provides incrementally scalable, highly available, automatically managed virtual disks
            - Petal use a distributed lock service to ensure coherence
        - the higher layer, Frangipani
    - layer: user => Frangipani => (distributed lock + Petal virtual disk) => physical disks
    - all machines are assumed to be able to communicate securely
    - Frangipani gives all users a consistent view of the same set of files

- system structure
    - build a file system in two layers
        - a lower level providing a storage respository
        - a higher level providing names, directories, files
    - the Petal servers available as long as a majority of the Petal servers remain up and in communication
        - large, scalable, fault-tolerant virtual disks
    - the Frangipani servers have no need to communicate directly with one another
        - they communicate only with Petal and the lock service
    - the lock service provides multiple-reader/single-writer locks
        - Frangipani uses the lock service to coordinate access to the virtual disk and to keep the buffer caches coherent across the multiple servers

- disk layout
    - a Petal virtual disk has 2^64 bytes of address space
    - Petal commits physical disk space to virtual addresses only when they are written

- logging and recovery
    - as long as the underlying Petal volume remains available, the system tolerates an unlimited number of Frangipani server failures
    - Frangipani log metadata only, user data is not logged
        - Frangipani creates a record describing the update and appends it to its log in memory
        - log records are periodically written out to Petal in the same order
        - after a log record is written to Petal, the server modify the actual metadata in its permanent locations
    - no guarantee that the file system state is consistent from the point of view after a failures
        - 因为只有 metadata 的 log，data 可能丢失了
        - user can get better consistency semantics by calling fsync at suitable checkpoints
        - 用户自己调用 fsync 确保 data 已保存（作者解释说，这和 linux 下的 fs 是一样的

- synchronization and cache coherence
    - Frangipani uses multiple-reader/single-writer locks
    - Frangipani servers donot need to communicate with each other (only with Petal and the lock server)
    - when a Frangipani server crashes, we need only process the log used by that server
    - transaction, some operations require atomically updating several on-disk data structure covered by different locks
        - avoid deadlock by globally ordering there locks and acquiring them in two phase
        - locks is sorted by inode address

- the lock service
    - 完全可以用其他 lock 组件代替，比如 ZooKeeper
    - the lock service deals with client failures using leases
        - client first contacts the lock service to obtain a lease
        - all locks the client acquires are associated with the lease
        - each lease has an expiration time
        - if the lease is not renewed, the lock server discards all its locks and the data in its cache

- adding and removing Frangipani servers
    - new Frangipani server need only be told which Petal virtual to use and where to find lock service
        - the new server contacts the lock service to obtain a lease
        - which portion of the log space to use from the lease identifier
    - it is preferable for server to flush all its dirty data and release its locks before halting (not strictly needed)

- backup
    - just take a Petal snapshot (copy-on-write for efficiency)
    - the snapshot will include all the logs
        - can be restored by copying back to a new Petal virtual disk and running recovery on each log
