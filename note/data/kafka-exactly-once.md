# kafka exactly-once

https://www.confluent.io/blog/exactly-once-semantics-are-possible-heres-how-apache-kafka-does-it/

---

> Depending on the action the producer takes to handle such a failure,
> you can get different semantics: at-least-once / at-most-once / exactly-once
这里是 producer 视角，也就 client 发出数据，kafka broker 接收数据。

---

> idempotence: exactly-once in order semantics per partition

> The producer send operation is now idempotent.
producer 要实现 at-least-once 是比较容易的。
在这个基础上实现 exactly-once，其实就是要求 send 这个操作是幂等的。

> Under the covers, it works in a way similar to TCP:
> each batch of messages sent to Kafka will contain a sequence number that
> the broker will use to dedupe any duplicate send
通过在 broker 记录每个操作的编号并对操作去重，借此达到幂等。

---

> transactions: atomic writes across multiple partitions

> commit your consumer offsets in the same transaction along with the data
> you have processed, thereby allowing end-to-end exactly-once semantics.
通过 kafka 内部的事物 API 实现原子操作。
（我没明白，这怎么就 exactly-once 了

---

> exactly-once stream processing in Apache Kafka

> exactly-once semantics is guaranteed within the scope of Kafka Streams'
> internal processing only
