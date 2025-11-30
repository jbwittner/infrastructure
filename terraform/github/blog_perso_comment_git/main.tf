# Specify the provider
provider "github" {
}

# This resource allows you to create and manage repositories within your GitHub organization or personal account.
resource "github_repository" "repo" {
  name                   = "blog_perso_comment"
  allow_auto_merge       = true
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  allow_update_branch    = false
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  gitignore_template     = "Java"
  auto_init              = true
  visibility             = "public"
}
