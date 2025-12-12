variable "AUTHENTIK_YOUTRACK_CLIENT_ID" {}
variable "AUTHENTIK_YOUTRACK_CLIENT_SECRET" {}

data "authentik_flow" "youtrack-authorization-flow" {
  slug = "default-provider-authorization-explicit-consent"
}

data "authentik_flow" "youtrack-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

resource "authentik_provider_oauth2" "youtrack-provider" {
  name               = "youtrack-oauth2-provider"
  client_id          = var.AUTHENTIK_YOUTRACK_CLIENT_ID
  client_secret      = var.AUTHENTIK_YOUTRACK_CLIENT_SECRET
  authorization_flow = data.authentik_flow.youtrack-authorization-flow.id
  invalidation_flow  = data.authentik_flow.youtrack-invalidation-flow.id
  property_mappings = [
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    data.authentik_property_mapping_provider_scope.openid.id
  ]
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      #url           = "https://youtrack.wittnerlab.com/login/generic_oauth",
      url = "http://localhost:8080/hub/api/rest/oauth2/interactive/login/6ebd4de1-d12b-44de-b6da-587b481e4951/land",
    }
  ]
  access_token_validity   = "minutes=5"
  refresh_token_threshold = "hours=1"
  refresh_token_validity  = "days=30"
}

resource "authentik_application" "youtrack-application" {
  name            = "YouTrack"
  slug            = "youtrack"
  meta_icon       = "fa://fa-chart-area"
  open_in_new_tab = true

  protocol_provider = authentik_provider_oauth2.youtrack-provider.id
}
