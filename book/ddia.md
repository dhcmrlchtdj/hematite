# Designing Data-Intensive Applications

---

https://dataintensive.net/

---

## Foundations of Data Systems

---

### Reliable, Scalable, and Maintainable Applications

---

- functional requirements
    - store, retrieve, search, process
- nonfunctional requirements
    - security, reliability, compliance, scalability, compatibility, maintainability

---

- Reliability means making systems work correctly, even when faults occur
    - faults: hardware, software, human
- Scalability means having strategies for keeping performance good, even when load increases
    - we first need ways of describing load and performance quantitatively
    - percentiles(p50,p95,p99,p999) are open used in SLO and SLA
    - measure response times on the client side
    - scaling up (vertical) / scaling out (horizontal), shared-nothing architecture
    - elastic: automatically add computing resources when they detect a load increase
- Maintainability (in essence) is about making life better for the engineering and operations teams who need to work with the system
    - good abstractions can help reduce complexity and make the system easier to modify and adapt for new use cases
    - good operability means having good visibility into the system’s health, and having effective ways of managing it

---



