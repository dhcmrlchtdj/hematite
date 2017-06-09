# reinvent FRP

---

http://vindum.io/blog/lets-reinvent-frp/

---

We will go back to the roots of FRP to figure out what it is really about.
We will see what problem FRP was made to solve and how it solves it.
To do so we will consider the underlying principles behind its design.

---

## goal

The “reactive” means that we want to write programs that react to user input
FRP is also inherently about time.

---

A behavior is a function from time to a value.

A stream is a list of records where each record contains a time value and a data value.
The records should be ordered increasingly by their time.

stream 可以是生产者 push，但 behavior 生产者只能等着被 pull 吧

A stateful behavior is behavior whose current value depends on the past.

