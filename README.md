# OpenTofu

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

1 . **State encryption**

