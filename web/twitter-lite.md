# How we built Twitter Lite

---

https://blog.twitter.com/2017/how-we-built-twitter-lite

---

> Twitter Lite is fast and responsive, uses less data, takes up less storage
> space, and supports push notifications and offline use in modern browsers.
> The web is becoming a platform for lightweight apps that can be accessed
> on-demand, installed without friction, and incrementally updated.

两句话总结优势

---

> The server handles user authentication, constructs the initial state of the
> app, and renders the initial HTML application shell.

node 服务做的事情很少，除了鉴权外只有初始页面的服务端渲染。
数据交互都交给公共 API。

---

> Relying on established open source software has allowed us to spend more time
> improving the user-experience, increasing our iteration speed, and working on
> Twitter-specific problems such as processing and manipulating Timeline and
> Tweet data.

借助第三方库，达到了哪些目的。
节约的时间花在了哪些事情上。

用户体验、迭代效率、项目核心问题

---

##  Availability

> Twitter Lite is network resilient.

借助 Service Worker 的缓存增强页面的可用性。
即使网络慢甚至网络不可用，页面本身仍是可用的。

---

## Progressive loading

> Over the last 3 months we’ve reduced average load times by over 30% and 99th
> percentile time-to-interactive latency by over 25%.

论监控的重要性。
提升是通过数据展现出来的。

> ..., sending instructions to preload critical resources while the server
> constructs the initial app state.
> ..., the app’s scripts are broken up into granular pieces and loaded on
> demand.
> This means that the initial load only requires resources needed for the
> visible screen.

还是按需加载。

---

## Rendering

> Twitter Lite breaks up expensive rendering work.
> We implemented our own virtualized list component; it only renders the
> content visible within the viewport, incrementally renders items over
> multiple frames using the requestAnimationFrame API, and preserves scroll
> position across screens.

很有效的一种优化，只渲染用户可见的部分。

---

## Data usage

> ..., serving smaller media resources and relying on cached data.
> ... reduces data usage by replacing images in Tweets and Direct Messages with
> a small, blurred preview.
> A HEAD request for the image helps us to display its size alongside a button
> to load it on demand.

展示更小的图片，提供加载全图的按钮。

---

## Design systems and iteration speed

> We rely heavily on flexbox for layout and a small, fixed number of colors,
> font sizes, and lengths.
> Working with UI components has helped us established a shared vocabulary
> between design and engineering that encourages rapid iteration and reuse of
> existing building blocks.

论设计规范和 UI 库的重要性。

> Some of our most complex features, such as mixed-content Timelines, can be
> created from as little as 30 lines of code configuring and connecting a Redux
> module to a React component.

UI 以外的代码做些什么？
能否自动化？

---

## Looking ahead

> experimenting with HTTP/2, GraphQL, and alternative compression formats to
> further reduce load times and data consumption.

积极引入新技术
