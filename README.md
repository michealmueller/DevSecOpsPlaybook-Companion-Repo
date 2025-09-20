# DevSecOps Playbook - Companion Repository

> **Practical code examples, templates, and configurations to implement secure DevOps practices from "The DevSecOps Playbook: Secure Pipelines from Code to Cloud"**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![DevSecOps](https://img.shields.io/badge/DevSecOps-Secure%20Pipelines-blue)](https://github.com/michealmueller/DevSecOpsPlaybook-Companion-Repo)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-Security%20First-green)](https://github.com/michealmueller/DevSecOpsPlaybook-Companion-Repo)

This repository contains production-ready code examples, templates, and configurations that demonstrate the security patterns and practices described in "The DevSecOps Playbook." Each example is battle-tested, documented, and ready to use in your own projects.

## 🚀 Quick Start

### Prerequisites
- Git
- Docker
- Your preferred CI/CD platform (GitHub Actions, GitLab CI, Azure DevOps)
- Cloud provider CLI tools (AWS CLI, Azure CLI, or gcloud)

### Installation
```bash
git clone https://github.com/michealmueller/DevSecOpsPlaybook-Companion-Repo.git
cd DevSecOpsPlaybook-Companion-Repo
```

## 📁 Repository Structure

```
DevSecOpsPlaybook-Companion-Repo/
├── 📋 .github/workflows/           # GitHub Actions templates
├── 🔧 ci-cd/                      # CI/CD pipeline configurations
│   ├── github-actions/            # GitHub Actions workflows
│   ├── gitlab-ci/                 # GitLab CI/CD pipelines
│   └── azure-devops/              # Azure DevOps pipelines
├── 🔒 security/                   # Security scanning configurations
│   ├── sast/                      # Static Application Security Testing
│   ├── sca/                       # Software Composition Analysis
│   ├── container-scanning/        # Container security scanning
│   └── iac-scanning/              # Infrastructure as Code scanning
├── 🔐 secrets-management/         # Secrets management patterns
│   ├── aws/                       # AWS Secrets Manager
│   ├── azure/                     # Azure Key Vault
│   ├── gcp/                       # Google Cloud Secret Manager
│   └── hashicorp/                 # HashiCorp Vault
├── 📜 policy-as-code/             # Policy as Code implementations
│   ├── opa/                       # Open Policy Agent policies
│   └── gatekeeper/                # Kubernetes Gatekeeper policies
├── 🏗️ infrastructure/             # Infrastructure templates
│   ├── terraform/                 # Terraform configurations
│   ├── docker/                    # Docker security configurations
│   └── kubernetes/                # Kubernetes security manifests
├── 📊 monitoring/                 # Security monitoring and observability
│   ├── falco/                     # Runtime security monitoring
│   ├── prometheus/                # Metrics collection
│   └── grafana/                   # Dashboards and alerting
├── 📝 templates/                  # Reusable templates
│   ├── pre-commit/                # Pre-commit hooks
│   └── github-templates/          # GitHub repository templates
├── 💡 examples/                   # Complete working examples
│   ├── serverless/                # Serverless application security
│   ├── kubernetes/                # Kubernetes security patterns
│   └── containerized-apps/        # Container security examples
└── 📚 docs/                       # Documentation and guides
```

## 🎯 Key Features

### 🔒 **Security-First CI/CD Pipelines**
- **Multi-stage security scanning** with SAST, SCA, and container scanning
- **Secrets detection** and prevention with pre-commit hooks
- **Policy enforcement** at every stage of the pipeline
- **OIDC-based authentication** eliminating static credentials

### 🛡️ **Comprehensive Security Tooling**
- **Static Analysis**: Semgrep, SonarQube, CodeQL configurations
- **Dependency Scanning**: Snyk, OWASP Dependency Check, Dependabot
- **Container Security**: Trivy, Snyk Container, Clair scanning
- **Infrastructure Security**: Checkov, Tfsec, Kubesec policies

### 🔐 **Secrets Management Patterns**
- **Cloud-native solutions** for AWS, Azure, and GCP
- **Zero-trust secrets** with automatic rotation
- **Audit trails** and access controls
- **Development workflow integration**

### 📜 **Policy as Code**
- **OPA policies** for pipeline security
- **Kubernetes Gatekeeper** constraints
- **Automated policy testing** and validation
- **Policy versioning** and rollback capabilities

## 🚀 Getting Started

### 1. Choose Your CI/CD Platform

#### GitHub Actions
```bash
cp -r ci-cd/github-actions/.github/workflows/ your-project/.github/workflows/
```

#### GitLab CI
```bash
cp ci-cd/gitlab-ci/.gitlab-ci.yml your-project/
```

#### Azure DevOps
```bash
cp -r ci-cd/azure-devops/pipelines/ your-project/.azuredevops/
```

### 2. Configure Security Scanning

#### Static Application Security Testing (SAST)
```bash
# Copy SAST configuration
cp -r security/sast/ your-project/.security/
```

#### Software Composition Analysis (SCA)
```bash
# Copy SCA configuration
cp -r security/sca/ your-project/.security/
```

### 3. Set Up Secrets Management

#### AWS Secrets Manager
```bash
cp -r secrets-management/aws/ your-project/infrastructure/
```

#### Azure Key Vault
```bash
cp -r secrets-management/azure/ your-project/infrastructure/
```

### 4. Implement Policy as Code

#### Open Policy Agent (OPA)
```bash
cp -r policy-as-code/opa/ your-project/policies/
```

#### Kubernetes Gatekeeper
```bash
kubectl apply -f policy-as-code/gatekeeper/
```

## 📖 Documentation

- **[Getting Started Guide](docs/getting-started.md)** - Step-by-step setup instructions
- **[Security Patterns](docs/security-patterns.md)** - Detailed explanations of security patterns
- **[Tool Configuration](docs/tool-configuration.md)** - How to configure each security tool
- **[Best Practices](docs/best-practices.md)** - DevSecOps best practices and recommendations
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions

## 💡 Examples

### Serverless Security
- **AWS Lambda** with least-privilege IAM roles
- **Azure Functions** with Key Vault integration
- **Google Cloud Functions** with Secret Manager

### Kubernetes Security
- **Pod Security Standards** implementation
- **Network Policies** for micro-segmentation
- **RBAC** configurations for fine-grained access control

### Container Security
- **Multi-stage builds** with security scanning
- **Distroless base images** for minimal attack surface
- **Content Trust** and image signing

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### How to Contribute
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow the existing code style and patterns
- Add tests for new functionality
- Update documentation for new features
- Ensure all security scans pass

## 📚 Related Resources

- **[The DevSecOps Playbook Book](https://github.com/michealmueller/devsecops-playbook)** - The main book repository
- **[OWASP DevSecOps Maturity Model](https://owasp.org/www-project-devsecops-maturity-model/)** - Security maturity assessment
- **[NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)** - Cybersecurity best practices

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/michealmueller/DevSecOpsPlaybook-Companion-Repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/michealmueller/DevSecOpsPlaybook-Companion-Repo/discussions)
- **Email**: [Contact the Author](mailto:your-email@example.com)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- The DevSecOps community for sharing knowledge and best practices
- Security tool maintainers for their excellent open-source tools
- Contributors who help improve this repository

---

**⭐ If this repository helps you implement secure DevOps practices, please give it a star!**

**📖 For the complete guide to DevSecOps, check out "The DevSecOps Playbook: Secure Pipelines from Code to Cloud"**
