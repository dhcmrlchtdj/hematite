# weechat

---

https://weechat.org/files/doc/devel/weechat_quickstart.en.html
https://latest.glowing-bear.org/
https://wiki.archlinux.org/index.php/WeeChat
https://weblog.lkiesow.de/20160226-nginx-weechat-relay/

---

装好 weechat，连上 irc，开启 relay，打开 glowing-bear。

---

连接 freenode

```
/server add freenode chat.freenode.net/6697 -ssl -autoconnect
/set irc.server.freenode.sasl_username "username"
/set irc.server.freenode.sasl_password "password"
/set irc.server.freenode.autojoin = "#archlinux-cn"
/connect freenode
```

配置一下传话机器人

```
curl https://github.com/tuna/scripts/raw/master/weechat_bot2human.py \
	-o ~/.weechat/python/autoload/weechat_bot2human.py

/set plugins.var.python.bot2human.bot_nicks "teleboto toxsync xmppbot akarin2"
/script load weechat_bot2human.py
```

配置 relay

```
/set relay.network.bind_address "127.0.0.1"
/set relay.network.password "password"
/relay add ipv4.weechat 9001
```

再用 nginx 做一层转发

```
# Set connection header based on upgrade header
map $http_upgrade $connection_upgrade {
	default upgrade;
	'' close;
}

# Proxy for Weechat relay
server {
	listen 443 ssl http2;
	server_name weechat.example.com;

	ssl_certificate_key /path/to/ssl/key;
	ssl_certificate     /path/to/ssl/cert;

	location / {
		proxy_pass http://127.0.0.1:9001;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection $connection_upgrade;
		proxy_read_timeout 4h;
	}
}
```

没啥用的设置

```
/set weechat.plugin.autoload "*,!aspell,!tcl,!ruby"
```
