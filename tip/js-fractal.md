# fractal

---

https://github.com/staltz/cycle-onionify

---

> "Fractal" means that every component in the hierarchy is built in the same way as the top-level main function is built.

我也认为分型的结构更易于组合、易于理解。
关键就是具体的代码组合方式了。

---

这个工具做的事情，还是状态一层层进来，再一层层出去。


> All the state in your application should live in the state stream managed internally by onionify.

> With onion-layered state, there is no distinction between props and state because both are encoded in the large state tree.

> reducer functions and a single state atom
> contain all of your application state in one large tree of objects and arrays
> To update any part in that state tree, you write reducer functions: pure functions that take previous state as argument and return new state.

> there is no global entity in the onion state architecture
> any component is written in the same way without expecting any global entity to exist
> As a result, you gain reusability: you can take any component and run it anywhere else because it's not tied to any global entity.

---

> This may lead to cases where you read the source code for the child component, but cannot be sure how does that state behave over time, since the parent may be modifying it dynamically and concurrently.

> The state vs props distinction makes the parent-child boundary explicit, making it possible for the child component to regulate which props from the parent does it allow or reject. With onionify, the child cannot protect its state from being tampered by the parent in possibly undesireable ways.

> In practice, the developer should just be careful to avoid invasive child state updates from the parent. Try to contain all child state updates in the child component, while occasionally allowing the parent to update it too.
