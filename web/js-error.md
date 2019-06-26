# error handling

---

https://www.joyent.com/node-js/production/design/errors
https://github.com/bitinn/node-fetch/blob/master/ERROR-HANDLING.md

---

- programmer error
    - bug in the programs, can be avoided by changing the code
    - where you made a mistake
    - should never happen except in development
    - (fetch) thrown as soon as possible, or rejected with default `Error`
- operational error
    - run-time problem experienced by correctly-written programs
    - what all correct programs must deal with
    - (fetch) rejected with a `FetchError`
    - (fetch) originating from node-fetch are marked with a custom `err.type`
    - (fetch) originating from Node.js core are marked with `err.type = 'system'`

---

感觉列举出来的 programmer error，都是类型系统能覆盖的，根本不应该出现。
而 operational error 则是代码逻辑没有覆盖到的情况，例子看着像是 if/else 没写完整。

---

### handling operational errors

- deal with the failure directly
- propagate the failure to your client
- retry the operation
    - clearly document that you may retry multiple times, how many times you'll
        try before failing, and how long you'll wait between retries
- log the error, and crash
- log the error, and do nothing else

---

### handling programmer errors

- the best way to recover from programmer errors is to crash immediately

---

- when do you use throw, and when do you use callbacks or event emitters
    - Is the error an operational error or a programmer error?
    - Is the function itself synchronous or asynchronous?

- throw programmer errors immediately (synchronously)
- a function may deliver operational errors synchronously or asynchronously,
    but it should not do both.

- it's up to you to define and document what types your function will allow and
    how you'll try to interpret them. If you get something other than what
    you've documented to accept, that's a programmer error. If the input is
    something you've documented to accept but you can't process right now,
    that's an operational error.

---

### recommendations

- be clear about what your function does.
    - types and additional constraints
- Use `Error` objects (or subclasses) for all errors, and implement the `Error` contract.
    - `name` `message` `stack`
- Use the `Error`'s `name` property to distinguish errors programmatically.
- Augment the `Error` object with properties that explain details.
- If you pass a lower-level error to your caller, consider wrapping it instead.
    - wrapping the Error instead of returning it directly
    - includes all of the information from the lower level, plus additional
        helpful context based on the current level
    - preserve all of the properties of the original error
