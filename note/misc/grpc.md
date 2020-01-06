# gRPC

https://grpc.io/docs/guides/

- use protocol buffers as
    - Interface Definition Language (IDL)
    - underlying message interchange format

- service (gRPC server) - client (gRPC stub)

- gRPC provides both synchronous and asynchronous flavors implements
- gRPC supports unary/streaming RPC
    - `rpc UnaryHello(HelloRequest) returns (HelloResponse);`
    - `rpc ClientStreamHello(stream HelloRequest) returns (HelloResponse);`
    - `rpc ServerStreamHello(HelloRequest) returns (stream HelloResponse);`
    - `rpc BidiStreamHello(stream HelloRequest) returns (stream HelloResponse);`
- life cycle
    - unary RPC
    - server streaming
    - client streaming
    - bidirectional streaming
    - deadlines/timeouts
    - RPC termination
    - cancelling RPCs
    - metadata
    - channels

- authentication

- error handling
    - standard error model
        - supported by all gRPC client/server libraries
        - independent of the gRPC data format (ProtoBuf / JSON / ...)
    - richer error model
        - put error details in trailing response metadata
        - the extended error model may not be consistent across languages

---

https://stackoverflow.com/questions/47238928/rpc-semantics-of-grpc

> gRPC provides at-most-once guarantee by default.
> you've explicitly told gRPC it is okay to replay the RPC.

---

https://www.quora.com/How-should-I-choose-between-gRPC-and-Kafka-when-building-microservices

- if your service calls are synchronous, you don't need a message broker
- if you are passing messages between components which must not be lost, I would use a message broker
- send the same message to more than one service, a pub/sub system is easiest
- when services are decoupled in time, you need a message broker


---

## protobuf

https://developers.google.com/protocol-buffers/docs/overview
https://developers.google.com/protocol-buffers/docs/proto3
