# js storage auth

---

http://blog.guya.net/2015/06/12/sharing-sessionstorage-between-tabs-for-secure-multi-tab-authentication/
http://blog.guya.net/2015/08/25/the-never-ending-browser-sessions/
https://developer.mozilla.org/en-US/docs/Web/API/StorageEvent

---

+ `localStorage` ~5MB, saved for infinity or until the user manually deletes it.
+ `sessionStorage` ~5MB, saved for the life of the current tab (not always deleted)
+ `cookie` ~4KB, can be saved up to infinity
+ `session cookie` ~4KB, deleted when the user closes the browser (not always deleted)

---

session 实在太坑，想要清空，必须将浏览器完全关闭，完全关闭。

session cookie 是在浏览器关闭时清空，但是浏览器会在后台运行，自认为没有关闭，不清空 session cookie。

session storage 是在标签关闭的时候情况，但是浏览器可以撤销关闭操作，这时 session storage 还保留着。

---

文中探讨的场景

1. 关闭标签时，退出登录
2. 打开多个标签，不需要重新登录

---

由于上面说到的问题，这个问题基本无解。
不考虑 sessionStorage 被保留的情况，文中使用了 storage 这个事件。

先在新打开的标签 B 设置一个值，触发标签 A 的 storage 事件。
A 收到事件时，将 sessionStorage 存储到 localStorage 中，这会触发 B 的 storage 事件。
然后 A 马上删除 localStorage。
B 在收到事件时，将收到的 sessionStorage 存储起来。

---

+ 在已经存在多个标签时，新开标签会导致所有旧标签都被激活。当然，这里可以再加其他机制。
+ 这个场景中，首次打开必须登录。如果希望持久存储，还是感觉本地存储的机制并不可靠。
