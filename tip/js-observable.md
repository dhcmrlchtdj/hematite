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
