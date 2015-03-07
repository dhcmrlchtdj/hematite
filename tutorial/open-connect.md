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
$ cp server-cert.pem /etc/ssl/certs/my-server-cert.pem # 生成时的 cn 必须为服务器地址
$ cp server-key.pem /etc/ssl/private/my-server-key.pem

$ mkdir /etc/ocserv
$ ocpasswd -c /etc/ocserv/ocpasswd username # 生成一个测试账号
$ cp doc/sample.config /etc/ocserv/ocserv.conf # 生成一个配置文件
$ cat /etc/ocserv/ocserv.conf
...
auth = "plain[/etc/ocserv/ocpasswd]"
server-cert = /etc/ssl/certs/my-server-cert.pem
server-key = /etc/ssl/private/my-server-key.pem
cisco-client-compat = true
#route = 192.168.1.0/255.255.255.0 # 注释掉所有的route，让服务器成为gateway
...

$ # 修改 iptables
$ iptables -A INPUT -p tcp -m state --state NEW --dport 9000 -j ACCEPT
$ iptables -A INPUT -p udp -m state --state NEW --dport 9001 -j ACCEPT
$ iptables -t nat -A POSTROUTING -j MASQUERADE
$ iptables-save >>> /etc/iptables/rules.v4 # 保存规则，需要安装 iptables-persistent

$ vim /etc/syslog.conf # 开启 ipv4 转发 net.ipv4.ip_forward=1
$ sysctl -p /etc/sysctl.conf

$ sudo ocserv -f -d 1 # 开启服务，可以测试能不能用了
```

按照上面的流程配置，先让服务能跑起来。

### 优化

```
$ # 生成客户端证书
$ man 8 ocserv # Generating the client certificates
$ # 将最后的 user.p12 倒入客户端即可

$ # 将登陆方式改成证书验证
$ cat /etc/ocserv/ocserv.conf
auth = "certificate"
#listen-clear-file = /var/run/ocserv-conn.socket # 注释掉
ca-cert = /etc/ssl/certs/my-ca-cert.pem

$ # 开机自动启动
...
```
