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

## the what, where, when, and how of data processing

> the core set of principles and concepts required for robust out-of-order data processing

> if you care about both correctness and the context within which events
> actually occurred, you must analyze data relative to their inherent event
> times, not the processing time at which they are encountered during the
> analysis itself.

- concepts
    - processing time, event time
    - windowing
    - trigger
        - a mechanism for declaring when the output for a window should be materialized relative to some external singal
    - watermark
        - a notion of input completeness with respect to event times
    - accumulation
        - a mode specifies the relationship between multiple results that are observed for the same window

- questions, critical to every unbounded data processing
    - what results are calculated
    - where in event time are results calculated
    - when in processing time are results materialized
    - how to refinements of results relate

- batch processing
    - what, transformations
    - where, windowing

- streaming processing
    - when, triggers plus watermarks
        - triggers
            - triggers provide the answer to the when question
            - there are only two useful types of triggers
                - repeated update triggers
                - completeness triggers
        - watermarks
            - it is an assertion, no more data with smaller event time will ever be seen again
            - types: perfect watermarks, heuristic watermarks
            - watermark is completeness trigger
        - lateness
    - how, accumulation
        - modes
            - discarding
            - accumulating
            - accumulating and retracting
        - example
            - input: `pane1=[3], pane2=[8,1]`
            - discarding: `r1=3, r2=9`
            - accumulating: `r1=3, r2=12`
            - accumulating and retracting: `r1=3, r2=[12,-3]`

---

## watermarks



---

## streams and tables

- two orthogonal dimensions of data
    - cardinality (bounded vs unbounded)
    - constitution (stream vs table)
- the special theory of stream and table relativity
    - tables are data at rest
        - stream -> table, the table is just the result of applying the log
        - table is the snapshot
    - streams are data in motion
        - table -> stream, a stream is a changelog for a table
        - stream is the log
    - operations act upon a stream or table
        - stream -> stream, non-grouping operations
        - stream -> table, grouping operations
        - table -> stream, ungrouping (triggering) operations
        - table -> table, none

- map-reduce
    - TABLE -> MapRead -> STREAM -> Map -> STREAM -> MapWrite -> TABLE -> ReduceRead -> STREAM -> Reduce -> STREAM -> ReduceWrite -> TABLE
    - map 和 reduce 的输入输出是 table，处理过程中是 stream

---


