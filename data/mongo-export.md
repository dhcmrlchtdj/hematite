# mongo export

---

https://stackoverflow.com/questions/12976145/mongoexport-without-id-field

---

- `mongo <url>/<db-name> --quiet --eval "db.getCollectionNames()"`
- `mongoexport --db <db-name> --collection <collection-name> --out out.json`

---

- `mongo <url>/<db-name> --quiet --eval "db.collection.find({}, {_id:0}).forEach(printjson);"`
