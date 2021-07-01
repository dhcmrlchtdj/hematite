# perceus

https://www.microsoft.com/en-us/research/publication/perceus-garbage-free-reference-counting-with-reuse/

---

reference counting 的几个问题

- concurrency
    - 多线程，计数必须是原子操作，开销太大
- cycles
    - 不能处理循环引用
- precision
    - 资源释放不及时，作者不是说延迟释放的优化导致释放不及时，而是说 scope 结束才释放不够及时
    - 感觉这个说法太过了

而 koka 的 RC 解决这些问题，一部分是通过语言本身来实现的，不符合要求的程序都过不了编译。
