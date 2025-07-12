# 🛠️ My DevOps Contributions

This document outlines my practical DevOps contributions across infrastructure automation, CI/CD, containerization, and monitoring.

---

## 🔹 1. Infrastructure Provisioning with Terraform

- Defined **Infrastructure as Code (IaC)** using Terraform.
- Provisioned AWS resources including:
  - EC2 instances for Dev, Test, and Prod environments.
  - Security groups, key pairs, and networking components (VPC, subnets, etc.).
- Maintained modular `.tf` files for easier reuse and clarity.

---

## 🔹 2. CI/CD Pipeline with Jenkins

- Designed Jenkins pipelines using **Jenkinsfile** to automate application delivery.
- Key pipeline stages:
  - Cloning source code from GitHub.
  - Building the project with **Maven** and running unit tests.
  - Creating Docker images and pushing to Docker Hub.
  - Deploying containers to AWS EC2 instances.

- Structured environments:
  - **Dev**: Triggered on commit push.
  - **Test**: Triggered after successful Dev pipeline.
  - **Prod**: Triggered only after Test approval.

---

## 🔹 3. Containerization with Docker

- Wrote clean and efficient **Dockerfiles** for a Spring Boot application.
- Built and tagged Docker images with proper versioning strategy.
- Used **Docker Compose** to deploy containers to EC2 instances.
- Ensured consistent environment across development and production.

---

## 🔹 4. Monitoring with Prometheus & Grafana *(Next Phase)*

- Set up **Prometheus** and **Grafana** locally for performance monitoring.
- Monitoring targets:
  - Docker containers
  - EC2 instances
  - Application availability
- Future plan: integrate with **Alertmanager** for real-time alerts and incident response.

---

📌 *This setup showcases a full DevOps lifecycle from provisioning to deployment and monitoring.*

