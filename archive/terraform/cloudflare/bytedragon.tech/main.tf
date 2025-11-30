# Define the required variables (secrets)
variable "cloudflare_api_token" {}

variable "ip_cluster_k8s" {
  default = "5.135.136.115"
}

# Define the required variables

# Specify the provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_account" "account" {
  name              = "Jeanbaptiste.wittner@outlook.com's Account"
  type              = "standard"
}

resource "cloudflare_zone" "zone" {
  account = {
    id = cloudflare_account.account.id  
  }
  name       = "bytedragon.tech"
}


resource "cloudflare_certificate_pack" "bankwiz_dev_app" {
  zone_id               = cloudflare_zone.zone.id
  type                  = "advanced"
  hosts                 = ["app.dev.bankwiz.bytedragon.tech"]
  validation_method     = "txt"
  validity_days         = 30
  certificate_authority = "google"
  cloudflare_branding   = false
}

resource "cloudflare_certificate_pack" "bankwiz_dev_api" {
  zone_id               = cloudflare_zone.zone.id
  type                  = "advanced"
  hosts                 = ["api.dev.bankwiz.bytedragon.tech"]
  validation_method     = "txt"
  validity_days         = 30
  certificate_authority = "google"
  cloudflare_branding   = false
}

/*
resource "cloudflare_dns_record" "api_dev_bankwiz" {
  zone_id = cloudflare_zone.zone.id
  comment = "Domain verification record"
  content = var.ip_cluster_k8s
  name = "api.dev.bankwiz"
  proxied = true
  tags = ["owner:dns-team"]
  ttl = 1
  type = "A"
}
*/