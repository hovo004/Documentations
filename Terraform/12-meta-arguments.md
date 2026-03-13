## Terraform Meta-Arguments

Meta-arguments are special arguments that change **how Terraform manages a resource or module**, rather than configuring the underlying provider API.

### Common meta-arguments

- **`count`**: Create multiple instances of the same resource.

```hcl
resource "aws_instance" "web" {
  count         = 2
  instance_type = "t3.micro"
  ami           = var.ami_id
}
```

- **`for_each`**: Create instances from a map or set, giving each instance a stable key.

```hcl
resource "aws_s3_bucket" "b" {
  for_each = toset(["logs", "assets"])
  bucket   = "my-${each.key}"
}
```

- **`depends_on`**: Declare an explicit dependency when Terraform can’t infer it from references.

```hcl
resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  depends_on = [aws_iam_role.app]
}
```

- **`provider`**: Choose a specific provider configuration (useful for multiple regions/accounts).

```hcl
resource "aws_s3_bucket" "eu" {
  provider = aws.eu
  bucket   = "my-eu-bucket"
}
```

- **`lifecycle`**: Control create/update/destroy behavior (use carefully).

`lifecycle` is a special block inside a resource that lets you control **how Terraform performs changes**, for example whether it is allowed to destroy a resource, or whether certain changes should be ignored.

### Lifecycle arguments (short explanation)

- **`create_before_destroy`**: Creates the replacement resource **first**, then destroys the old one. Helpful to reduce downtime, but may fail if the provider requires unique names.
- **When to use**: Load balancers, security groups, launch templates—anything where you prefer zero/minimal downtime.
- **Watch out**: Some resources can’t exist twice (unique names) or have quotas that prevent creating a second copy.

- **`prevent_destroy`**: Blocks accidental deletes. If a plan would destroy the resource, Terraform will error until you remove/disable this setting.
- **When to use**: Critical resources like production databases, state buckets, IAM foundations.
- **Watch out**: If you truly need to delete it, you must first remove `prevent_destroy` (or move the resource out of state).

- **`replace_triggered_by`**: Forces replacement when another resource/attribute changes (useful when changes don’t automatically imply replacement).
- **When to use**: When a downstream resource must be recreated because an upstream change affects it, but Terraform wouldn’t automatically replace it.
- **Watch out**: Overusing it can cause unexpected replacements (and downtime). Keep triggers minimal and intentional.

- **`ignore_changes`**: Tells Terraform to ignore driffs for specific attributes (useful for externally-managed fields), but it can also hide real drift if overused.
- **When to use**: Fields intentionally managed outside Terraform (some tags, timestamps, autoscaler-managed capacity, etc.).
- **Watch out**: You are telling Terraform “don’t fix drift here”, so limit it to only the attributes you truly want to ignore.

```hcl
resource "aws_security_group" "sg" {
  name = "example"

  lifecycle {
    create_before_destroy = true
  }
}
```

More examples:

```hcl
resource "aws_s3_bucket" "important" {
  bucket = "my-important-bucket"

  lifecycle {
    prevent_destroy = true
  }
}
```

```hcl
resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  lifecycle {
    ignore_changes = [
      tags["LastPatched"]
    ]
  }
}
```

```hcl
resource "aws_launch_template" "lt" {
  name_prefix   = "app-"
  image_id      = var.ami_id
  instance_type = "t3.micro"
}

resource "aws_autoscaling_group" "asg" {
  name               = "app-asg"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2

  lifecycle {
    replace_triggered_by = [
      aws_launch_template.lt
    ]
  }
}
```

