# letsencrypt ECC

---

https://github.com/diafygi/acme-tiny
https://github.com/Neilpang/acme.sh
http://security.stackexchange.com/questions/78621/which-elliptic-curve-should-i-use
https://imququ.com/post/letsencrypt-certificate.html

---

改用 acme.sh 的 dns 验证了

```
$ CF_Key="1bce7c4dbfdf65aca770c2fdeccfba2fa76c5" CF_Email="nirisix@gmail.com" \
	./acme.sh --issue \
	--dns dns_cf \
	--keylength ec-384 \
	-d example.org \
	-d www.example.org
$ ./acme.sh --list
$ ./acme.sh --renewAll

# nginx
ssl_certificate /path/to/fullchain.cer;
ssl_certificate_key /path/to/domain.key;
```

---

```
# 创建 account private key
$ openssl genrsa 4096 > account.key

# 创建 domain private key
$ openssl ecparam -genkey -name secp384r1 -out domain.key
$ # openssl genrsa 4096 > domain.key # 如果要用 RSA 的话

# 生成 CSR (certificate signing request)
$ openssl req -new -sha384 -key domain.key -subj "/CN=yoursite.com" > domain.csr
$ # openssl req -new -sha384 -key domain.key -subj "/CN=yoursite.com" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:yoursite.com,DNS:www.yoursite.com")) > domain.csr

# 获取证书
$ curl -O 'https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py'
$ mkdir -p /opt/www/challenges/
$ python acme_tiny.py --account-key ./account.key --csr ./domain.csr --acme-dir /opt/www/challenges/ > signed.crt

# 获取中间证书，生成证书链
$ curl -s 'https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem' -o intermediate.pem
$ cat signed.crt intermediate.pem > chained.pem
```

可选的 ECC 曲线有很多种，可以看 `openssl ecparam -list_curves` 的输出。
前文链接里说，最少上 `prime256v1` 。
而 `secp384r1` 的开销不比 `prime256v1` 大多少，干脆就更安全一点吧。

配置好 nginx 就可以跑起来了。

```
ssl_certificate /path/to/chained.pem;
ssl_certificate_key /path/to/domain.key;
```

---

```
$ # 检查证书的过期时间
$ openssl x509 -noout -enddate -in chained.pem

$ # 检查 CSR 的内容
$ openssl req -noout -text -in domain.csr
```
