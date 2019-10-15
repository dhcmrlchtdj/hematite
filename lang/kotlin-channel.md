## kotlin channel

- backpressure
    - unbufferred channel (default)
        - `Channel<Int>(0) // RENDEZVOUS=0, RendezvousChannel()` 阻塞
    - buffered channel
        - `Channel<Int>(50) // [1,Int.MAX_VALUE-1], ArrayChannel()` 定长
        - `Channel<Int>(Channel.UNLIMITED) // UNLIMITED=Int.MAX_VALUE, LinkedListChannel()` 不定长
        - `Channel<Int>(Channel.CONFLATED) // CONFLATED=-1, ConflatedChannel()` 长度为 1，新数据覆盖旧数据
- send / receive
- thread confinement
    - `async( newSingleThreadContext("name") ) { ... }`
- actor
    - thread confinement + channel
- `atomicInteger()`
