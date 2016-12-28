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
