# 

---

https://github.com/diafygi/acme-tiny
http://security.stackexchange.com/questions/78621/which-elliptic-curve-should-i-use
https://imququ.com/post/letsencrypt-certificate.html
https://poonchit.im/2016/02/13/letsencrypt-ecc-nginx-2/

---

## RSA

```
# 创建 account private key
$ openssl genrsa 4096 > account.key

# 创建 domain private key
$ openssl genrsa 4096 > domain.key

# 生成 CSR (certificate signing request)
$ openssl req -new -sha256 -key domain.key -subj "/CN=yoursite.com" > domain.csr
$ # openssl req -new -sha256 -key domain.key -subj "/" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:yoursite.com,DNS:www.yoursite.com")) > domain.csr

# 获取证书
$ python acme_tiny.py --account-key ./account.key --csr ./domain.csr --acme-dir /var/www/challenges/ > ./signed.crt

# 获取中间证书，生成证书链
$ wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > intermediate.pem
$ cat signed.crt intermediate.pem > chained.pem
```

然后配置好 nginx 就可以跑起来了。

```
ssl_certificate /path/to/chained.pem;
ssl_certificate_key /path/to/domain.key;
```

---

## ECC

其他部分都一样，只是生成 domain.key 的时候，改成 ECC 签名。

```
# 生成 domain private key
$ openssl ecparam -genkey -name prime256v1 | openssl ec -out domain.key
```

这里稍微展开一点，可选的曲线有很多种，可以看 `openssl ecparam -list_curves` 的输出。
前文的链接里说 `prime256v1` 就够了，不放心可以上 `secp384r1`。
至于 `secp521r1` 什么的可能会出现兼容问题？`Curve25519` 则是根本不支持的样子？

---

```
$ # update nginx config
$ curl -O 'https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py'
$ mkdir -p /opt/www/challenges/
$ python acme_tiny.py --account-key ./account.key --csr ./domain.csr --acme-dir /opt/www/challenges/ > signed.crt
$ curl 'https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem' -o 'intermediate.pem'
$ cat signed.crt intermediate.pem > chained.pem
```
