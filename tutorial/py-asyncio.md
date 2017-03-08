# asyncio

---

https://www.python.org/dev/peps/pep-3156/

---

- transport: how bytes are transmitted
- protocol: which bytes to transmit (and to some extent when)

- transport: abstraction for a socket (or similar I/O endpoint)
- protocol: abstraction for an application

- transport: abstract interface for using network I/O
- protocol: abstract interface for using interprocess I/O

- transport
	- plain socket transport
	- SSL/TLS transport
