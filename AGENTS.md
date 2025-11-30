# GitHub Copilot Instructions

## Project Overview
This repository manages infrastructure using **GitOps** principles. It combines **Kubernetes** configurations (managed by ArgoCD on Talos Linux) and **Terraform** for external resources (GitHub, Cloudflare, etc.).

## Architecture & Patterns

### Kubernetes (GitOps)
- **Root Directory**: `k8s_gitops/`
- **Structure**:
  - `bootstrap/`: Entry points for ArgoCD (`bootstrap-app.yaml`, `bootstrap-infra.yaml`).
  - `infra/`: System-level components (Ingress, Storage, Secrets).
  - `app/`: User-facing applications.
- **Mechanism**: ArgoCD watches this repo. Changes to `main` branch are automatically synced.
- **Manifest Management**: **Kustomize** is the standard for hydration.
- **Secrets**: **Sealed Secrets** (`bitnami/sealed-secrets`) are used. Never commit raw secrets.

### Terraform
- **Root Directory**: `terraform/`
- **State Management**: GCP Storage Bucket is used as the backend.
- **Variable Management**: Sensitive/Environment variables are stored in `prod.env.tfvars` (git-ignored), derived from `env.sample.tfvars`.

## Critical Workflows

### Adding a New Kubernetes Application
1.  **Create Directory**: `mkdir -p k8s_gitops/app/<app-name>/resources`
2.  **Define Resources**: Place K8s manifests or Helm values in the `resources` folder.
3.  **Create ArgoCD App**: Create `k8s_gitops/app/<app-name>/<app-name>.yaml` defining the `Application` resource.
    - Source path should be `k8s_gitops/app/<app-name>/resources`.
4.  **Register**: Add the new app file to `k8s_gitops/app/kustomization.yaml`.

### Terraform Provisioning
1.  **Setup**: Ensure `prod.env.tfvars` exists (copy from `env.sample.tfvars`).
2.  **Plan**: `terraform plan -var-file=prod.env.tfvars`
3.  **Apply**: `terraform apply -var-file=prod.env.tfvars`

## Key Files & Paths
- **Cluster Bootstrap**: `k8s_gitops/bootstrap/bootstrap-app.yaml` (Apps), `k8s_gitops/bootstrap/bootstrap-infra.yaml` (Infra).
- **App Registry**: `k8s_gitops/app/kustomization.yaml`.
- **Infra Registry**: `k8s_gitops/infra/kustomization.yaml`.
- **Terraform Backend**: `terraform/terraform_backend/backend.tf`.

## Conventions
- **Path References**: In ArgoCD manifests, `repoURL` is `https://github.com/jbwittner/infrastructure` and paths are relative to repo root (e.g., `k8s_gitops/app/...`).
- **Namespace**: Most apps go into their own namespace or `default`. ArgoCD lives in `argocd`.
- **Ingress**: Uses `ingress-nginx` and `cloudflare-tunnel`.
- **Ignored Paths**: The `archive/` directory contains legacy configurations and must be **completely ignored**.
