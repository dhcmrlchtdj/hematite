# Clean Architecture

---

## design principle

- how to arrange code and data
    - goal
        - tolerate change
        - easy to understand
        - easy to reuse
    - SOLID
        - SRP, The Single Responsibility Principle
        - OCP, The Open-Closed Principle
        - LSP, The Liskov Substitution Principle
        - ISP, The Interface Segregation Principle
        - DIP, The Dependency Inversion Principle

---

## architecture

- by layer
    - horizontal layered architecture
    - the first and simplest design approach
    - adopt such a layered architecture is a good way to get started
    - strict layered architecture, layers should depend only on the next adjacent lower layer
    - relaxed layered architecture, layers are allowed to skip around their adjacent neighbors
- by feature
    - vertical layered architecture
    - based on related features, domain concepts, aggregate roots
    - the top-level organization of the code now screams something about the business domain
- ports and adpters
    - hexagonal architecture
    - boundaries, controllers, entities
    - business/domain-focused code is independent and separate from the technical implementation details
    - code bases being composed of domain and infrastructure
- by component
    - bundle up the business logic and persistence code into a single component
    - inside the component, the separation of concerns is still maintained

> lean on the compiler to enforce architecture principles,
> rather than relying on self-discipline and post-compilation tooling.

（感觉 by layer/feature 就像 expression problem 一样，在可扩展性方面做了不同的取舍。

---

## architecture

---

- development
- deployment
- operation
- maintenance

> good architects design the policy so that decisions about the details can be
> delayed and deferred for as long as possible.

---

- decouple
    - modes
    - use cases / components
    - layers

---

> separation of concerns.
> divide the software into layers.
> at least one layer for business rules, and another layer for user and system interfaces.

- independent of frameworks
- testable
- independent of the UI
- independent of the database
- independent of any external agency

---

- clean architecture
    - entities (critical business rules)
    - use cases (application-specific business rules)
    - interface adapters (gateways, controllers, presenters, ...)
    - frameworks and drivers (UI, DB, web, external interfaces, ...)

> source code dependencies must point only inward, toward higher-level policies.
> nothing in an inner circle can know anything at all about something in an outer circle.
> when we pass data across a boundary, it is always in the form that is most convenient for the inner circle.

---


