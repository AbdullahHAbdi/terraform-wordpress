# WordPress on AWS — Terraform

Terraform project that provisions a WordPress installation on AWS EC2, fully automated via user data. Infrastructure is defined as code across modular `.tf` files following Terraform best practices.

---

## Architecture

Internet → Cloudflare DNS → EC2 Public IP
└── Apache + PHP 8.5 + WordPress
└── MariaDB 10.5 (local)

| Resource       | Details                         |
|----------------|---------------------------------|
| EC2            | t2.micro, Amazon Linux 2023     |
| Web Server     | Apache httpd                    |
| PHP            | PHP 8.5 + php-fpm, php-mysqlnd  |
| Database       | MariaDB 10.5 (local)            |
| DNS            | Cloudflare                      |
| Security Group | HTTP, HTTPS open — SSH restricted |

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.3
- AWS CLI configured (`aws configure`)
- An existing EC2 key pair in your target region
- A Cloudflare-managed domain (optional)

---

## Quickstart
```bash
# 1. Clone the repo
git clone https://github.com/AbdullahHAbdi/wordpress-terraform
cd wordpress-terraform

# 2. Create your tfvars from the example
cp terraform.tfvars.example terraform.tfvars
# Fill in your key_name and db_password

# 3. Deploy
terraform init
terraform plan
terraform apply
```

After apply completes, wait 3–5 minutes for cloud-init to finish, then:
```bash
terraform output wordpress_url
```

Open that URL in your browser to complete the WordPress setup wizard.

---

## Variables

| Variable        | Description                        | Default                  |
|-----------------|------------------------------------|--------------------------|
| `aws_region`    | AWS region                         | `us-east-2`              |
| `project_name`  | Prefix for all resource names      | `wordpress-tf`           |
| `instance_type` | EC2 instance type                  | `t2.micro`               |
| `ami_id`        | Amazon Linux 2023 AMI ID           | AL2023 us-east-2         |
| `key_name`      | Existing EC2 key pair name         | **required**             |
| `db_name`       | WordPress database name            | `wordpress`              |
| `db_user`       | WordPress database user            | `wpuser`                 |
| `db_password`   | WordPress database password        | **required, sensitive**  |

> `terraform.tfvars` is gitignored. See `terraform.tfvars.example` for the template.

---

## User Data

WordPress installation is handled by [`scripts/install_wordpress.sh`](scripts/install_wordpress.sh), injected into the EC2 instance via Terraform's `templatefile()` function. The script:

- Updates system packages
- Installs Apache, PHP 8.5, and MariaDB 10.5
- Creates the WordPress database and user
- Downloads and configures WordPress
- Sets correct file ownership and permissions

To monitor the install after launch:
```bash
ssh -i ~/.ssh/<key>.pem ec2-user@<public_ip>
sudo tail -f /var/log/wordpress-install.log
```

---

## Cleanup
```bash
terraform destroy
```

---

## Screenshot

![WordPress Deployment](terraform-wordpress.png)

---

## Related Projects

- [clickops-aws-wordpress](https://github.com/AbdullahHAbdi/clickops-aws-wordpress) — Same stack deployed manually through the AWS Console, featuring VPC, public/private subnets, ALB, CloudFront, and Cloudflare DNS