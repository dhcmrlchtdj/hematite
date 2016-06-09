# dnscrypt resolver

---

https://github.com/jedisct1/dnscrypt-proxy/blob/master/dnscrypt-resolvers.csv

---

完整的 resolver 列表在上面。
需求是筛选出一个稳定、可用的 resolver 出来。

---

```
$ curl -O https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/dnscrypt-resolvers.csv
$ sed 's/, //g' dnscrypt-resolvers.csv | \
	sed '1d' | \
	cut -f 11 -d, | \
	sed '/^\[/d' | \
	sed -E 's/:[[:digit:]]+//' | \
	sort -u -g \
	> dnscrypt-resolvers-ip.txt
$ cat dnscrypt-resolver-ip.txt | while read ip; do ping -c 10 ${ip} | tee -a ping.txt; done
```

然后根据 ping 的结果，找个好用的吧

---

可以用国内一些 DNS 服务做个速度的比较，比如 `119.29.29.29` 之类的。
我自己测试的结果，`119.29.29.29` 基本在 30ms 以内，dnscrypt 的速度完全不行……
