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
      url           = "https://youtrack.wittnerlab.com/hub/api/rest/oauth2/interactive/login/6dca8800-ccad-4c23-aff7-ff57357424f1/land",
    }
  ]
  access_token_validity   = "minutes=5"
  refresh_token_threshold = "hours=1"
  refresh_token_validity  = "days=30"
}

resource "authentik_application" "youtrack-application" {
  name            = "YouTrack"
  slug            = "youtrack"
  meta_icon       = "fa://fa-ticket"
  open_in_new_tab = true

  protocol_provider = authentik_provider_oauth2.youtrack-provider.id
}

resource "authentik_policy_binding" "youtrack-access" {
  target = authentik_application.youtrack-application.uuid
  group  = authentik_group.youtrack-users.id
  order  = 0
}