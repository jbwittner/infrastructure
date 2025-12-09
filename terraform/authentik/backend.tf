terraform {
  backend "gcs" {
    bucket = "f1ca7121a411ff04-terraform-backend"
    prefix = "terraform/state/github/authentik"
  }
}

terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2025.10.1"
    }
  }
}