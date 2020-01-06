# http api design

---

https://github.com/interagent/http-api-design/tree/master
https://github.com/paypal/api-standards/blob/master/api-style-guide.md
https://pages.apigee.com/web-api-design-ebook.html

---

## URI component

```
/{version}/
/{version}/{namespace}
/{version}/{namespace}/{resource}/{resource-id}/{sub-resource}/{sub-resource-id}
```

- 直接使用 `/v1` 比在 header 中增加版本号来得更方便

---

## Filtering

- 分页，`page / page_size`，返回 `items / total_items / total_pages`
- 时间，`start_time / end_time / {property_name}_after / {property_name}_before`
- 排序，`sort_by / sort_order=asc / sort_order=desc`

---

## read

- 请求的单个资源不存在时，可以返回 404（请求的列表的话，应该返回空列表
- query 中包含无效的参数时，可以返回 400
- 其他情况返回 200

## updte

- 使用 PUT 替换完整资源，成功时返回 204
- 使用 PATCH 更新部分资源，成功时返回 204

# delete

- DELETE 总是返回 204

# create

- 使用 PUT 创建完整资源，成功返回 201
- 使用 POST 创建资源，成功返回 201
- 区别的话，你有 ID 吗，有 ID 就 PUT，没有就 POST

---

+ 每个实体对应一个 url，url 中使用名词，不要包含动作。
+ 使用 http method 来表示对实体进行某种操作。
    - `PUT` 增
    - `DELETE` 删
    - `POST` 改
    - `GET` 查
+ 复杂修改的时候，使用 url 明确表明这是某种修改
    - `/resource/:id/action/:act`

---

+ 对于部分没有实体的请求，url 中使用动词。
    - `/convert?from=EUR&to=CNY&amount=100`

---

+ 发生错误时，返回 200，在返回值中给出错误信息。
+ 唯一的 `error_code` 配合完整的说明文档。
+ 在 `error_code` 不够用的时候，在 data 中放需要的额外信息。
+ 有错时，`error_code` 为真值，方便判断。

```json
{
    error: [0 | error_code],
    data: [NULL | error_data]
}
```

---

+ 在 url 中给出具体的版本信息。
    - `/api/v1/blah`
    - `/api/v2/blah`

---

+ 使用 `fields` 来精简返回值。
    - `?fields=id,title,author`
+ 如果需要进行更复杂的筛选，感觉不好表达。
    - `?fields=article:(title,date,author:(id,name))`
    - `?fields=article.title,article.date,article.author.id,article.author.name`

---

+ 使用 `limit` 和 `offset` 来翻页。
    - `?limit=10&offset=0`

---

+ 使用 `q` 进行关键字搜索。
    - `?q=blah+blah`

---

+ 允许使用 `method` 来指定 http method
    - `?method=delete`

---

+ 使用 OAuth2.0 进行身份认证
