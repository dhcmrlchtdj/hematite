# CLFUS

---

https://cwiki.apache.org/confluence/display/TS/RamCache

---

CLFUS (Clocked Least Frequently Used by Size)

被 ATS 用来代替 LRU 等缓存

---

```
- seen?
    - no  => insert to **seen**
    - yes => cache_list?
        - yes => insert to **cached**
        - no  => history_list?
            - no  => insert to **history**
            - yes => update history => compare cache_value
                - x => insert to **cached**
                - x => insert to **history**
```

- 看到请求后，先看是否在 `seen list` 中，在 seen list 中才会进行缓存
    - 也就是说被请求两次才可能走缓存
    - 用来防止 scan
- `cached list` 放在内存中


---


