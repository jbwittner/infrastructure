# ArgoCD Installation

This directory contains the Helm values configuration for ArgoCD deployment.

## Installation

```bash
# Add ArgoCD Helm repository
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install ArgoCD
helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values k8s_gitops/argocd/values.yaml
```

## Access ArgoCD

```bash
# Get admin password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath='{.data.password}' | base64 -d

# Port-forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Open https://localhost:8080
# Username: admin
# Password: (from command above)
```

## Upgrade

```bash
helm upgrade argocd argo/argo-cd \
  --namespace argocd \
  --values k8s_gitops/argocd/values.yaml
```

## Sealed Secrets

Generate sealed secret for sensitive configuration:

```bash
cat k8s_gitops/argocd/argocd.secret.yaml | \
  kubeseal --controller-namespace sealed-secrets \
  --controller-name infra-sealed-secrets \
  --format yaml > k8s_gitops/argocd/argocd.sealed-secret.yaml
```

Before applying, ensure the template values are filled in `argocd.secret.yaml` with labels.

```yaml
  template:
    metadata:
      labels:
        app.kubernetes.io/name: argocd-secret
        app.kubernetes.io/part-of: argocd
```

Apply the sealed secret:

```bash
kubectl apply -f k8s_gitops/argocd/argocd.sealed-secret.yaml
``` 


## Cloudflare Tunnel Integration

To expose ArgoCD behind Cloudflare Tunnel with Ingress NGINX, the following annotations are required:

```yaml
nginx.ingress.kubernetes.io/ssl-passthrough: "true"
nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
```

**Note**: If you encounter `TOO_MANY_REDIRECTS` errors, ensure these annotations are properly configured.

## Uninstall

```bash
helm uninstall argocd -n argocd
kubectl delete namespace argocd
```

## Reference

- [ArgoCD Helm Chart](https://github.com/argoproj/argo-helm)

