locals {
  pg_host          = var.pg_host
  pg_user          = var.pg_user
  pg_port          = var.pg_port
  pg_pass          = var.pg_pass
  pg_database      = var.pg_database
  pg_exporter_pass = random_string.pg_exporter_pass.result

  postgresql_exporter_user_template = templatefile("${path.module}/templates/postgresql-exporter-user-script.tmpl",
    {
      pg_host          = local.pg_host
      pg_user          = local.pg_user
      pg_port          = local.pg_port
      pg_pass          = local.pg_pass
      pg_database      = local.pg_database
      pg_exporter_pass = local.pg_exporter_pass
  })

  prometheus_postgresql_exporter_template = templatefile("${path.module}/templates/prometheus-postgresql-exporter.tmpl",
    {
      pg_host     = local.pg_host
      pg_pass     = local.pg_exporter_pass
      pg_port     = local.pg_port
      pg_database = local.pg_database
  })

}
