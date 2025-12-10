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
  signing_key             = data.authentik_certificate_key_pair.generated.id
  access_token_validity   = "minutes=5"
  refresh_token_threshold = "hours=1"
  refresh_token_validity  = "days=30"
}

resource "authentik_application" "argocd-application" {
  name              = "ArgoCD"
  slug              = "argocd"
  meta_icon         = "fa://fa-octopus-deploy"
  open_in_new_tab   = true
  protocol_provider = authentik_provider_oauth2.argocd-provider.id
}
