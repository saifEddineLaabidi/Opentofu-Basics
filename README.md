# OpenTofu
- [opentofu registry](https://search.opentofu.org/)
- [Why OpenTofu](https://opentofu.org/docs/v1.6/intro/use-cases/)
- [Manifesto](https://opentofu.org/manifesto)
- [About the OpenTofu fork](https://opentofu.org/fork)
- [How to install](https://opentofu.org/docs/intro/install)
- [How to install in Windows](https://github.com/opentofu/opentofu/releases?ref=blog.ippon.fr)
- [Join our Slack community!](https://opentofu.org/slack)

## Getting help and contributing

- Have a question? Post it in [GitHub Discussions](https://github.com/orgs/opentofu/discussions) or on the [OpenTofu Slack](https://opentofu.org/slack/)!
- Want to contribute? Please read the [Contribution Guide](CONTRIBUTING.md).
- Want to stay up to date? Read the [weekly updates](WEEKLY_UPDATES.md), [TSC summary](TSC_SUMMARY.md), or join the [community meetings](https://meet.google.com/xfm-cgms-has) on Wednesdays at 14:30 CET / 8:30 AM Eastern / 5:30 AM Western / 19:00 India time on this link: https://meet.google.com/xfm-cgms-has ([📅 calendar link](https://calendar.google.com/calendar/event?eid=NDg0aWl2Y3U1aHFva3N0bGhyMHBhNzdpZmsgY18zZjJkZDNjMWZlMGVmNGU5M2VmM2ZjNDU2Y2EyZGQyMTlhMmU4ZmQ4NWY2YjQwNzUwYWYxNmMzZGYzNzBiZjkzQGc))

> For more OpenTofu events, subscribe to the [OpenTofu Events Calendar](https://calendar.google.com/calendar/embed?src=c_3f2dd3c1fe0ef4e93ef3fc456ca2dd219a2e8fd85f6b40750af16c3df370bf93%40group.calendar.google.com)!

![ScreenShot](/assets/Capture.PNG)

**OpenTofu** is an infrastructure as code tool that lets you define infrastructure resources in human-readable configuration files that you can version, reuse, and share. You can then use a consistent workflow to safely and efficiently provision and manage your infrastructure throughout its lifecycle.

# Key features of OpenTofu:

- **Modularity** – encourages modular design, making it easy to reuse code.
- **Declarative configuration** – define the end state of the infrastructure and OpenTofu will take care of it.
- **State management and encryption** – maintains and gives the ability to encrypt the state.
- **Community-driven** – developed and maintained by a community of contributors that listens to people’s needs and prioritizes new features based on a ranking system that users can directly

## Basic Commands

Next, let’s talk about some of the basic commands for OpenTofu. If you are familiar with Terrafrom, these will be instantly familiar. 

**`tofu init`** - Initiates your OpenTofu project by running tofu init, which downloads cloud provider plugins  (commonly AWS, Azure, GCP), and modules, and configures the backend as specified in your setup. [same as terraform init](https://www.env0.com/blog/terraform-init)

**`tofu plan`** - Analyzes your configuration, assesses existing infrastructure, and details changes that would be taking place in your infrastructure. 

**`tofu apply`** - Starts the process of infrastructure provisioning. Before creating infrastructure, OpenTofu generates a 'terraform.tfstate' file, which has metadata regarding the provisioned infrastructure.

## [Migrating to OpenTofu from Terraform 1.6.x](https://opentofu.org/docs/v1.6/intro/migration/terraform-1.6/)
[Terraform 1.7.x](https://opentofu.org/docs/v1.7/intro/migration/terraform-1.7/)
[Terraform 1.8.x](https://opentofu.org/docs/v1.7/intro/migration/terraform-1.8/)

1. Prepare a disaster recovery plan

Although OpenTofu 1.6.2 is very similar to Terraform 1.6.6, make sure you have an up to date and tested disaster recovery plan.

2. Upgrading Terraform To 1.6.6
3. Apply all changes with Terraform 

```sh
$ terraform plan

...

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your
configuration and found no differences, so no changes are needed.
```

3. Install OpenTofu 1.6.2

```sh
$ tofu --version
OpenTofu v1.6.2
on linux_amd64
```
4. Back up your state file and code
5. Code changes

If you are using the **`skip_s3_checksum`** option on the S3 backend, remove this option as OpenTofu does not need it.

If you are using the **`endpoints → sso`** option or the **`AWS_ENDPOINT_URL`** environment variable, remove this option and verify if your code still works as intended after the migration.

6. Initialize OpenTofu **tofu init**
7. Inspect the plan **tofu plan**
8. Apply **tofu apply** (Even though there should be no changes in your infrastructure) 
9. **tofu apply** with a smaller, non-critical change.
10. Upgrade to the latest OpenTofu version

## What's new in OpenTofu 1.7

### State encryption

**State encryption** has long been one of Terraform’s most requested features, but it was never delivered. However, after just six months in existence, the OpenTofu team has listened to the community and released, state encryption.

**OpenTofu’s encryption** mechanism allows you to encrypt both your state files and your plan files. 

1. **Why should you encrypt your state file?**

**Encrypting your state** and plan files is **critical in infrastructure management** because they often contain sensitive information such as **credentials, access keys**, and configurations. If these are exposed, your infrastructure can have serious problems, which could lead to severe security breaches. 

2. **How does OpenTofu state encryption work?**

**OpenTofu state encryption** works through robust **encryption methods and key providers**. It currently supports the following key providers:  **`PBKDF2, AWS KMS, GCP KMS, and OpenBao in beta`**. The encryption method can be either AES-GCM or unencrypted (used only for explicit migration to and from encryption). AES-GCM ensures data integrity by making any unauthorized changes detectable, making your IaC secure and reliable.

OpenTofu uses these mechanisms to encrypt your state data at rest. **`If you enable it, you won’t be able to recover the state/plan files without the appropriate encryption key`**.

3. **How to configure state encryption?**

* **key_provider** – **Specifies the key provider for the encryption**, can be PBKDF2, AWS KMS, GCP KMS, orOpenBao. Depending on which key provider you select, you will have different configuration options.
* **method** – The encryption method to be used, currently the option is AES-GCM which permits 16, 24, and 32-byte keys.
* **state and/or plan** – Here you specify the encryption method and a fallback option because OpenTofu lets you automatically roll over your encryption configuration to an old one by having this fallback option.
* **remote_state_data_source** – You have the option to also configure encryption for remote state that you leverage through the “terraform_remote_state” datasource.

```sh
terraform {
 encryption {
   key_provider "pbkdf2" "migration_key" {
     passphrase    = "super-passphrase-hard-to-find"
     key_length    = 32
     salt_length   = 16
     hash_function = "sha256"
   }
   method "aes_gcm" "secure_method" {
     keys = key_provider.pbkdf2.migration_key
   }
   state {
     method = method.aes_gcm.secure_method
   }
 }
}

resource "random_pet" "one" {}
```
```sh
tofu apply

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
 OpenTofu will perform the actions described above.
 Only 'yes' will be accepted to approve.

 Enter a value: yes

random_pet.one: Creating...
random_pet.one: Creation complete after 0s [id=glad-bat]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
```json
{
   "serial": 1,
   "lineage": "92dada5a-e8a8-b917-73b0-25a9a8e19714",
   "meta": {
       "key_provider.pbkdf2.migration_key": "..."
   },
   "encrypted_data": "RL…",
   "encryption_version": "v0"
}
```
```sh
tofu state list
random_pet.one
```
Let’s change the passphrase and try to run the command again:
```sh
tofu state list
Failed to load state: decryption failed for all provided methods: attempted decryption failed for state: decryption failed: cipher: message authentication failed
```

4. **Configure state encryption through AWS KMS**

``` sh
terraform {
 encryption {
   key_provider "aws_kms" "kms_key" {
     kms_key_id = "18370188-.."
     key_spec   = "AES_256"
     region     = "eu-west-1"
   }
   method "aes_gcm" "secure_method" {
     keys = key_provider.aws_kms.kms_key
   }
   state {
     method = method.aes_gcm.secure_method
   }
 }
}

resource "random_pet" "one" {}
```
Repeat the init/apply steps, and then check the state file:

```json
{
   "serial": 1,
   "lineage": "d97396a4-7d24-aa29-add7-22abf0a563d8",
   "meta": {
       "key_provider.aws_kms.kms_key": ".."
   },
   "encrypted_data": "...,
   "encryption_version": "v0"
}
```

5. **State encryption with Spacelift**

```sh
terraform {
 backend "remote" {
   hostname     = "spacelift.io"
   organization = "saturnhead"

   workspaces {
     name = "tofu_state_encryption"
   }
 }
 encryption {
   key_provider "aws_kms" "kms_key" {
     kms_key_id = "18370188-.."
     key_spec   = "AES_256"
     region     = "eu-west-1"
   }
   method "aes_gcm" "secure_method" {
     keys = key_provider.aws_kms.kms_key
   }
   state {
     method = method.aes_gcm.secure_method
   }
 }
}
```

6. **GCP KMS**

```
terraform {
  encryption {
    key_provider "gcp_kms" "basic" {
      kms_encryption_key = "projects/local-vehicle-id/locations/global/keyRings/ringid/cryptoKeys/keyid"
      key_length = 32
    }
  }
}
```

### Provider-defined functions


What's more, we added an OpenTofu-only feature to let providers dynamically **define custom functions** based on your configuration. This enhancement allows you to fully integrate other programming languages as shown in our live stream. You can try out this functionality with our experimental Lua and Go providers.

```sh
terraform {
  required_providers {
    corefunc = {
      source = "northwood-labs/corefunc"
      version = "1.4.0"
    }
  }
}

provider "corefunc" {
}

output "test" {
  value = provider::corefunc::str_snake("Hello world!")
  # Prints: hello_world
}
```

### Removed block

there are instances when you want to remove a resource from your configuration without destroying the corresponding infrastructure object. In such cases, you can remove it from the OpenTofu state while allowing it to persist in the remote system.

```
removed {
  from = aws_instance.web
}
```
```
resource "local_file" "test" {
  content = "Hello world!"
  filename = "test.txt"
}
```
```
removed {
  from = local_file.test
}
```

### Loopable import blocks

In previous OpenTofu versions, you could already use the import block to declaratively import resources, for example:

```
resource "random_id" "test_id" {
  byte_length = 8
}

import {
  to = random_id.test_id
  id = "Y2FpOGV1Mkk"
}

output "id" {
  value = random_id.test_id.b64_url
}
```
```sh
#["server1", "server2"]
variable "server_ids" {
  type = list(string)
}

resource "random_id" "test_id" {
  byte_length = 8
  count = 2
}

import {
  to = random_id.test_id[tonumber(each.key)]
  id = each.value
  for_each = {
    for idx, item in var.server_ids: idx => item
  }
}

output "id" {
  value = random_id.test_id.*.b64_url
}
```

### Built-in function changes

This release also contains several new functions and changes to existing functions:

* New function: [templatestring](https://opentofu.org/docs/v1.7/language/functions/templatestring/)
* New function: [base64gunzip](https://opentofu.org/docs/v1.7/language/functions/base64gunzip/)
* New function: [cidrcontains](https://opentofu.org/docs/v1.7/language/functions/cidrcontains/)
* New function: [urldecode](https://opentofu.org/docs/v1.7/language/functions/urldecode/)
* New function: [issensitive](https://opentofu.org/docs/v1.7/language/functions/issensitive/)
* [nonsensitive](https://opentofu.org/docs/v1.7/language/functions/nonsensitive/) no longer returns an error when the applied values are not sensitive.
* [templatefile](https://opentofu.org/docs/v1.7/language/functions/templatefile/) now supports recursion up to a depth of 1024.


## What's new in OpenTofu 1.8?
