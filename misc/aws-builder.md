# AWS builder

---

https://aws.amazon.com/builders-library/challenges-with-distributed-systems/

## challenges with distributed systems

- types
    - offline (example: batch processing system, big data analysis cluster, ...
    - soft real-time (example: search index builder, ...
    - hard real-time (example: front-end web server, the order pipeline, credit card transaction, ...

---

https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/

## timeouts, retries, and backoff with jitter

- to build resilient systems, we employ three essential tools
    - timeout
    - retry
    - backoff
- timeout
    - set a timeout on any remote call, and generally on any call across processes even on the same box
    - timeout value, start with the latency metrics of the downstream service
- retry
    - when failures are caused by overload, retries that increase load can make matters significantly worse.
- backoff
    - instead of retrying immediately and aggressively, the client waits some amount of time between tries
    - the most common pattern is an exponential backoff, where the wait time is increased exponentially after every attempt
    - capped exponential backoff (maximum backoff value, exponential functions grow quickly)
        - https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/
        - `sleep = min(cap, base * 2 ** attempt)`
        - full jitter `sleep = random_between(0, min(cap, base * 2 ** attempt))`
        - decorrelated jitter `sleep = min(cap, random_between(base, sleep * 3))`
        - equal jitter `temp = min(cap, base * 2 ** attempt); sleep = temp / 2 + random_between(0, temp / 2)`

- timeouts keep systems from hanging unreasonably long
- retries can mask those failures
- backoff can improve utilization and reduce congestion on systems

---


