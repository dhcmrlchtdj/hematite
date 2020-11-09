# cache policy

https://codeahoy.com/2017/08/11/caching-strategies-and-how-to-choose-the-right-one/
https://en.wikipedia.org/wiki/Cache_(computing)

---

## read strategy

- cache-aside
    - application -> cache [query]
        - [hit]
            - cache -> application [data]
        - [miss]
            - application -> database [query]
            - database -> application [data]
            - application -> cache [write]

- read-through
    - application -> cache [query]
        - [hit]
            - cache -> application [data]
        - [miss]
            - cache -> database [query]
            - database -> cache [data, write]
            - cache -> application [data]

---

## write strategy

- write-around
    - application -> database [data, write]
    - (no cache

- write-through
    - application -> cache [data, write]
    - cache -> database [data, write]

- write-back / write-behind
    - application -> cache [data, write] x N
    - cache -> database [data, write] (batch)
    - (the data may be permanently lost
