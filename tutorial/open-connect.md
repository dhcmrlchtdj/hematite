# ocserv

---

+ http://www.infradead.org/ocserv/
+ http://www.infradead.org/openconnect/

---

## ocserv

### 安装

不得不说，PKGBUILD 大法好。

下面是 debian 手动过程，照着 readme 弄就 ok 了。

```
$ git clone git://git.infradead.org/ocserv.git # 下载源码
$ git co $(git tag | tail -n1) # 切换到稳定分支

$ # 依赖／依赖／还是依赖
$ aptitude install libgnutls28-dev libwrap0-dev libpam0g-dev liblz4-dev libseccomp-dev libreadline-dev libnl-route-3-dev libkrb5-dev
$ aptitude install libprotobuf-c0-dev libtalloc-dev libhttp-parser-dev libpcl1-dev  libopts25-dev autogen  protobuf-c-compiler gperf
$ aptitude install autoconf automake autogen git2cl xz-utils

$ autoreconf -fvi # 生成 configure
$ ./configure
$ make
$ make install # 完成
```

### 配置

参考 http://bitinn.net/11084/

```
$ # 生成证书
$ man 8 ocserv # Generating the CA 和 Generating a local server certificate
$ cp ca-cert.pem /etc/ssl/certs/my-ca-cert.pem
$ cp server-cert.pem /etc/ssl/certs/my-server-cert.pem
$ cp server-key.pem /etc/ssl/private/my-server-key.pem

$ mkdir /etc/ocserv
$ ocpasswd -c /etc/ocserv/ocpasswd username # 生成一个测试账号
$ cp doc/sample.config /etc/ocserv/ocserv.conf # 生成一个配置文件／需要注意下登陆方式，端口，ca 文件等等等等

$ # 修改 iptables
$ iptables -A INPUT -p tcp -m state --state NEW --dport 9000 -j ACCEPT
$ iptables -A INPUT -p udp -m state --state NEW --dport 9001 -j ACCEPT
$ iptables -t nat -A POSTROUTING -j MASQUERADE

$ vim /etc/syslog.conf # 开启 ipv4 转发 net.ipv4.ip_forward=1
$ sysctl -p /etc/sysctl.conf

$ sudo ocserv -f -d 1 # 开启服务，可以测试能不能用了
```
