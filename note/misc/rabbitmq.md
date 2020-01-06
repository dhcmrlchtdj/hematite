# Rabbit MQ

---

https://www.rabbitmq.com/getstarted.html

---

> RabbitMQ is a message broker: it accepts and forwards messages.
> RabbitMQ is a post box, a post office and a postman.

---

- A producer is a user application that sends messages.
- A queue is a buffer that stores messages.
- A consumer is a user application that receives messages.
- An exchange receives messages from producers and pushes them to queues.

---

> The main idea behind Work Queues (aka: Task Queues) is to avoid doing a
> resource-intensive task immediately and having to wait for it to complete.

> One of the advantages of using a Task Queue is the ability to easily
> parallelise work.

---

> The producer never sends any messages directly to a queue.
> Instead, the producer can only send messages to an exchange.
