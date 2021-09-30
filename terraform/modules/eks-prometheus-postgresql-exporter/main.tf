resource "random_string" "pg_exporter_pass" {
  length  = 32
  special = false
  upper   = true
}

resource "helm_release" "postgresql_exporter_user" {
  name        = "pg-exporter-user"
  chart       = "./helm-chart/pg-exporter-user"
  namespace   = var.kubernetes_namespace
  wait        = var.helm_release_wait
  max_history = var.helm_release_history_size

  values = [
    local.postgresql_exporter_user_template
  ]
}

resource "helm_release" "postgresql_exporter" {
  name        = "prometheus-postgres-exporter"
  chart       = "prometheus-postgres-exporter"
  repository  = var.helm_repo_prometheus_community
  version     = var.postgres_exporter_version
  namespace   = var.kubernetes_namespace
  wait        = var.helm_release_wait
  max_history = var.helm_release_history_size

  values = [
    local.prometheus_postgresql_exporter_template
  ]

  depends_on = [helm_release.postgresql_exporter_user]
}