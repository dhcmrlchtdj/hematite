# hapi

---

## performance

https://gist.github.com/hueniverse/a3109f716bf25718ba0e

---

> While this is not a design pattern I would choose, it is simple and elegant.
> It keeps the entire framework codebase minimal and consistent with its architecture.

> In hapi, we limit the types of routes you can add so that we can enforce strict limits on conflicts.

限制反而有益。
所谓框架，本就是戴着镣铐舞蹈。

---

## plugin

https://gist.github.com/hueniverse/f01faf422eb038d87d57

---

- Plugins are designed for two main purposes
    - Break a large code base into smaller pieces to facilitate easier team collaboration
    - Provide flexibility in deployment configuration
    - plugins help manage complex configuration
- Don't use plugins
    - when simple node modules are enough
    - when all you are trying to do is share state across your application
