variable "ACCOUNT_TOKEN" {}

provider "cloudflare" {
  api_token = var.ACCOUNT_TOKEN
}

data "cloudflare_account" "personal_account" {
  account_id = "588c0a8eaabdcd4db76d75b14250a0e1"
}

# resource "cloudflare_zone" "example_zone" {
#   account = {
#     id = "023e105f4ecef8ad9ca31a8372d0c353"
#   }
#   name = "wittnerlab.com"
#   type = "full"
# }

# resource "cloudflare_dns_record" "example_dns_record" {
#   zone_id = "023e105f4ecef8ad9ca31a8372d0c353"
#   name = "example.com"
#   ttl = 3600
#   type = "A"
#   comment = "Domain verification record"
#   content = "198.51.100.4"
#   proxied = true
#   settings = {
#     ipv4_only = true
#     ipv6_only = true
#   }
#   tags = ["owner:dns-team"]
# }