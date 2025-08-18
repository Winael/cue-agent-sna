package artifacts

import "github.com/winael/cue-agent-sna/cue/types"

artifacts: [name=string]: types.#Artifact // New section for all artifacts
artifacts: {
    "artifact-alpha-web-app": types.#Artifact & {
        name: "Web Application"
        description: "Main customer-facing web application"
        type: "application"
        owner: "Team Alpha"
        hosted_on: ["artifact-sigma-kubernetes-platform"]
        dependsOn: ["artifact-delta-core-api", "artifact-delta-auth-service"]
    }
    "artifact-alpha-design-system": types.#Artifact & {
        name: "Design System"
        description: "UI component library and design guidelines"
        type: "library"
        owner: "Team Alpha"
        hosted_on: []
        dependsOn: []
    }
    "artifact-alpha-e2e-tests": types.#Artifact & {
        name: "E2E Test Suite"
        description: "End-to-end test suite for the web application"
        type: "application"
        owner: "Team Alpha"
        hosted_on: ["artifact-sigma-ci-cd-pipeline"]
        dependsOn: ["artifact-alpha-web-app"]
    }

    "artifact-delta-core-api": types.#Artifact & {
        name: "Core API"
        description: "Core business logic API"
        type: "service"
        owner: "Team Delta"
        hosted_on: ["artifact-sigma-kubernetes-platform"]
        dependsOn: []
    }
    "artifact-delta-auth-service": types.#Artifact & {
        name: "Auth Service"
        description: "Authentication and authorization microservice"
        type: "service"
        owner: "Team Delta"
        hosted_on: ["artifact-sigma-kubernetes-platform"]
        dependsOn: []
    }
    "artifact-delta-api-gateway": types.#Artifact & {
        name: "API Gateway"
        description: "API Gateway for routing and managing API traffic"
        type: "service"
        owner: "Team Delta"
        hosted_on: ["artifact-sigma-kubernetes-platform"]
        dependsOn: []
    }

    "artifact-gamma-poc-framework": types.#Artifact & {
        name: "POC Framework"
        description: "Framework for rapid prototyping and proof-of-concepts"
        type: "library"
        owner: "Team Gamma"
        hosted_on: []
        dependsOn: []
    }
    "artifact-gamma-integration-toolkit": types.#Artifact & {
        name: "Integration Toolkit"
        description: "Tools and libraries for inter-system communication"
        type: "library"
        owner: "Team Gamma"
        hosted_on: []
        dependsOn: []
    }
    "artifact-gamma-data-explorer": types.#Artifact & {
        name: "Data Explorer"
        description: "Tool for exploring and visualizing data from various sources"
        type: "application"
        owner: "Team Gamma"
        hosted_on: []
        dependsOn: []
    }

    "artifact-omega-integration-platform": types.#Artifact & {
        name: "Integration Platform"
        description: "Platform for orchestrating and monitoring integrations"
        type: "service"
        owner: "Team Omega"
        hosted_on: ["artifact-sigma-kubernetes-platform"]
        dependsOn: ["artifact-sigma-ci-cd-pipeline", "artifact-sigma-monitoring-stack"]
    }
    "artifact-omega-automated-tests-suite": types.#Artifact & {
        name: "Automated Tests Suite"
        description: "Comprehensive suite of automated integration tests"
        type: "application"
        owner: "Team Omega"
        hosted_on: ["artifact-sigma-ci-cd-pipeline"]
        dependsOn: ["artifact-omega-integration-platform"]
    }
    "artifact-omega-deployment-scripts": types.#Artifact & {
        name: "Deployment Scripts"
        description: "Scripts for deploying integrated systems"
        type: "application"
        owner: "Team Omega"
        hosted_on: []
        dependsOn: ["artifact-sigma-ci-cd-pipeline"]
    }

    "artifact-sigma-ci-cd-pipeline": types.#Artifact & {
        name: "CI/CD Pipeline"
        description: "Standardized CI/CD pipelines"
        type: "service"
        owner: "Team Sigma"
        hosted_on: []
        dependsOn: []
    }
    "artifact-sigma-monitoring-stack": types.#Artifact & {
        name: "Monitoring Stack"
        description: "Centralized monitoring and logging infrastructure (Prometheus, Grafana, ELK)"
        type: "service"
        owner: "Team Sigma"
        hosted_on: []
        dependsOn: []
    }
    "artifact-sigma-security-scanner": types.#Artifact & {
        name: "Security Scanner"
        description: "Automated security scanning tools and services"
        type: "application"
        owner: "Team Sigma"
        hosted_on: []
        dependsOn: []
    }
    "artifact-sigma-kubernetes-platform": types.#Artifact & {
        name: "Kubernetes Platform"
        description: "Managed Kubernetes platform"
        type: "service"
        owner: "Team Sigma"
        hosted_on: []
        dependsOn: ["artifact-sigma-monitoring-stack"]
    }
}