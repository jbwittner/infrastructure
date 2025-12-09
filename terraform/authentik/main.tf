variable "AUTHENTIK_TOKEN" {}
variable "AUTHENTIK_INSECURE" {}
variable "AUTHENTIK_GRAFANA_CLIENT_ID" {}
variable "AUTHENTIK_GRAFANA_CLIENT_SECRET" {}

provider "authentik" {
  url   = "https://authentik.wittnerlab.com/"
  token = var.AUTHENTIK_TOKEN
  insecure = var.AUTHENTIK_INSECURE
}


### OAUTH2 PROVIDER AND APPLICATION FOR GRAFANA ###

# Create an application with a provider attached and policies applied

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
  invalidation_flow = data.authentik_flow.grafana-invalidation-flow.id
  access_token_validity = "minutes=5"
  refresh_token_threshold = "hours=1"
  refresh_token_validity = "days=30"
}

