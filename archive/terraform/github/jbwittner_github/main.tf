# Define the required variables
variable "github_token" {}

# Specify the provider
provider "github" {
  token = var.github_token # Token sourced from an environment variable
}

resource "github_user_ssh_key" "ssh_worspace_server" {
  title = "Workspace server (ansible)"
  key   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEFbPCc5zZciOevu8ss680J4cschdarkcZPLVP7Dmd3 ansible-generated on localhost.localdomain"
}

resource "github_user_ssh_key" "ssh_pc_fixe" {
  title = "PC Fixe (manuelle)"
  key   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMY/RHrvY3GeQYyoWf1v9vKjqQsaeKIcIW2bqhKo6jhM jbwittner@JB-Fixe"
}