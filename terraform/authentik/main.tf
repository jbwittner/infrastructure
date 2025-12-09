variable "AUTHENTIK_TOKEN" {}
variable "AUTHENTIK_INSECURE" {}

provider "authentik" {
  url      = "https://authentik.wittnerlab.com/"
  token    = var.AUTHENTIK_TOKEN
  insecure = var.AUTHENTIK_INSECURE
}

### CORE AUTHENTIK RESOURCES ###

resource "authentik_system_settings" "settings" {
  default_token_duration = "hours=24"
}

### Certificate ###

data "authentik_certificate_key_pair" "generated" {
  name = "authentik Self-signed Certificate"
}

### OAUTH2 GENERIC SETTINGS  ###

data "authentik_property_mapping_provider_scope" "email" {
  managed = "goauthentik.io/providers/oauth2/scope-email"
}

data "authentik_property_mapping_provider_scope" "profile" {
  managed = "goauthentik.io/providers/oauth2/scope-profile"
}

data "authentik_property_mapping_provider_scope" "openid" {
  managed = "goauthentik.io/providers/oauth2/scope-openid"
}

### OAUTH2 PROVIDER AND APPLICATION FOR GRAFANA ###

variable "AUTHENTIK_GRAFANA_CLIENT_ID" {}
variable "AUTHENTIK_GRAFANA_CLIENT_SECRET" {}

data "authentik_flow" "grafana-authorization-flow" {
  slug = "default-provider-authorization-explicit-consent"
}

data "authentik_flow" "grafana-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

resource "authentik_provider_oauth2" "grafana-provider" {
  name               = "grafana-oauth2-provider"
  client_id          = var.AUTHENTIK_GRAFANA_CLIENT_ID
  client_secret      = var.AUTHENTIK_GRAFANA_CLIENT_SECRET
  authorization_flow = data.authentik_flow.grafana-authorization-flow.id
  invalidation_flow  = data.authentik_flow.grafana-invalidation-flow.id
  property_mappings = [
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    data.authentik_property_mapping_provider_scope.openid.id
  ]
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://grafana.wittnerlab.com/login/generic_oauth",
    }
  ]
  access_token_validity   = "minutes=5"
  refresh_token_threshold = "hours=1"
  refresh_token_validity  = "days=30"
}

resource "authentik_application" "grafana-application" {
  name              = "Grafana"
  slug              = "grafana"
  protocol_provider = authentik_provider_oauth2.grafana-provider.id
}


### OAUTH2 PROVIDER AND APPLICATION FOR ARGOCD ###

variable "AUTHENTIK_ARGOCD_CLIENT_ID" {}
variable "AUTHENTIK_ARGOCD_CLIENT_SECRET" {}

data "authentik_flow" "argocd-authorization-flow" {
  slug = "default-provider-authorization-explicit-consent"
}

data "authentik_flow" "argocd-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

resource "authentik_provider_oauth2" "argocd-provider" {
  name               = "argocd-oauth2-provider"
  client_id          = var.AUTHENTIK_ARGOCD_CLIENT_ID
  client_secret      = var.AUTHENTIK_ARGOCD_CLIENT_SECRET
  authorization_flow = data.authentik_flow.argocd-authorization-flow.id
  invalidation_flow  = data.authentik_flow.argocd-invalidation-flow.id
  property_mappings = [
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    data.authentik_property_mapping_provider_scope.openid.id
  ]
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://argocd.wittnerlab.com/api/dex/callback",
    }
  ]
  signing_key         = data.authentik_certificate_key_pair.generated.id
  access_token_validity   = "minutes=5"
  refresh_token_threshold = "hours=1"
  refresh_token_validity  = "days=30"
}

resource "authentik_application" "argocd-application" {
  name              = "ArgoCD"
  slug              = "argocd"
  protocol_provider = authentik_provider_oauth2.argocd-provider.id
}

### Users ###

resource "authentik_user" "jbwittner" {
  username = "jbwittner"
  name     = "Jean-Baptiste WITTNER"
  email    = "jeanbaptiste.wittner@outlook.com"
}

### GROUPS ###

### Grafana Groups ###

resource "authentik_group" "grafana-admins" {
  name         = "grafana_admins"
  users        = [authentik_user.jbwittner.id]
  is_superuser = true
}

### ArgoCO Groups ###

resource "authentik_group" "argocd-admins" {
  name         = "argocd_admins"
  users        = [authentik_user.jbwittner.id]
  is_superuser = true
}

resource "authentik_group" "argocd-users" {
  name         = "argocd_users"
  users        = []
  is_superuser = true
}