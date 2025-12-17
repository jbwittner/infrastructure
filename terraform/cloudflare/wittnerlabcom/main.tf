variable "ACCOUNT_TOKEN" {}
variable "ACCOUNT_ID" {
  default = "588c0a8eaabdcd4db76d75b14250a0e1"
}
variable "TUNNEL_SECRET" {}

provider "cloudflare" {
  api_token = var.ACCOUNT_TOKEN
}

data "cloudflare_account" "personal_account" {
  account_id = var.ACCOUNT_ID
}

resource "cloudflare_zone" "wittnerlabcom_zone" {
  account = {
    id = data.cloudflare_account.personal_account.id
  }
  name = "wittnerlab.com"
}

resource "cloudflare_dns_record" "authentik_dns_record" {
  zone_id = cloudflare_zone.wittnerlabcom_zone.id
  name    = "authentik"
  ttl     = 1 # "auto"
  type    = "A"
  content = "54.37.86.175"
  proxied = true
}

resource "cloudflare_dns_record" "dokploy_dns_record" {
  zone_id = cloudflare_zone.wittnerlabcom_zone.id
  name    = "dokploy"
  ttl     = 1 # "auto"
  type    = "A"
  content = "54.37.86.175"
  proxied = true
}

resource "cloudflare_dns_record" "excalidraw_dns_record" {
  zone_id = cloudflare_zone.wittnerlabcom_zone.id
  name    = "excalidraw"
  ttl     = 1 # "auto"
  type    = "A"
  content = "54.37.86.175"
  proxied = true
}

resource "cloudflare_dns_record" "kuma_dns_record" {
  zone_id = cloudflare_zone.wittnerlabcom_zone.id
  name    = "kuma"
  ttl     = 1 # "auto"
  type    = "A"
  content = "54.37.86.175"
  proxied = true
}

resource "cloudflare_dns_record" "youtrack_dns_record" {
  zone_id = cloudflare_zone.wittnerlabcom_zone.id
  name    = "youtrack"
  ttl     = 1 # "auto"
  type    = "A"
  content = "54.37.86.175"
  proxied = true
}

resource "cloudflare_dns_record" "languagetool_dns_record" {
  zone_id = cloudflare_zone.wittnerlabcom_zone.id
  name    = "languagetool"
  ttl     = 1 # "auto"
  type    = "A"
  content = "54.37.86.175"
  proxied = true
}

resource "cloudflare_dns_record" "squash_dns_record" {
  zone_id = cloudflare_zone.wittnerlabcom_zone.id
  name    = "squash"
  ttl     = 1 # "auto"
  type    = "A"
  content = "54.37.86.175"
  proxied = true
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "wittnerlabcom_tunnel_kubernetes" {
  account_id   = data.cloudflare_account.personal_account.id
  name = "wittnerlabcom-tunnel-kubernetes"
  config_src = "cloudflare"
  tunnel_secret = var.TUNNEL_SECRET
}


# data "cloudflare_account_permission_group" "example_account_permission_group" {
#   account_id = data.cloudflare_account.personal_account.id
#   permission_group_id = "49ce85367bae433b9f0717ed4fea5c74"
# }

# resource "cloudflare_account_token" "wittnerlabcom_test" {
#   account_id = data.cloudflare_account.personal_account.id
#   name = "external-dns-token-wittnerlabcom"
#   policies = [{
#     effect = "allow"
#     permission_groups = [{
#       id = data.cloudflare_account_permission_group.example_account_permission_group.id
#       meta = {
#         key = "key"
#         value = "value"
#       }
#     }]
#     resources = jsonencode({
#       "com.cloudflare.api.account.zone.${cloudflare_zone.wittnerlabcom_zone.id}" = "*"
#     })
#   }]
#   expires_on = "2030-01-01T00:00:00Z"
# }
