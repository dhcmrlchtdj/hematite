# js event delegate

---

事件代理，在 jquery 时代就被广泛使用
大部分 js 初学者应该也都自己实现过

翻看 vue-rx 的时候，看到事件代理相关的代码
感觉，一点都不够优雅
去看了下其他框架如何实现

文中所有代码都做了简化，只看个思路结构

---

## vue-rx

https://github.com/vuejs/vue-rx/blob/1faf574b08138ac95958393887a1aea56868232b/vue-rx.js#L119

```javascript
const $fromDOMEvent = function(selector, event) {
	function listener(e) {
		if (vm.$el && (vm.$el.querySelector(selector) === e.target)) {
			observer.next(e)
		}
	}
	doc.addEventListener(event, listener);
};
```

首先为什么说不优雅
每增加一个事件监听，就在 doc 上注册一个回调函数，这不是一个事件代理应有的表现

另外，这里使用 `querySelector`，是 bug 吧？

---

## infernojs

infernojs 和 react，虽然叫做 synthetic events，但其实就是全部代理了

https://github.com/infernojs/inferno/blob/1.2.0/src/DOM/events/delegation.ts

```javascript
const delegatedEvents = new Map();

const handleEvent = function(eventName, handler, dom) {
	let delegatedRoots = delegatedEvents.get(eventName);
	if (!delegatedRoots) {
		delegatedRoots = { items: new Map(), count: 0, docEvent: null };
		const docEvent = attachEventToDocument(eventName, delegatedRoots);
		delegatedRoots.docEvent = docEvent;
		delegatedEvents.set(name, delegatedRoots);
	}
	delegatedRoots.count++;
	delegatedRoots.items.set(dom, handler);
};

const attachEventToDocument = function(eventName, delegatedRoots) {
	const docEvent = function(event) {
		const count = delegatedRoots.count;
		if (count > 0) {
			dispatchEvent(event, event.target, delegatedRoots.items, count);
		}
	};
	document.addEventListener(eventName, docEvent);
	return docEvent;
};

const dispatchEvent(event, dom, items, count) {
	const eventsToTrigger = items.get(dom);

	if (eventsToTrigger) {
		count--;
		eventsToTrigger(event);
	}

	const parentDom = dom.parentNode;
	if (count > 0 && (parentDom || parentDom === document.body)) {
		dispatchEvent(event, parentDom, items, count);
	}
};
```

- `delegatedEvents` 是 `eventName -> domElements` 的映射。
	每个事件都有一个回调函数，一个回调里，处理所有的 dom 节点。
- `attachEventToDocument` 在 `document` 上设置了回调，对事件进行了分发
	删除监听的代码在 `delegatedEvents` 里面，没抄出来
- `dispatchEvent` 最核心的分发，是通过 `dom.parentNode` 一层层向上查找
	全程携带的 `count` 都是为了及早停下这个查找过程
- `stopPropagation` 相关的代码没摘抄出来，这也是实现时应该注意的一点
- 代码里没有处理一个 `dom` 绑定多个 `click` 的情况
	应该是假设了 jsx 编写时不会写出多个监听吧
	（即使有这种情况，修改为回调数组比较简单
- 一个事件只有一个回调，应该是一个较大改进

---

## jquery

https://github.com/jquery/jquery/blob/3.1.1/src/event.js

```javascript
jQuery.event.add = function() {
	if (!(events = elemData.events)) {
		events = elemData.events = {};
	}
	if (!(eventHandle = elemData.handle)) {
		eventHandle = elemData.handle = function(e) {
			return jQuery.event.dispatch.apply(elem, arguments);
		};
	}
	if (!(handlers = events[type])) {
		handlers = events[type] = [];
		handlers.delegateCount = 0;
		elem.addEventListener(type, eventHandle);
	}

	if (selector) {
		handlers.splice(handlers.delegateCount++, 0, handleObj);
	} else {
		handlers.push(handleObj);
	}
};

jQuery.event.dispatch = function(event) {
	handlers = (this.events || {})[event.type];
	handlerQueue = jQuery.event.handlers.call(
		this,
		event,
		handlers,
	);
	let i = 0;
	while ((matched = handlerQueue[i++]) &&
		!event.isPropagationStopped()) { // loop elements
		let j = 0;
		while ((handleObj = matched.handlers[j++]) &&
			!event.isImmediatePropagationStopped()) { // loop element handlers
			handleObj.handler.apply(matched.elem, args);
		}
	}
};

jQuery.event.handlers = function(event, handlers) {
	let handlerQueue = [];
	let delegateCount = handlers.delegateCount;
	let cur = event.target;

	if (delegateCount) {
		for (; cur !== this; cur = cur.parentNode || this) {
			let matchedHandlers = [];
			for (i = 0; i < delegateCount; i++) {
				handleObj = handlers[i];
				if (jQuery(sel, this).index(cur) > -1) {
					matchedHandlers.push(handleObj);
				}
			}
			handlerQueue.push({
				elem: cur,
				handlers: matchedHandlers,
			});
		}
	}

	return handlerQueue;
};
```

- jquery 作为历史最长的库，里面的历史包袱和细节处理，应该都是最多的了
	- 包了一层又一层，并且有大量无关代码，很讨厌……
	- 出于学习目的的话，绝对是 infernojs 更适合
- 和 infernojs 非常类似的处理方式，一种事件注册一个回调
	（或者应该说 infernojs 像 jquery 才对？
	- infernojs 那里也提到了，可以把用户回调改成一个数组。jquery 就是这样实现的
	- 可以在任意 element 上注册回调，所以比 infernojs 复杂了，感觉有好几个数量级
- 在寻找用户回调的时候，也是通过 `parentNode` 来遍历 DOM 树。
	- 不过查找过程不像 infernojs 是个字典，要慢很多
	- 比如 `click`，会先找到该元素上所有的 `click` 回调。
		遍历回调，是否代理了从 `event.target` 到当前元素这 N 个 DOM 节点的 `click`。
		也就是说，N 个节点 M 个回调，会 O(MN) 对比。

---

## vue && svelte

https://github.com/vuejs/vue/blob/v2.1.8/src/platforms/web/runtime/modules/events.js#L17
https://github.com/sveltejs/svelte/blob/v1.6.3/src/shared/dom.js#L29

- vue 和 svelte 都没有 synthetic events 之类的机制
- 虽然感觉可能会造成页面有大量事件监听，不过就目前能看到的各种测试来看，
	浏览器处理起来压力不大
- 不得不说，vue 的代码树太复杂，完全不知道想找的代码可能在哪……

---

## react

TBD
