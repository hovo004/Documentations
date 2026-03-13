## Terraform Resource Dependencies

Terraform builds a **dependency graph** between resources so that they are created, updated, and destroyed in a safe order. Dependencies can be **implicit** (inferred from references) or **explicit** (declared with `depends_on`).

### Implicit dependencies

Terraform automatically detects dependencies whenever one resource uses attributes from another:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id  # creates an implicit dependency
  cidr_block = "10.0.1.0/24"
}
```

Here, the subnet **depends on** the VPC because it references `aws_vpc.main.id`. Terraform will always create the VPC before the subnet, and destroy the subnet before the VPC.

### Simple dependency graph diagram

```text
Nodes = resources, arrows = "depends on"

aws_vpc.main
   |
   v
aws_subnet.public
   |
   v
aws_instance.app
```

### Explicit dependencies (`depends_on`)

Sometimes you need to tell Terraform about a dependency that is **not visible from attribute references**, for example when using modules, provisioners, or external resources:

```hcl
resource "aws_iam_role" "app" { ... }

resource "aws_instance" "app" {
  # no direct attribute reference to the role in this example

  depends_on = [
    aws_iam_role.app
  ]
}
```

`depends_on` forces Terraform to treat `aws_iam_role.app` as a prerequisite for `aws_instance.app`, even if no attributes are referenced.

### Why dependencies matter

- **Correct ordering**: Ensures resources are created and destroyed in a safe sequence.
- **Accurate plans**: The dependency graph lets Terraform understand what can be changed in parallel and what must be serialized.
- **Stability**: Reduces race conditions and errors caused by resources being created or removed too early.

