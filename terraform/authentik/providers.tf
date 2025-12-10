variable "AUTHENTIK_TOKEN" {}
variable "AUTHENTIK_INSECURE" {}

provider "authentik" {
  url      = "https://authentik.wittnerlab.com/"
  token    = var.AUTHENTIK_TOKEN
  insecure = var.AUTHENTIK_INSECURE
}
