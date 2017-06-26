# Active Record / Data Mapper

---

http://jgaskins.org/blog/2012/04/20/data-mapper-vs-active-record/
https://martinfowler.com/eaaCatalog/activeRecord.html
https://martinfowler.com/eaaCatalog/dataMapper.html
http://culttt.com/2014/06/18/whats-difference-active-record-data-mapper/

---

主要区别就是，数据自己是否知道如何持久化。

---

## acrive record

> Objects manage their own persistence.
> object carries both data and behavior.

```
user = new User()
user.name = 'ha'
user.save()
```

> Active Record style ORMs map an object to a database row.
> simple call the save() method on the object to update the database.

---

## data mapper

> Object persistence is managed by a separate mapper class.
> the in-memory objects needn't know even that there's a database present.

```
user = new User()
user.name = 'ha'
User.persist(user)
```

> Data Mapper style completely separates your domain from the persistence layer.
> Data Mapper model objects are just plain objects that have no knowledge of the database.
> domain objects don't need to know anything about how they are stored in the database.
