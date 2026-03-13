## 1. Operators

### Math
| Operator | Description |
|----------|-------------|
| `+` | Addition |
| `-` | Subtraction |
| `*` | Multiplication |
| `/` | Division |
| `%` | Modulo |
---
### Equality
| Operator | Description |
|----------|-------------|
| `==` | Equal |
| `!=` | Not equal |
---
### Comparison
| Operator | Description |
|----------|-------------|
| `<` | Less than |
| `>` | Greater than |
| `<=` | Less than or equal |
| `>=` | Greater than or equal |
---
### Logical
| Operator | Description |
|----------|-------------|
| `&&` | And |
| `\|\|` | Or |
| `!` | Not |




## 2. For Expression

A `for` expression transforms a collection into a new collection.
```hcl
# List → List
[for item in var.names : upper(item)]

# List → Map
{for item in var.names : item => upper(item)}

# Map → List
[for key, value in var.tags : "${key}=${value}"]
```

> 📌 Use `[ ]` to produce a list, use `{ }` to produce a map.


## Duplicate Keys

By default, duplicate keys throw an error. Use `...` after the value to group them into a list.
```hcl
{for item in var.users : item.role => item.name...}
```
```hcl
# Result
{
  admin = ["alice", "bob"]
  dev   = ["carol"]
}
```

You can also filter with `if`:
```hcl
[for item in var.names : item if item != "admin"]
```

# Splat Expression

A shorthand to extract a single attribute from a list of objects.
```hcl
var.users[*].name
```

This is equivalent to:
```hcl
[for item in var.users : item.name]
```

> 📌 Use `[*]` for lists. For a single object, Terraform will wrap it into a list automatically.

---

##  In Terraform we can't create our functions

https://developer.hashicorp.com/terraform/language/functions