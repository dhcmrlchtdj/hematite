# Dependency Injection

---

https://github.com/glimmerjs/glimmer-di

---

对 DI 的理解
- SOLID 中的 D，是一个解耦的方式
- 需要先进行架构的分层，明确了依赖关系，然后才轮到 DI 出场吧（？）
- 能避免对全局变量的依赖
    - 最大的好处，应该是可以实现对模块独立测试
    - 不过像异步记录 log 的场景，全局变量对解耦更有好处，否则 context 需要在所有代码中传递

---

用 glimmer 的例子来说

在使用 DI 之前，代码是这样的

```typescript
// hello-world-server.ts
import HTTPServer from "./servers/http";

export default class HelloWorldServer {
  constructor() {
    let server = new HTTPServer({
      port: 80
    });

    server.on('request', req => {
      req.write("<html><body>Hello, world!</body></html>");
    });
  }
}

// main.ts
import HelloWorldServer from "./hello-world-server";
new HelloWorldServer();
```

在使用 DI 之后，代码是这样的

```typescript
// hello-world-server.ts
export default class HelloWorldServer {
  constructor(server) {
    server.on('request', req => {
      req.write("<html><body>Hello, world!</body></html>");
    });
  }
}

// main.ts
import HTTPServer from "./servers/http";
import HelloWorldServer from "./hello-world-server";
let httpServer = new HTTPServer({
  port: 80
});
new HelloWorldServer(httpServer);
```

对比这两个例子，从代码量、代码内容来说，差别不那么大。
比较明显的就是 `hello-world-server.ts` 里逻辑更纯粹了。
就像前面说的，全局变量变成了局部变量，让我们可以对模块进行独立测试。
同时，对不同模块提出了更高的要求，作为参数的 server 要满足特定的接口。
（例子中是 `on('request',...)`

总之，用这种方式来组织代码、处理模块依赖关系，就是所谓的依赖注入了。

---

- registry
- container
- injection

所有服务都到 registry 注册，然后消费者从 container 寻找需要的服务。
injection 是依赖这种中心化实现的额外功能，自动给服务设置依赖。

例子

```typescript
// register component
import ProfileComponent from './components/profile';
registry.register('component:profile', ProfileComponent);

// register store
import DataStore from "./data/store";
registry.register('store:main', DataStore);
registry.registerInjection('component', 'store', 'store:main');

// while new component created
let component = container.lookup('component:profile');
// let store = container.lookup('store:main');
// return ProfileComponent.create({ store });
```

在消费者获取 `component` 的时候，会自动为 `component` 注入 `store`

---

glimmer 还提到了 resolver，这个属于更高层次的代码结构组织约定。
通过规范目录结构，container 来寻找、加载服务对应的实现，不需要模块自己去 register。
