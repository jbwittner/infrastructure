variable "ACCOUNT_TOKEN" {}

provider "cloudflare" {
  api_token = var.ACCOUNT_TOKEN
}

data "cloudflare_account" "personal_account" {
  account_id = "588c0a8eaabdcd4db76d75b14250a0e1"
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