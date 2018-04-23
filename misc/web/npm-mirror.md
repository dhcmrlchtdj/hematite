# npm mirror

---

网络问题不多说了……
指定镜像的方式也是多种多样……

https://npm.taobao.org/mirrors 是比较全的

---

```
$ # https://github.com/creationix/nvm#usage
$ export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/dist

$ # https://docs.npmjs.com/misc/config#registry
$ echo "registry=https://registry.npm.taobao.org" >> ~/.npmrc

$ # https://github.com/nodejs/node-gyp/pull/878/files
$ export NODEJS_ORG_MIRROR=https://npm.taobao.org/dist

$ # https://github.com/sass/node-sass/commit/4d583856ebc64b564733b221bd25325be70a329c
$ export SASS_BINARY_SITE=https://npm.taobao.org/mirrors/node-sass
$ # https://github.com/sass/node-sass/commit/8efaac28c2ff0086f30d17df55c62a4260fd3328
$ echo "sass_binary_site=https://npm.taobao.org/mirrors/node-sass" >> ~/.npmrc

$ # https://github.com/mapbox/node-pre-gyp#download-binary-files-from-a-mirror
$ echo "profiler_binary_host_mirror=https://npm.taobao.org/mirrors/node-inspector/" >> ~/.npmrc
```
