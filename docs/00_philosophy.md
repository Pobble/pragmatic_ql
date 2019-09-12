## Philosophy

Most critical part is how to implement the tool not the tool itself.
Incrorectly implemented solution can do more harm so pls read this.


### By default return only ID


When you don't include anythnig you will get only the ID back


`GET /v3/students`

```json
[
  { "id": 123 },
  { "id": 234 },
  { "id": 456 }
]
```


`GET /v3/student/123`

```json
{
  "id": 123
}
```

Even if you require nested associations without any definition you will
get just their IDs

```json
{
  "id": 123,
  "work_list": [
    { "id": 111 },
    { "id": 222 },
  ]
}
```

This is design intention. You want to provide FE with minimum
information as possible. If FE need more than just `id` FE will ask
for it.



### Associations are seperate includes


`?include=student.work_list`

```json
{
  "id": 123,
  "work_list": [
    { "id": 111 },
    { "id": 222 },
  ]
}
```


`?include=student.comment_list`

```json
{
  "id": 123,
  "comment_list": [
    { "id": 999 },
    { "id": 888 },
  ]
}
```

If frontend needs multiple it will ask for it:

`?include=student.comment_list,student.work_list`

```json
{
  "id": 123,
  "comment_list": [
    { "id": 999 },
    { "id": 888 },
  ],
  "work_list": [
    { "id": 111 },
    { "id": 222 },
  ]
}
```

**DON'T** wrap muliple associations into one key


`?include=student.stuff`  DON'T

```json
{
  "id": 123,
  "comment_list": [
    { "id": 999 },
    { "id": 888 },
  ],
  "work_list": [
    { "id": 111 },
    { "id": 222 },
  ]
}
```


