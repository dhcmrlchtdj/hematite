# observable

---

https://medium.com/@benlesh/hot-vs-cold-observables-f8094ed53339

---

+ COLD is when your observable creates the producer

```
// COLD
var cold = new Observable((observer) => {
	var producer = new Producer();
	// have observer listen to producer here
});
```

+ HOT is when your observable closes over the producer

```
// HOT
var producer = new Producer();
var hot = new Observable((observer) => {
	// have observer listen to producer here
});
```

---

cold 是惰性求值的，被订阅后，才会生成 producer 并生产数据
hot 是非惰性的，一开始就有 producer 一直在生产数据，订阅前的数据都会丢失

---

https://egghead.io/lessons/rxjs-demystifying-cold-and-hot-observables-in-rxjs

---

cold 被订阅后才开始生成数据，多个订阅之间是无关的，即多个数据源。
hot 只有一个数据源，订阅的是同一个数据。

cold 像是视频，每个人都可以在不同的时候，从头开始看。
hot 像是直播，大家看一个一个源，开头没看到就没看到了。

---

https://staltz.com/cold-and-hot-callbacks.html

---

- `setInterval` is cold
- `addEventListener` is hot

> cold by default is better for the general case.

> It’s easy to go from cold to hot, but not always obvious to do the other way.
> And if something is already hot, making it hot again is harmless and transparent.
