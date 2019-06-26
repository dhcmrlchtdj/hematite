# tcp AIMD

---

https://en.wikipedia.org/wiki/Additive_increase/multiplicative_decrease
http://blog.chinaunix.net/uid-28387257-id-4543179.html

---

早年看 TCP 基本忘光了……

+ additive-increase/multiplicative-decrease (AIMD)
    每次窗口增长时，增长量是固定的
    每次窗口缩小时，缩小到原长度的一半
+ multiplicative-increase/multiplicative-decrease (MIMD)
+ additive-increase/additive-decrease (AIAD)

AIMD 被用于保证带宽分配的公平性
重复进行 AIMD 的结果是竞争双方的带宽会收敛到近似的值
