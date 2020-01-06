# letsencrypt ECC

---

https://github.com/diafygi/acme-tiny
https://github.com/Neilpang/acme.sh
http://security.stackexchange.com/questions/78621/which-elliptic-curve-should-i-use
https://imququ.com/post/letsencrypt-certificate.html

---

```makefile
p:
	certbot certonly -d example.com -d www.example.com --csr ./domain.csr --preferred-challenges dns --manual --manual-public-ip-logging-ok --manual-auth-hook /path/to/dns_cf.sh

csr:
	openssl req -new -sha384 -key domain.key -subj "/CN=example.com" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:example.com,DNS:www.example.com")) -out domain.csr
```

```sh
#!/usr/bin/env bash

# Get your API key from https://www.cloudflare.com/a/account/my-account
API_KEY="TODO"
EMAIL="TODO"
CURL_HEADERS=( -s -H "X-Auth-Email: $EMAIL" -H "X-Auth-Key: $API_KEY" -H "Content-Type: application/json" )

# Strip only the top domain to get the zone id
DOMAIN=$(awk -F "." '{print $(NF-1)"."$NF}' <<< $CERTBOT_DOMAIN)

# Get the Cloudflare zone id
ZONE_EXTRA_PARAMS="status=active&page=1&per_page=20&order=status&direction=desc&match=all"
ZONE_ID=$(curl -X GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN&$ZONE_EXTRA_PARAMS" \
    "${CURL_HEADERS[@]}" \
    | python -c "import sys,json;print(json.load(sys.stdin)['result'][0]['id'])")

# Create TXT record
CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
RECORD_ID=$(curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    "${CURL_HEADERS[@]}" \
    --data '{"type":"TXT","name":"'"$CREATE_DOMAIN"'","content":"'"$CERTBOT_VALIDATION"'","ttl":120}' \
    | python -c "import sys,json;print(json.load(sys.stdin)['result']['id'])")

# Sleep to make sure the change has time to propagate over to DNS
sleep 25
```

---

改用官方的 certbot 了

注册
```
$ certbot register -m nirisix@gmail.com --no-eff-email
```

生成 CSR
```
$ openssl ecparam -genkey -name secp384r1 -out domain.key
$ openssl req -new -sha384 -key domain.key \
    -subj "/CN=yoursite.com" -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:yoursite.com,DNS:www.yoursite.com")) \
    -out domain.csr
```

获取证书
```
$ certbot certonly \
    -d yoursite.com -d www.yoursite.com \
    --csr /path/to/csr \
    --preferred-challenges dns \
    --manual \
    --manual-public-ip-logging-ok \
    --manual-auth-hook /path/to/dns/authenticator.sh
```

成功后会拿到 `0001_chain.pem`

然后配置证书就可以了

```
ssl_certificate /path/to/0001_chain.pem;
ssl_certificate_key /path/to/domain.key;
```

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
