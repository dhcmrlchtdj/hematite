# streaming systems

---

## streaming 101

- event time VS processing time
    - it will be much easier if you don't care about event times
    - time skew, between event time and processing time

- pattern
    - bounded data
    - unbounded data (batch)
        - fixed windows (tumbling windows)
        - sessions
            - sessions are typically defined as a periods of activity terminated by a gap of inactivity
    - unbounded data (streaming)
        - time-agnostic (all relevant logic is data driven)
            - filtering
            - inner joins
        - approximation (process elements as they arrive, time element is usually processing-time based
        - windowing
            - window
                - fixed windows (tumbling windows)
                - sliding windows (hopping windows)
                - sessions
            - windowing by processing time (it is simple and straightforward)
            - windowing by event time
                - require more buffer data
                - estimate the window completion via watermarks

---

## The What, Where, When, and How of Data Processing







