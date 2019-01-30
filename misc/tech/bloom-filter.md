# bloom filter

https://en.wikipedia.org/wiki/Bloom_filter

https://llimllib.github.io/bloomfilter-tutorial/
https://www.eecs.harvard.edu/~michaelm/postscripts/rsa2008.pdf

https://github.com/jasondavies/bloomfilter.js/blob/master/bloomfilter.js
http://willwhim.wpengine.com/2011/09/03/producing-n-hash-functions-by-hashing-only-once/
http://www.isthe.com/chongo/tech/comp/fnv/index.html

https://libsodium.gitbook.io/doc/hashing/short-input_hashing#purpose
https://github.com/jedisct1/siphash-js

---

- 判断元素是否在集合中
    - 肯定不在
    - 可能在
- 加入集合后，就删除不了了
- 实现
    - 长度 m 的 bit array
    - k 个 hash 函数
    - k 小于 m
    - hash 是 [0,m] 的均匀分布
    - k 个函数将 bit array 中 k 个 bit 标记为黑色（当然，也可能一次少于 k 个）
    - 一样的流程用于判断是否在集合中
    - 不同元素可能标记了相同的点，所以结果并不可靠

---

## hash

- 去哪找那么多符合要求的 hash 函数呢？
    - 搜了一下，SipHash 或者 FNV 都可以
    - 但是，怎么用呢？
- `hash(x, i) = [h1(x) + i * h2(x)] % m`
    - 可以通过两个 hash 函数，计算出 k 个值（i 从 1 到 k）
    - SipHash 用两个不同的 key 即可获得两个 hash 函数
    - FNV，看前面描述，直接 h1/h2 是都用同一个函数（呃呃呃
