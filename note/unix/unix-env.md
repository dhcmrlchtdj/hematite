# env

---

heroku 那种 config var 是个好办法
在本地部署的时候，如果用 systemd，可以设置 `EnvironmentFile`
在开发的时候就比较麻烦了，不想在代码里引入什么 dotenv 之类的

---

http://stackoverflow.com/questions/19331497/set-environment-variables-from-file

SO 上面各种脚本……
比较简单的应该是用 `env` 来初始化环境吧。
有人用 eval，但是感觉不太安全啊（好像是为了解决引号相关问题的，没碰到

```
$ env $(cat .env | xargs) ./start-app
$ env $(cat .env | grep -v ^# | xargs) ./start-app

$ eval $(cat .env) ./start-app
```
