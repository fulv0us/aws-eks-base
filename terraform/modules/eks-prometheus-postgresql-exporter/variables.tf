variable "helm_repo_prometheus_community" {
  description = "Repository name for postgres-exporter"
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "helm_release_history_size" {
  description = "How much helm releases to store"
  type        = number
  default     = 5
}

variable "kubernetes_namespace" {
  description = "Name of kubernetes namespace for postgres-exporter"
  type        = string
  default     = "monitoring"
}

variable "postgres_exporter_version" {
  description = "postgres-exporter chart version"
  type        = string
  default     = "1.4.0"
}

variable "helm_release_wait" {
  description = "Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to true."
  type        = string
  default     = false
}

variable "pg_host" {
  description = "postgres host"
  type        = string
  default     = ""
}

variable "pg_user" {
  description = "postgres user"
  type        = string
  default     = ""
}

variable "pg_port" {
  description = "postgres port"
  type        = string
  default     = ""
}

variable "pg_pass" {
  description = "postgres pass"
  type        = string
  default     = ""
}

variable "pg_database" {
  description = "postgres database"
  type        = string
  default     = ""
}
