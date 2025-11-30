# Define the required variables (secrets)
variable "github_token" {}
variable "cloudflare_account_id" {}
variable "cloudflare_api_token" {}
variable "sonar_token" {}
variable "vite_client_id_auth0" {}

# Define the required variables
variable "sonar_host_url" {
  default = "https://sonarcloud.io"
}
variable "vite_audience_auth0" {
  default = "bankwiz_server"
}
variable "vite_domain_auth0" {
  default = "bankwiz-development.eu.auth0.com"
}
variable "vite_server_url" {
  default = "https://api.dev.bankwiz.bytedragon.tech"
}

# Specify the provider
provider "github" {
  token = var.github_token # Token sourced from an environment variable
}

# This resource allows you to create and manage repositories within your GitHub organization or personal account.
resource "github_repository" "repo" {
  name                   = "bankwiz_frontend"
  allow_auto_merge       = true
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  allow_update_branch    = false
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  gitignore_template     = "Node"
  auto_init              = true
  visibility             = "public"
}

# This resource allows you to create and manage branches within your GitHub repository.
resource "github_branch" "develop" {
  repository    = github_repository.repo.name
  branch        = "develop"
  source_branch = "main"
}

# This resource allows you to set the default branch for your GitHub repository.
resource "github_branch_default" "branch_default" {
  repository = github_repository.repo.name
  branch     = "develop"
}

# This resource allows you to enable Dependabot security updates for your GitHub repository.
resource "github_repository_dependabot_security_updates" "default" {
  repository = github_repository.repo.name
  enabled    = true
}

## GITHUB ACTIONS SECRETS
# This resource allows you to create and manage secrets within your GitHub repository.
resource "github_actions_secret" "cloudflare_account_id" {
  repository      = github_repository.repo.name
  secret_name     = "CLOUDFLARE_ACCOUNT_ID"
  plaintext_value = var.cloudflare_account_id
}

resource "github_actions_secret" "cloudflare_api_token" {
  repository      = github_repository.repo.name
  secret_name     = "CLOUDFLARE_API_TOKEN"
  plaintext_value = var.cloudflare_api_token
}

resource "github_actions_secret" "sonar_token" {
  repository      = github_repository.repo.name
  secret_name     = "SONAR_TOKEN"
  plaintext_value = var.sonar_token
}

resource "github_actions_secret" "vite_client_id_auth0" {
  repository      = github_repository.repo.name
  secret_name     = "VITE_CLIENT_ID_AUTH0"
  plaintext_value = var.vite_client_id_auth0
}
## GITHUB ACTIONS SECRETS

## GITHUB DEPENDABOT SECRETS
# This resource allows you to create and manage secrets within your GitHub repository.
resource "github_dependabot_secret" "cloudflare_account_id" {
  repository      = github_repository.repo.name
  secret_name     = "CLOUDFLARE_ACCOUNT_ID"
  plaintext_value = var.cloudflare_account_id
}

resource "github_dependabot_secret" "cloudflare_api_token" {
  repository      = github_repository.repo.name
  secret_name     = "CLOUDFLARE_API_TOKEN"
  plaintext_value = var.cloudflare_api_token
}

resource "github_dependabot_secret" "sonar_token" {
  repository      = github_repository.repo.name
  secret_name     = "SONAR_TOKEN"
  plaintext_value = var.sonar_token
}

resource "github_dependabot_secret" "vite_client_id_auth0" {
  repository      = github_repository.repo.name
  secret_name     = "VITE_CLIENT_ID_AUTH0"
  plaintext_value = var.vite_client_id_auth0
}
## GITHUB DEPENDABOT SECRETS

## GITHUB ACTIONS VARIABLES
resource "github_actions_variable" "sonar_host_url" {
  repository    = github_repository.repo.name
  variable_name = "SONAR_HOST_URL"
  value         = var.sonar_host_url
}

resource "github_actions_variable" "vite_audience_auth0" {
  repository    = github_repository.repo.name
  variable_name = "VITE_AUDIENCE_AUTH0"
  value         = var.vite_audience_auth0
}

resource "github_actions_variable" "vite_domain_auth0" {
  repository    = github_repository.repo.name
  variable_name = "VITE_DOMAIN_AUTH0"
  value         = var.vite_domain_auth0
}

resource "github_actions_variable" "vite_server_url" {
  repository    = github_repository.repo.name
  variable_name = "VITE_SERVER_URL"
  value         = var.vite_server_url
}
## GITHUB ACTIONS VARIABLES

# This resource allows you to create and manage secrets within your GitHub repository.
resource "github_repository_ruleset" "develop" {
  name        = "develop"
  repository  = github_repository.repo.name
  target      = "branch"
  enforcement = "active"

  # Define the conditions for the ruleset
  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  # Define the rules for the ruleset
  rules {
    creation                = true
    update                  = false
    deletion                = true
    required_linear_history = true
    required_signatures     = false
    non_fast_forward        = true

    pull_request {
      required_approving_review_count   = 0
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_review_thread_resolution = false
    }

    required_status_checks {
      strict_required_status_checks_policy = true

      required_check {
        context        = "Check eslint"
        integration_id = 15368 # GitHub Actions
      }
      required_check {
        context        = "Check prettier"
        integration_id = 15368 # GitHub Actions
      }
      required_check {
        context        = "Build"
        integration_id = 15368 # GitHub Actions
      }
      required_check {
        context        = "Units tests"
        integration_id = 15368 # GitHub Actions
      }
    }

  }
}
