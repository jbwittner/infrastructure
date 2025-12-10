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
  name            = "Grafana"
  slug            = "grafana"
  meta_icon       = "fa://fa-chart-area"
  open_in_new_tab = true

  protocol_provider = authentik_provider_oauth2.grafana-provider.id
}
