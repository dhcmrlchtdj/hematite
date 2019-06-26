# ChinaDNS

https://gist.github.com/pexcn/5af609563758a94fa1e603c117671efc

---

ChinaDNS 的原理

- 同时请求国内 DNS 和国外 DNS
- 如果国外快，使用国外地址
- 如果国内快
    - 如果返回的是国内 IP，直接使用
    - 如果返回的是国外 IP，等待国外 DNS 解析结果

---

这里面有一些约束

- DNS 污染后，只返回国外 IP。如果这个不符合，前面判断就错了
- 必须知道哪些 IP 属于国内。否则同样无法进行判断
