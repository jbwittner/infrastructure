terraform {
  backend "gcs" {
    bucket = "f1ca7121a411ff04-terraform-backend"
    prefix = "terraform/state/discord/bytedragon"
  }
}

terraform {
  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "1.9.0"
    }
  }
}