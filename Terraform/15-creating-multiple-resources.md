# Creating Multiple Resources

## count

Creates N copies of a resource. Access the current index with `count.index`.
```hcl
resource "aws_instance" "server" {
  count = 3
  tags  = { Name = "server-${count.index}" }
}
```

---

## for_each

Creates one resource per item in a map or set. Access current item with `each.key` and `each.value`.
```hcl
resource "aws_instance" "server" {
  for_each = { dev = "t3.micro", prod = "t3.large" }
  instance_type = each.value
  tags          = { Name = each.key }
}
```

---

## count vs for_each

| | `count` | `for_each` |
|---|---------|------------|
| Input | Number | Map or Set |
| Reference | `count.index` | `each.key`, `each.value` |
| Best for | Identical resources | Resources with distinct config |

> 📌 Prefer `for_each` over `count` when resources have different configurations — it avoids index shifting when items are removed.