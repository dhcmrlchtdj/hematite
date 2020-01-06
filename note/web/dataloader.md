# data loader

---

https://github.com/facebook/dataloader

---

以前没仔细看一下，实在太可惜了。
概念、实现都很简单，不过感觉很使用。

---

## 解决什么问题？

可以先把场景设置得小一些。

```GraphQL
{
    me {
        name
        bestFriend {
            name
        }
        friends(first: 5) {
            name
            bestFriend {
                name
            }
        }
    }
}
```

在 GraphQL 进行 resolve 的时候，可能会发起多个请求。
上面的例子里，`bestFriend / name` 这些信息，可能被分成多个请求发送给后端。
但理论上，应该是可以聚合成一个请求的。

DataLoader 通过 batch 和 cache，简化了这种场景下的数据处理。

---

## batch

> DataLoader will coalesce all individual loads which occur within a single
> frame of execution (a single tick of the event loop) and then call your batch
> function with all requested keys.

在需要请求数据的时候，不会直接发送请求，而是稍等一下（JS 里使用了 microtask）。
期间的请求会被聚合起来，只发送一个数据请求到上游服务。

如果请求不在一个 microtask 周期里，那还是会发送多个请求。
但至少，N+1 会简化成 1+1。

---

## cache

> Each DataLoader instance represents a unique cache.

DataLoader 的缓存是不会自动失效的。
设想的使用场景里，每个实例的生命周期和 HTTP 请求生命周期一致。
生命周期内不需要考虑数据失效的问题。
当然，强制清除缓存也是可以的。

---

batch / cache 两个操作都很简单（对应的代码量也很小），但确实能极大简化数据查询操作。
