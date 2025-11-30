# Infrastructure

Infrastructure management using **GitOps** (ArgoCD on Talos Linux) and **Terraform**.

## Repository Structure

```
├── k8s_gitops/         # Kubernetes GitOps configurations
│   ├── infra/          # System-level components (Ingress, Storage, Secrets)
│   ├── app/            # User-facing applications
│   ├── bootstrap/      # ArgoCD bootstrap manifests
│   └── argocd/         # ArgoCD installation values
├── terraform/          # Terraform configurations for external resources
└── archive/            # Legacy configurations (ignored)
```

## Architecture

### Kubernetes (GitOps)
- **Mechanism**: ArgoCD watches `k8s_gitops/` directory.
- **Manifest Management**: Kustomize.
- **Secrets**: Sealed Secrets.

### Terraform
- **Scope**: External resources (GitHub, Cloudflare, etc.).
- **State**: GCP Storage Bucket.

## Deployed Components

### Infrastructure (`k8s_gitops/infra`)
- [**sealed-secrets**](k8s_gitops/infra/sealed-secrets/README.md) - Encrypted secrets management
- [**ingress-nginx**](k8s_gitops/infra/ingress-nginx/README.md) - Ingress controller
- [**longhorn**](k8s_gitops/infra/longhorn/README.md) - Distributed storage
- [**cloudflare-tunnel**](k8s_gitops/infra/cloudflare-tunnel/README.md) - External access & DNS

### Applications (`k8s_gitops/app`)
- [**authentik**](k8s_gitops/app/authentik/README.md) - Identity Provider
- [**metrics-server**](k8s_gitops/app/metrics-server/README.md) - Resource metrics
- [**monitoring**](k8s_gitops/app/monitoring/README.md) - Prometheus & Grafana
- [**cloudnative-pg**](k8s_gitops/app/cloudnative-pg/README.md) - PostgreSQL

## Quick Start

### 1. Install ArgoCD
See [ArgoCD installation guide](k8s_gitops/argocd/README.md).

### 2. Bootstrap the Cluster
Apply the bootstrap manifests to start the GitOps loop:
```bash
kubectl apply -k k8s_gitops/bootstrap
```

### 3. Terraform Provisioning
```bash
cd terraform/<component>
terraform init
terraform apply -var-file=prod.env.tfvars
```

## Workflows

### Adding a New Kubernetes Application
1. Create directory: `k8s_gitops/app/<app-name>/resources`
2. Define resources (Manifests/Helm) in `resources/`
3. Create ArgoCD App definition in `k8s_gitops/app/<app-name>/<app-name>.yaml`
4. Add to `k8s_gitops/app/kustomization.yaml`

## Useful Commands

```bash
# List all applications
kubectl get applications -n argocd

# Watch sync status
kubectl get applications -n argocd -w
```