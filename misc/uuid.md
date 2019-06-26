# how UUID work

https://en.wikipedia.org/wiki/Universally_unique_identifier
https://stackoverflow.com/questions/20342058/which-uuid-version-to-use
https://www.zhihu.com/question/34876910
https://www.famkruithof.net/guid-uuid-timebased.html

疑问：UUID 能保证唯一性吗？拼接 timestamp 和 UUIDv4 有意义吗？

- xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx
    - 8-4-4-4-12
    - M 表明是 UUIDvM，N 是 UUIDvM 的 variant

- UUIDv1 基于时间、MAC
    - 58e0a7d7-eebc-11d8-9669-0800200c9a66
    - 58e0a7d7-eebc-_1d8 是时间，1d8_eebc_58e0a7d7
        - nanosecond 纳秒
    - 0800200c9a66 是 MAC，08:00:20:0c:9a:66
    - 1669 是 clock id，并不是每次都会变（为什么上面是 669 呢，因为是 14bit 的）

- UUIDv4 基于随机数
    - 加上一个 timestamp 应该是有意义的

- v3/v5 一个 md5 一个 sha1，看场景吧
