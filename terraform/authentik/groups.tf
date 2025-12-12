resource "authentik_group" "authentik_admins" {
  name         = "authentik_admins"
  users        = [authentik_user.jbwittner.id]
  is_superuser = true
}

resource "authentik_group" "grafana-admins" {
  name         = "grafana_admins"
  users        = [authentik_user.jbwittner.id]
  is_superuser = false
}

resource "authentik_group" "argocd-admins" {
  name         = "argocd_admins"
  users        = [authentik_user.jbwittner.id]
  is_superuser = false
}

resource "authentik_group" "argocd-users" {
  name         = "argocd_users"
  users        = []
  is_superuser = false
}


resource "authentik_group" "youtrack-users" {
  name         = "youtrack_users"
  users        = []
  is_superuser = false
}

resource "authentik_group" "youtrack-admins" {
  name         = "youtrack_admins"
  users        = [authentik_user.jbwittner.id]
  is_superuser = false
}
