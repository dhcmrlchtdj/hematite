# system design interview

https://systeminterview.com/

---

- horizontal scaling
- load balance
- database replication
- cache
- CDN
- stateless web tier
- data centers
- message queue
- logging, metrics, automation
- database scaling
    - sharding

开篇是些很常见的主题

---

- understand the problem and establish design scope (3-10 min)
    - questions
        - What specific features are we going to build?
        - How many users does the product have?
        - How fast does the company anticipate to scale up? What are the anticipated scales in 3 months, 6 months, and a year?
        - What is the company’s technology stack? What existing services you might leverage to simplify the design?
    - the interviewer may ask you to make your assumptions.
        - write down your assumptions on the whiteboard or paper
- propose high-level design and get buy-in (10-15 min)
    - develop a high-level design
        - and **reach an agreement** with the interviewer on the design
    - go through a few concrete use cases
    - think out loud. communicate with your interviewer.
- design deep dive (10-25 min)
    - You shall work with the interviewer to identify and prioritize components in the architecture.
    - Time management is essential. Try not to get into unnecessary details.
- wrap up, (3-5 min)
    - a recap of your design
    - identify the system bottlenecks and discuss potential improvements
    - error cases (server failure, network loss, etc.)
    - Operation issues are worth mentioning. How do you monitor metrics and error logs? How to roll out the system?

设计系统时由上至下

---

- Design a Chat System (Facebook messenger, Whatsapp)
- Design a Video Streaming Service (YouTube, Netflix)
- Design a Key-value Store
- Design a URL shortener
- Design a Web Crawler
- Design a Shared Cloud Drive (Google Drive, Dropbox)
- Design a News feed System
- Design a Search Autocomplete System
- Design a Notification System
- Design a scalable system that supports millions of users

常见的设计问题
