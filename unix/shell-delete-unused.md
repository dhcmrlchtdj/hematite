# delete file used

---

https://stackoverflow.com/questions/17945538/delete-directory-based-on-date

---

```
$ find path -type d -ctime +90 -exec echo {} \;

$ find path -type d -ctime +90 -exec rm -rf {} \;
```

根据文件修改、创建时间，删除文件
