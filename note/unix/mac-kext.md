# kext mac

---

http://osxdaily.com/2010/08/03/list-all-third-party-kernel-extensions/
http://osxdaily.com/2015/06/24/load-unload-kernel-extensions-mac-os-x/

---

```
$ kextstat | grep -v 'com.apple'
$ kextunload -b 'com.objective-see.lulu'
```
