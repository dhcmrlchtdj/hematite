# vue rx

---

看一下 vue rx 的实现

使用 `created` 创建，`beforeDestroy` 销毁
整体使用 mixin 实现

额外的功能绑定在 `Vue.prototype` 上

vue 插件写法就这么几个，没啥好说的

---

```js
// https://github.com/vuejs/vue-rx/blob/4e354fa3ee10c62ac8108bc791abdfcbc285d59e/vue-rx.js#L26-L49

created() {
	Object.keys(obs).forEach((key) => {
		defineReactive(vm, key, undefined);

		var ob = vm.$observables[key] = obs[key];

		vm._obSubscriptions.push(
			obs[key].subscribe(val => vm[key] = val)
		);
	});
}
```

创建过程中比较核心的部分就是上面了
在 vm 上，为全部 obs 定义了一个同名的变量
后面 obs 发生变化的时候，更新 vm 上的变量，达到同步修改的目的

可以看到，所有 obs 都有 subscribe
所以，不管 view 上是否使用到，应该都会执行才对

---

```js
// https://github.com/vuejs/vue-rx/blob/4e354fa3ee10c62ac8108bc791abdfcbc285d59e/vue-rx.js#L52-L58

this._obSubscriptions.forEach((handle) => {
	if (handle.unsubscribe) {
		handle.unsubscribe();
	}
});
```

销毁的时候，会调用 unsubscribe
不过，为什么会有没有 unsubscribe 方法的情况？不需要处理吗？

---

`$subscribeTo` 在功能上和 `subscriptions` 一样
都是往 `this._obSubscriptions` 里面赛东西
等于是一个对外暴露的接口
不过没有 在 vm 上定义变量，所以只是为了实现一些副作用吧

`$watchAsObservable` 自己创建 obs，然后同样往 `_obSubscriptions` 赛
和 vue 关系比较紧密的，就是 watch 本身和 `hook:created` 这个事件了

`$fromDOMEvent` 是对 `doc.addEventListener` 的封装
实现上是简单粗暴的 if 判断对象
（感觉不精致

---

vuex 正确的使用姿势
