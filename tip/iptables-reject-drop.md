# iptables reject or drop

---

http://www.chiark.greenend.org.uk/~peterb/network/drop-vs-reject

---

对于普通用户
reject 表示意味着出错，不需要重试
drop 会造成 TCP 不断重试

---

对于恶意用户
reject 和 drop 没什么区别
