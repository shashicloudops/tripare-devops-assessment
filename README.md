# Tripare DevOps Assessment: Terraform + Database Reliability

## Overview

This repository contains a production-oriented solution for the DevOps Assessment. The project demonstrates Infrastructure as Code (IaC) using Terraform, local database provisioning with Docker Compose, database migration and seeding, backup and restore automation, SQL query optimization, and CI validation using GitHub Actions.

**Technology Stack**

* Terraform
* AWS (Infrastructure Design)
* Docker Compose
* PostgreSQL
* GitHub Actions
* Bash (Shell Scripting)

---

# Project Architecture

```
Internet
    │
    ▼
Application Load Balancer (ALB)
    │
    ▼
Amazon ECS (Fargate)
    │
    ▼
Amazon RDS PostgreSQL
```

RDS is deployed in private subnets and is accessible only from the ECS security group.

---

# Repository Structure

```
tripare-devops-assessment/
│
├── infra/
│   ├── modules/
│   │   ├── network/
│   │   ├── ecs/
│   │   └── rds/
│   │
│   └── envs/
│       ├── dev/
│       └── prod/
│
├── database/
│   ├── migrations/
│   ├── seeds/
│   └── indexes.sql
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
├── docker-compose.yml
├── README.md
└── .github/
    └── workflows/
        └── terraform.yml
```

---

# Prerequisites

The following software should be installed before running this project.

| Software                     | Version |
| ---------------------------- | ------- |
| Docker                       | Latest  |
| Docker Compose               | Latest  |
| Terraform                    | 1.15.7  |
| Git                          | Latest  |
| PostgreSQL Client (optional) | Latest  |

Verify installation:

```bash
docker --version
docker compose version
terraform version
git --version
```

---

# Running the Local Database

Start PostgreSQL using Docker Compose.

```bash
docker compose up -d
```

Verify the container is running.

```bash
docker ps
```

Expected output should include:

```
postgres-db
```

Connect to PostgreSQL.

```bash
docker exec -it postgres-db psql -U admin hoteldb
```

---

# Database Migration

Create the required tables.

```bash
docker exec -i postgres-db \
psql -U admin hoteldb \
< database/migrations/001_create_tables.sql
```

Verify tables.

```sql
\dt
```

Expected tables:

```
hotel_bookings
booking_events
```

---

# Load Seed Data

Insert sample booking data.

```bash
docker exec -i postgres-db \
psql -U admin hoteldb \
< database/seeds/seed.sql
```

Verify.

```sql
SELECT COUNT(*) FROM hotel_bookings;
```

Expected result:

```
100
```

or more.

---

# Create Database Indexes

Apply indexes.

```bash
docker exec -i postgres-db \
psql -U admin hoteldb \
< database/indexes.sql
```

Verify.

```sql
\d hotel_bookings
```

---

# Optimized Query

Execute the required reporting query.

```sql
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city='delhi'
AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id,status;
```

---

# Indexing Strategy

The following indexes were created.

```sql
CREATE INDEX idx_booking_city_created
ON hotel_bookings(city, created_at);

CREATE INDEX idx_booking_org_status
ON hotel_bookings(org_id, status);
```

## Why these indexes?

The reporting query filters records using:

* city
* created_at

and groups by:

* org_id
* status

Creating composite indexes on these columns significantly reduces sequential scans and improves query execution time.

---

# Backup

Run the backup script.

```bash
chmod +x scripts/backup.sh

./scripts/backup.sh
```

A timestamped SQL dump is created under:

```
backups/
```

Example

```
backups/hoteldb_20260122_183000.sql
```

---

# Restore

Restore the latest backup.

```bash
chmod +x scripts/restore.sh

./scripts/restore.sh
```

The script recreates the database and imports the latest SQL dump.

---

# Verify Restore

Connect to PostgreSQL.

```bash
docker exec -it postgres-db psql -U admin hoteldb
```

Verify.

```sql
SELECT COUNT(*) FROM hotel_bookings;

SELECT COUNT(*) FROM booking_events;
```

If the row counts match the backup, the restore completed successfully.

---

# Security Note

Database credentials are hardcoded in terraform.tfvars for demonstration purposes only to keep the assessment simple.

In a production environment, sensitive values such as database passwords should never be stored in source code. They should be managed using a secure secret management solution such as:

- AWS Secrets Manager
- HashiCorp Vault
- Environment variables injected through CI/CD

---

# Terraform Infrastructure

Terraform is organized using reusable modules.

```
infra/
│
├── modules/
│   ├── network/
│   ├── ecs/
│   └── rds/
│
└── envs/
    ├── dev/
    └── prod/
```

## Modules

### Network

Creates

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables

### ECS

Creates

* ECS Cluster
* Task Definition
* ECS Service
* Security Group
* CloudWatch Log Group

### RDS

Creates

* PostgreSQL Instance
* DB Subnet Group
* Security Group
* Parameter Group

---

# Environment Configuration

## Development

| Setting             | Value       |
| ------------------- | ----------- |
| Instance            | db.t3.micro |
| Backup Retention    | 3 Days      |
| Deletion Protection | Disabled    |

## Production

| Setting             | Value        |
| ------------------- | ------------ |
| Instance            | db.t3.medium |
| Backup Retention    | 14 Days      |
| Deletion Protection | Enabled      |

---

# Terraform Commands

Initialize Terraform.

```bash
terraform init
```

Format configuration.

```bash
terraform fmt
```

Validate configuration.

```bash
terraform validate
```

Generate execution plan.

```bash
terraform plan -refresh=false
```

---

# GitHub Actions

The repository includes a GitHub Actions workflow that executes on every Pull Request.

Pipeline stages:

* Checkout repository
* Install Terraform
* terraform fmt
* terraform init
* terraform validate
* terraform plan

This workflow ensures Terraform configuration remains properly formatted, valid, and ready for deployment before merging changes.

---

# Design Decisions

* Modular Terraform architecture for reusability.
* Separate development and production environments.
* Private RDS deployment.
* Principle of least privilege using Security Groups.
* Docker Compose for local development.
* SQL migration-based schema management.
* Automated database backup and restore.
* Query optimization through composite indexes.
* CI validation using GitHub Actions.

---

# Future Improvements

* Remote Terraform backend using Amazon S3.
* Terraform state locking with DynamoDB.
* ECS Auto Scaling.
* Multi-AZ RDS deployment.
* AWS Secrets Manager integration.
* Monitoring using CloudWatch and Prometheus.
* Automated Terraform deployment after approval.
* Prometheus and Grafana monitoring.
* Blue/Green deployment strategy.

---

# Author

**Shashi Sharma**

DevOps Engineer

This project was developed as part of a DevOps Assessment to demonstrate practical experience with Infrastructure as Code, AWS architecture design, database reliability, automation, and CI/CD best practices.

