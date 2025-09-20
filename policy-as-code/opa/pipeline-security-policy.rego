package pipeline.security

import rego.v1

# Policy for DevSecOps Pipeline Security
# This policy enforces security requirements for CI/CD pipelines

# Deny pipeline execution if critical security checks fail
deny[msg] {
    input.pipeline_type == "deployment"
    not input.security_scan_passed
    msg := "Deployment blocked: Security scan failed"
}

# Deny if secrets are detected in the codebase
deny[msg] {
    input.secrets_detected > 0
    msg := sprintf("Deployment blocked: %d secrets detected in codebase", [input.secrets_detected])
}

# Deny if high-severity vulnerabilities are found
deny[msg] {
    input.vulnerabilities.high > 5
    msg := sprintf("Deployment blocked: %d high-severity vulnerabilities found", [input.vulnerabilities.high])
}

# Deny if critical vulnerabilities are found
deny[msg] {
    input.vulnerabilities.critical > 0
    msg := sprintf("Deployment blocked: %d critical vulnerabilities found", [input.vulnerabilities.critical])
}

# Require code review for production deployments
deny[msg] {
    input.pipeline_type == "deployment"
    input.environment == "production"
    input.code_review_approvals < 2
    msg := "Production deployment requires at least 2 code review approvals"
}

# Require security team approval for security-related changes
deny[msg] {
    input.security_related_changes == true
    not input.security_team_approved
    msg := "Security-related changes require security team approval"
}

# Enforce branch protection for production deployments
deny[msg] {
    input.pipeline_type == "deployment"
    input.environment == "production"
    input.branch != "main"
    msg := "Production deployments must be from main branch"
}

# Require signed commits for production deployments
deny[msg] {
    input.pipeline_type == "deployment"
    input.environment == "production"
    not input.commits_signed
    msg := "Production deployments require signed commits"
}

# Enforce container image scanning
deny[msg] {
    input.pipeline_type == "deployment"
    input.container_image_scanned != true
    msg := "Container image must be scanned before deployment"
}

# Require infrastructure as code scanning
deny[msg] {
    input.pipeline_type == "deployment"
    input.iac_files_changed == true
    input.iac_scan_passed != true
    msg := "Infrastructure as Code must pass security scan"
}

# Enforce dependency scanning
deny[msg] {
    input.pipeline_type == "deployment"
    input.dependencies_scanned != true
    msg := "Dependencies must be scanned before deployment"
}

# Require license compliance check
deny[msg] {
    input.pipeline_type == "deployment"
    input.license_compliance_checked != true
    msg := "License compliance must be verified before deployment"
}

# Enforce SBOM generation
deny[msg] {
    input.pipeline_type == "deployment"
    input.sbom_generated != true
    msg := "Software Bill of Materials (SBOM) must be generated"
}

# Require image signing for production
deny[msg] {
    input.pipeline_type == "deployment"
    input.environment == "production"
    input.image_signed != true
    msg := "Production container images must be signed"
}

# Enforce runtime security monitoring
deny[msg] {
    input.pipeline_type == "deployment"
    input.runtime_security_configured != true
    msg := "Runtime security monitoring must be configured"
}

# Require backup verification for database changes
deny[msg] {
    input.pipeline_type == "deployment"
    input.database_changes == true
    input.backup_verified != true
    msg := "Database backup must be verified before deployment"
}

# Enforce network security policies
deny[msg] {
    input.pipeline_type == "deployment"
    input.network_policies_configured != true
    msg := "Network security policies must be configured"
}

# Require secrets rotation for long-running deployments
deny[msg] {
    input.pipeline_type == "deployment"
    input.environment == "production"
    input.secrets_rotated != true
    input.deployment_duration_hours > 168  # 1 week
    msg := "Secrets must be rotated for long-running production deployments"
}

# Enforce compliance checks
deny[msg] {
    input.pipeline_type == "deployment"
    input.compliance_checked != true
    msg := "Compliance checks must be performed before deployment"
}

# Require security documentation updates
deny[msg] {
    input.pipeline_type == "deployment"
    input.security_documentation_updated != true
    input.security_related_changes == true
    msg := "Security documentation must be updated for security-related changes"
}

# Enforce incident response plan verification
deny[msg] {
    input.pipeline_type == "deployment"
    input.environment == "production"
    input.incident_response_plan_verified != true
    msg := "Incident response plan must be verified for production deployments"
}

# Require disaster recovery testing
deny[msg] {
    input.pipeline_type == "deployment"
    input.environment == "production"
    input.disaster_recovery_tested != true
    input.last_disaster_recovery_test_days > 90
    msg := "Disaster recovery must be tested within the last 90 days"
}

# Enforce data encryption requirements
deny[msg] {
    input.pipeline_type == "deployment"
    input.data_encrypted != true
    input.sensitive_data_handled == true
    msg := "Sensitive data must be encrypted"
}

# Require access logging
deny[msg] {
    input.pipeline_type == "deployment"
    input.access_logging_enabled != true
    msg := "Access logging must be enabled"
}

# Enforce multi-factor authentication
deny[msg] {
    input.pipeline_type == "deployment"
    input.mfa_enabled != true
    input.environment == "production"
    msg := "Multi-factor authentication must be enabled for production"
}

# Require security awareness training
deny[msg] {
    input.pipeline_type == "deployment"
    input.security_training_current != true
    input.developer_last_training_days > 365
    msg := "Security awareness training must be current (within 1 year)"
}

# Enforce vulnerability disclosure policy
deny[msg] {
    input.pipeline_type == "deployment"
    input.vulnerability_disclosure_policy != true
    msg := "Vulnerability disclosure policy must be in place"
}

# Require penetration testing for new features
deny[msg] {
    input.pipeline_type == "deployment"
    input.new_features_added == true
    input.penetration_testing_completed != true
    input.environment == "production"
    msg := "Penetration testing must be completed for new features in production"
}

# Enforce secure coding standards
deny[msg] {
    input.pipeline_type == "deployment"
    input.secure_coding_standards_met != true
    msg := "Secure coding standards must be met"
}

# Require threat modeling for new components
deny[msg] {
    input.pipeline_type == "deployment"
    input.new_components_added == true
    input.threat_modeling_completed != true
    msg := "Threat modeling must be completed for new components"
}

# Enforce data classification
deny[msg] {
    input.pipeline_type == "deployment"
    input.data_classification_verified != true
    input.sensitive_data_handled == true
    msg := "Data classification must be verified for sensitive data"
}

# Require business continuity planning
deny[msg] {
    input.pipeline_type == "deployment"
    input.environment == "production"
    input.business_continuity_plan_verified != true
    msg := "Business continuity plan must be verified for production"
}

# Allow deployment if all security requirements are met
allow {
    not deny
}
