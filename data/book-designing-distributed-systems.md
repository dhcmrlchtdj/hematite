# designing distributed systems

---

## single-node patterns

- sidecar
    - two containers, application + sidecar
    - example: add https to a legacy service
        - request -> ssl proxy (sidecar) -> server (application)
    - example: configuration synchronization
        - sidecar
            - sync config from config service
            - update local config file
            - notify application
        - application
            - read local config file
    - used for adaptation, monitor, and so on
- ambassador
    - two containers, application + ambassador
    - ambassador brokers interactions between the application and the rest of the world
    - example: mysql service broker
- adapter
    - example: logging, health monitor

---

## multi-node distributed patterns

- replicated load-balanced services
    - exampe: load balancer
        - request -> load balancer -> replica1,replica2,replica3
        - stateless, scale up
    - example: session layer, cacheing layer
- sharded services
    - example: sharded caching
- scatter, gather
- event-driven
- ownership election

---

## batch computational patterns

- worker queue

---

# review

不推荐

- 可能有三分一是 k8s 配置或类似的东西？
- 其他部分也没有眼前一亮的感觉
- 看下目录就差不多了
