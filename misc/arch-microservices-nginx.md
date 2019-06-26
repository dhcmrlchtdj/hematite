# microservices

---

现在还在说微服务，会不会有过时的感觉哈

---

https://www.nginx.com/blog/introducing-the-nginx-microservices-reference-architecture/

---

- monolithic architecture, communicate in the memory
- microservices architecture, communicate over the network

---

- networking models
    - proxy model
        - 适合简单的 API 服务，在负载均衡方面不是很好扩展
        - nginx 在最外层拦截请求，分发到内部服务
        - 服务发现使用依靠 DNS
        - 服务之间可以相互通信，直接相连
    - router mesh model
        - 负载均衡的能力更强
        - 最外层的 nginx 拦截请求后，还有一个内部的 nginx 来统一分发请求
        - 服务间通信都经过内部 nginx，不再两两互相通信
        - 有中心节点做调度，对中心节点稳定性的要求就更高了
    - fabric model
        - 每个服务节点，都有一个 nginx 顶着，不直接对外暴露
        - 这个 nginx 做服务发现、负载均衡、健康检查等
        - 加一个 zookeeper 做记录集群的信息

---

- capability
    - caching
    - load balancing
    - low-latency connectivity
    - high availablity
    - rate limiting / WAF
    - health checks
    - SSL/TLS termination
    - HTTP/2 support
    - central communications point for services
    - dynamic service discovery
    - API gateway capability

---

https://www.nginx.com/blog/introduction-to-microservices/

---

- monolithic
    - at first
        - simple to test
        - simple to deploy
        - simple to scale
    - then
        - difficult to understand
        - difficult to maintain
        - difficult to scale

- microservices
    - benefits
        - tackle the problem of complexity
        - can be developed independently
        - can be deployed independently
        - can be scaled independently
    - drawbacks
        - the term microservice places excessive emphasis on service size
        - a microservices application is a distributed system
        - the partitioned database architecture
        - testing
        - need to carefully plan and coordinate the rollout of changes to each of the services
        - deploying

---

> A Monolithic architecture only makes sense for simple, lightweight applications
> The Microservices architecture pattern is the better choice for complex, evolving applications

---

- API gateway
    - API Gateway acts as a single entry point into a system
    - design issues
        - Performance and Scalability
        - Reactive Programming Model
        - Service Invocation
            - asynchronous, messaging-based mechanism (MQ)
            - synchronous mechanism (RPC)
        - Service Registry / Service Discovery
        - Handling Partial Failures

---

- IPC
    - how services interact
        - 1:1 or 1:N
        - synchronous or asynchronous
    - asynchronous, message-based communication
        - decouples the client from the service
        - message buffering
        - flexible client-service interactions
        - explicit inter-process communication
        - additional operational complexity
        - complexity of implementing request/response-based interaction
    - Synchronous, Request/Response IPC

---

- Service Discovery
    - client-side discovery
        - client query the service registry to get all locations of service
    - server-side discovery
        - client make requests to load balancer, the load balancer queriesthe service registry
        - details of discovery are abstracted away from the client
- Service Registry
    - a database containing the network locations of service instances
    - self-registration pattern
        - simple
        - couples the service instances to the service registry
        - must implement the registration code in each programming language and framework
    - third-party registration pattern
        - tracks changes to the set of running instances by either polling the deployment environment or subscribing to events

---

- Distributed Data Management
