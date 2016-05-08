# docker vboxnet

---

http://superuser.com/questions/854369/how-do-i-remove-a-virtualbox-host-only-network-adapter

---

docker-machine 删除后，vboxnet 却还留着，看着很不舒服……


```
$ VBoxManage hostonlyif remove vboxnet4
```

or 

`Open Virtualbox, click File -> Preferences -> Network -> Host-only Network, remove Vboxnet#`
