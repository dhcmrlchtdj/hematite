# ocserv

---

## install

```
$ yaourt -S ocserv
```

`PKGBUILD` 里面配置文件路径有错，需要手动改一下

---

## ip forward

```
$ echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.d/30-ipforward.conf
$ # echo "net.ipv6.conf.all.forwarding=1" | tee -a /etc/sysctl.d/30-ipforward.conf
$ sysctl --system # load conf
$ # sysctl -p /etc/sysctl.d/30-ipforward.conf # load conf
```

## nat

```
$ iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
# $ iptables -t nat -A POSTROUTING -j SNAT --to-source <server ip> -o <nic>
$ iptables -t nat -A POSTROUTING -j MASQUERADE -o <nic>
$ iptables-save | tee -a /etc/iptables/iptables.rules
$ # systemctl start iptables
$ # systemctl enable iptables
```

`iptables.service` 停用的时候会把 iptables 清空
会导致 fail2ban 等其他服务的配置丢失，比较坑

---

## cert

服务端证书，可以去 letsencrypt 来签发
用户端证书，可以自签
`man ocserv` 里写得还是很清楚的

```
$ cat << _EOF_ > ca.tmpl
cn = "AC CA CN"
organization = "AC CA ORG"
serial = 1
expiration_days = 366
ca
signing_key
cert_signing_key
crl_signing_key
_EOF_
$ certtool --generate-privkey --outfile=ca-key.pem && \
certtool --generate-self-signed --load-privkey=ca-key.pem --template=ca.tmpl --outfile=ca-cert.pem

$ cat << _EOF_ > user.tmpl
cn = "AC USER CN"
unit = "AC USER UNIT"
expiration_days = 365
signing_key
tls_www_client
_EOF_
$ certtool --generate-privkey --outfile=user-key.pem && \
certtool --generate-certificate --load-privkey=user-key.pem --load-ca-certificate=ca-cert.pem --load-ca-privkey=ca-key.pem --template=user.tmpl --outfile=user-cert.pem && \
certtool --load-certificate=user-cert.pem --load-privkey=user-key.pem --pkcs-cipher=3des-pkcs12 --to-p12 --outder --outfile=user.p12
```

测试了一下
`--pkcs-cipher=aes-xxx` 生成的 p12 无法导入 keychain
`--ecc --curve=secp521r1` 签的 p12 AC 不认
错误日志都不知道去哪查……
