# Modules

**`Modules are containers`** for multiple `resources` that are used together. A module consists of a collection of **.tf**, **.tofu**, **.tf.json**, and/or **.tofu.json** files that are kept together in a directory.

Modules are the main way to package and `reuse resource configurations` with OpenTofu.

## Creating Modules

The .tf and/or .tofu files in your working directory when you run tofu plan or tofu apply together form the root module. That module may call other modules and connect them together by passing output values from one to input values of another.

### Module structure

**Re-usable modules** are defined using all of the same configuration language concepts we use in root modules. Most commonly, modules use:

* **Input variables** to accept values from the calling module.
* **Output values** to return results to the calling module, which it can then use to populate arguments elsewhere.
* **Resources** to define one or more infrastructure objects that the module will manage.

## When to write a module

In principle any combination of resources and other constructs can be factored out into a module, but over-using modules can make your overall OpenTofu configuration harder to understand and maintain, so we recommend moderation.

## Module Composition

```sh
resource "aws_vpc" "example" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id = aws_vpc.example.id

  availability_zone = "us-west-2b"
  cidr_block        = cidrsubnet(aws_vpc.example.cidr_block, 4, 1)
}
```
===>
```sh
module "network" {
  source = "./modules/aws-network"

  base_cidr_block = "10.0.0.0/8"
}

module "consul_cluster" {
  source = "./modules/aws-consul-cluster"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.subnet_ids
}
```
## Dependency Inversion

```sh
data "aws_vpc" "main" {
  tags = {
    Environment = "production"
  }
}

data "aws_subnet_ids" "main" {
  vpc_id = data.aws_vpc.main.id
}

module "consul_cluster" {
  source = "./modules/aws-consul-cluster"

  vpc_id     = data.aws_vpc.main.id
  subnet_ids = data.aws_subnet_ids.main.ids
}
```

## Conditional Creation of Objects

```sh
# In situations where the AMI will be directly managed:

resource "aws_ami_copy" "example" {
  name              = "local-copy-of-ami"
  source_ami_id     = "ami-abc123"
  source_ami_region = "eu-west-1"
}

module "example" {
  source = "./modules/example"

  ami = aws_ami_copy.example
}
```

```sh
# Or, in situations where the AMI already exists:

data "aws_ami" "example" {
  owner = "9999933333"

  tags = {
    application = "example-app"
    environment = "dev"
  }
}

module "example" {
  source = "./modules/example"

  ami = data.aws_ami.example
}
```

## Assumptions and Guarantees
* **Assumption**: A condition that must be true in order for the configuration of a particular resource to be usable. For example, an aws_instance configuration can have the assumption that the given AMI will always be configured for the x86_64 CPU architecture.
* **Guarantee**: A characteristic or behavior of an object that the rest of the configuration should be able to rely on. For example, an aws_instance configuration can have the guarantee that an EC2 instance will be running in a network that assigns it a private DNS record.

The following examples creates a precondition that checks whether the EC2 instance has an **encrypted root volume**.

```sh
output "api_base_url" {
  value = "https://${aws_instance.example.private_dns}:8433/"

  # The EC2 instance must have an encrypted root volume.
  precondition {
    condition     = data.aws_ebs_volume.example.encrypted
    error_message = "The server's root volume is not encrypted."
  }
}
```
## Multi-cloud Abstractions

through composition of modules it is possible to create your own lightweight multi-cloud abstractions by making your own tradeoffs about which platform features are important to you.

Opportunities for such abstractions arise in any situation where multiple vendors implement the same concept, protocol, or open standard. For example, the basic capabilities of the domain name system are common across all vendors, and although some vendors differentiate themselves with unique features such as geolocation and smart load balancing, you may conclude that in your use-case you are willing to eschew those features in return for creating modules that abstract the common DNS concepts across multiple vendors:

```sh
module "webserver" {
  source = "./modules/webserver"
}

locals {
  fixed_recordsets = [
    {
      name = "www"
      type = "CNAME"
      ttl  = 3600
      records = [
        "webserver01",
        "webserver02",
        "webserver03",
      ]
    },
  ]
  server_recordsets = [
    for i, addr in module.webserver.public_ip_addrs : {
      name    = format("webserver%02d", i)
      type    = "A"
      records = [addr]
    }
  ]
}

module "dns_records" {
  source = "./modules/route53-dns-records"

  route53_zone_id = var.route53_zone_id
  recordsets      = concat(local.fixed_recordsets, local.server_recordsets)
}
```
```sh
module "k8s_cluster" {
  source = "modules/azurerm-k8s-cluster"

  # (Azure-specific configuration arguments)
}

module "monitoring_tools" {
  source = "modules/monitoring_tools"

  cluster_hostname = module.k8s_cluster.hostname
}
```
