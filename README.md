# Production-Grade 3-Tier Web Application Deployment using Shell Scripting

# Project Overview
Designed and implemented a production-style 3-tier web application deployment on AWS using shell scripting to automate infrastructure configuration and application setup.

This project simulates real-world DevOps responsibilities by automating provisioning, configuration, and deployment across multiple layers.

---

# Architecture Overview

Client → Nginx (Frontend) → Node.js (Backend) → MySQL (Database)

# Key Design Decisions
- Separated application layers for scalability and maintainability
- Used reverse proxy (Nginx) to handle client traffic efficiently
- Backend communicates securely with database using internal networking
- Automated setup to eliminate manual configuration errors

---

# Tech Stack

- **Cloud**: AWS EC2
- **Automation**: Shell Scripting (Bash)
- **Web Server**: Nginx
- **Backend Runtime**: Node.js
- **Database**: MySQL
- **Service Management**: systemd
- **Version Control**: Git

---

# Repository Structure
├── mysql.sh # Database setup script
├── backend.sh # Backend deployment script
├── frontend.sh # Frontend & Nginx setup
├── backend.service # Systemd service file for Node.js app
├── nginx.conf # Reverse proxy configuration


---

# End-to-End Deployment Flow

# 1. Database Layer Initialization
- Automated MySQL installation and configuration
- Database and schema setup
- Service enablement for persistence

# 2. Backend Layer Deployment
- Node.js runtime installation
- Application deployment and dependency installation
- Systemd service configuration for process management
- Database connectivity setup

# 3. Frontend Layer Configuration
- Nginx installation and configuration
- Reverse proxy setup to backend service
- Static content serving and request routing

---

# Production-Level Features

- **Automation-first approach**: Zero manual setup required
- **Service orchestration using systemd**
- **Centralized logging for debugging**
- **Error handling with validation checks**
- **Layered architecture for scalability**
- **Re-runnable scripts (idempotent design)**

---

# Engineering Highlights

# Reliability
- Implemented validation checks after each critical step
- Ensured services restart automatically on failure

# Maintainability
- Modular scripts for each tier
- Clear separation of responsibilities

# Debugging & Observability
- Logs stored under `/var/log/`
- Easy troubleshooting for production-like failures

---

# Execution Steps

```bash
git clone https://github.com/vamsi-battu/3-Tier-Web-App-shell_Scripting.git
cd 3-Tier-Web-App-shell_Scripting

Setup Database
sudo bash mysql.sh

Setup Backend
sudo bash backend.sh

Setup Frontend
sudo bash frontend.sh

Request Flow
Client sends HTTP request to Nginx
Nginx forwards API requests to Node.js backend
Backend processes business logic
Backend interacts with MySQL database
Response returned to client

Challenges & Solutions
Challenge	Solution
Service dependency management	Sequential deployment strategy (DB → Backend → Frontend)
Debugging failures	Implemented logging & validation
Process reliability	Used systemd for service management
Configuration consistency	Automated via shell scripts


Future Enhancements
Infrastructure provisioning using Terraform
Configuration management using Ansible
CI/CD pipeline integration (Jenkins)
Containerization using Docker
Monitoring using CloudWatch / Prometheus
Load balancing and auto-scaling

Key Learnings
Automation significantly reduces deployment errors
Layered architecture improves scalability
Logging and validation are critical in production systems
Shell scripting can be leveraged for rapid automation


