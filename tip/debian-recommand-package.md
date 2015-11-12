# recommand package

---

http://askubuntu.com/questions/244470/list-all-suggested-packages-for-currently-installed-packages

---

```
aptitude search '?reverse-recommends(~i)!(~i)'
aptitude search '?reverse-suggests(~i)!(~i)'
```
