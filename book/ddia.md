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


### Data Models and Query Languages

---

由于不同的数据关系，发展出了不同的存储模型

- one-to-many
    - hierarchical model
    - document databases
- many-to-one, many-to-many
    - network model
    - relational model
- many-to-many
    - graph model
        - property graph model
        - triple-store model

---

> If the data in your application has a document-like structure, then it’s probably a good idea to use a document model.
> if your application does use many-to-many relationships, the document model becomes less appealing.
> For highly interconnected data, the document model is awkward, the relational model is acceptable, and graph models are the most natural.

---

> Document databases target use cases where data comes in self-contained documents and relationships between one document and another are rare.
> Graph databases target use cases where anything is potentially related to everything.

---

### Storage and Retrieval

---


