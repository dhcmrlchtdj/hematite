# Chord

- introduction
    - p2p's fundamental problem: how to efficiently locate the node that stores a particular data item
    - Chord is a distributed lookup protocol
        - simple, correct, performance
        - given a key, determines the node that storing the key's value, efficiently
    - Chord use a variant of consistent hashing to assign keys to Chord nodes
        - impractical assume: nodes are aware of most other nodes in the system
        - Chord node route information about other nodes

- system model
    - Chord addresses there problems
        - load balance
        - decentralization
        - scalability
        - availability
        - flexible naming
    - Chord and application interact in two ways
        - app 向 Chord 发出 lookup(key) 指令
        - Chord 通知 app 有节点发生变化

- Chord protocol
    - overview
        - how to find the locations of keys
        - how new nodes join the system
        - how to recover from failure
        - how to handle concurrent joins
        - how to handle concurrent failures
    - consistent hashing
        - 第 N 个节点加入的时候，大约 1/N 的 key 需要移动到新节点。实现 load balance 需要的改动很小
        - 在 Chord 里进一步，节点并不知道全部 N 个其他节点
    - node joins
    - stabilization
        - keep nodes' successor pointers up to date

**TODO**
