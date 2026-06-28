# shopflow
# 🚀 ShopFlow DevOps Project


---

# 📖 Project Overview

ShopFlow is a complete DevOps project demonstrating how to provision AWS infrastructure using Terraform, containerize an application with Docker, store images in Amazon ECR, and automate deployment using GitHub Actions.

---

# 🏗️ Architecture

```text
                        +----------------------+
                        |      GitHub Repo     |
                        +----------+-----------+
                                   |
                                   | Push
                                   v
                      +---------------------------+
                      |     GitHub Actions        |
                      |  CI/CD Pipeline           |
                      +------------+--------------+
                                   |
             +---------------------+----------------------+
             |                                            |
             | Build Docker Image                         |
             |                                            |
             v                                            v
      +---------------+                          +----------------+
      | Docker Image  |                          | Terraform Apply|
      +-------+-------+                          +--------+-------+
              |                                           |
              | Push                                      |
              v                                           v
      +---------------+                     +----------------------------+
      | Amazon ECR    |                     | AWS Infrastructure         |
      +---------------+                     |                            |
                                            | • VPC                      |
                                            | • Public Subnet            |
                                            | • Private Subnet           |
                                            | • Internet Gateway         |
                                            | • NAT Gateway              |
                                            | • Route Tables             |
                                            | • Security Groups          |
                                            | • EC2                      |
                                            | • Launch Template          |
                                            | • Auto Scaling Group       |
                                            +----------------------------+
```

---

# ☁️ AWS Services

* Amazon VPC
* Public Subnet
* Private Subnet
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups
* Amazon EC2
* Launch Template
* Auto Scaling Group
* Amazon ECR
* IAM

---

# 🛠️ Technologies

* Terraform
* Docker
* Git
* GitHub Actions
* AWS
* Nginx

---

# 📂 Project Structure

```text
shopflow
│
├── app
│   ├── Dockerfile
│   └── index.html
│
├── terraform
│   ├── modules
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── .github
│   └── workflows
│       └── deploy.yml
│
└── README.md
```

---

# ⚙️ CI/CD Workflow

1. Push code to GitHub
2. GitHub Actions starts automatically
3. Configure AWS Credentials
4. Build Docker Image
5. Push Image to Amazon ECR
6. Initialize Terraform
7. Validate Terraform
8. Create Terraform Plan
9. Apply Infrastructure Changes

---

# 🐳 Docker

```bash
docker build -t shopflow ./app
docker run -d -p 8085:80 shopflow
```

---

# 🌍 Terraform

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

---

# 👩‍💻 Author

**Nada Essam**

DevOps Project using AWS • Terraform • Docker • GitHub Actions
