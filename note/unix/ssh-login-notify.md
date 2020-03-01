# ssh notify

https://askubuntu.com/questions/179889/how-do-i-set-up-an-email-alert-when-a-ssh-login-is-successful/448602#448602
https://medium.com/@alessandrocuda/ssh-login-alerts-with-sendmail-and-pam-3ef53aca1381
https://blog.502.li/linux-login-alarm-telegram.html

看了 blog，感觉 telegram 监控 ssh 的想法不错

---

- 在 `/etc/ssh/sshd_config` 开启 `UsePAM yes`
- 创建 `login-notify.sh`
- 在 `/etc/pam.d/sshd` 添加 `session optional pam_exec.so seteuid log=/path/to/login-notify.log /path/to/login-notify.sh`
- 完

---

```bash
$ man 8 pam_exec
$ cat login-notify.sh

#!/bin/bash

BOT_TOKEN=''
CHAT_ID=''

text="<pre>from sshd:
ip     = ${PAM_RHOST}
user   = ${PAM_USER}
type   = ${PAM_TYPE}
date   = $(date -u +'%Y-%m-%d %H:%M:%S')
server = $(uname -nr)
</pre>"

json="{
    \"parse_mode\": \"HTML\",
    \"chat_id\": ${CHAT_ID},
    \"text\": \"${text}\"
}"

curl "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -H 'Content-Type: application/json' \
    --data "${json}"
```

用 JS 来写，虽然代码变长了，但是 HTTP 和 JSON 相关的部分，还是要舒服一些的。

```javascript
#!/usr/bin/env node

const CHAT_ID = 0
const BOT_TOKEN = '000000000:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
const report = async data => {
    const https = require('https')
    return new Promise((resolve, reject) => {
        const req = https.request(
            {
                host: 'api.telegram.org',
                method: 'POST',
                path: `/bot${BOT_TOKEN}/sendMessage`,
                headers: {
                    'Content-Type': 'application/json',
                    'Content-Length': Buffer.byteLength(data),
                },
            },
            resp => {
                resp.setEncoding('utf8')
                let buf = ''
                resp.on('data', chunk => {
                    buf += chunk
                })
                resp.on('end', () => {
                    resolve(JSON.parse(buf))
                })
            },
        )
        req.on('error', e => {
            reject(e)
        })
        req.write(data)
        req.end()
    })
}

const formatter = (date, format) => {
    const pad = value => ('0' + value).substr(-2)

    const _year = date.getUTCFullYear()
    const _month = date.getUTCMonth() + 1
    const _date = date.getUTCDate()
    const _hour = date.getUTCHours()
    const _minute = date.getUTCMinutes()
    const _second = date.getUTCSeconds()

    const pairs = {
        YYYY: _year,
        m: _month,
        mm: pad(_month),
        d: _date,
        dd: pad(_date),
        H: _hour,
        HH: pad(_hour),
        M: _minute,
        MM: pad(_minute),
        S: _second,
        SS: pad(_second),
    }

    return format.replace(
        /YYYY|mm?|dd?|HH?|MM?|SS?/g,
        matched => pairs[matched],
    )
}

const main = async () => {
    const os = require('os')
    const date = formatter(new Date(), 'YYYY-mm-dd HH:MM:SS')
    const server = `${os.hostname()}.${os.platform()}.${os.release()}`
    const text = `<pre>from sshd:
ip     = ${process.env.PAM_RHOST}
user   = ${process.env.PAM_USER}
type   = ${process.env.PAM_TYPE}
date   = ${date}
server = ${server}
</pre>`
    const json = {
        parse_mode: 'HTML',
        chat_id: CHAT_ID,
        text,
    }
    const data = JSON.stringify(json, null, 4)
    console.log(data)
    const resp = await report(data)
    console.log(JSON.stringify(resp, null, 4))
}

main()
```
