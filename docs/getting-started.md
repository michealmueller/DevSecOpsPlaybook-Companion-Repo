# Getting Started with DevSecOps Playbook Companion Repository

This guide will help you quickly set up and use the security patterns and configurations from the DevSecOps Playbook Companion Repository.

## Quick Setup

### 1. Clone the Repository
```bash
git clone https://github.com/michealmueller/DevSecOpsPlaybook-Companion-Repo.git
cd DevSecOpsPlaybook-Companion-Repo
```

### 2. Choose Your CI/CD Platform

#### GitHub Actions
```bash
# Copy workflow templates to your project
cp -r .github/workflows/ your-project/.github/
cp -r ci-cd/github-actions/.github/workflows/ your-project/.github/
```

#### GitLab CI
```bash
# Copy GitLab CI configuration
cp ci-cd/gitlab-ci/.gitlab-ci.yml your-project/
```

### 3. Configure Security Scanning

#### Static Application Security Testing (SAST)
```bash
# Copy Semgrep configuration
cp security/sast/.semgrep.yml your-project/
```

#### Software Composition Analysis (SCA)
```bash
# Copy Dependabot configuration
cp security/sca/dependabot.yml your-project/.github/
```

### 4. Set Up Secrets Management

#### AWS Secrets Manager
```bash
# Copy Terraform configuration
cp -r secrets-management/aws/ your-project/infrastructure/
```

### 5. Implement Policy as Code

#### Open Policy Agent (OPA)
```bash
# Copy OPA policies
cp -r policy-as-code/opa/ your-project/policies/
```

### 6. Secure Your Infrastructure

#### Docker Security
```bash
# Copy secure Dockerfile template
cp infrastructure/docker/Dockerfile.secure your-project/
```

### 7. Enable Runtime Monitoring

#### Falco Rules
```bash
# Copy Falco configuration
cp monitoring/falco/falco-rules.yaml your-project/monitoring/
```

### 8. Set Up Pre-commit Hooks

```bash
# Copy pre-commit configuration
cp templates/pre-commit/.pre-commit-config.yaml your-project/

# Install pre-commit
pip install pre-commit

# Install the hooks
pre-commit install
```

## Configuration Steps

### GitHub Actions Setup

1. **Enable GitHub Actions** in your repository settings
2. **Add required secrets** to your repository:
   - `SNYK_TOKEN` - For dependency scanning
   - `AWS_ROLE_ARN` - For AWS deployments
   - `GITHUB_TOKEN` - Automatically provided

3. **Configure branch protection rules**:
   - Require status checks
   - Require pull request reviews
   - Restrict pushes to main branch

### GitLab CI Setup

1. **Configure GitLab CI variables**:
   - `SNYK_TOKEN`
   - `STAGING_WEBHOOK_URL`
   - `PRODUCTION_WEBHOOK_URL`

2. **Set up protected branches**:
   - Protect main branch
   - Require merge requests

### AWS Secrets Manager Setup

1. **Deploy Terraform configuration**:
   ```bash
   cd infrastructure/
   terraform init
   terraform plan
   terraform apply
   ```

2. **Configure IAM roles** for your applications
3. **Set up monitoring and alerting**

### OPA Policy Setup

1. **Deploy OPA server**:
   ```bash
   kubectl apply -f policy-as-code/opa/
   ```

2. **Configure policy validation** in your CI/CD pipeline
3. **Set up policy testing**

## Testing Your Setup

### 1. Test Security Scanning
```bash
# Run Semgrep locally
semgrep --config=auto .

# Run TruffleHog for secrets detection
trufflehog git file://. --since-commit HEAD~1
```

### 2. Test Pre-commit Hooks
```bash
# Run pre-commit on all files
pre-commit run --all-files
```

### 3. Test Container Scanning
```bash
# Build and scan your container
docker build -t your-app .
trivy image your-app
```

## Troubleshooting

### Common Issues

#### GitHub Actions Failures
- Check that all required secrets are configured
- Verify branch protection rules
- Ensure workflow files are in `.github/workflows/`

#### GitLab CI Failures
- Verify GitLab CI variables are set
- Check protected branch configuration
- Ensure `.gitlab-ci.yml` is in the root directory

#### Terraform Errors
- Verify AWS credentials are configured
- Check that required variables are set
- Ensure you have proper IAM permissions

#### OPA Policy Issues
- Verify OPA server is running
- Check policy syntax
- Ensure proper policy loading

### Getting Help

- **Issues**: [GitHub Issues](https://github.com/michealmueller/DevSecOpsPlaybook-Companion-Repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/michealmueller/DevSecOpsPlaybook-Companion-Repo/discussions)
- **Documentation**: [Main README](README.md)

## Next Steps

1. **Customize configurations** for your specific needs
2. **Add additional security tools** as required
3. **Set up monitoring and alerting**
4. **Train your team** on the new security practices
5. **Contribute improvements** back to the repository

## Security Considerations

- **Never commit secrets** or credentials
- **Use environment variables** for configuration
- **Rotate secrets regularly**
- **Monitor access logs**
- **Keep dependencies updated**
- **Follow least privilege principle**

## Best Practices

- **Start small** - implement one security measure at a time
- **Test thoroughly** - validate all configurations
- **Document changes** - keep your team informed
- **Monitor continuously** - security is an ongoing process
- **Stay updated** - security threats evolve constantly

For more detailed information, refer to the main [README](README.md) and individual configuration files.
